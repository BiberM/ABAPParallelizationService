interface zif_aps_task_starter
  public.
    methods:
      "! <p class="shorttext synchronized" lang="en"></p>
      "! Starts a parallel execution
      "! @parameter i_packages | <p class="shorttext synchronized" lang="en">List of packages to be started as tasks</p>
      "! raising zcx_aps_task_creation_error | <p class="shorttext synchronized" lang="en">error creating tasks</p>
      "! raising zcx_aps_job_creation_error | <p class="shorttext synchronized" lang="en">error creating job</p>
      start
        importing
          i_packages  type ref to zaps_packages
        raising
          zcx_aps_task_creation_error
          zcx_aps_job_creation_error.
endinterface.
