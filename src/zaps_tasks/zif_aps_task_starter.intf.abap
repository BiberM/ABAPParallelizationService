interface zif_aps_task_starter
  public.
    methods:
      "! <p class="shorttext synchronized" lang="en">Starts a parallel execution</p>
      "!
      "! @parameter i_packages | <p class="shorttext synchronized" lang="en">List of packages to be started as tasks</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">parameter sets containing the results</p>
      "! @raising zcx_aps_task_creation_error | <p class="shorttext synchronized" lang="en">error creating tasks</p>
      "! @raising zcx_aps_job_creation_error | <p class="shorttext synchronized" lang="en">error creating job</p>
      "! @raising zcx_aps_jobs_aborted | <p class="shorttext synchronized" lang="en">at least one job aborted</p>
      start
        importing
          i_packages    type ref to zaps_packages
        returning
          value(result) type zaps_parameter_set_list
        raising
          zcx_aps_task_creation_error
          zcx_aps_job_creation_error
          zcx_aps_jobs_aborted,

      "! <p class="shorttext synchronized" lang="en">Restarts an execution with all aborted and intial tasks</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">parameter sets containing the results</p>
      "! @raising zcx_aps_task_creation_error | <p class="shorttext synchronized" lang="en">Error creating the tasks</p>
      "! @raising zcx_aps_job_creation_error | <p class="shorttext synchronized" lang="en">Error creating the jobs</p>
      "! @raising zcx_aps_jobs_aborted | <p class="shorttext synchronized" lang="en">at least one job aborted</p>
      retry
        returning
          value(result) type zaps_parameter_set_list
        raising
          zcx_aps_task_creation_error
          zcx_aps_job_creation_error
          zcx_aps_jobs_aborted,

      "! <p class="shorttext synchronized" lang="en">Restarts an execution with only the intial tasks</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">parameter sets containing the results</p>
      "! @raising zcx_aps_task_creation_error | <p class="shorttext synchronized" lang="en">Error creating the tasks</p>
      "! @raising zcx_aps_job_creation_error | <p class="shorttext synchronized" lang="en">Error creating the jobs</p>
      "! @raising zcx_aps_jobs_aborted | <p class="shorttext synchronized" lang="en">at least one job aborted</p>
      resume
        returning
          value(result) type zaps_parameter_set_list
        raising
          zcx_aps_task_creation_error
          zcx_aps_job_creation_error
          zcx_aps_jobs_aborted.
endinterface.
