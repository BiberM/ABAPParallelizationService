interface zif_aps_task
  public.
    interfaces:
      if_serializable_object.


    methods:
      getAppId
        returning
          value(return)   type zaps_appid,

      getConfigId
        returning
          value(return)   type zaps_configid,

      getTaskId
        returning
          value(return)   type zaps_taskid,

      setPackage
        importing
          i_package       type zaps_package,

      setSettings
        importing
          i_settings      type ref to zif_aps_settings,

      start.

endinterface.
