class zcl_aps_task_starter_dialog definition
  public
  inheriting from zcl_aps_task_starter
  final
  create private
  global friends zcl_aps_task_starter_factory.

  public section.
    methods:
      zif_aps_task_starter~start redefinition.

  protected section.
    methods:
      createtask redefinition.

  private section.
endclass.



class zcl_aps_task_starter_dialog implementation.
  method zif_aps_task_starter~start.

  endmethod.

  method createTask.

  endmethod.

endclass.
