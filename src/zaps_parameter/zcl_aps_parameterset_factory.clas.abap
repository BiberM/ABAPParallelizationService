class zcl_aps_parameterset_factory definition
  public
  final
  create private.

  public section.
    class-methods:
      provideFunctionUnitParameters
        importing
          i_settings      type ref to zif_aps_settings
        returning
          value(result)   type ref to zif_aps_parameterSet_func
        raising
          zcx_aps_unknown_executable,
      provideReportParameters
        importing
          i_settings      type ref to zif_aps_settings
        returning
          value(result)   type ref to zif_aps_parameterSet_report
        raising
          zcx_aps_unknown_executable,
      provideObjectParameters
        importing
          i_settings      type ref to zif_aps_settings
        returning
          value(result)   type ref to zif_aps_parameterSet_object.

  protected section.
  private section.
endclass.



class zcl_aps_parameterset_factory implementation.
  method providefunctionunitparameters.
    result = new zcl_aps_parameterset_func( i_settings ).
  endmethod.

  method provideobjectparameters.
    result = new zcl_aps_parameterset_object( ).
  endmethod.

  method providereportparameters.
    result = new zcl_aps_parameterset_report( i_settings ).
  endmethod.

endclass.
