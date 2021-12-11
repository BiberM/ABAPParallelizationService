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

    " This one is specified in the customizing.
    " We definitely have to be sure it is of the right type
    select single @abap_true
    from seometarel
    where clsname     eq @classnameOfExecutable
      and refclsname  eq 'ZCL_APS_EXECUTABLE_OBJECT'
      and reltype     eq '2'    " inheriting from
    into @data(inheritsFromAPSTask).

    if sy-subrc ne 0.
      data(errorInvalidClass) = new zcx_aps_task_invalid_class( ).

      raise exception
      type zcx_aps_executable_call_error
      exporting
        i_previous  = errorInvalidClass.
    endif.

    loop at packageToBeProcessed-selections
    into data(parameterSet).
      try.
        create object executableObject
        type (classnameOfExecutable)
        exporting
          i_parameterSet  = cast zif_aps_parameterset_object( parameterSet ).

        executableObject->start( ).

      catch cx_sy_move_cast_error
            cx_sy_create_object_error
      into data(previousInstanciationError).
        data(instanciationError) = new zcx_aps_task_instanciation_err(
          i_previous  = previousInstanciationError
          i_classname = classnameOfExecutable
        ).

        raise exception
      type zcx_aps_executable_call_error
      exporting
        i_previous  = instanciationError.
      endtry.
    endloop.
  endmethod.

endclass.
