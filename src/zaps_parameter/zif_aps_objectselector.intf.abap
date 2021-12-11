interface zif_aps_objectselector
  public.
    methods:
      "! <p class="shorttext synchronized" lang="en">Supplies the to be parallelized objets/parameter sets</p>
      "!
      "! @parameter i_infoFromCaller | <p class="shorttext synchronized" lang="en">abstract/application specific additional info from caller</p>
      "! @parameter i_settings | <p class="shorttext synchronized" lang="en">parallelization settings</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">objects / parameter sets</p>
      "! @raising zcx_aps_unknown_executable | <p class="shorttext synchronized" lang="en">invalid executable</p>
      "! @raising zcx_aps_unknown_parameter | <p class="shorttext synchronized" lang="en">invalid parameter</p>
      calculateObjects
        importing
          i_infoFromCaller      type ref to object
          i_settings            type ref to zif_aps_settings
        returning
          value(result)         type zaps_parameter_set_list
        raising
          zcx_aps_unknown_executable
          zcx_aps_unknown_parameter.
endinterface.
