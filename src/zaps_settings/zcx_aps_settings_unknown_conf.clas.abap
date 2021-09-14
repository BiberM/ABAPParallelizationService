class zcx_aps_settings_unknown_conf definition
  public
  inheriting from cx_static_check
  final
  create public.

  public section.

    interfaces:
      if_t100_dyn_msg,
      if_t100_message.

    constants:
      begin of zcx_aps_settings_unknown_conf,
        msgid type symsgid value 'ZAPS_SETTINGS',
        msgno type symsgno value '002',
        attr1 type scx_attrname value 'APPID',
        attr2 type scx_attrname value 'CONFIGID',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_aps_settings_unknown_conf.

    methods:
      constructor
        importing
          i_textid    type scx_t100key default zcx_aps_settings_unknown_conf
          i_previous  type ref to cx_root optional
          i_appId     type zaps_appid
          i_configId  type zaps_configid.
  protected section.
  private section.
    data:
      appId     type zaps_appid,
      configId  type zaps_configid.
endclass.



class zcx_aps_settings_unknown_conf implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = i_previous ).
    clear textid.

    if_t100_message~t100key = i_textid.

    appId = i_appid.
    configid = i_configid.

  endmethod.
endclass.
