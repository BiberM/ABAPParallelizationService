*"* use this source file for your ABAP unit test classes
class ltcl_parameterset_report definition deferred.
class zcl_aps_parameterset_report definition
local friends ltcl_parameterset_report.

class ltcl_parameterset_report definition
  final
  for testing
  duration short
  risk level harmless.

  private section.
    data:
      settings      type ref to ztd_aps_settings,
      cut           type ref to zcl_aps_parameterset_report.

    methods:
      setup,

      addParameterValid for testing raising cx_static_check,
      addParameterInvalid for testing raising cx_static_check,
      addSelectOptionValid for testing raising cx_static_check,
      addSelectOptionAllInvalid for testing raising cx_static_check,
      addSelectOptionPartInvalid for testing raising cx_static_check,
      executeValidCall for testing raising cx_static_check.

endclass.


class ltcl_parameterset_report implementation.

  method addparameterinvalid.
    " given
    data(parameterValue) = conv char14( 'AB1' ).

    " when
    try.
      cut->zif_aps_parameterset_report~addparameter(
        i_parametername  = 'INVALID'
        i_parametervalue = conv #( parameterValue )
      ).
    catch zcx_aps_unknown_parameter.
      " exactly what we expect
      return.
    endtry.

    cl_abap_unit_assert=>fail( 'invalid parameter not found' ).
  endmethod.

  method addparametervalid.
    " given
    data(parameterValue) = conv char14( 'AB1' ).

    " when
    try.
      cut->zif_aps_parameterset_report~addparameter(
        i_parametername  = 'PARAMET'
        i_parametervalue = conv #( parameterValue )
      ).
    catch zcx_aps_unknown_parameter.
      cl_abap_unit_assert=>fail( 'add valid parameter failed' ).
    endtry.

    " then
    cl_abap_unit_assert=>assert_equals(
      act = lines( cut->selections )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->selections[ 1 ]-low
      exp = parameterValue
    ).
  endmethod.

  method addselectoptionallinvalid.
    " given
    data(selectOption) = value rotselect(
                           (
                             fieldnm   = 'IAMINVALID'
                             sign      = 'I'
                             option    = 'BT'
                             low       = 42
                             high      = 1337
                           )
                         ).

    " when
    try.
      cut->zif_aps_parameterset_report~addSelectOption( selectOption ).
    catch zcx_aps_unknown_parameter.
      " exactly what we expect
      return.
    endtry.

    " Invalid Select Option not found --> error!
    cl_abap_unit_assert=>fail(
      msg   = 'Invalid Select Option not found'
      quit  = if_abap_unit_constant=>quit-no
    ).

    cl_abap_unit_assert=>assert_initial( cut->selections ).
  endmethod.

  method addselectoptionpartinvalid.
    " given
    data(selectOption) = value rotselect(
                           (
                             fieldnm   = 'SELECTO'
                             sign      = 'I'
                             option    = 'BT'
                             low       = 42
                             high      = 1337
                           )
                           (
                             fieldnm   = 'IAMINVALID'
                             sign      = 'I'
                             option    = 'BT'
                             low       = 42
                             high      = 1337
                           )
                         ).

    " when
    try.
      cut->zif_aps_parameterset_report~addSelectOption( selectOption ).
    catch zcx_aps_unknown_parameter.
      " exactly what we expect
      return.
    endtry.

    " Invalid Select Option not found --> error!
    cl_abap_unit_assert=>fail(
      msg   = 'Invalid Select Option not found'
      quit  = if_abap_unit_constant=>quit-no
    ).

    cl_abap_unit_assert=>assert_initial( cut->selections ).
  endmethod.

  method addselectoptionvalid.
    " given
    data(selectOption) = value rotselect(
                           fieldnm   = 'SELECTO'
                           sign      = 'I'
                           option    = 'BT'
                           (
                             low       = 0
                             high      = 42
                           )
                           (
                             low       = 1337
                             high      = 31337
                           )
                         ).

    " when
    try.
      cut->zif_aps_parameterset_report~addSelectOption( selectOption ).
    catch zcx_aps_unknown_parameter.
      cl_abap_unit_assert=>fail( 'add valid select option failed' ).
    endtry.

    " then
    cl_abap_unit_assert=>assert_equals(
      act = lines( cut->selections )
      exp = 2
    ).
  endmethod.

  method executevalidcall.
    " given
    try.
      cut->zif_aps_parameterset_report~addparameter(
        i_parametername  = 'PARAMET'
        i_parametervalue = 'ABC'
      ).

      cut->zif_aps_parameterset_report~addselectoption( value rotselect(
        fieldnm   = 'SELECTO'
        sign      = 'I'
        option    = 'BT'
        (
          low       = 0
          high      = 42
        )
        (
          low       = 1337
          high      = 31337
        )
      ) ).

    catch zcx_aps_unknown_parameter.
      cl_abap_unit_assert=>fail( 'Error setting selection screen data' ).
    endtry.

    data(selectionScreenData) = cut->zif_aps_parameterset_report~getSelectionsTable( ).
    data(reportName) = settings->zif_aps_settings~getNameOfExecutable( ).

    submit (reportName)
    with selection-table selectionScreenData
    and return.
  endmethod.

  method setup.
    settings = new #( ).

    settings->setAppDefinition( value #(
                                  appid = 'UNITTEST'
                                  typeofexecutable = 'R'
                                  nameofexecutable = 'DEMO_PROGRAM_SUBMIT_REP'

    ) ).

    try.
      cut = new #( settings ).
    catch zcx_aps_unknown_executable.
      cl_abap_unit_assert=>fail( 'Please execute demo report DEMO_PROGRAM_SUBMIT_REP once to generate selection screen' ).
    endtry.
  endmethod.

endclass.
