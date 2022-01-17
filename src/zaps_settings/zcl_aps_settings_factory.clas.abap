class zcl_aps_settings_factory definition
  public
  final
  create public.

  public section.
    class-methods:
      provideNew
        importing
          i_appId     type zaps_appid
          i_configId  type zaps_configid
        returning
          value(result) type ref to zif_aps_settings
        raising
          zcx_aps_settings_unknown_app
          zcx_aps_settings_unknown_conf
          cx_uuid_error,

      provideExisting
        importing
          i_runId     type zaps_run_id
        returning
          value(result) type ref to zif_aps_settings
        raising
          zcx_aps_settings_unknown_run
          zcx_aps_settings_unknown_app
          zcx_aps_settings_unknown_conf.

  protected section.
  private section.

endclass.



class zcl_aps_settings_factory implementation.

  method provideNew.
    result = new zcl_aps_settings( ).

    cast zcl_aps_settings( result )->create(
                                       i_appid    = i_appid
                                       i_configid = i_configid
                                     ).
  endmethod.


  method provideExisting.
    result = new zcl_aps_settings( ).

    cast zcl_aps_settings( result )->load( i_runId ).
  endmethod.

endclass.
