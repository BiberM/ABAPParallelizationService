class zcx_aps_task_invalid_class definition
  public
  inheriting from cx_static_check
  final
  create public.

  public section.

    interfaces:
      if_t100_dyn_msg,
      if_t100_message.

    constants:
      begin of zcx_aps_task_invalid_class,
        msgid type symsgid value 'ZAPS_TASK',
        msgno type symsgno value '001',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_aps_task_invalid_class.

    methods:
      constructor
        importing
          i_textid   type scx_t100key default zcx_aps_task_invalid_class
          i_previous type ref to cx_root optional.
  protected section.
  private section.
endclass.



class zcx_aps_task_invalid_class implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = i_previous ).
    clear textid.

    if_t100_message~t100key = i_textid.
  endmethod.
endclass.
