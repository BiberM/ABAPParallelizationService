class zcl_aps_task_report definition
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



class zcl_aps_task_report implementation.
  method zif_aps_task~start.
    loop at packageToBeProcessed-selections
    into data(parameterSet).
      try.
        data(reportParameters) = cast zif_aps_parameterset_report( parameterSet ).
      catch cx_sy_move_cast_error.
        continue.
      endtry.

      data(selectionScreenData) = reportParameters->getSelectionsTable( ).
      data(reportName) = settings->getNameOfExecutable( ).

      submit (reportName)
      with selection-table selectionScreenData
      and return.
    endloop.
  endmethod.

endclass.
