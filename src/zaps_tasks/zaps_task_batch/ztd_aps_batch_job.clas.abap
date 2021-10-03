class ztd_aps_batch_job definition
  public
  final
  create public
  for testing
  duration short
  risk level harmless.

  public section.
    interfaces:
      zif_aps_batch_job.

    methods:
      constructor
        importing
          i_task              type ref to zif_aps_task
          i_settings          type ref to zif_aps_settings
          i_chainNumber       type sytabix
          i_taskNumberInChain type sytabix,

      setAddStepFailure,
      setAddStepSuccess,
      setCreateFailure,
      setCreateSuccess,
      setEventTriggeredFailure,
      setEventTriggeredSuccess,
      setSuccessorFailure,
      setSuccessorSuccess.

  protected section.
  private section.
    data:
      task                  type ref to zif_aps_task,
      settings              type ref to zif_aps_settings,
      letAddStepFail        type abap_bool,
      letCreateFail         type abap_bool,
      letEventTriggeredFail type abap_bool,
      letSuccessorFail      type abap_bool.
endclass.



class ztd_aps_batch_job implementation.
  method zif_aps_batch_job~addStep.
    if letAddStepFail = abap_true.
      raise exception
      type zcx_aps_task_job_submit
      exporting
        i_jobname     = 'JobName'
        i_jobuniqueid = 'UniqueId'.
    endif.
  endmethod.


  method zif_aps_batch_job~create.
    if letCreateFail = abap_true.
      raise exception
      type zcx_aps_task_job_creation
      exporting
        i_jobname   = 'JobName'
        i_errorcode = 42.
    endif.
  endmethod.


  method zif_aps_batch_job~getJobName.
    result = 'JobName'.
  endmethod.


  method zif_aps_batch_job~getJobUniqueId.
    result = 'UniqueId'.
  endmethod.


  method zif_aps_batch_job~planAsEventTriggered.
    if letEventTriggeredFail = abap_true.
      raise exception
      type zcx_aps_task_job_release
      exporting
        i_jobname     = 'JobName'
        i_jobuniqueid = 'UniqueId'
        i_errorcode   = 42.
    endif.
  endmethod.


  method zif_aps_batch_job~planAsSuccessor.
    if letSuccessorFail = abap_true.
      raise exception
      type zcx_aps_task_job_release
      exporting
        i_jobname     = 'JobName'
        i_jobuniqueid = 'UniqueId'
        i_errorcode   = 42.
    endif.
  endmethod.


  method setaddstepfailure.
    letAddStepFail = abap_true.
  endmethod.


  method setaddstepsuccess.
    letAddStepFail = abap_false.
  endmethod.


  method setcreatefailure.
    letCreateFail = abap_true.
  endmethod.


  method setcreatesuccess.
    letCreateFail = abap_false.
  endmethod.


  method seteventtriggeredfailure.
    letEventTriggeredFail = abap_true.
  endmethod.


  method seteventtriggeredsuccess.
    letEventTriggeredFail = abap_false.
  endmethod.


  method setsuccessorfailure.
    letSuccessorFail = abap_true.
  endmethod.


  method setsuccessorsuccess.
    letSuccessorFail = abap_false.
  endmethod.


  method constructor.
    task = i_task.
    settings = i_settings.
  endmethod.

endclass.
