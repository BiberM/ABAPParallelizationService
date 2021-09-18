*&---------------------------------------------------------------------*
*& Report zaps_batch_task_run
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zaps_batch_task_run.

  parameters:
    p_ap      type zaps_appId obligatory,
    p_co      type zaps_configId obligatory,
    p_ta      type zaps_taskId obligatory.

*/////// ToDo: Check for abort request ///////////////

  data(task) = zcl_aps_task_storage_factory=>provide( )->loadtask(
                 i_appid    = p_ap
                 i_configid = p_co
                 i_taskid   = p_ta
               ).


  if task is bound.
    task->start( ).
  endif.
