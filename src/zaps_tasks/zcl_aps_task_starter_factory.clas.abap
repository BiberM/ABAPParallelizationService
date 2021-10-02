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
          i_settings  type ref to zif_aps_settings
        returning
          value(result) type ref to zif_aps_task_starter
        raising
          zcx_aps_settings_unknown_app
          zcx_aps_settings_unknown_conf.
  protected section.
  private section.
endclass.



class zcl_aps_task_starter_factory implementation.
  method provide.
    result = switch #(
               i_settings->gettasktype( )
               when i_settings->taskTypeBatch
                 then new zcl_aps_task_starter_batch(
                        i_appid    = i_appId
                        i_configid = i_configId
                        i_settings = i_settings
                      )
               when i_settings->taskTypeDialog
                 then new zcl_aps_task_starter_dialog(
                        i_appid    = i_appId
                        i_configid = i_configId
                        i_settings = i_settings
                      )
             ).
  endmethod.

endclass.
