class zcx_aps_settings_unknown_run definition
  public
  inheriting from cx_static_check
  final
  create public.

  public section.

    interfaces:
      if_t100_dyn_msg,
      if_t100_message.

    constants:
      begin of zcx_aps_settings_unknown_app,
        msgid type symsgid value 'ZAPS_SETTINGS',
        msgno type symsgno value '003',
        attr1 type scx_attrname value 'RUNID',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_aps_settings_unknown_app.

    methods:
      constructor
        importing
          i_textid   type scx_t100key default zcx_aps_settings_unknown_app
          i_previous type ref to cx_root optional
          i_runId type zaps_run_id.
  protected section.
  private section.
    data:
      runId type zaps_run_id.
endclass.



class zcx_aps_settings_unknown_run implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = i_previous ).
    clear textid.

    if_t100_message~t100key = i_textid.

    runId = i_runid.

  endmethod.
endclass.
