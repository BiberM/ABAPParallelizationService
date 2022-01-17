class ztd_aps_settings definition
  public
  final
  create public
  for testing
  duration short
  risk level harmless.

  public section.
    interfaces:
      zif_aps_settings.

    methods:
      setAppDefinition
        importing
          i_appDefintion      type zaps_paraapp,

      setParallelConfiguration
        importing
          i_parallelConfiguration type zaps_paraconf,

      setMaxPackageSize
        importing
          i_maxPackaageSize     type zaps_max_package_size,

      setMaxParallelTasks
        importing
          i_maxParallelTasks    type zaps_max_parallel_tasks.

  protected section.
  private section.
    data:
      appDefinition                 type zaps_paraapp,
      parallelizationConfiguration  type zaps_paraconf,
      runInfo                       type zaps_runs.
endclass.



class ztd_aps_settings implementation.

  method zif_aps_settings~getmaxpackagesize.
    result = parallelizationConfiguration-maxpackagesize.
  endmethod.


  method zif_aps_settings~getmaxparalleltasks.
    result = parallelizationConfiguration-maxparalleltasks.
  endmethod.


  method zif_aps_settings~gettasktype.
    result = parallelizationConfiguration-parallelizationtype.
  endmethod.


  method zif_aps_settings~getJobNamePrefix.
    result = parallelizationconfiguration-jobnameprefix.
  endmethod.


  method zif_aps_settings~gettypeofexecutable.
    result = appDefinition-typeOfExecutable.
  endmethod.


  method zif_aps_settings~getnameofexecutable.
    result = appDefinition-nameOfExecutable.
  endmethod.


  method zif_aps_settings~getappid.
    result = appDefinition-appId.
  endmethod.


  method zif_aps_settings~getconfigid.
    result = parallelizationConfiguration-configId.
  endmethod.


  method setappdefinition.
    appDefinition = i_appDefintion.
  endmethod.


  method setparallelconfiguration.
    parallelizationConfiguration = i_parallelConfiguration.
  endmethod.


  method setmaxpackagesize.
    parallelizationConfiguration-maxpackagesize = i_maxPackaageSize.
  endmethod.


  method setmaxparalleltasks.
    parallelizationConfiguration-maxparalleltasks = i_maxParallelTasks.
  endmethod.


  method zif_aps_settings~getobjectselectionclassname.
    result = appDefinition-objectselectionclass.
  endmethod.


  method zif_aps_settings~shouldwaituntilfinished.
    result = parallelizationConfiguration-waituntilfinished.
  endmethod.


  method zif_aps_settings~getrunid.
    result = runInfo-runid.
  endmethod.


  method zif_aps_settings~setstatusaborted.
    runInfo-status = zif_aps_settings~runstatusaborted.
  endmethod.


  method zif_aps_settings~setstatuscompleted.
    runInfo-status = zif_aps_settings~runstatuscompleted.
  endmethod.


  method zif_aps_settings~setstatusrunning.
    runInfo-status = zif_aps_settings~runstatusrunning.
  endmethod.


  method zif_aps_settings~setstatusstarted.
    runInfo-status = zif_aps_settings~runstatusstarted.
  endmethod.

endclass.
