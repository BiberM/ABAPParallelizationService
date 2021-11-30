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
endclass.



class zcl_aps_parameterset_object implementation.
  method zif_aps_parameterset_object~getdatareference.
    result = dataReference.
  endmethod.

  method zif_aps_parameterset_object~getobject.
    result = object.
  endmethod.

  method zif_aps_parameterset_object~setdatareference.
    dataReference = i_dataRef.
  endmethod.

  method zif_aps_parameterset_object~setobject.
    object = i_object.
  endmethod.

endclass.
