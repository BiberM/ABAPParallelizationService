class zcl_parallelization_service definition
  public
  final
  create public .

  public section.
    interfaces zif_parallelization_service.

  protected section.
  private section.
    data:
      parameterSetsAfterExecution     type zaps_parameter_set_list.
endclass.



class zcl_parallelization_service implementation.
  method zif_parallelization_service~start.
    try.
      data(settings) = zcl_aps_settings_factory=>provideNew(
                         i_appid    = i_appId
                         i_configid = i_configId
                       ).

      data(objects) = zcl_aps_objectSelectorFactory=>provideObjectSelector( settings )->calculateObjects(
                        i_settings        = settings
                        i_infoFromCaller  = i_infoFromCaller
                      ).

      data(packages) = zcl_aps_object_packetizer_fact=>provide( settings )->packetize( objects ).

      parameterSetsAfterExecution = zcl_aps_task_starter_factory=>provide( settings )->start( packages ).
    catch zcx_aps_jobs_aborted
    into data(jobsAbortedError).
      " This one needs to be signalized to the caller. All others can be handled via message
      raise exception jobsAbortedError.

    catch cx_static_check
    into data(executionError).
      if executionError is instance of if_t100_message.
        message executionError
        type 'I'
        display like 'E'.
      endif.
    endtry.
  endmethod.


  method zif_parallelization_service~getObjectParameterSets.
    loop at parameterSetsAfterExecution
    into data(parameterSet).
      if parameterSet is instance of zif_aps_parameterset_object.
        insert cast #( parameterSet )
        into table result.
      endif.
    endloop.
  endmethod.


  method zif_parallelization_service~getFuncParameterSets.
    loop at parameterSetsAfterExecution
    into data(parameterSet).
      if parameterSet is instance of zif_aps_parameterset_func.
        insert cast #( parameterSet )
        into table result.
      endif.
    endloop.
  endmethod.


  method zif_parallelization_service~resume.
    try.
      data(settings) = zcl_aps_settings_factory=>provideExisting( i_runId ).

      parameterSetsAfterExecution = zcl_aps_task_starter_factory=>provide( settings )->resume( ).
    catch zcx_aps_jobs_aborted
    into data(jobsAbortedError).
      " This one needs to be signalized to the caller. All others can be handled via message
      raise exception jobsAbortedError.

    catch cx_static_check
    into data(executionError).
      if executionError is instance of if_t100_message.
        message executionError
        type 'I'
        display like 'E'.
      endif.
    endtry.
  endmethod.


  method zif_parallelization_service~retry.
    try.
      data(settings) = zcl_aps_settings_factory=>provideExisting( i_runId ).

      parameterSetsAfterExecution = zcl_aps_task_starter_factory=>provide( settings )->retry( ).
    catch zcx_aps_jobs_aborted
    into data(jobsAbortedError).
      " This one needs to be signalized to the caller. All others can be handled via message
      raise exception jobsAbortedError.

    catch cx_static_check
    into data(executionError).
      if executionError is instance of if_t100_message.
        message executionError
        type 'I'
        display like 'E'.
      endif.
    endtry.
  endmethod.

endclass.
