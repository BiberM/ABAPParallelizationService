interface zif_aps_parameterset_object
  public.
    interfaces:
      zif_aps_parameterSet.

    methods:
      setDataReference
        importing
          i_dataRef             type ref to data,

      setObject
        importing
          i_object              type ref to if_serializable_object,

      getDataReference
        returning
          value(result)         type ref to data,

      getObject
        importing
          value(result)         type ref to if_serializable_object.

endinterface.
