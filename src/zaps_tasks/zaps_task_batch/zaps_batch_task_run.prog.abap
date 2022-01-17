*&---------------------------------------------------------------------*
*& Report zaps_batch_task_run
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zaps_batch_task_run.

  parameters:
    p_runid   type zaps_run_id obligatory,
    p_ta      type zaps_taskId obligatory.

  try.
    data(task) = zcl_aps_task_storage_factory=>provide( )->loadSingleTask(
                   i_runid    = p_runid
                   i_taskid   = p_ta
                 ).


    if task is bound.
      task->setStatusStarted( ).
      task->start( ).
      task->setStatusFinished( ).
      zcl_aps_task_storage_factory=>provide( )->storeTask( task ).
    endif.
  catch zcx_aps_executable_call_error
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
