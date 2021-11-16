class zcl_aps_parameterset_func definition
  public
  final
  create private
  global friends zcl_aps_parameterset_factory.

  public section.
    interfaces:
      zif_aps_parameterSet_func.

    methods:
      constructor
        importing
          i_settings      type ref to zif_aps_settings.

  protected section.
  private section.
    data:
      settings                  type ref to zif_aps_settings,
      functionUnitParameters    type abap_func_parmbind_tab,
      funcExportingparameters   type rsfb_exp,
      funcImportingparameters   type rsfb_imp,
      funcChangingparameters    type rsfb_cha,
      funcExceptions            type rsfb_exc,
      funcTableparameters       type rsfb_tbl.

    methods:
      loadFunctionUnitParams,

      createDataTypeDescriptor
        importing
          i_dataType        type likefield
          i_parametername   type abap_parmname
        returning
          value(result)     type ref to cl_abap_datadescr
        raising
          zcx_aps_unknown_parameter.


endclass.



class zcl_aps_parameterset_func implementation.
  method zif_aps_parameterSet_func~addchanging.
    insert value #(
      name = i_parametername
      kind = abap_func_changing
    )
    into table functionUnitParameters
    reference into data(currentParameter).

    if sy-subrc ne 0.
      "duplicate key for example?
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endif.

    try.
      data(dataType) = createDataTypeDescriptor(
        i_dataType        = funcChangingparameters[ parameter = i_parametername ]-dbfield
        i_parametername   = i_parametername
      ).

      create data currentParameter->value
      type handle dataType.

    catch cx_sy_itab_line_not_found
          cx_sy_create_data_error.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.

    if  i_parametervalue is supplied
    and i_parametervalue is bound.
      assign currentParameter->value->*
      to field-symbol(<parameter>).

      if sy-subrc ne 0.
        "that cannot fail as it is one field of a structure
        "the insert has succeeded!
        return.
      endif.

      assign i_parameterValue->*
      to field-symbol(<input>).

      if sy-subrc ne 0.
        "inside that if-construct?
        return.
      endif.

      <parameter> = <input>.
    endif.
  endmethod.


  method createDataTypeDescriptor.

    try.
      cl_abap_typedescr=>describe_by_name(
        exporting
          p_name = i_dataType
        receiving
          p_descr_ref = data(datatypeDescriptor)
        exceptions
          type_not_found  = 1
          others          = 2
      ).

      if sy-subrc ne 0.
        raise exception
          type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
      endif.

      result = cast cl_abap_datadescr( dataTypeDescriptor ).
    catch cx_sy_itab_line_not_found
          cx_sy_move_cast_error.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.

  endmethod.


  method zif_aps_parameterSet_func~addexporting.
    insert value #(
      name = i_parametername
      kind = abap_func_exporting
    )
    into table functionUnitParameters
    reference into data(currentParameter).

    if sy-subrc ne 0.
      "duplicate key for example?
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endif.

    try.
      data(dataType) = createDataTypeDescriptor(
        i_dataType        = funcExportingparameters[ parameter = i_parametername ]-dbfield
        i_parametername   = i_parametername
      ).

      create data currentParameter->value
      type handle dataType.

    catch cx_sy_itab_line_not_found
          cx_sy_create_data_error.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.
  endmethod.

  method zif_aps_parameterSet_func~addimporting.
    insert value #(
      name  = i_parametername
      kind  = abap_func_importing
      value = i_parametervalue
    )
    into table functionUnitParameters
    reference into data(currentParameter).

    if sy-subrc ne 0.
      "duplicate key for example?
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endif.
  endmethod.

  method zif_aps_parameterSet_func~addtables.
    insert value #(
      name = i_parametername
      kind = abap_func_tables
    )
    into table functionUnitParameters
    reference into data(currentParameter).

    if sy-subrc ne 0.
      "duplicate key for example?
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endif.

    try.
      data(dataType) = createDataTypeDescriptor(
        i_dataType        = funcTableParameters[ parameter = i_parametername ]-dbstruct
        i_parametername   = i_parametername
      ).

      create data currentParameter->value
      type handle dataType.

    catch cx_sy_itab_line_not_found
          cx_sy_create_data_error.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.

    zif_aps_parameterSet_func~settablesvalue(
      i_parametername  = i_parametername
      i_parametervalue = i_parametervalue
    ).
  endmethod.

  method zif_aps_parameterSet_func~getchangingvalue.
    try.
      result = functionUnitParameters[
                 name = i_parametername
               ]-value.
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.
  endmethod.

  method zif_aps_parameterSet_func~getexportingvalue.
    try.
      result = functionUnitParameters[
                 name = i_parametername
               ]-value.
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.
  endmethod.

  method zif_aps_parameterSet_func~gettablesvalue.
    try.
      result = functionUnitParameters[
                 name = i_parametername
               ]-value.
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.
  endmethod.

  method zif_aps_parameterSet_func~setchangingvalue.
    try.
      data(currentParameter) = functionUnitParameters[
                                 name = i_parametername
                               ]-value.
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.

    if  i_parametervalue is bound.
      assign currentParameter->*
      to field-symbol(<parameter>).

      if sy-subrc ne 0.
        "that cannot fail as it is one field of a structure
        "the insert has succeeded!
        return.
      endif.

      assign i_parameterValue->*
      to field-symbol(<input>).

      if sy-subrc ne 0.
        "inside that if-construct?
        return.
      endif.

      <parameter> = <input>.
    endif.
  endmethod.

  method zif_aps_parameterSet_func~setexportingvalue.
    try.
      data(currentParameter) = functionUnitParameters[
                                 name = i_parametername
                               ]-value.
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.

    if  i_parametervalue is bound.
      assign currentParameter->*
      to field-symbol(<parameter>).

      if sy-subrc ne 0.
        "that cannot fail as it is one field of a structure
        "the insert has succeeded!
        return.
      endif.

      assign i_parameterValue->*
      to field-symbol(<input>).

      if sy-subrc ne 0.
        "inside that if-construct?
        return.
      endif.

      <parameter> = <input>.
    endif.
  endmethod.

  method zif_aps_parameterSet_func~settablesvalue.
    field-symbols:
      <parameter> type table,
      <input>     type table.

    try.
      data(currentParameter) = functionUnitParameters[
                                 name = i_parametername
                               ]-value.
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.


    if  i_parametervalue is bound.
      assign currentParameter->*
      to <parameter>.

      if sy-subrc ne 0.
        return.
      endif.

      assign i_parameterValue->*
      to <input>.

      if sy-subrc ne 0.
        "inside that if-construct?
        return.
      endif.

      <parameter>[] = <input>[].
    endif.
  endmethod.

  method constructor.
    settings = i_settings.

    loadFunctionUnitParams( ).
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


  method zif_aps_parameterset_func~getexceptionstab.
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


  method zif_aps_parameterset_func~getparameterstab.
    result = functionUnitParameters.
  endmethod.

endclass.
