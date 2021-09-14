interface zif_aps_settings
  public.
    constants:
      task_type_batch   type zaps_task_type value 'B',
      task_type_dialog  type zaps_task_type value 'D'.

    methods:
      "! <p class="shorttext synchronized" lang="en">returns the customized maximum package size</p>
      "! @parameter return | <p class="shorttext synchronized" lang="en">maximum package size</p>
      getMaxPackageSize
        returning
          value(return)   type zaps_max_package_size,

      "! <p class="shorttext synchronized" lang="en">returns the customized maximum number of parallel tasks</p>
      "! @parameter return | <p class="shorttext synchronized" lang="en">maximum number of parallel tasks</p>
      getMaxParallelTasks
        returning
          value(return)   type zaps_max_parallel_tasks,

      "! <p class="shorttext synchronized" lang="en">returns the customized task type (Batch/Dialog)</p>
      "! @parameter return | <p class="shorttext synchronized" lang="en">task type (Batch/Dialog)</p>
      getTaskType
        returning
          value(return)   type zaps_task_type,

      "! <p class="shorttext synchronized" lang="en">returns the customized background job name prefix</p>
      "! @parameter return | <p class="shorttext synchronized" lang="en">background job name prefix</p>
      getJobNamePrefix
        returning
          value(return)   type zaps_job_prefix.
endinterface.
