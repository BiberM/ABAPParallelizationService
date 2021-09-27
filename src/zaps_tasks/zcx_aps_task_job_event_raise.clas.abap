class zcx_aps_task_job_event_raise definition
  public
  inheriting from cx_static_check
  final
  create public.

  public section.

    interfaces:
      if_t100_dyn_msg,
      if_t100_message.

    constants:
      begin of zcx_aps_task_job_event_raise,
        msgid type symsgid value 'ZAPS_TASK',
        msgno type symsgno value '007',
        attr1 type scx_attrname value 'EVENTNAME',
        attr2 type scx_attrname value 'ERRORCODE',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_aps_task_job_event_raise.

    methods:
      constructor
        importing
          i_textid    type scx_t100key default zcx_aps_task_job_event_raise
          i_previous  type ref to cx_root optional
          i_eventName type btcevtid
          i_errorCode type sysubrc.
  protected section.
  private section.
    data:
      eventName  type btcevtid,
      errorCode  type sysubrc.
endclass.



class zcx_aps_task_job_event_raise implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = i_previous ).
    clear textid.

    if_t100_message~t100key = i_textid.

    eventName = i_eventName.
    errorCode = i_errorCode.
  endmethod.
endclass.
