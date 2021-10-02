class zcl_aps_object_packetizer definition
  public
  abstract
  create public.

  public section.
    interfaces:
      zif_aps_object_packetizer
        all methods abstract.

    methods:
      constructor
        importing
          i_appId         type zaps_appid
          i_configId      type zaps_configid
          i_settings      type ref to zif_aps_settings.

  protected section.
    data:
      appId           type zaps_appid,
      configId        type zaps_configid,
      settings        type ref to zif_aps_settings.
  private section.
endclass.



class zcl_aps_object_packetizer implementation.
  method constructor.
    appId = i_appId.
    configId = i_configId.
    settings = i_settings.
  endmethod.

endclass.
