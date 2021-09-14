class zcl_aps_settings definition
  public
  final
  create public.

  public section.
    interfaces zif_aps_settings.

    methods:
      constructor
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
        raising
          zcx_aps_settings_unknown_app
          zcx_aps_settings_unknown_conf.

  protected section.
  private section.
    data:
      appDefinition                 type zaps_paraapp,
      parallelizationConfiguration  type zaps_paraconf.
endclass.



class zcl_aps_settings implementation.

  method constructor.
    select single *
    from zaps_paraapp
    where appId eq @i_appId
    into @appDefinition.

    if sy-subrc ne 0.
      raise exception
      type zcx_aps_settings_unknown_app
      exporting
        i_appId = i_appId.
    endif.

    select single *
    from zaps_paraconf
    where appId eq @i_appId
      and configId  eq @i_configId
    into @parallelizationConfiguration.

    if sy-subrc ne 0.
      raise exception
      type zcx_aps_settings_unknown_conf
      exporting
        i_appId     = i_appId
        i_configid  = i_configId.
    endif.
  endmethod.


  method zif_aps_settings~getmaxpackagesize.
    return = parallelizationConfiguration-maxpackagesize.
  endmethod.


  method zif_aps_settings~getmaxparalleltasks.
    return = parallelizationConfiguration-maxparalleltasks.
  endmethod.


  method zif_aps_settings~gettasktype.
    return = parallelizationConfiguration-parallelizationtype.
  endmethod.

  method zif_aps_settings~getJobNamePrefix.
    return = parallelizationconfiguration-jobnameprefix.
  endmethod.

endclass.
