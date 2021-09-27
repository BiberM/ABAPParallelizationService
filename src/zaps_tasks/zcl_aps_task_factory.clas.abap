class zcl_aps_task_factory definition
  public
  final
  create public.

  public section.
    class-methods:
      provide
        importing
          i_appId         type zaps_appId
          i_configId      type zaps_configId
          i_settings      type ref to zif_aps_settings
          i_packageData   type zaps_package
        returning
          value(return)   type ref to zif_aps_task
        raising
          zcx_aps_task_invalid_class
          zcx_aps_task_instanciation_err
          zcx_aps_task_unknown_exec_type.

  protected section.
  private section.
endclass.



class zcl_aps_task_factory implementation.
  method provide.
    case i_settings->getTypeOfExecutable( ).
      when i_settings->executableTypeReport.
        return = new zcl_aps_task_report(
                   i_appid    = i_appId
                   i_configid = i_configId
                 ).

      when i_settings->executableTypeFuncUnit.
        return = new zcl_aps_task_functionunit(
                   i_appid    = i_appId
                   i_configid = i_configId
                 ).

      when i_settings->executableTypeObject.
        " This one is specified in the customizing.
        " We definitely have to be sure it is of the right type
        data(className) = i_settings->getNameOfExecutable( ).

        select single @abap_true
        from seometarel
        where clsname     eq @className
          and refclsname  eq 'ZCL_APS_TASK'
          and reltype     eq '2'    " inheriting from
        into @data(inheritsFromAPSTask).

        if sy-subrc ne 0.
          raise exception
          type zcx_aps_task_invalid_class.
        endif.

        try.
          create object return
          type (className)
          exporting
            i_appid    = i_appId
            i_configid = i_configId.
        catch cx_sy_create_object_error
        into data(instanciationError).
          raise exception
          type zcx_aps_task_instanciation_err
          exporting
            i_previous  = instanciationError
            i_classname = className.
        endtry.

      when others.
        raise exception
        type zcx_aps_task_unknown_exec_type
        exporting
          i_executabletype = i_settings->getTypeOfExecutable( ).
    endcase.

    return->setSettings( i_settings ).
    return->setPackage( i_packageData ).

  endmethod.

endclass.
