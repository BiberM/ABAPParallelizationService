class zcl_aps_task_report definition
  public
  inheriting from zcl_aps_task
  final
  create private
  global friends zcl_aps_task_factory.

  public section.
    METHODS: zif_aps_task~start REDEFINITION.
  protected section.
  private section.
endclass.



class zcl_aps_task_report implementation.
  method zif_aps_task~start.

  endmethod.

endclass.
