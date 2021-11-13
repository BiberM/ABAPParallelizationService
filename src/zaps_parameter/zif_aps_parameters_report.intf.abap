interface zif_aps_parameters_report
  public.
    interfaces:
      zif_aps_parameters.

    methods:
      addParameter
        importing
          i_parameterName     type rsscr_name
          i_parameterValue    type tvarv_val,

      addSelectOption
        importing
          i_selectOption      type rotselect.

endinterface.
