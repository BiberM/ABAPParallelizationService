class zcx_aps_unknown_parameter definition
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
        msgid type symsgid value 'ZAPS_PARAMETER',
        msgno type symsgno value '001',
        attr1 type scx_attrname value 'PARAMETERNAME',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_aps_settings_unknown_app.

    methods:
      constructor
        importing
          i_textid   type scx_t100key default zcx_aps_settings_unknown_app
          i_previous type ref to cx_root optional
          i_parameterName type text50.
  protected section.
  private section.
    data:
      parameterName type text50.
endclass.



class zcx_aps_unknown_parameter implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = i_previous ).
    clear textid.

    if_t100_message~t100key = i_textid.

    parameterName = i_parameterName.

  endmethod.
endclass.
