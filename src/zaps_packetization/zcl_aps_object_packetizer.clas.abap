class zcl_aps_object_packetizer definition
  public
  abstract
  create public.

  public section.
    interfaces:
      zif_aps_object_packetizer
        all methods abstract.

    methods:
      constructor
        importing
          i_settings      type ref to zif_aps_settings.

  protected section.
    data:
      settings        type ref to zif_aps_settings.
  private section.
endclass.



class zcl_aps_object_packetizer implementation.
  method constructor.
    settings = i_settings.
  endmethod.

endclass.
