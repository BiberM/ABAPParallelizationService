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
          i_appid    type zaps_appid
          i_configid type zaps_configid
          i_taskid   type zaps_taskid
          i_status   type zaps_task_status.
endclass.



class zcl_aps_task_storage_db implementation.

  method zif_aps_task_storage~loadtask.
    data:
      serializedTask    type xstring,
      storageLine       type zaps_taskstore,
      taskStorageKeyString  type c length 132.

    data(taskStorageKey) = value zaps_task_storage_key(
                             appid    = i_appId
                             configid = i_configId
                             taskid   = i_taskId
                           ).

    import taskobject = serializedTask
    from database zaps_taskstore(ts)
    to storageLine
    id taskStorageKey.

    if sy-subrc ne 0.
*///////////////// ToDo: Exception /////////////////////*
      return.
    endif.

    try.
      call transformation id
      source xml serializedTask
      result taskObject = result.
    catch cx_transformation_error
    into data(transformationError).
*///////////////// ToDo: Exception /////////////////////*
      return.
    endtry.

    delete from zaps_taskstore
    where relid     = 'TS'
      and appid     = @i_appId
      and configid  = @i_configId
      and taskid    = @i_taskId.

    if sy-subrc ne 0.
      " was that destructive reading what we did before????
      return.
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
*///////////////// ToDo: Exception /////////////////////*
      return.
    endtry.

    data(metaInfo) = value zaps_taskstore(
        userid    = cl_abap_syst=>get_user_name( )
        timestamp = conv #( sy-datum && sy-uzeit )
    ).

    data(taskStorageKey) = value zaps_task_storage_key(
                             appid    = i_task->getappid( )
                             configid = i_task->getconfigid( )
                             taskid   = i_task->gettaskid( )
                           ).

    export taskObject = serializedTask
    to database zaps_taskstore(ts)
    from metaInfo
    id taskStorageKey.

    if sy-subrc ne 0.
*///////////////// ToDo: Exception /////////////////////*
      return.
    endif.
  endmethod.


  method zif_aps_task_storage~settaskstatuscreated.
    setTaskStatus(
      i_appid    = i_appid
      i_configid = i_configid
      i_taskid   = i_taskid
      i_status   = 'C'
    ).
  endmethod.


  method zif_aps_task_storage~settaskstatusfinished.
    setTaskStatus(
      i_appid    = i_appid
      i_configid = i_configid
      i_taskid   = i_taskid
      i_status   = 'F'
    ).
  endmethod.


  method zif_aps_task_storage~setTaskStatusStarted.
    setTaskStatus(
      i_appid    = i_appid
      i_configid = i_configid
      i_taskid   = i_taskid
      i_status   = 'S'
    ).
  endmethod.


  method zif_aps_task_storage~settaskstatusaborted.
    setTaskStatus(
      i_appid    = i_appid
      i_configid = i_configid
      i_taskid   = i_taskid
      i_status   = 'A'
    ).
  endmethod.


  method setTaskStatus.

    data(dataset) = value zaps_taskstatus(
      appid    = i_appId
      configid = i_configId
      taskid   = i_taskId
      status   = i_status
    ).

    modify zaps_taskstatus
    from @dataset.

    if sy-subrc <> 0.
*//////////// ToDo: error handling /////////////////////////////*
      return.
    endif.

  endmethod.

endclass.
