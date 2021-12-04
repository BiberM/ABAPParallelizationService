function z_aps_task_starter_dialog.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_APPID) TYPE  ZAPS_APPID
*"     VALUE(I_CONFIGID) TYPE  ZAPS_CONFIGID
*"     VALUE(I_TASKID) TYPE  ZAPS_TASKID
*"----------------------------------------------------------------------

  data(task) = zcl_aps_task_storage_factory=>provide( )->loadTask(
                 i_appid    = i_appId
                 i_configid = i_configId
                 i_taskid   = i_taskId
               ).


  if task is bound.
    task->setStatusStarted( ).
    task->start( ).
    task->setStatusFinished( ).
    zcl_aps_task_storage_factory=>provide( )->storeTask( task ).
  endif.


ENDFUNCTION.
