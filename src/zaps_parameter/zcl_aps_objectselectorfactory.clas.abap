class zcl_aps_objectselectorfactory definition
  public
  final
  create public.

  public section.
    class-methods:
      "! <p class="shorttext synchronized" lang="en">Returns an instance of the class specified in customizing</p>
      "!
      "! @parameter i_settings | <p class="shorttext synchronized" lang="en">APS settings</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">object selector instance</p>
      provideObjectSelector
        importing
          i_settings    type ref to zif_aps_settings
        returning
          value(result) type ref to zif_aps_objectSelector.
  protected section.
  private section.
endclass.



class zcl_aps_objectselectorfactory implementation.
  method provideobjectselector.
    data(classname) = i_settings->getObjectSelectionClassname( ).

    try.
      create object result
      type (classname).
    catch cx_sy_create_object_error
    into data(createObjectError).
*////////// ToDo: Error handling
    endtry.
  endmethod.

endclass.
