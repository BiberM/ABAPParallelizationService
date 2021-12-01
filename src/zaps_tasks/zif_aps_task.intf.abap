interface zif_aps_task
  public.
    interfaces:
      if_serializable_object.


    methods:
      getAppId
        returning
          value(result)   type zaps_appid,

      getConfigId
        returning
          value(result)   type zaps_configid,

      getTaskId
        returning
          value(result)   type zaps_taskid,

      setPackage
        importing
          i_package       type zaps_package,

      start,

      setStatusCreated,

      setStatusStarted,

      setStatusFinished,

      setStatusAborted.

endinterface.
