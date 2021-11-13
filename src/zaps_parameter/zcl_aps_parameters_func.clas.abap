class zcl_aps_parameters_func definition
  public
  final
  create private
  global friends zcl_aps_parameters_factory.

  public section.
    interfaces:
      zif_aps_parameters_func.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_APS_PARAMETERS_FUNC IMPLEMENTATION.


  method zif_aps_parameters_func~addchanging.

  endmethod.


  method zif_aps_parameters_func~addexporting.

  endmethod.


  method zif_aps_parameters_func~addimporting.

  endmethod.


  method zif_aps_parameters_func~addtables.

  endmethod.


  method zif_aps_parameters_func~getchangingvalue.

  endmethod.


  method zif_aps_parameters_func~getexportingvalue.

  endmethod.


  method zif_aps_parameters_func~gettablesvalue.

  endmethod.


  method zif_aps_parameters_func~setchangingvalue.

  endmethod.


  method zif_aps_parameters_func~setexportingvalue.

  endmethod.


  method zif_aps_parameters_func~settablesvalue.

  endmethod.
ENDCLASS.
