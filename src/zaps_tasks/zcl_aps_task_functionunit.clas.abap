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
    data:
      funcExportingparameters   type rsfb_exp,
      funcImportingparameters   type rsfb_imp,
      funcChangingparameters    type rsfb_cha,
      funcExceptions            type rsfb_exc,
      funcTableparameters       type rsfb_tbl.


    methods:
      loadFunctionUnitParams,

      convertParamSetToParamTab
        importing
          i_parameterSet  type ref to zaps_parameter_set
        returning
          value(result) type abap_func_parmbind_tab,

      calcExceptionsTable
        returning
          value(result) type abap_func_excpbind_tab.
endclass.



class zcl_aps_task_functionunit implementation.
  method zif_aps_task~start.
    loadFunctionUnitParams( ).

    loop at packageToBeProcessed-selections
    reference into data(parameterSet).

      data(functionUnitParameterTable) = convertParamSetToParamTab( parameterSet ).
      data(functionUnitExceptionTable) = calcExceptionsTable( ).
      data(functionUnitToBeCalled) = settings->getNameOfExecutable( ).


      try.
        call function functionUnitToBeCalled
        parameter-table functionUnitParameterTable
        exception-table functionUnitExceptionTable.
      catch cx_sy_dyn_call_illegal_func
            cx_sy_dyn_call_illegal_type
            cx_sy_dyn_call_param_missing
            cx_sy_dyn_call_param_not_found.
*/////////// ToDo: error handling ////////////////////////
      endtry.
    endloop.
  endmethod.


  method convertParamSetToParamTab.
    loop at i_parameterSet->*
    reference into data(parameter).
      " is it an exporting?
      if line_exists( funcExportingparameters[ parameter = to_upper( parameter->fieldnm ) ] ).
        insert value #(
                 kind = abap_func_exporting
                 name = to_upper( parameter->fieldnm )
                 value = ref #( parameter->low )
               )
        into table result.

        continue.
      endif.

      " is it an importing?


      " is it a tables?


      " is it a changing?
    endloop.
  endmethod.


  method loadFunctionUnitParams.
    call function 'FUNCTION_IMPORT_INTERFACE'
      exporting
        funcname                = conv rs38l_fnam( settings->getNameOfExecutable( ) )
      tables
        exception_list          = funcExceptions
        export_parameter        = funcExportingparameters
        import_parameter        = funcImportingparameters
        changing_parameter      = funcChangingparameters
        tables_parameter        = funcTableparameters
      exceptions
        error_message           = 1
        function_not_found      = 2
        invalid_name            = 3
        others                  = 4.

    if sy-subrc <> 0.
*/////////// ToDo: error handling ///////////////////////*
      return.
    endif.
  endmethod.


  method calcExceptionsTable.
    loop at funcExceptions
    reference into data(exception).
      data(desiredSubRc) = sy-tabix.

      insert value #(
               name = exception->exception
               value = desiredSubRc
             )
      into table result.
    endloop.
  endmethod.

endclass.
