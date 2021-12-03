class zcl_aps_executable_object definition
  public
  abstract
  create public.

  public section.
    methods:
      constructor
        importing
          i_parameterSet    type ref to zif_aps_parameterset_object,

      start abstract.

  protected section.
    data:
      parameterSet      type ref to zif_aps_parameterset_object.

  private section.
endclass.



class zcl_aps_executable_object implementation.

  method constructor.
    parameterSet = i_parameterSet.
  endmethod.

endclass.
