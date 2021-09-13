class zcl_aps_settings_factory definition
  public
  final
  create public.

  public section.
    methods:
      provide
        importing
          i_appId     type zaps_appid
          i_configId  type zaps_configid
        returning
          value(return) type ref to zif_aps_settings.

  protected section.
  private section.
    types:
      begin of objectBufferLineType,
        appId     type zaps_appid,
        configId  type zaps_configid,
        instance  type ref to zif_aps_settings,
      end of objectbufferlinetype.

    data:
      objectBuffer  type hashed table
                         of objectBufferLineType
                         with unique key appId
                                         configid.

endclass.



class zcl_aps_settings_factory implementation.

  method provide.
    try.
      return = objectbuffer[ appid    = i_appId
                             configid = i_configid ]-instance.
    catch cx_sy_itab_line_not_found.
      return = new zcl_aps_settings(
                     i_appid    = i_appid
                     i_configid = i_configid
                   ).

      insert value objectbufferlinetype(
                     appid    = i_appId
                     configid = i_configid
                     instance = return
                   )
      into table objectbuffer.
    endtry.
  endmethod.

endclass.
