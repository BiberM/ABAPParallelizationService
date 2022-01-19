class zcl_aps_task_storage_db definition
  public
  final
  create private
  global friends zcl_aps_task_storage_factory.

  public section.
    interfaces:
      zif_aps_task_storage.

  protected section.
  private section.
    methods:
      setTaskStatus
        importing
          i_runId    type zaps_run_id
          i_taskid   type zaps_taskid
          i_status   type zaps_task_status
        raising
          zcx_aps_task_status.
endclass.



class zcl_aps_task_storage_db implementation.

  method zif_aps_task_storage~loadSingleTask.
    data:
      serializedTask    type xstring,
      storageLine       type zaps_taskstore,
      taskStorageKeyString  type c length 132.

    data(taskStorageKey) = value zaps_task_storage_key(
                             runid    = i_runId
                             taskid   = i_taskId
                           ).

    import taskobject = serializedTask
    from database zaps_taskstore(ts)
    to storageLine
    id taskStorageKey.

    if sy-subrc ne 0.
      raise exception
      type zcx_aps_task_storage.
    endif.

    try.
      call transformation id
      source xml serializedTask
      result taskObject = result.
    catch cx_transformation_error
    into data(transformationError).
      raise exception
      type zcx_aps_task_serialization.
    endtry.

    if i_keepOnDB = abap_false.
      delete from zaps_taskstore
      where relid     = 'TS'
        and runid     = @i_runId
        and taskid    = @i_taskId.

      if sy-subrc ne 0.
        " was that destructive reading what we did before????
        return.
      endif.
    endif.

  endmethod.


  method zif_aps_task_storage~storetask.
    if not i_task is bound.
      return.
    endif.

    try.
      call transformation id
      options data_refs = 'heap-or-create'
      source taskObject = i_task
      result xml data(serializedTask).
    catch cx_transformation_error.
      raise exception
      type zcx_aps_task_serialization.
    endtry.

    data(metaInfo) = value zaps_taskstore(
        userid    = cl_abap_syst=>get_user_name( )
        timestamp = conv #( sy-datum && sy-uzeit )
    ).

    data(taskStorageKey) = value zaps_task_storage_key(
                             runid    = i_task->getRunId( )
                             taskid   = i_task->gettaskid( )
                           ).

    export taskObject = serializedTask
    to database zaps_taskstore(ts)
    from metaInfo
    id taskStorageKey.

    if sy-subrc ne 0.
      raise exception
      type zcx_aps_task_storage.
    endif.
  endmethod.


  method zif_aps_task_storage~settaskstatuscreated.
    setTaskStatus(
      i_runId    = i_runId
      i_taskid   = i_taskid
      i_status   = 'C'
    ).
  endmethod.


  method zif_aps_task_storage~settaskstatusfinished.
    setTaskStatus(
      i_runId    = i_runId
      i_taskid   = i_taskid
      i_status   = 'F'
    ).
  endmethod.


  method zif_aps_task_storage~setTaskStatusStarted.
    setTaskStatus(
      i_runId    = i_runId
      i_taskid   = i_taskid
      i_status   = 'S'
    ).
  endmethod.


  method zif_aps_task_storage~settaskstatusaborted.
    setTaskStatus(
      i_runId    = i_runId
      i_taskid   = i_taskid
      i_status   = 'A'
    ).
  endmethod.


  method setTaskStatus.

    data(dataset) = value zaps_taskstatus(
      runid    = i_runId
      taskid   = i_taskId
      status   = i_status
    ).

    modify zaps_taskstatus
    from @dataset.

    if sy-subrc <> 0.
      raise exception
      type zcx_aps_task_status.
    endif.

  endmethod.


  method zif_aps_task_storage~loadAllTasks.
    select distinct taskId
    from zaps_taskstore
    where relid     = 'TS'
      and runId     = @i_runId
    into table @data(tasks).

    loop at tasks
    into data(task).
      insert zif_aps_task_storage~loadSingleTask(
               i_runId    = i_runId
               i_taskid   = task-taskId
             )
      into table result.
    endloop.
  endmethod.


  method zif_aps_task_storage~loadTasksForResume.
    select distinct zaps_taskstore~taskId
    from zaps_taskstore
      inner join zaps_taskstatus
        on    zaps_taskstore~runid  = zaps_taskstatus~runid
          and zaps_taskstore~taskid = zaps_taskstatus~taskid
          and zaps_taskstatus~status = 'C'
    where zaps_taskstore~relid = 'TS'
      and zaps_taskstore~runid = @i_runId
    into table @data(tasks).

    loop at tasks
    into data(task).
      insert zif_aps_task_storage~loadSingleTask(
               i_runId    = i_runId
               i_taskid   = task-taskId
               i_keepOnDB = abap_true
             )
      into table result.
    endloop.
  endmethod.


  method zif_aps_task_storage~loadTasksForRetry.
    select distinct zaps_taskstore~taskId
    from zaps_taskstore
      inner join zaps_taskstatus
        on    zaps_taskstore~runid  = zaps_taskstatus~runid
          and zaps_taskstore~taskid = zaps_taskstatus~taskid
          and ( zaps_taskstatus~status = 'C'
            or  zaps_taskstatus~status = 'S'
            or  zaps_taskstatus~status = 'A' )
    where zaps_taskstore~relid = 'TS'
      and zaps_taskstore~runid = @i_runId
    into table @data(tasks).

    loop at tasks
    into data(task).
      insert zif_aps_task_storage~loadSingleTask(
               i_runId    = i_runId
               i_taskid   = task-taskId
               i_keepOnDB = abap_true
             )
      into table result.
    endloop.
  endmethod.

endclass.
