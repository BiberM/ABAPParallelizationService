class zcl_aps_task_starter_dialog definition
  public
  inheriting from zcl_aps_task_starter
  final
  create private
  global friends zcl_aps_task_starter_factory.

  public section.
    class-methods:
      callback
        importing
          p_task  type clike.

    methods:
      zif_aps_task_starter~start redefinition.

  protected section.

  private section.
    class-data:
      runningTasksCount   type int8.
endclass.



class zcl_aps_task_starter_dialog implementation.
  method zif_aps_task_starter~start.
    data:
      errorMessage type text200.

    runningTasksCount = 0.

    loop at i_packages->*
    reference into data(package).
      if runningTasksCount >= settings->getMaxParallelTasks( ).
        wait for asynchronous tasks
        until runningTasksCount < settings->getMaxParallelTasks( ).
      endif.

      data(task) = createtask( package ).

      zcl_aps_task_storage_factory=>provide( )->storetask( task ).

      call function 'Z_APS_TASK_STARTER_DIALOG'
        destination 'NONE'
        starting new task 'ZAPS'
        calling zcl_aps_task_starter_dialog=>callback on end of task
        exporting
          i_appid    = settings->getAppId( )
          i_configid = settings->getConfigId( )
          i_taskid   = task->getTaskId( )
        exceptions
          system_failure        = 1 message errorMessage
          communication_failure = 2 message errorMessage
          resource_failure      = 3
          others                = 4.

      if sy-subrc <> 0.
        raise exception
        type zcx_aps_job_creation_error.
      endif.

      runningTasksCount = runningTasksCount + 1.
    endloop.
  endmethod.

  method callback.
    data:
      errorMessage type text200.

    receive results
    from function 'Z_APS_TASK_STARTER_DIALOG'
    exceptions
      system_failure        = 1 message errorMessage
      communication_failure = 2 message errorMessage
      resource_failure      = 3
      others                = 4.

    if sy-subrc <> 0.
*//////////////// ToDo: Where to log? we are asynchronous ... //////////////////*
    endif.

    runningTasksCount = runningTasksCount - 1.
  endmethod.

endclass.
