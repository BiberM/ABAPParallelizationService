class zcl_aps_parameterset_object definition
  public
  final
  create private
  global friends zcl_aps_parameterset_factory.

  public section.
    interfaces:
      zif_aps_parameterset_object.
  protected section.
  private section.
    data:
      dataReference     type ref to data,
      object            type ref to if_serializable_object.

    methods:
      createDataTypeDescriptorByRef
        importing
          i_dataRef         type ref to data
          i_parametername   type abap_parmname
        returning
          value(result)     type ref to cl_abap_datadescr
        raising
          zcx_aps_unknown_parameter.
endclass.



class zcl_aps_parameterset_object implementation.
  method zif_aps_parameterset_object~getdatareference.
    result = dataReference.
  endmethod.


  method zif_aps_parameterset_object~getobject.
    result = object.
  endmethod.


  method zif_aps_parameterset_object~setdatareference.
    try.
      data(dataType) = createDataTypeDescriptorByRef(
        i_dataRef         = i_dataRef
        i_parametername   = 'Data reference'
      ).

      create data dataReference
      type handle dataType.

    catch cx_sy_itab_line_not_found
          cx_sy_create_data_error
          zcx_aps_unknown_parameter.
      return.
    endtry.

    if i_dataRef is bound.
      assign dataReference->*
      to field-symbol(<parameter>).

      if sy-subrc ne 0.
        " type ref to data ...
        return.
      endif.

      assign i_dataRef->*
      to field-symbol(<input>).

      if sy-subrc ne 0.
        "inside that if-construct?
        return.
      endif.

      <parameter> = <input>.
    endif.
  endmethod.


  method zif_aps_parameterset_object~setobject.
    object = i_object.
  endmethod.


  method createDataTypeDescriptorByRef.

    try.
      cl_abap_typedescr=>describe_by_data_ref(
        exporting
          p_data_ref = i_dataRef
        receiving
          p_descr_ref = data(datatypeDescriptor)
        exceptions
          reference_is_initial  = 1
          others                = 2
      ).

      if sy-subrc ne 0.
        raise exception
          type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
      endif.

      result = cast cl_abap_datadescr( dataTypeDescriptor ).
    catch cx_sy_move_cast_error.
      raise exception
        type zcx_aps_unknown_parameter
        exporting
          i_parametername = conv #( i_parametername ).
    endtry.

  endmethod.

endclass.
