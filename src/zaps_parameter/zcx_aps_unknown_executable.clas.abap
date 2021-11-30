class zcx_aps_unknown_executable definition
  public
  inheriting from cx_static_check
  final
  create public.

  public section.

    interfaces:
      if_t100_dyn_msg,
      if_t100_message.

    constants:
      begin of zcx_aps_unknown_executable,
        msgid type symsgid value 'ZAPS_PARAMETER',
        msgno type symsgno value '002',
        attr1 type scx_attrname value 'EXECUTABLENAME',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_aps_unknown_executable.

    methods:
      constructor
        importing
          i_textid   type scx_t100key default zcx_aps_unknown_executable
          i_previous type ref to cx_root optional
          i_executableName type zaps_executable_name.
  protected section.
  private section.
    data:
      executableName type zaps_executable_name.
endclass.



class zcx_aps_unknown_executable implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = i_previous ).
    clear textid.

    if_t100_message~t100key = i_textid.

    executableName = i_executableName.

  endmethod.
endclass.
