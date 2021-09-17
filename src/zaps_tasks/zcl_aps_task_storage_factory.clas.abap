class zcl_aps_task_storage_factory definition
  public
  final
  create public.

  public section.
    methods:
      "! <p class="shorttext synchronized" lang="en">Returns the current task storage Object</p>
      "!
      "! @parameter return | <p class="shorttext synchronized" lang="en">task storage object</p>
      provide
        returning
          value(return)   type ref to zif_aps_task_storage.
  protected section.
  private section.
    data:
      currentTaskStorage      type ref to zif_aps_task_storage.
endclass.



class zcl_aps_task_storage_factory implementation.

  method provide.
    if not currentTaskStorage is bound.
      currentTaskStorage = new  zcl_aps_task_storage_db( ).
    endif.

    return = currentTaskStorage.
  endmethod.

endclass.
