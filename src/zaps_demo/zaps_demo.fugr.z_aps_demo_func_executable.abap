function Z_APS_DEMO_FUNC_EXECUTABLE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_INDEX) TYPE  I
*"  EXPORTING
*"     REFERENCE(E_SQUARE) TYPE  I
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

  e_square = i_index * i_index.

  message i319(01)
  with |{ i_index }^2 = { e_square }|.



ENDFUNCTION.
