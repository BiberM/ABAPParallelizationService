class zcl_aps_demo_object_executable definition
  public
  final
  inheriting from zcl_aps_executable_object
  create public.

  public section.
    methods:
      start redefinition.
  protected section.
  private section.
endclass.



class zcl_aps_demo_object_executable implementation.
  method start.
    data(dataRef) = parameterSet->getdatareference( ).

    assign dataRef->*
    to field-symbol(<dataParam>).

    try.
      data(randomWaitSeconds) = cl_abap_random_int=>create(
                                  seed = cl_abap_random=>seed( )
                                  min  = 5
                                  max  = 20
                                )->get_next( ).
    catch cx_abap_random.
      randomWaitSeconds = 5.
    endtry.

    wait up to randomWaitSeconds seconds.

    message i319(01)
    with |This is task number { <dataParam> }|.
  endmethod.

endclass.
