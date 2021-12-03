class zcl_aps_demo_object_select_obj definition
  public
  final
  create public.

  public section.

    interfaces:
      zif_aps_objectselector.

  protected section.
  private section.
endclass.



class zcl_aps_demo_object_select_obj implementation.
  method zif_aps_objectselector~calculateObjects.
    do 10 times.
      data(currentLoopCounter) = sy-index.

      try.
        data(singleExecutionParameters) = zcl_aps_parameterset_factory=>provideobjectparameters( i_settings ).

        singleExecutionParameters->setdatareference( ref #( currentLoopCounter ) ).

      catch zcx_aps_unknown_executable
            zcx_aps_unknown_parameter.
*////////////// ToDo: proper error handling ////////////////////////*
        clear result.
        return.
      endtry.

      insert singleExecutionParameters
      into table result.
    enddo.
  endmethod.

endclass.
