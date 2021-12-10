*&---------------------------------------------------------------------*
*& Report zaps_demo_execute_func_dia
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zaps_demo_execute_func_dia.
  " This part is normally done in table customizing
  " due to git restrictions this is done within the report
  data(appDefinition) = value zaps_paraapp(
    appid                = 'APS_DEMO_FUNCUNIT_DIA'
    typeofexecutable     = 'F'
    nameofexecutable     = 'Z_APS_DEMO_FUNC_EXECUTABLE'
    objectselectionclass = 'ZCL_APS_DEMO_OBJECT_SELECT_FUN'
  ).

  modify zaps_paraapp
  from @appDefinition.


  data(configDefinition) = value zaps_paraconf(
      appid               = 'APS_DEMO_FUNCUNIT_DIA'
      configid            = 'DEMO_FUNCUNIT_5_1_DIA'
      parallelizationtype = 'D'
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
      i_appid          = 'APS_DEMO_FUNCUNIT_DIA'
      i_configid       = 'DEMO_FUNCUNIT_5_1_DIA'
    ).

    data(parameterSets) = go_parallelization->zif_parallelization_service~getFuncParameterSets( ).

    data(outputText) = value string( ).

    loop at parameterSets
    into data(parameterSet).
      data(square) = parameterSet->getExportingValue( 'E_SQUARE' ).

      assign square->*
      to field-symbol(<square>).

      if sy-subrc = 0.
        outputText = outputText && |\ne_square = { <square> }|.
      endif.
    endloop.

    cl_demo_output=>display_text( outputText ).

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
  where appid = 'APS_DEMO_FUNCUNIT_DIA'.

  delete from zaps_paraconf
  where appid     = 'APS_DEMO_FUNCUNIT_DIA'
    and configid  = 'DEMO_FUNCUNIT_5_1_DIA'.
