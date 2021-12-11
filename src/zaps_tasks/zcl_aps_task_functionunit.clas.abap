class zcl_aps_task_functionunit definition
  public
  inheriting from zcl_aps_task
  final
  create private
  global friends zcl_aps_task_factory.

  public section.
    methods:
      zif_aps_task~start redefinition.

  protected section.
  private section.
endclass.



class zcl_aps_task_functionunit implementation.
  method zif_aps_task~start.
    loop at packageToBeProcessed-selections
    into data(parameterSet).

      try.
        data(funcUnitParameterSet) = cast zif_aps_parameterset_func( parameterSet ).
      catch cx_sy_move_cast_error.
        continue.
      endtry.

      data(functionUnitParameterTable) = funcUnitParameterSet->getParametersTab( ).
      data(functionUnitExceptionTable) = funcUnitParameterSet->getExceptionsTab( ).
      data(functionUnitToBeCalled) = settings->getNameOfExecutable( ).


      try.
        call function functionUnitToBeCalled
        parameter-table functionUnitParameterTable
        exception-table functionUnitExceptionTable.
      catch cx_sy_dyn_call_illegal_func
            cx_sy_dyn_call_illegal_type
            cx_sy_dyn_call_param_missing
            cx_sy_dyn_call_param_not_found
      into data(callError).
        raise exception
        type zcx_aps_executable_call_error
        exporting
          i_previous  = callError.
      endtry.
    endloop.
  endmethod.

endclass.
