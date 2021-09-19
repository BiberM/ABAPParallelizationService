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
    methods:
      createTaskChains
        importing
          i_packages      type zaps_packages
        returning
          value(return)   type zaps_task_chains,

      createJobChains
        importing
          i_taskChains    type zaps_task_chains,

      createJobChain
        importing
          i_taskChain     type ref to zaps_task_chain
          i_chainNumber   type sytabix.
endclass.



class zcl_aps_task_starter_batch implementation.
  method zif_aps_task_starter~start.
    data(taskChains) = createTaskChains( i_packages ).

    createJobChains( taskChains ).
  endmethod.

  method createTask.

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
*////////////// ToDo Error handling ///////////////
        return.
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
*///////////// ToDo: Error handling ///////////////
        return.
      endif.

      call function 'JOB_CLOSE'
        exporting
*          at_opmode                   = space
*          at_opmode_periodic          = space
*          calendar_id                 = space
*          event_id                    = space
*          event_param                 = space
*          event_periodic              = space
          jobcount                    = jobUniqueId
          jobname                     = jobName
*          laststrtdt                  = NO_DATE
*          laststrttm                  = NO_TIME
*          prddays                     = 0
*          prdhours                    = 0
*          prdmins                     = 0
*          prdmonths                   = 0
*          prdweeks                    = 0
*          predjob_checkstat           = space
*          pred_jobcount               = space
*          pred_jobname                = space
*          sdlstrtdt                   = NO_DATE
*          sdlstrttm                   = NO_TIME
*          startdate_restriction       = BTC_PROCESS_ALWAYS
*          strtimmed                   = space
*          targetsystem                = space
*          start_on_workday_not_before = SY-DATUM
*          start_on_workday_nr         = 0
*          workday_count_direction     = 0
*          recipient_obj               =
*          targetserver                = space
*          dont_release                = space
*          targetgroup                 = space
*          direct_start                =
*          inherit_recipient           =
*          inherit_target              =
*          register_child              = abap_false
*          time_zone                   =
*          email_notification          =
*        importing
*          job_was_released            =
*        changing
*          ret                         =
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

      if sy-subrc <> 0.
*///////////// ToDo: Error handling ///////////////
        return.
      endif.
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
