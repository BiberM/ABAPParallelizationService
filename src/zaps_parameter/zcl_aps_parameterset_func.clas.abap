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
          i_settings      type ref to zif_aps_settings
        raising
          zcx_aps_unknown_executable.

  protected section.
  private section.
    " all other parameters tables have a subset of the changing parameters structure.
    " so, we use this one for all of them as a common structure
    data:
      settings                  type ref to zif_aps_settings,
      functionUnitParameters    type abap_func_parmbind_tab,
      funcExportingparameters   type rsfb_cha,
      funcImportingparameters   type rsfb_cha,
      funcChangingparameters    type rsfb_cha,
      funcExceptions            type rsfb_exc,
      funcTableparameters       type rsfb_cha.

    methods:
      loadFunctionUnitParams
        raising
          zcx_aps_unknown_executable,

      createDataRefForParameter
        importing
          i_parameterTypedefinition type rscha
          i_parmbindEntry           type ref to abap_func_parmbind
        raising
          zcx_aps_unknown_parameter,

      createDataRefDDICReference
        importing
          i_parameterTypedefinition type rscha
          i_parmbindEntry           type ref to abap_func_parmbind
        raising
          zcx_aps_unknown_parameter,

      createDataRefObject
        importing
          i_parameterTypedefinition type rscha
          i_parmbindEntry           type ref to abap_func_parmbind
        raising
          zcx_aps_unknown_parameter,

      createDataRefInternal
        importing
          i_parameterTypedefinition type rscha
          i_parmbindEntry           type ref to abap_func_parmbind
        raising
          zcx_aps_unknown_parameter,

      copyContentOfDataRef
        importing
          i_source        type ref to data
          i_target        type ref to data.


endclass.



class zcl_aps_parameterset_func implementation.
  method zif_aps_parameterSet_func~addchanging.
    try.
      data(parameterTypeDefinition) = funcChangingParameters[ parameter = i_parametername ].
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endtry.

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

    createDataRefForParameter(
      i_parametertypedefinition = parameterTypeDefinition
      i_parmbindentry           = currentParameter
    ).

    copyContentOfDataRef(
      i_source = i_parameterValue
      i_target = currentParameter->value
    ).
  endmethod.


  method zif_aps_parameterSet_func~addexporting.
    try.
      data(parameterTypeDefinition) = funcExportingParameters[ parameter = i_parametername ].
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endtry.

    " exporting of func unit is importing for caller
    insert value #(
      name = i_parametername
      kind = abap_func_importing
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

    createDataRefForParameter(
      i_parametertypedefinition = parameterTypeDefinition
      i_parmbindentry           = currentParameter
    ).
  endmethod.

  method zif_aps_parameterSet_func~addimporting.
    try.
      data(parameterTypeDefinition) = funcImportingParameters[ parameter = i_parametername ].
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endtry.

    " importing of func unit is exporting for caller
    insert value #(
      name  = i_parametername
      kind  = abap_func_exporting
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

    createDataRefForParameter(
      i_parametertypedefinition = parameterTypeDefinition
      i_parmbindentry           = currentParameter
    ).

    copyContentOfDataRef(
      i_source = i_parameterValue
      i_target = currentParameter->value
    ).
  endmethod.

  method zif_aps_parameterSet_func~addtables.
    try.
      data(parameterTypeDefinition) = funcTableParameters[ parameter = i_parametername ].
    catch cx_sy_itab_line_not_found.
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endtry.

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

    createDataRefForParameter(
      i_parametertypedefinition = parameterTypeDefinition
      i_parmbindentry           = currentParameter
    ).

    copyContentOfDataRef(
      i_source = i_parameterValue
      i_target = currentParameter->value
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

    copyContentOfDataRef(
      i_source = i_parameterValue
      i_target = currentParameter
    ).
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

    copyContentOfDataRef(
      i_source = i_parameterValue
      i_target = currentParameter
    ).
  endmethod.

  method zif_aps_parameterSet_func~settablesvalue.
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

    copyContentOfDataRef(
      i_source = i_parameterValue
      i_target = currentParameter
    ).
  endmethod.

  method constructor.
    settings = i_settings.

    loadFunctionUnitParams( ).
  endmethod.


  method loadFunctionUnitParams.
    data:
      exportingParameters type rsfb_exp,
      importingParameters type rsfb_imp,
      tablesParameters    type rsfb_tbl.

    call function 'FUNCTION_IMPORT_INTERFACE'
      exporting
        funcname                = conv rs38l_fnam( settings->getNameOfExecutable( ) )
      tables
        exception_list          = funcExceptions
        export_parameter        = exportingParameters
        import_parameter        = importingParameters
        changing_parameter      = funcChangingparameters
        tables_parameter        = tablesParameters
      exceptions
        error_message           = 1
        function_not_found      = 2
        invalid_name            = 3
        others                  = 4.

    if sy-subrc <> 0.
      raise exception
      type zcx_aps_unknown_executable
        exporting
          i_executablename = settings->getNameOfExecutable( ).
    endif.

    " all other parameters tables have a subset of the changing parameters structure.
    " so, we use this one for all of them
    funcExportingparameters = corresponding #(
                                exportingParameters
                              ).
    funcImportingparameters = corresponding #(
                                importingParameters
                              ).

    " correction:
    " the tables parrameters have a field dbstruct but table_of = abap_false
    " as this is impicitely clear that this is a table of.
    " We want to use a common structure and therefor need table_of = abap_true set explicitely.
    funcTableParameters = value #(
      for tableParameter in tablesParameters
      (
        value rscha(
          base tableParameter
          dbfield  = tableParameter-dbstruct
          table_of = abap_true
        )
      )
    ).
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

    insert value #(
             name = 'OTHERS'
             value = lines( funcExceptions ) + 1
           )
    into table result.
  endmethod.


  method zif_aps_parameterset_func~getparameterstab.
    result = functionUnitParameters.
  endmethod.


  method createDataRefForParameter.
    if not i_parameterTypeDefinition-dbfield is initial.
      createDataRefDDICReference(
        i_parameterTypeDefinition = i_parameterTypeDefinition
        i_parmbindEntry           = i_parmbindEntry
      ).
    elseif not i_parameterTypeDefinition-ref_class is initial.
      createDataRefObject(
        i_parameterTypeDefinition = i_parameterTypeDefinition
        i_parmbindEntry           = i_parmbindEntry
      ).
    else.
      createDataRefInternal(
        i_parameterTypeDefinition = i_parameterTypeDefinition
        i_parmbindEntry           = i_parmbindEntry
      ).
    endif.
  endmethod.


  method createDataRefDDICReference.
    try.
      data(DDICName) = cond #(
                         when not i_parameterTypeDefinition-dbfield is initial
                           then i_parameterTypeDefinition-dbfield
                         when not i_parameterTypeDefinition-line_of is initial
                           then i_parameterTypeDefinition-line_of
                         else space
                       ).

      cl_abap_typedescr=>describe_by_name(
        exporting
          p_name = DDICName
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
            i_parametername = conv #( i_parameterTypeDefinition-parameter ).
      endif.

      data(dataDescriptor) = cast cl_abap_datadescr( dataTypeDescriptor ).

      if i_parameterTypeDefinition-table_of = abap_true.
        dataDescriptor = cast cl_abap_datadescr( cl_abap_tabledescr=>create( dataDescriptor ) ).
      endif.

      create data i_parmbindEntry->value
      type handle dataDescriptor.

    catch cx_sy_itab_line_not_found
          cx_sy_move_cast_error
          cx_sy_create_data_error.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parameterTypeDefinition-parameter ).
    endtry.
  endmethod.


  method createDataRefObject.
    " that's a hard one. object references are global in memory and if you copy them
    " they don't get freed as long as there is still a reference somewhere
    " so here we don't need to create a new data area and copy the contents.
    " Copying the reference is enough.
  endmethod.


  method createDataRefInternal.
    try.
      create data i_parmbindEntry->value
      type (i_parameterTypeDefinition-typ).
    catch cx_sy_create_data_error.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parameterTypeDefinition-parameter ).
    endtry.
  endmethod.


  method copyContentOfDataRef.
    if  i_source is bound
    and i_target is bound.
      assign i_target->*
      to field-symbol(<parameter>).

      if sy-subrc ne 0.
        return.
      endif.

      assign i_source->*
      to field-symbol(<input>).

      if sy-subrc ne 0.
        return.
      endif.

      <parameter> = <input>.
    endif.
  endmethod.

endclass.
