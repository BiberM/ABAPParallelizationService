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

endclass.
