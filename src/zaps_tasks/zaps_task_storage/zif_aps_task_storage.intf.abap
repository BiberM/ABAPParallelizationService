interface zif_aps_task_storage
  public.
    methods:
      storeTask
        importing
          i_task        type ref to zif_aps_task,

      loadSingleTask
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
          i_taskid      type zaps_taskid
        returning
          value(result) type ref to zif_aps_task,

      loadAllTasks
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
        returning
          value(result) type zaps_task_chain,

      setTaskStatusCreated
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
          i_taskid      type zaps_taskid,

      setTaskStatusStarted
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
          i_taskid      type zaps_taskid,

      setTaskStatusFinished
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
          i_taskid      type zaps_taskid,

      setTaskStatusAborted
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
          i_taskid      type zaps_taskid.
endinterface.
