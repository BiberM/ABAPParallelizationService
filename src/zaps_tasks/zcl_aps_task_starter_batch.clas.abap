class zcl_aps_task_starter_batch definition
  public
  inheriting from zcl_aps_task_starter
  final
  create private
  global friends zcl_aps_task_starter_factory.

  public section.
    methods:
      zif_aps_task_starter~start redefinition.

  protected section.
    methods:
      createTask redefinition.

  private section.
    constants:
      c_jobStartEvent type btceventid value 'ZAPS_JOB_START' ##NO_TEXT.

    methods:
      createTaskChains
        importing
          i_packages      type zaps_packages
        returning
          value(return)   type zaps_task_chains
        raising
          zcx_aps_task_invalid_class
          zcx_aps_task_instanciation_err
          zcx_aps_task_unknown_exec_type,

      createJobChains
        importing
          i_taskChains    type zaps_task_chains
        RAISING
          zcx_aps_task_job_creation
          zcx_aps_task_job_submit
          zcx_aps_task_job_release,

      createJobChain
        importing
          i_taskChain     type ref to zaps_task_chain
          i_chainNumber   type sytabix
        raising
          zcx_aps_task_job_creation
          zcx_aps_task_job_submit
          zcx_aps_task_job_release.
endclass.



class zcl_aps_task_starter_batch implementation.
  method zif_aps_task_starter~start.
    data(taskChains) = createTaskChains( i_packages ).

    createJobChains( taskChains ).

    " When all job chains have been created successfully, raise the event to start them
    cl_batch_event=>raise(
      exporting
        i_eventid                      = c_jobStartEvent
        i_eventparm                    = conv btcevtparm( i_appId )
      exceptions
        excpt_raise_failed             = 1
        excpt_server_accepts_no_events = 2
        excpt_raise_forbidden          = 3
        excpt_unknown_event            = 4
        excpt_no_authority             = 5
        others                         = 6
    ).

    if sy-subrc <> 0.
      raise exception
      type zcx_aps_task_job_event_raise
      exporting
        i_eventname = c_jobStartEvent
        i_errorcode = sy-subrc.
    endif.
  endmethod.

  method createTask.
    return = zcl_aps_task_factory=>provide(
        i_appid       = appId
        i_configid    = configId
        i_settings    = settings
        i_packagedata = taskData->*
    ).
  endmethod.

  method createTaskChains.
    data(numberOfNeededChains) = nmin(
                                   val1 = lines( i_packages )
                                   val2 = settings->getmaxparalleltasks( )
                                 ).

    do numberOfNeededChains times.
      append initial line
      to return.
    enddo.

    loop at i_packages
    reference into data(package).
      " Modulo only works with table indices starting at 0. ABAP instead starts counting at 1.
      " This -1/+1 ensures correct indices for tasks n*numberofNeededTasks (last Chain)
      data(chainNumber) = ( ( sy-tabix - 1 ) mod numberOfNeededChains ) + 1.

      " ABAP doesn't like nested tables inside append command ...
      data(chainReference) = ref #( return[ chainNumber ] ).

      append createTask( package )
      to chainReference->*.
    endloop.
  endmethod.

  method createJobChain.
    data:
      previousJobName      type btcjob,
      previousJobUniqueId  type btcjobcnt,
      isJobReleased        type btcchar1.


    loop at i_taskChain->*
    into data(task).
      data(taskNumberInChain) = sy-tabix.
      data(isFirstTaskOfChain) = switch abap_bool(
                                   sy-tabix
                                   when 1 then abap_true
                                   else abap_false
                                 ).

      zcl_aps_task_storage_factory=>provide( )->storetask( task ).

      data(jobUniqueId) = value btcjobcnt( ).

      " Prefix in combination with large numbers could exceed jobname length. So it is truncated.
      data(jobName)     = conv btcjob( |{ settings->getjobnameprefix( ) }{ i_chainnumber }/{ taskNumberInChain }| ).

      " Application jobs should always be created as lowest priority
      call function 'JOB_OPEN'
        exporting
          jobname          = jobName
          jobclass         = 'C'
        importing
          jobcount         = jobUniqueId
        exceptions
          cant_create_job  = 1
          invalid_job_data = 2
          jobname_missing  = 3
          others           = 4.

      if sy-subrc <> 0.
        raise exception
        type zcx_aps_task_job_creation
        exporting
          i_jobname   = jobname
          i_errorcode = sy-subrc.
      endif.

      data(selectionScreenData) = value rsparams_tt(
                                    ( selname = 'P_AP'
                                      kind    = 'P'
                                      low     = task->getAppId( ) )
                                    ( selname = 'P_CO'
                                      kind    = 'P'
                                      low     = task->getConfigId( ) )
                                    ( selname = 'P_TA'
                                      kind    = 'P'
                                      low     = task->getTaskId( ) )
                                  ).

      submit zaps_batch_task_run
      with selection-table selectionScreenData
      via job jobName number jobUniqueId
      and return.

      if sy-subrc <> 0.
        raise exception
        type zcx_aps_task_job_submit
        exporting
          i_jobname     = jobName
          i_jobuniqueid = jobUniqueId.
      endif.

      " The first job of each chain is started by an event
      " If it would start directly it could have been finished before the successor is even released
      if isFirstTaskOfChain = abap_true.
        call function 'JOB_CLOSE'
          exporting
            event_id                    = c_jobStartEvent
            event_param                 = conv btcevtparm( task->getAppId( ) )
            jobcount                    = jobUniqueId
            jobname                     = jobName
          importing
            job_was_released            = isJobReleased
          exceptions
            cant_start_immediate        = 1
            invalid_startdate           = 2
            jobname_missing             = 3
            job_close_failed            = 4
            job_nosteps                 = 5
            job_notex                   = 6
            lock_failed                 = 7
            invalid_target              = 8
            invalid_time_zone           = 9
            others                      = 10.

        if sy-subrc <> 0
        or isJobReleased = abap_false.
          raise exception
          type zcx_aps_task_job_release
          exporting
            i_jobname     = jobName
            i_jobuniqueid = jobUniqueId
            i_errorcode   = sy-subrc.
        endif.

      else.
        call function 'JOB_CLOSE'
          exporting
            jobcount                    = jobUniqueId
            jobname                     = jobName
            pred_jobcount               = previousJobUniqueId
            pred_jobname                = previousJobName
          importing
            job_was_released            = isJobReleased
          exceptions
            cant_start_immediate        = 1
            invalid_startdate           = 2
            jobname_missing             = 3
            job_close_failed            = 4
            job_nosteps                 = 5
            job_notex                   = 6
            lock_failed                 = 7
            invalid_target              = 8
            invalid_time_zone           = 9
            others                      = 10.

        if sy-subrc <> 0
        or isJobReleased = abap_false.
          raise exception
          type zcx_aps_task_job_release
          exporting
            i_jobname     = jobName
            i_jobuniqueid = jobUniqueId
            i_errorcode   = sy-subrc.
        endif.
      endif.

      previousJobName = jobName.
      previousJobUniqueId = jobUniqueId.
    endloop.
  endmethod.

  method createJobChains.
    loop at i_taskChains
    reference into data(taskChain).
      createJobChain(
        i_taskchain   = taskChain
        i_chainnumber = sy-tabix
      ).
    endloop.
  endmethod.

endclass.
