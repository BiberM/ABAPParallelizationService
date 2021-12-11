*"* use this source file for your ABAP unit test classes
class ltcl_parameterset_func definition deferred.
class zcl_aps_parameterset_func definition
local friends ltcl_parameterset_func.

class ltcl_parameterset_func definition final for testing
  duration short
  risk level harmless.

  private section.
    data:
      settings      type ref to ztd_aps_settings,
      cut           type ref to zcl_aps_parameterset_func.

    methods:
      setup raising cx_static_check,

      importing_in for testing raising cx_static_check,
      importing_invalid for testing raising cx_static_check,
      exporting_in for testing raising cx_static_check,
      tables_inout for testing raising cx_static_check,
      executeValidCall for testing raising cx_static_check.
endclass.


class ltcl_parameterset_func implementation.

  method setup.
    settings = new #( ).

    settings->setappdefinition( value #(
                                  appid = 'UNITTEST'
                                  typeofexecutable = 'F'
                                  nameofexecutable = 'FUNCTION_IMPORT_INTERFACE'

    ) ).

    cut = new #( settings ).
  endmethod.

  method importing_in.
    " given
    data(funcnameAsParameterValue) = 'ABC'.

    " when
    try.
      cut->zif_aps_parameterset_func~addimporting(
        i_parametername  = 'FUNCNAME'
        i_parametervalue = ref #( funcnameAsParameterValue )
      ).
    catch zcx_aps_unknown_parameter.
      cl_abap_unit_assert=>fail( 'add valid importing parameter failed' ).
    endtry.

    " then
    cl_abap_unit_assert=>assert_equals(
      act = lines( cut->functionunitparameters )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_bound( cut->functionunitparameters[ 1 ]-value ).

    data(valueRef) = cut->functionunitparameters[ 1 ]-value.

    assign valueRef->*
    to field-symbol(<valueRef>).

    cl_abap_unit_assert=>assert_equals(
      act = <valueRef>
      exp = funcnameAsParameterValue
    ).
  endmethod.

  method importing_invalid.
    " given
    data(funcnameAsParameterValue) = 'ABC'.

    " when
    try.
      cut->zif_aps_parameterset_func~addimporting(
        i_parametername  = 'ABC'
        i_parametervalue = ref #( funcnameAsParameterValue )
      ).

      " no exception? That's wrong!
      cl_abap_unit_assert=>fail( 'add invalid importing parameter did not fail' ).
    catch zcx_aps_unknown_parameter.
      " That is exactly, what we expect here!
    endtry.
  endmethod.

  method exporting_in.
    " when
    try.
      cut->zif_aps_parameterset_func~addexporting(
        i_parametername  = 'GLOBAL_FLAG'
      ).
    catch zcx_aps_unknown_parameter.
      cl_abap_unit_assert=>fail( 'add valid exporting parameter failed' ).
    endtry.

    " then
    cl_abap_unit_assert=>assert_equals(
      act = lines( cut->functionunitparameters )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_bound( cut->functionunitparameters[ 1 ]-value ).
  endmethod.

  method tables_inout.
    " given
    " yes that is stupid if executed. But until then it proves functionality
    data(exceptionListIn) = value rsfb_exc( (
      exception    = 'ABC'
      is_resumable = abap_true
    ) ).


    " when
    try.
      cut->zif_aps_parameterset_func~addtables(
        i_parametername  = 'EXCEPTION_LIST'
        i_parametervalue = ref #( exceptionListIn )
      ).
    catch zcx_aps_unknown_parameter.
      cl_abap_unit_assert=>fail( 'add valid tables parameter failed' ).
    endtry.

    " then
    cl_abap_unit_assert=>assert_equals(
      act = lines( cut->functionunitparameters )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_bound( cut->functionunitparameters[ 1 ]-value ).

    data(tableRefOut) = cut->functionunitparameters[ 1 ]-value.

    assign tableRefOut->*
    to field-symbol(<exceptionListOut>).

    cl_abap_unit_assert=>assert_equals(
      act = <exceptionListOut>
      exp = exceptionListIn
    ).
  endmethod.

  method executeValidCall.
    " given
    data(funcnameAsParameterValue) = conv rs38l_fnam( 'FUNCTION_IMPORT_INTERFACE' ).
    try.
      cut->zif_aps_parameterset_func~addimporting(
        i_parametername  = 'FUNCNAME'
        i_parametervalue = ref #( funcnameAsParameterValue )
      ).

      cut->zif_aps_parameterset_func~addtables( 'EXCEPTION_LIST' ).
      cut->zif_aps_parameterset_func~addtables( 'EXPORT_PARAMETER' ).
      cut->zif_aps_parameterset_func~addtables( 'IMPORT_PARAMETER' ).
      cut->zif_aps_parameterset_func~addtables( 'CHANGING_PARAMETER' ).
      cut->zif_aps_parameterset_func~addtables( 'TABLES_PARAMETER' ).

    catch zcx_aps_unknown_parameter.
      cl_abap_unit_assert=>fail( 'add valid parameter failed' ).
    endtry.

    " when
    data(funcUnitExceptionsTab) = cut->zif_aps_parameterset_func~getexceptionstab( ).

    try.
        call function funcnameAsParameterValue
        parameter-table cut->functionunitparameters
        exception-table funcUnitExceptionsTab.

        if sy-subrc <> 0.
          cl_abap_unit_assert=>fail( 'Func Unit Exception occured' ).
        endif.
      catch cx_sy_dyn_call_illegal_func
            cx_sy_dyn_call_illegal_type
            cx_sy_dyn_call_param_missing
            cx_sy_dyn_call_param_not_found.
        cl_abap_unit_assert=>fail( 'valid func Unit call failed' ).
      endtry.
  endmethod.

endclass.
