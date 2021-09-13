interface zif_aps_task_starter
  public.
    methods:
      "! <p class="shorttext synchronized" lang="en"></p>
      "! Starts a parallel execution of App with Config
      "! @parameter i_appId | <p class="shorttext synchronized" lang="en">ID of configured application</p>
      "! @parameter i_configId | <p class="shorttext synchronized" lang="en">ID of the parallelization configuration</p>
      start
        importing
          i_appId     type zaps_appid
          i_configId  type zaps_configid.
endinterface.
