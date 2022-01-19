interface zif_aps_settings
  public.
    interfaces:
      if_serializable_object.

    constants:
      taskTypeBatch   type zaps_task_type value 'B',
      taskTypeDialog  type zaps_task_type value 'D',
      executableTypeReport    type zaps_executable_type value 'R',
      executableTypeFuncUnit  type zaps_executable_type value 'F',
      executableTypeObject    type zaps_executable_type value 'O',
      runStatusStarted        type zaps_run_status value 'S',
      runStatusRunning        type zaps_run_status value 'R',
      runStatusCompleted      type zaps_run_status value 'C',
      runStatusAborted        type zaps_run_status value 'A'.

    methods:
      "! <p class="shorttext synchronized" lang="en">returns the Application ID</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">APS Application ID</p>
      getAppId
        returning
          value(result)   type zaps_appid,

      "! <p class="shorttext synchronized" lang="en">Returns the Configuration ID</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">APS Configuration ID</p>
      getConfigId
        returning
          value(result)   type zaps_configid,

      "! <p class="shorttext synchronized" lang="en">returns the customized maximum package size</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">maximum package size</p>
      getMaxPackageSize
        returning
          value(result)   type zaps_max_package_size,

      "! <p class="shorttext synchronized" lang="en">returns the customized maximum number of parallel tasks</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">maximum number of parallel tasks</p>
      getMaxParallelTasks
        returning
          value(result)   type zaps_max_parallel_tasks,

      "! <p class="shorttext synchronized" lang="en">returns the customized task type (Batch/Dialog)</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">task type (Batch/Dialog)</p>
      getTaskType
        returning
          value(result)   type zaps_task_type,

      "! <p class="shorttext synchronized" lang="en">returns the customized background job name prefix</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">background job name prefix</p>
      getJobNamePrefix
        returning
          value(result)   type zaps_job_prefix,

      "! <p class="shorttext synchronized" lang="en">Returns the type of the executable</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">type of the executable (report, function unit, object)</p>
      getTypeOfExecutable
        returning
          value(result)   type zaps_executable_type,

      "! <p class="shorttext synchronized" lang="en">Returns the name of the executable</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">name of the executable</p>
      getNameOfExecutable
        returning
          value(result)   type zaps_executable_name,

      "! <p class="shorttext synchronized" lang="en">Returns the class name to be used for object selection</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">Name of class for object selection</p>
      getObjectSelectionClassName
        returning
          value(result)   type zaps_obj_sel_classname,

      "! <p class="shorttext synchronized" lang="en">Returns the run ID</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">Run ID</p>
      getRunId
        returning
          value(result)   type zaps_run_id,

      "! <p class="shorttext synchronized" lang="en">Sets the status "Started"</p>
      setStatusStarted,

      "! <p class="shorttext synchronized" lang="en">Sets the status "Running"</p>
      setStatusRunning,

      "! <p class="shorttext synchronized" lang="en">Sets the status "Completed"</p>
      setStatusCompleted,

      "! <p class="shorttext synchronized" lang="en">Sets the status "Aborted"</p>
      setStatusAborted,

      "! <p class="shorttext synchronized" lang="en">checks if the run had aborted tasks</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">sign if one or more tasks aborted</p>
      isAborted
        returning
          value(result)   type abap_bool,

      "! <p class="shorttext synchronized" lang="en">Should framework wait until all tasks finished?</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">wait until all tasks finished?</p>
      shouldWaitUntilFinished
        returning
          value(result)   type abap_bool.
endinterface.
