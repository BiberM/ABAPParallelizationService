class zcx_aps_task_job_creation definition
  public
  inheriting from cx_static_check
  final
  create public.

  public section.

    interfaces:
      if_t100_dyn_msg,
      if_t100_message.

    constants:
      begin of zcx_aps_task_job_creation,
        msgid type symsgid value 'ZAPS_TASK',
        msgno type symsgno value '004',
        attr1 type scx_attrname value 'JOBNAME',
        attr2 type scx_attrname value 'ERRORCODE',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_aps_task_job_creation.

    methods:
      constructor
        importing
          i_textid    type scx_t100key default zcx_aps_task_job_creation
          i_previous  type ref to cx_root optional
          i_jobName   type btcjob
          i_errorCode type sysubrc.
  protected section.
  private section.
    data:
      jobName     type btcJob,
      errorCode  type sysubrc.
endclass.



class zcx_aps_task_job_creation implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = i_previous ).
    clear textid.

    if_t100_message~t100key = i_textid.

    jobName = i_jobName.
    errorCode = i_errorCode.
  endmethod.
endclass.
