class zcl_aps_task_starter_factory definition
  public
  final
  create public.

  public section.
    class-methods:
      provide
        importing
          i_appId     type zaps_appid
          i_configId  type zaps_configid
        returning
          value(return) type ref to zif_aps_task_starter
        raising
          zcx_aps_settings_unknown_app
          zcx_aps_settings_unknown_conf.
  protected section.
  private section.
endclass.



class zcl_aps_task_starter_factory implementation.
  method provide.
    data(settings) = zcl_aps_settings_factory=>provide(
                       i_appid    = i_appId
                       i_configid = i_configId
                     ).

    return = switch #(
               settings->gettasktype( )
               when settings->task_type_batch
                 then new zcl_aps_task_starter_batch(
                        i_appid    = i_appId
                        i_configid = i_configId
                        i_settings = settings
                      )
               when settings->task_type_dialog
                 then new zcl_aps_task_starter_dialog(
                        i_appid    = i_appId
                        i_configid = i_configId
                        i_settings = settings
                      )
             ).
  endmethod.

endclass.
