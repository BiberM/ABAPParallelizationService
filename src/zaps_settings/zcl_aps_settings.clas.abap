class zcl_aps_settings definition
  public
  final
  create private
  global friends zcl_aps_settings_factory.

  public section.
    interfaces zif_aps_settings.

  protected section.
  private section.
    data:
      appDefinition                 type zaps_paraapp,
      parallelizationConfiguration  type zaps_paraconf,
      runInfo                       type zaps_runs.

    methods:
      create
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
        raising
          zcx_aps_settings_unknown_app
          zcx_aps_settings_unknown_conf
          cx_uuid_error,

      load
        importing
          i_runid       type zaps_run_id
        raising
          zcx_aps_settings_unknown_run
          zcx_aps_settings_unknown_app
          zcx_aps_settings_unknown_conf,

      saveRunInfo.
endclass.



class zcl_aps_settings implementation.

  method create.
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

    runInfo-runid = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( ).
    runInfo-creation-creation_user = cl_abap_syst=>get_user_name( ).
    runInfo-creation-creation_transaction = cl_abap_syst=>get_transaction_code( ).
    get time stamp field runInfo-creation-creation_timestamp.
    runInfo-appid = i_appId.
    runInfo-configId = i_configId.
    zif_aps_settings~setStatusStarted( ).
  endmethod.


  method load.
    select single *
    from zaps_runs
    where runid eq @i_runId
    into @runInfo.

    if sy-subrc ne 0.
      raise exception
      type zcx_aps_settings_unknown_run
      exporting
        i_runid = i_runid.
    endif.

    select single *
    from zaps_paraapp
    where appId eq @runInfo-appId
    into @appDefinition.

    if sy-subrc ne 0.
      raise exception
      type zcx_aps_settings_unknown_app
      exporting
        i_appId = runInfo-appId.
    endif.

    select single *
    from zaps_paraconf
    where appId eq @runInfo-appId
      and configId  eq @runInfo-configId
    into @parallelizationConfiguration.

    if sy-subrc ne 0.
      raise exception
      type zcx_aps_settings_unknown_conf
      exporting
        i_appId     = runInfo-appId
        i_configid  = runInfo-configId.
    endif.
  endmethod.


  method zif_aps_settings~getmaxpackagesize.
    result = parallelizationConfiguration-maxpackagesize.
  endmethod.


  method zif_aps_settings~getmaxparalleltasks.
    result = parallelizationConfiguration-maxparalleltasks.
  endmethod.


  method zif_aps_settings~gettasktype.
    result = parallelizationConfiguration-parallelizationtype.
  endmethod.


  method zif_aps_settings~getJobNamePrefix.
    result = parallelizationconfiguration-jobnameprefix.
  endmethod.


  method zif_aps_settings~gettypeofexecutable.
    result = appDefinition-typeOfExecutable.
  endmethod.


  method zif_aps_settings~getnameofexecutable.
    result = appDefinition-nameOfExecutable.
  endmethod.


  method zif_aps_settings~getappid.
    result = appDefinition-appId.
  endmethod.


  method zif_aps_settings~getconfigid.
    result = parallelizationConfiguration-configId.
  endmethod.


  method zif_aps_settings~getObjectSelectionClassname.
    result = appDefinition-objectSelectionClass.
  endmethod.

  method zif_aps_settings~shouldwaituntilfinished.
    result = parallelizationConfiguration-waituntilfinished.
  endmethod.


  method zif_aps_settings~getRunId.
    result = runInfo-runId.
  endmethod.


  method saveRunInfo.
    runInfo-change-change_user = cl_abap_syst=>get_user_name( ).
    runInfo-change-change_transaction = cl_abap_syst=>get_transaction_code( ).
    get time stamp field runInfo-change-change_timestamp.

    modify zaps_runs
    from @runInfo.

    if sy-subrc ne 0.
      " some serious malhandling has been done with the runInfo.
      return.
    endif.
  endmethod.


  method zif_aps_settings~setStatusAborted.
    runInfo-status = zif_aps_settings~runStatusAborted.

    saveRunInfo( ).
  endmethod.


  method zif_aps_settings~setStatusCompleted.
    " Aborted status must not be overwritten
    if runInfo-status = zif_aps_settings~runStatusAborted.
      return.
    endif.

    runInfo-status = zif_aps_settings~runStatusCompleted.

    saveRunInfo( ).
  endmethod.


  method zif_aps_settings~setStatusRunning.
    runInfo-status = zif_aps_settings~runStatusRunning.

    saveRunInfo( ).
  endmethod.


  method zif_aps_settings~setStatusStarted.
    runInfo-status = zif_aps_settings~runStatusStarted.

    saveRunInfo( ).
  endmethod.


  method zif_aps_settings~isAborted.
    result = switch #(
               runInfo-status
               when zif_aps_settings~runStatusAborted then abap_true
               else abap_false
             ).
  endmethod.

endclass.
