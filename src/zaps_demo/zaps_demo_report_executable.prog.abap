*&---------------------------------------------------------------------*
*& Report zaps_demo_report_executable
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zaps_demo_report_executable.
  parameters:
    p_index       type i.

  try.
    data(randomWaitSeconds) = cl_abap_random_int=>create(
                                seed = cl_abap_random=>seed( )
                                min  = 5
                                max  = 20
                              )->get_next( ).
  catch cx_abap_random.
    randomWaitSeconds = 5.
  endtry.

  wait up to randomWaitSeconds seconds.

  message i319(01)
  with |This is task number { p_index }|.
