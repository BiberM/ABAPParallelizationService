class zcl_aps_parameterset_report definition
  public
  final
  create private
  global friends zcl_aps_parameterset_factory.

  public section.
    interfaces:
      zif_aps_parameterset_report.

    methods:
      constructor
        importing
          i_settings      type ref to zif_aps_settings
        raising
          zcx_aps_unknown_executable.

  protected section.
  private section.
    constants:
      kindParameter             type rsscr_kind value 'P',
      kindSelectOption          type rsscr_kind value 'S'.


    data:
      settings                  type ref to zif_aps_settings,
      selectionScreenItems      type standard table of rsscr,
      selections                type rsparams_tt.

    methods:
      loadReportSelectionScreen
        raising
          zcx_aps_unknown_executable.
endclass.



class zcl_aps_parameterset_report implementation.
  method zif_aps_parameterset_report~addparameter.
    if not line_exists( selectionScreenItems[
                          name = i_parametername
                          kind = kindParameter
                       ] ).
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endif.

    insert value #(
      selname = i_parameterName
      kind    = kindParameter
      sign    = 'I'
      option  = 'EQ'
      low     = i_parameterValue
    )
    into table selections
    reference into data(currentParameter).

    if sy-subrc ne 0.
      "duplicate key for example?
      raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( i_parametername ).
    endif.
  endmethod.


  method zif_aps_parameterset_report~addselectoption.
    if i_selectoption is initial.
      return.
    endif.

    loop at i_selectOption
    reference into data(tempIterator)
    group by ( fieldnm = tempIterator->fieldnm )
    without members
    reference into data(groupKey).
      if not line_exists( selectionScreenItems[
                            name = groupKey->fieldnm
                            kind = kindSelectOption
                         ] ).
        raise exception
        type zcx_aps_unknown_parameter
          exporting
            i_parametername = conv #( groupKey->fieldnm ).
      endif.
    endloop.

    " the importing table is technically not restricted to only one
    " select option. Therefor we import all or none after checking all.
    insert lines of value rsparams_tt(
                      for selctionLine in i_selectOption
                      (
                        selname = selctionLine-fieldnm
                        kind    = kindSelectOption
                        sign    = selctionLine-sign
                        option  = selctionLine-option
                        low     = selctionLine-low
                        high    = selctionLine-high
                    ) )
    into table selections.
  endmethod.


  method constructor.
    settings = i_settings.

    loadReportSelectionScreen( ).
  endmethod.


  method loadReportSelectionScreen.
    " To check the given parameters and selection options we need the selection screen definition.
    " To get this we need a commonly forbidden command
    data(reportName) = settings->getNameOfExecutable( ).

    load report reportName
    part 'SSCR'
    into selectionScreenItems.

    if sy-subrc ne 0.
      clear selectionScreenItems[].

      raise exception
      type zcx_aps_unknown_executable
      exporting
        i_executablename = reportName.
    endif.
  endmethod.


  method zif_aps_parameterset_report~getselectionstable.
    result = selections.
  endmethod.

endclass.
