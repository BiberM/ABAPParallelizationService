class zcl_aps_task_object definition
  public
  inheriting from zcl_aps_task
  final
  create private
  global friends zcl_aps_task_factory.

  public section.
    methods:
      zif_aps_task~start redefinition.
  protected section.
  private section.
endclass.



class zcl_aps_task_object implementation.
  method zif_aps_task~start.
    data:
      executableObject type ref to zcl_aps_executable_object.

    data(classnameOfExecutable) = conv classname( settings->getNameOfExecutable( ) ).

    loop at packageToBeProcessed-selections
    reference into data(parameterSet).
      try.
        create object executableObject
        type (classnameOfExecutable)
        exporting
          i_parameterSet  = parameterSet.

        executableObject->start( ).

      catch cx_sy_create_object_error.
*//////////// ToDo: error handling /////////////////
        return.
      endtry.
    endloop.
  endmethod.

endclass.
