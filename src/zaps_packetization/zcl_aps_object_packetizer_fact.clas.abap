class zcl_aps_object_packetizer_fact definition
  public
  final
  create public.

  public section.
    class-methods:
      provide
        importing
          i_appId         type zaps_appid
          i_configId      type zaps_configid
          i_settings      type ref to zif_aps_settings
        returning
          value(result)   type ref to zif_aps_object_packetizer.
  protected section.
  private section.
endclass.



class zcl_aps_object_packetizer_fact implementation.
  method provide.
*///////// ToDo: different types from settings /////////////////*
    result = new zcl_aps_object_packetizer_roro(
               i_appId    = i_appId
               i_configId = i_configId
               i_settings = i_settings
             ).
  endmethod.

endclass.
