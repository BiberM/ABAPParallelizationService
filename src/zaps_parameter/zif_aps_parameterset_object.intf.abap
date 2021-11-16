interface zif_aps_parameterset_object
  public.
    interfaces:
      zif_aps_parameterSet.

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
          i_parameterName       type abap_parmname,

      addReturning
        importing
          i_parameterName       type abap_parmname,

      getExportingValue
        returning
          value(result)         type ref to data,

      getChangingValue
        returning
          value(result)         type ref to data,

      getReturningValue
        returning
          value(result)         type ref to data,

      setExportingValue
        importing
          i_parameterValue      type ref to data,

      setChangingValue
        importing
          i_parameterValue      type ref to data,

      setReturningValue
        importing
          i_parameterValue      type ref to data.

endinterface.
