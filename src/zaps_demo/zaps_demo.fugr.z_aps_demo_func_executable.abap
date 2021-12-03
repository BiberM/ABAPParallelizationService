function Z_APS_DEMO_FUNC_EXECUTABLE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_INDEX) TYPE  I
*"----------------------------------------------------------------------
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
  with |This is task number { i_index }|.

ENDFUNCTION.
