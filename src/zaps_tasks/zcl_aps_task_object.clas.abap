class zcl_aps_task_object definition
  public
  inheriting from zcl_aps_task
  final
  create public .

  public section.
    methods:
      zif_aps_task~start redefinition.
  protected section.
  private section.
endclass.



class zcl_aps_task_object implementation.
  method zif_aps_task~start.

  endmethod.

endclass.
