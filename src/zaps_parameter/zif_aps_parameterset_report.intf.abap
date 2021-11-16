interface zif_aps_parameterset_report
  public.
    interfaces:
      zif_aps_parameterSet.

    methods:
      addParameter
        importing
          i_parameterName     type rsscr_name
          i_parameterValue    type tvarv_val,

      addSelectOption
        importing
          i_selectOption      type rotselect.

endinterface.
