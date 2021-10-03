class ztd_aps_task_object definition
  public
  inheriting from zcl_aps_task
  final
  create public
  for testing
  duration short
  risk level harmless.

  public section.
    methods:
      zif_aps_task~start redefinition.

  protected section.
  private section.
endclass.



class ztd_aps_task_object implementation.

  method zif_aps_task~start.

  endmethod.

endclass.
