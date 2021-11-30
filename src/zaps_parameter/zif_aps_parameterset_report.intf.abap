interface zif_aps_parameterset_report
  public.
    interfaces:
      zif_aps_parameterSet.

    methods:
      addParameter
        importing
          i_parameterName     type rsscr_name
          i_parameterValue    type tvarv_val
        raising
          zcx_aps_unknown_parameter,

      addSelectOption
        importing
          i_selectOption      type rotselect
        raising
          zcx_aps_unknown_parameter,

      getSelectionsTable
        returning
          value(result)       type rsparams_tt.

endinterface.
