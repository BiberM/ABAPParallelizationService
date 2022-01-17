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

    settings->setStatusRunning( ).

    loop at i_packages->*
    reference into data(package).
      data(taskNumber) = sy-tabix.

      if runningTasksCount >= settings->getMaxParallelTasks( ).
        wait for asynchronous tasks
        until runningTasksCount < settings->getMaxParallelTasks( ).
      endif.

      data(task) = createtask( package ).

      try.
        zcl_aps_task_storage_factory=>provide( )->storetask( task ).
      catch zcx_aps_task_storage
            zcx_aps_task_serialization
      into data(storageError).
        message storageError
        type 'I'
        display like 'E'.

        continue.
      endtry.

      data(funcUnitTaskId) = |{ settings->getJobNamePrefix( ) }-{ taskNumber }|.

      " for the possible event of a ressource shortage:
      " we'll wait for one of our own jobs to finish
      " if all ended and error remains we have to raise an exception.

      call function 'Z_APS_TASK_STARTER_DIALOG'
        destination 'NONE'
        starting new task funcUnitTaskId
        calling zcl_aps_task_starter_dialog=>callback on end of task
        exporting
          i_runId    = task->getRunId( )
          i_taskid   = task->getTaskId( )
        exceptions
          system_failure        = 1 message errorMessage
          communication_failure = 2 message errorMessage
          resource_failure      = 3
          others                = 4.

      case sy-subrc.
        when 0.
          "all fine
          runningTasksCount = runningTasksCount + 1.

        when 1 or 2.
          settings->setStatusAborted( ).

          " directly throw an exception as this is a major issue
          raise exception
          type zcx_aps_job_creation_error.

        when 3.
          if runningTasksCount > 0.
            wait for asynchronous tasks
            until runningTasksCount < settings->getMaxParallelTasks( ).
          else.
            settings->setStatusAborted( ).

            raise exception
            type zcx_aps_job_creation_error.
          endif.

        when others.
          settings->setStatusAborted( ).

          " directly throw an exception as this is a major issue
          raise exception
          type zcx_aps_job_creation_error.
      endcase.
    endloop.

    doWaitUntilFinished( ).

    " loading the tasks does delete them from the temporary table
    " that's why it is always done.
    try.
      data(tasklist) = zcl_aps_task_storage_factory=>provide( )->loadalltasks( settings->getRunId( ) ).
    catch zcx_aps_task_storage
          zcx_aps_task_serialization
    into data(storageErrorLoad).
      message storageErrorLoad
      type 'I'
      display like 'E'.

      taskList = value zaps_task_chain( ).
    endtry.

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

    " although we are not sure if we can
    runningTasksCount = runningTasksCount - 1.

    receive results
    from function 'Z_APS_TASK_STARTER_DIALOG'
    exceptions
      system_failure        = 1 message errorMessage
      communication_failure = 2 message errorMessage
      resource_failure      = 3
      others                = 4.

    if sy-subrc <> 0.
      if not errorMessage is initial.
        message errorMessage
        type 'I'
        display like 'E'.
      endif.
    endif.
  endmethod.


  method doWaitUntilFinished.
    " with dialog parallelization we always have to wait for the last started jobs
    wait for asynchronous tasks
    until runningTasksCount = 0.

    " We do have a problem here. Based on the call position
    " we do know that the start of all tasks has at least been tried.
    " We do check for runningTasksCount to be zero but that will never happen
    " in case of at least one call resulting in a dump. We will never notice that
    " and therefor will never decrease runningTasksCount. As we have no identifier
    " to check the dialog process we can't check that either.
    " So currently there is absolutely no chance implementing that feature.
    return.
  endmethod.

endclass.
