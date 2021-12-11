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

      getPackage
        returning
          value(result)   type zaps_package,

      start
        raising
          zcx_aps_executable_call_error,

      setstatuscreated
        raising
          zcx_aps_task_status,

      setstatusstarted
        raising
          zcx_aps_task_status,

      setstatusfinished
        raising
          zcx_aps_task_status,

      setstatusaborted
        raising
          zcx_aps_task_status.

endinterface.
