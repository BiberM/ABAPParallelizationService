interface zif_aps_task_storage
  public.
    methods:
      storeTask
        importing
          i_task        type ref to zif_aps_task
        raising
          zcx_aps_task_storage
          zcx_aps_task_serialization,

      loadSingleTask
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
          i_taskid      type zaps_taskid
        returning
          value(result) type ref to zif_aps_task
        raising
          zcx_aps_task_storage
          zcx_aps_task_serialization,

      loadAllTasks
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
        returning
          value(result) type zaps_task_chain
        raising
          zcx_aps_task_storage
          zcx_aps_task_serialization,

      settaskstatuscreated
        importing
          i_appid       type zaps_appid
          i_configid    type zaps_configid
          i_taskid      type zaps_taskid
        raising
          zcx_aps_task_status,

      settaskstatusstarted
        importing
          i_appid       type zaps_appid
          i_configid    type zaps_configid
          i_taskid      type zaps_taskid
        raising
          zcx_aps_task_status,

      settaskstatusfinished
        importing
          i_appid       type zaps_appid
          i_configid    type zaps_configid
          i_taskid      type zaps_taskid
        raising
          zcx_aps_task_status,

      settaskstatusaborted
        importing
          i_appid       type zaps_appid
          i_configid    type zaps_configid
          i_taskid      type zaps_taskid
        raising
          zcx_aps_task_status.
endinterface.
