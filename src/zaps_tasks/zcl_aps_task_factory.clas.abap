class zcl_aps_task_factory definition
  public
  final
  create public.

  public section.
    class-methods:
      provide
        importing
          i_settings      type ref to zif_aps_settings
          i_packageData   type zaps_package
        returning
          value(result)   type ref to zif_aps_task
        raising
          zcx_aps_task_invalid_class
          zcx_aps_task_instanciation_err
          zcx_aps_task_unknown_exec_type.

  protected section.
  private section.
endclass.



class zcl_aps_task_factory implementation.
  method provide.
    case i_settings->getTypeOfExecutable( ).
      when i_settings->executableTypeReport.
        result = new zcl_aps_task_report( i_settings ).

      when i_settings->executableTypeFuncUnit.
        result = new zcl_aps_task_functionunit( i_settings ).

      when i_settings->executableTypeObject.
        result = new zcl_aps_task_object( i_settings ).

      when others.
        raise exception
        type zcx_aps_task_unknown_exec_type
        exporting
          i_executabletype = i_settings->getTypeOfExecutable( ).
    endcase.

    result->setPackage( i_packageData ).

  endmethod.

endclass.
