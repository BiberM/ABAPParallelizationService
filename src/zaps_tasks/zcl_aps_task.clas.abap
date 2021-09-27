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
          i_appId         type zaps_appId
          i_configId      type zaps_configId.

  protected section.
    data:
      appId                 type zaps_appId,
      configId              type zaps_configId,
      taskId                type zaps_taskId,
      packageToBeProcessed  type zaps_package,
      settings              type ref to zif_aps_settings.

  private section.
endclass.



class zcl_aps_task implementation.
  method zif_aps_task~getappid.
    return = appId.
  endmethod.

  method zif_aps_task~getconfigid.
    return = configId.
  endmethod.

  method zif_aps_task~gettaskid.
    return = taskId.
  endmethod.

  method zif_aps_task~setpackage.
    packageToBeProcessed = i_package.
  endmethod.

  method zif_aps_task~setsettings.
    settings = i_settings.
  endmethod.

  method constructor.
    appId = i_appId.
    configId = i_configId.

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

endclass.
