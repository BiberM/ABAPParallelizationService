class zcl_aps_batch_job definition
  public
  final
  create private
  global friends zcl_aps_batch_job_factory.

  public section.
    interfaces:
      zif_aps_batch_job.

    methods:
      constructor
        importing
          i_task              type ref to zif_aps_task
          i_settings          type ref to zif_aps_settings
          i_chainNumber       type sytabix
          i_taskNumberInChain type sytabix.

  protected section.
  private section.
    data:
      task              type ref to zif_aps_task,
      settings          type ref to zif_aps_settings,
      jobName           type btcjob,
      jobUniqueId       type btcjobcnt.

endclass.



class zcl_aps_batch_job implementation.
  method zif_aps_batch_job~addstep.
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
  endmethod.

  method zif_aps_batch_job~create.
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
  endmethod.

  method constructor.
    task = i_task.
    settings = i_settings.

    " Prefix in combination with large numbers could exceed jobname length. So it is truncated.
    jobName = |{ settings->getjobnameprefix( ) }{ i_chainNumber }/{ i_taskNumberInChain }|.
  endmethod.

  method zif_aps_batch_job~getjobname.
    return = jobName.
  endmethod.

  method zif_aps_batch_job~getjobuniqueid.
    return = jobUniqueId.
  endmethod.

  method zif_aps_batch_job~planAsEventTriggered.
    data:
      isJobReleased        type btcchar1.


    call function 'JOB_CLOSE'
      exporting
        event_id                    = zif_aps_batch_job~c_jobStartEvent
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
  endmethod.

  method zif_aps_batch_job~planAsSuccessor.
    data:
      isJobReleased        type btcchar1.


    call function 'JOB_CLOSE'
      exporting
        jobcount                    = jobUniqueId
        jobname                     = jobName
        pred_jobcount               = i_predecessor->getJobUniqueId( )
        pred_jobname                = i_predecessor->getJobName( )
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
  endmethod.

endclass.
