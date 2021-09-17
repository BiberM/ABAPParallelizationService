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
        abstract
        importing
          taskData      type ref to zaps_package
        returning
          value(return) type ref to zif_aps_task.

  private section.
endclass.



class zcl_aps_task_starter implementation.
  method constructor.
    appId = i_appId.
    configId = i_configId.
    settings = i_settings.
  endmethod.

endclass.
