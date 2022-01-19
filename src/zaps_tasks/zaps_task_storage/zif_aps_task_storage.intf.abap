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
          i_runId       type zaps_run_id
          i_taskid      type zaps_taskid
          i_keepOnDB    type abap_bool default abap_false
        returning
          value(result) type ref to zif_aps_task
        raising
          zcx_aps_task_storage
          zcx_aps_task_serialization,

      loadAllTasks
        importing
          i_runId       type zaps_run_id
        returning
          value(result) type zaps_task_chain
        raising
          zcx_aps_task_storage
          zcx_aps_task_serialization,

      loadTasksForRetry
        importing
          i_runId       type zaps_run_id
        returning
          value(result) type zaps_task_chain
        raising
          zcx_aps_task_storage
          zcx_aps_task_serialization,

      loadTasksForResume
        importing
          i_runId       type zaps_run_id
        returning
          value(result) type zaps_task_chain
        raising
          zcx_aps_task_storage
          zcx_aps_task_serialization,

      settaskstatuscreated
        importing
          i_runId       type zaps_run_id
          i_taskid      type zaps_taskid
        raising
          zcx_aps_task_status,

      settaskstatusstarted
        importing
          i_runId       type zaps_run_id
          i_taskid      type zaps_taskid
        raising
          zcx_aps_task_status,

      settaskstatusfinished
        importing
          i_runId       type zaps_run_id
          i_taskid      type zaps_taskid
        raising
          zcx_aps_task_status,

      settaskstatusaborted
        importing
          i_runId       type zaps_run_id
          i_taskid      type zaps_taskid
        raising
          zcx_aps_task_status.
endinterface.
