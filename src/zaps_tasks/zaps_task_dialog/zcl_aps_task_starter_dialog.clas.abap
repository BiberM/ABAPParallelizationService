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

    methods:
      doWaitUntilFinished.
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

    doWaitUntilFinished( ).

    " loading the tasks does delete them from the temporary table
    " that's why it is always done.
    data(taskList) = zcl_aps_task_storage_factory=>provide( )->loadalltasks(
                                                                 i_appid    = settings->getAppId( )
                                                                 i_configid = settings->getConfigId( )
                                                               ).

    " receiving the results is only useful if we waited for completion
    if settings->shouldWaitUntilFinished( ) = abap_true.
      loop at taskList
      into data(taskAfterExecution).
        insert lines of taskAfterExecution->getPackage( )-selections
        into table result.
      endloop.
    endif.
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


  method doWaitUntilFinished.
    if settings->shouldwaituntilfinished( ) = abap_false.
      return.
    endif.

    " We do have a problem here. Based on the call position
    " we do know that the start of all tasks has at least been tried.
    " We could check for runningTasksCount to be zero but that will never happen
    " in case of at least one call resulting in a dump. We will never notice that
    " and therefor will never decrease runningTasksCount. As we have no identifier
    " to check the dialog process we can't check that either.
    " So currently there is absolutely no chance implementing that feature.
    return.
  endmethod.

endclass.
