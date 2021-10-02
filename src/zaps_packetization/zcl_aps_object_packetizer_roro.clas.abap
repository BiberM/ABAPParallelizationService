class zcl_aps_object_packetizer_roro definition
  public
  inheriting from zcl_aps_object_packetizer
  final
  create public.

  public section.
    methods:
      zif_aps_object_packetizer~packetize redefinition.
  protected section.
  private section.
    methods:
      calculatePackageCount
        importing
          i_objects       type ref to zaps_parameter_set_list
        returning
          value(result)   type dec10_0,

      initializePackages
        importing
          i_objects       type zaps_parameter_set_list
        returning
          value(result)   type zaps_packages.
endclass.



class zcl_aps_object_packetizer_roro implementation.
  method zif_aps_object_packetizer~packetize.
    result = new #( ).

    result->* = initializePackages( i_objects ).

    loop at i_objects
    reference into data(object).
      " Modulo only works directly if index started with 0. But ABAP starts at 1.
      data(packageIndex) = ( ( sy-tabix - 1 ) mod lines( result->* ) ) + 1.

      " Meh, ABAP! Syntax check doesn't want that adressing directly in INSERT
      assign result->*[ packageIndex ]
      to field-symbol(<package>).

      if sy-subrc <> 0.
        " As packageIndex is always <= lines( result->* ) this cannot happen!
        " (Modulo + 1)
      endif.

      insert object->*
      into table <package>-selections[].
    endloop.
  endmethod.


  method initializePackages.
    data(packageCount) = calculatePackageCount( ref #( i_objects ) ).

    do packageCount times.
      insert initial line
      into table result.
    enddo.
  endmethod.


  method calculatePackageCount.
    result = ceil( lines( i_objects->*[] ) / settings->getMaxPackageSize( ) ).
  endmethod.

endclass.
