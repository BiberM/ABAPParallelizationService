interface zif_aps_task_storage
  public.
    methods:
      storeTask
        importing
          i_task        type ref to zif_aps_task,
      loadTask
        importing
          i_appId       type zaps_appid
          i_configId    type zaps_configid
          i_taskid      type zaps_taskid
        returning
          value(return) type ref to zif_aps_task.
endinterface.
