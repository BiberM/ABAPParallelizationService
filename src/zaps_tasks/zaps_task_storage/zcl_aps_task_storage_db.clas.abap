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
      serializedTask    type string.

    data(taskStorageKey) = value zaps_task_storage_key(
                             appid    = i_appId
                             configid = i_configId
                             taskid   = i_taskId
                           ).

    import taskobject = serializedTask
    from database zaps_taskstore(ts)
    id taskstoragekey.

    if sy-subrc ne 0.
*///////////////// ToDo: Exception /////////////////////*
      return.
    endif.

    try.
      call transformation id
      source xml serializedTask
      result taskObject = result.
    catch cx_transformation_error.
*///////////////// ToDo: Exception /////////////////////*
      return.
    endtry.
  endmethod.


  method zif_aps_task_storage~storetask.
    if not i_task is bound.
      return.
    endif.

    try.
      call transformation id
      source taskObject = i_task
      result xml data(serializedTask).
    catch cx_transformation_error.
*///////////////// ToDo: Exception /////////////////////*
      return.
    endtry.

    data(metaInfo) = value zaps_taskstore(
        userid    = conv #( sy-datum && sy-uzeit )
        timestamp = cl_abap_syst=>get_user_name( )
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
