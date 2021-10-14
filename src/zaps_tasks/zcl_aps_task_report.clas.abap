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
    data:
      selectionScreenItems  type standard table of rsscr.


    methods:
      loadReportSelectionScreen,

      convertParamSetToSelTab
        importing
          i_parameterSet  type ref to zaps_parameter_set
        returning
          value(result) type rsparams_tt.
endclass.



class zcl_aps_task_report implementation.
  method zif_aps_task~start.
    loadReportSelectionScreen( ).

    loop at packageToBeProcessed-selections
    reference into data(parameterSet).
      data(selectionScreenData) = convertParamSetToSelTab( parameterSet ).
      data(reportName) = settings->getNameOfExecutable( ).

      submit zaps_batch_task_run
      with selection-table selectionScreenData
      and return.
    endloop.
  endmethod.


  method convertParamSetToSelTab.
    loop at i_parameterSet->*
    reference into data(parameter).
      try.
        data(selectionScreenItem) = selectionScreenItems[ name = to_upper( parameter->fieldnm ) ].

        insert value #(
                 selname    = to_upper( parameter->fieldnm )
                 kind       = selectionScreenItem-kind
                 sign       = parameter->sign
                 option     = parameter->option
                 low        = parameter->low
                 high       = parameter->high
               )
        into table result.

      catch cx_sy_itab_line_not_found.
        " invalid / non-existing parameter
*///////// ToDo: log that!! /////////////////
        continue.
      endtry.
    endloop.
  endmethod.


  method loadReportSelectionScreen.
    " as long as the parameter Sets contain no information about
    " what type (Select-Option / Parameter) it is, we need to check
    " against the selection screen. To get this we need a commonly forbidden command
    data(reportName) = settings->getNameOfExecutable( ).

    load report reportName
    part 'SSCR'
    into selectionScreenItems.

    if sy-subrc ne 0.
*//////////// ToDo: error handling ////////////////////
      clear selectionScreenItems[].

      return.
    endif.
  endmethod.

endclass.
