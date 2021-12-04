*&---------------------------------------------------------------------*
*& Report zaps_demo_execute_funcunit
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zaps_demo_execute_funcunit.
  " This part is normally done in table customizing
  " due to git restrictions this is done within the report
  data(appDefinition) = value zaps_paraapp(
    appid                = 'APS_DEMO_FUNCUNIT'
    typeofexecutable     = 'F'
    nameofexecutable     = 'Z_APS_DEMO_FUNC_EXECUTABLE'
    objectselectionclass = 'ZCL_APS_DEMO_OBJECT_SELECT_FUN'
  ).

  modify zaps_paraapp
  from @appDefinition.


  data(configDefinition) = value zaps_paraconf(
      appid               = 'APS_DEMO_FUNCUNIT'
      configid            = 'DEMO_FUNCUNIT_5_1_BATCH'
      parallelizationtype = 'B'
      maxpackagesize      = 1
      maxparalleltasks    = 5
      jobnameprefix       = 'ZAPS_DEMO_'
      waituntilfinished   = abap_true
  ).

  modify zaps_paraconf
  from @configDefinition.


  " this part needs to be done in every usage
  data(go_parallelization) = new zcl_parallelization_service( ).

  try.
    go_parallelization->zif_parallelization_service~start(
      i_appid          = 'APS_DEMO_FUNCUNIT'
      i_configid       = 'DEMO_FUNCUNIT_5_1_BATCH'
    ).

    data(parameterSets) = go_parallelization->zif_parallelization_service~getFuncParameterSets( ).

    loop at parameterSets
    into data(parameterSet).
      data(square) = parameterSet->getExportingValue( 'E_SQUARE' ).

      assign square->*
      to field-symbol(<square>).

      if sy-subrc = 0.
        cl_demo_output=>display_text( |e_square = { <square> }| ).
      endif.
    endloop.
  catch zcx_aps_settings_unknown_app
        zcx_aps_settings_unknown_conf
        zcx_aps_task_creation_error
        zcx_aps_job_creation_error
        zcx_aps_unknown_parameter
  into data(parallelizationError).
    message parallelizationError
    type 'E'.
  endtry.


  " Again this is not necessary within real world usage
  delete from zaps_paraapp
  where appid = 'APS_DEMO_FUNCUNIT'.

  delete from zaps_paraconf
  where appid     = 'APS_DEMO_FUNCUNIT'
    and configid  = 'DEMO_FUNCUNIT_5_1_BATCH'.
