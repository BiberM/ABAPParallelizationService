class zcl_aps_parameters_factory definition
  public
  final
  create private.

  public section.
    class-methods:
      provideFunctionUnitParameters
        returning
          value(result)   type ref to zif_aps_parameters_func,
      provideReportParameters
        returning
          value(result)   type ref to zif_aps_parameters_report,
      provideObjectParameters
        returning
          value(result)   type ref to zif_aps_parameters_object.

  protected section.
  private section.
endclass.



class zcl_aps_parameters_factory implementation.
  method providefunctionunitparameters.
*    result = new
  endmethod.

  method provideobjectparameters.

  endmethod.

  method providereportparameters.

  endmethod.

endclass.
