interface zif_aps_object_packetizer
  public.
    methods:
      "! <p class="shorttext synchronized" lang="en"></p>
      "! Starts the object packetization of App with Config
      "! @parameter i_appId | <p class="shorttext synchronized" lang="en">ID of configured application</p>
      "! @parameter i_configId | <p class="shorttext synchronized" lang="en">ID of the parallelization configuration</p>
      "! @parameter i_objects | <p class="shorttext synchronized" lang="en">Object list to be packetized</p>
      "! @parameter r_packets | <p class="shorttext synchronized" lang="en">Packages</p>
      packetize
        importing
          i_appId     type zaps_appid
          i_configId  type zaps_configid
          i_objects   type zaps_parameter_set_list
        returning
          value(r_packets)  type ref to zaps_packages.
endinterface.
