*&---------------------------------------------------------------------*
*& Report zaps_demo_execute_object
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zaps_demo_execute_object.
  " This part is normally done in table customizing
  " due to git restrictions this is done within the report
  data(appDefinition) = value zaps_paraapp(
    appid                = 'APS_DEMO_OBJECT'
    typeofexecutable     = 'O'
    nameofexecutable     = 'ZCL_APS_DEMO_OBJECT_EXECUTABLE'
    objectselectionclass = 'ZCL_APS_DEMO_OBJECT_SELECT_OBJ'
  ).

  modify zaps_paraapp
  from @appDefinition.


  data(configDefinition) = value zaps_paraconf(
      appid               = 'APS_DEMO_OBJECT'
      configid            = 'DEMO_OBJECT_5_1_BATCH'
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
      i_appid          = 'APS_DEMO_OBJECT'
      i_configid       = 'DEMO_OBJECT_5_1_BATCH'
    ).
  catch zcx_aps_settings_unknown_app
        zcx_aps_settings_unknown_conf
        zcx_aps_task_creation_error
        zcx_aps_job_creation_error
        zcx_aps_jobs_aborted
  into data(parallelizationError).
    message parallelizationError
    type 'E'.
  endtry.


  " Again this is not necessary within real world usage
  delete from zaps_paraapp
  where appid = 'APS_DEMO_OBJECT'.

  delete from zaps_paraconf
  where appid     = 'APS_DEMO_OBJECT'
    and configid  = 'DEMO_OBJECT_5_1_BATCH'.
