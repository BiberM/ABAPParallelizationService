class zcl_aps_task definition
  public
  abstract
  create protected.

  public section.
    interfaces:
      zif_aps_task
        abstract methods start.

    methods:
      constructor
        importing
          i_settings      type ref to zif_aps_settings.

  protected section.
    data:
      taskId                type zaps_taskId,
      packageToBeProcessed  type zaps_package,
      settings              type ref to zif_aps_settings.

  private section.
endclass.



class zcl_aps_task implementation.
  method zif_aps_task~getappid.
    result = settings->getAppId( ).
  endmethod.

  method zif_aps_task~getconfigid.
    result = settings->getConfigId( ).
  endmethod.

  method zif_aps_task~gettaskid.
    result = taskId.
  endmethod.

  method zif_aps_task~setpackage.
    packageToBeProcessed = i_package.
  endmethod.

  method constructor.
    settings = i_settings.

    try.
      taskId = cl_system_uuid=>create_uuid_c32_static( ).
    catch cx_uuid_error.
      " In a normal running system this should never happen
      " Fallback: Timestamp long (27 char) and random number
      try.
        data(currentTimeStamp) = value timestampl( ).
        data(fillUp) = cl_abap_random=>create( )->packedinrange(
                         min   = '10000'
                         max   = '99999'
                       ).
      catch cx_abap_random.
        fillUp = '4242'.
      endtry.

      taskId = |{ currentTimeStamp }{ fillUp }|.
    endtry.
  endmethod.


  method zif_aps_task~setStatusCreated.
    zcl_aps_task_storage_factory=>provide( )->settaskstatuscreated(
      i_appid    = settings->getAppId( )
      i_configid = settings->getConfigId( )
      i_taskid   = taskId
    ).
  endmethod.


  method zif_aps_task~setStatusFinished.
    zcl_aps_task_storage_factory=>provide( )->settaskstatusFinished(
      i_appid    = settings->getAppId( )
      i_configid = settings->getConfigId( )
      i_taskid   = taskId
    ).
  endmethod.


  method zif_aps_task~setStatusStarted.
    zcl_aps_task_storage_factory=>provide( )->settaskstatusStarted(
      i_appid    = settings->getAppId( )
      i_configid = settings->getConfigId( )
      i_taskid   = taskId
    ).
  endmethod.


  method zif_aps_task~setStatusAborted.
    zcl_aps_task_storage_factory=>provide( )->settaskstatusAborted(
      i_appid    = settings->getAppId( )
      i_configid = settings->getConfigId( )
      i_taskid   = taskId
    ).
  endmethod.

endclass.
