class zcx_aps_task_job_release definition
  public
  inheriting from cx_static_check
  final
  create public.

  public section.

    interfaces:
      if_t100_dyn_msg,
      if_t100_message.

    constants:
      begin of zcx_aps_task_job_release,
        msgid type symsgid value 'ZAPS_TASK',
        msgno type symsgno value '006',
        attr1 type scx_attrname value 'JOBNAME',
        attr2 type scx_attrname value 'JOBUNIQUEID',
        attr3 type scx_attrname value 'ERRORCODE',
        attr4 type scx_attrname value '',
      end of zcx_aps_task_job_release.

    methods:
      constructor
        importing
          i_textid      type scx_t100key default zcx_aps_task_job_release
          i_previous    type ref to cx_root optional
          i_jobName     type btcjob
          i_jobUniqueId type btcjobcnt
          i_errorCode   type sysubrc.
  protected section.
  private section.
    data:
      jobName     type btcJob,
      jobUniqueId type btcjobcnt,
      errorCode   type sysubrc.
endclass.



class zcx_aps_task_job_release implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = i_previous ).
    clear textid.

    if_t100_message~t100key = i_textid.

    jobName = i_jobName.
    jobUniqueId = i_jobUniqueId.
    errorCode = i_errorCode.
  endmethod.
endclass.
