class zcl_aps_task_starter definition
  public
  abstract
  create protected.

  public section.
    interfaces:
      zif_aps_task_starter
        all methods abstract.

    methods:
      constructor
        importing
          i_appId     type zaps_appId
          i_configId  type zaps_configId
          i_settings  type ref to zif_aps_settings.

  protected section.
    data:
      appId     type zaps_appId,
      configId  type zaps_configId,
      settings  type ref to zif_aps_settings.

    methods:
      createTask
        importing
          taskData      type ref to zaps_package
        returning
          value(result) type ref to zif_aps_task
        raising
          zcx_aps_task_creation_error.

  private section.
endclass.



class zcl_aps_task_starter implementation.
  method constructor.
    appId = i_appId.
    configId = i_configId.
    settings = i_settings.
  endmethod.


  method createTask.
    try.
        result = zcl_aps_task_factory=>provide(
            i_appid       = appid
            i_configid    = configid
            i_settings    = settings
            i_packagedata = taskdata->*
        ).
    catch zcx_aps_task_invalid_class
          zcx_aps_task_instanciation_err
          zcx_aps_task_unknown_exec_type
    into data(detailedError).
      raise exception
      type zcx_aps_task_creation_error
      exporting
        i_previous = detailedError.
    endtry.
  endmethod.

endclass.
