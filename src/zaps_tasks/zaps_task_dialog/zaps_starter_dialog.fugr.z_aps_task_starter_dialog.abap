function z_aps_task_starter_dialog.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_APPID) TYPE  ZAPS_APPID
*"     VALUE(I_CONFIGID) TYPE  ZAPS_CONFIGID
*"     VALUE(I_TASKID) TYPE  ZAPS_TASKID
*"----------------------------------------------------------------------

  try.
    data(task) = zcl_aps_task_storage_factory=>provide( )->loadSingleTask(
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
  catch zcx_aps_executable_call_error
        zcx_aps_task_storage
        zcx_aps_task_serialization
        zcx_aps_task_status
  into data(callError).
    data(previousError) = callError->previous.
    while previousError is bound.
      if  previousError is instance of if_t100_message.
        message callError->previous
        type 'I'
        display like 'E'.
      endif.

      if previousError->previous is bound.
        previousError = previousError->previous.
      endif.
    endwhile.

    if callError is instance of if_t100_message.
      message callError
      type 'I'
      display like 'E'.
    endif.
  endtry.


ENDFUNCTION.
