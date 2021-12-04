interface zif_parallelization_service
  public.
    methods:
      "! <p class="shorttext synchronized" lang="en">Starts a parallel execution of App with Config</p>
      "!
      "! @parameter i_appId | <p class="shorttext synchronized" lang="en">ID of configured application</p>
      "! @parameter i_configId | <p class="shorttext synchronized" lang="en">ID of the parallelization configuration</p>
      "! @parameter i_infoFromCaller | <p class="shorttext synchronized" lang="en">object with data that helps the object selector</p>
      "! @raising zcx_aps_settings_unknown_app | <p class="shorttext synchronized" lang="en">invalid AppId</p>
      "! @raising zcx_aps_settings_unknown_conf | <p class="shorttext synchronized" lang="en">invalid ConfigId</p>
      start
        importing
          i_appId           type zaps_appid
          i_configId        type zaps_configid
          i_infoFromCaller  type ref to object optional
        raising
          zcx_aps_settings_unknown_app
          zcx_aps_settings_unknown_conf
          zcx_aps_task_creation_error
          zcx_aps_job_creation_error,

      "! <p class="shorttext synchronized" lang="en">Function Unit parameter sets after execution</p>
      "!
      "! @parameter result | <p class="shorttext synchronized" lang="en">Function Unit parameter sets after execution</p>
      getFuncParameterSets
        returning
          value(result)   type zaps_parameter_set_list_func,

      "! <p class="shorttext synchronized" lang="en">Object parameter sets after execution</p>
      "!
      "! @parameter result | <p class="shorttext synchronized" lang="en">Object parameter sets after execution</p>
      getObjectParameterSets
        returning
          value(result)   type zaps_parameter_set_list_object.
endinterface.
