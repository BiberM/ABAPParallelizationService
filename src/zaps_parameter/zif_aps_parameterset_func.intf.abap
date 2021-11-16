interface zif_aps_parameterset_func
  public.
    interfaces:
      zif_aps_parameterSet.

    methods:
      addImporting
        importing
          i_parameterName       type abap_parmname
          i_parameterValue      type ref to data
        raising
          zcx_aps_unknown_parameter,

      addExporting
        importing
          i_parameterName       type abap_parmname
        raising
          zcx_aps_unknown_parameter,

      addChanging
        importing
          i_parameterName       type abap_parmname
          i_parameterValue      type ref to data optional
        raising
          zcx_aps_unknown_parameter,

      addTables
        importing
          i_parameterName       type abap_parmname
          i_parameterValue      type ref to data optional
        raising
          zcx_aps_unknown_parameter,

      getParametersTab
        returning
          value(result)         type abap_func_parmbind_tab,

      getExceptionsTab
        returning
          value(result)         type abap_func_excpbind_tab,

      getExportingValue
        importing
          i_parameterName       type abap_parmname
        returning
          value(result)         type ref to data
        raising
          zcx_aps_unknown_parameter,

      getChangingValue
        importing
          i_parameterName       type abap_parmname
        returning
          value(result)         type ref to data
        raising
          zcx_aps_unknown_parameter,

      getTablesValue
        importing
          i_parameterName       type abap_parmname
        returning
          value(result)         type ref to data
        raising
          zcx_aps_unknown_parameter,

      setExportingValue
        importing
          i_parameterName       type abap_parmname
          i_parameterValue      type ref to data
        raising
          zcx_aps_unknown_parameter,

      setChangingValue
        importing
          i_parameterName       type abap_parmname
          i_parameterValue      type ref to data
        raising
          zcx_aps_unknown_parameter,

      setTablesValue
        importing
          i_parameterName       type abap_parmname
          i_parameterValue      type ref to data
        raising
          zcx_aps_unknown_parameter.

endinterface.
