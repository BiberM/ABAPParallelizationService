interface zif_aps_parameters_func
  public.
    interfaces:
      zif_aps_parameters.

    methods:
      addImporting
        importing
          i_parameterName       type abap_parmname
          i_parameterValue      type ref to data,

      addExporting
        importing
          i_parameterName       type abap_parmname,

      addChanging
        importing
          i_parameterName       type abap_parmname
          i_parameterValue      type ref to data optional,

      addTables
        importing
          i_parameterName       type abap_parmname,

      getImportingForCall
        returning
          value(result)         type rsfb_imp,

      getExportingForCall
        returning
          value(result)         type rsfb_exp,

      getExportingValue
        returning
          value(result)         type ref to data,

      getChangingForCall
        returning
          value(result)         type rsfb_cha,

      getChangingValue
        returning
          value(result)         type ref to data,

      getTablesForCall
        returning
          value(result)         type rsfb_tbl,

      getTablesValue
        returning
          value(result)         type ref to data,

      setExportingValue
        importing
          i_parameterValue      type ref to data,

      setChangingValue
        importing
          i_parameterValue      type ref to data,

      setTablesValue
        importing
          i_parameterValue      type ref to data.

endinterface.
