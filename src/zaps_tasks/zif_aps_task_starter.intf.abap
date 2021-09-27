interface zif_aps_task_starter
  public.
    methods:
      "! <p class="shorttext synchronized" lang="en"></p>
      "! Starts a parallel execution of App with Config
      "! @parameter i_appId | <p class="shorttext synchronized" lang="en">ID of configured application</p>
      "! @parameter i_configId | <p class="shorttext synchronized" lang="en">ID of the parallelization configuration</p>
      "! @parameter i_packages | <p class="shorttext synchronized" lang="en">List of packages to be started as tasks</p>
      "! raising zcx_aps_task_invalid_class | <p class="shorttext synchronized" lang="en">invalid class specified</p>
      "! raising zcx_aps_task_instanciation_err | <p class="shorttext synchronized" lang="en">instanciation error</p>
      "! raising zcx_aps_task_unknown_exec_type | <p class="shorttext synchronized" lang="en">unknown executable type</p>
      "! raising zcx_aps_task_job_creation | <p class="shorttext synchronized" lang="en">error creating job</p>
      "! raising zcx_aps_task_job_submit | <p class="shorttext synchronized" lang="en">error submiting runner to job</p>
      "! raising zcx_aps_task_job_release | <p class="shorttext synchronized" lang="en">error releasing job</p>
      "! raising zcx_aps_task_job_event_raise | <p class="shorttext synchronized" lang="en">error raising job start event</p>
      start
        importing
          i_appId     type zaps_appid
          i_configId  type zaps_configid
          i_packages  type zaps_packages
        raising
          zcx_aps_task_invalid_class
          zcx_aps_task_instanciation_err
          zcx_aps_task_unknown_exec_type
          zcx_aps_task_job_creation
          zcx_aps_task_job_submit
          zcx_aps_task_job_release
          zcx_aps_task_job_event_raise.
endinterface.
