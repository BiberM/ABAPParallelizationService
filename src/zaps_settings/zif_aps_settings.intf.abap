interface zif_aps_settings
  public.
    methods:
      getMaxPackageSize
        returning
          value(return)   type zaps_max_package_size,

      getMaxParallelTasks
        returning
          value(return)   type zaps_max_parallel_tasks,

      getTaskType
        returning
          value(return)   type zaps_task_type.
endinterface.
