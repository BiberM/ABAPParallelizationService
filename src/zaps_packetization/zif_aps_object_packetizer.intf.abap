interface zif_aps_object_packetizer
  public.
    methods:
      "! <p class="shorttext synchronized" lang="en"></p>
      "! Starts the object packetization of App with Config
      "! @parameter i_objects | <p class="shorttext synchronized" lang="en">Object list to be packetized</p>
      "! @parameter result | <p class="shorttext synchronized" lang="en">Packages</p>
      packetize
        importing
          i_objects   type zaps_parameter_set_list
        returning
          value(result)  type ref to zaps_packages.
endinterface.
