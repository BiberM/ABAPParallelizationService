*"* use this source file for your ABAP unit test classes
class ltd_executable definition
  inheriting from zcl_aps_executable_object.
  public section.
    class-methods:
      resetCounter,
      getCallCounter
        returning
          value(result)   type i.

    methods:
      start redefinition,
      constructor
        importing
          i_parameterSet  type ref to zif_aps_parameterset.

  protected section.
  private section.
    class-data:
      callCounter   type i.

    data:
      increaseCounterBy type i.

endclass.

class ltd_executable implementation.

  method start.
    callCounter = callCounter + increaseCounterBy.

    " prohibit counting the same object twice
    increaseCounterBy = 0.
  endmethod.

  method resetCounter.
    callCounter = 0.
  endmethod.

  method constructor.
    super->constructor( i_parameterset = i_parameterSet ).

    increaseCounterBy = 1.
  endmethod.

  method getcallcounter.
    result = callCounter.
  endmethod.

endclass.



class ltcl_task_object definition deferred.
class zcl_aps_task_object definition
  local friends ltcl_task_object.

class ltcl_task_object definition final for testing
  duration short
  risk level harmless.

  private section.
    data:
      cut         type ref to zcl_aps_task_object,
      settings    type ref to ztd_aps_settings.

    methods:
      setup,

      objectGetsInstanciated for testing raising cx_static_check,
      objectGetsStarted for testing raising cx_static_check,
      twoObjectsGetStarted for testing raising cx_static_check.
endclass.


class ltcl_task_object implementation.

  method setup.
    settings = new #( ).

    settings->setappdefinition( value #(
                                  appid = 'UNITTEST'
                                  typeofexecutable = 'O'
                                  nameofexecutable = 'LTD_EXECUTABLE'
                                )
    ).

    cut = new #(
            i_settings = settings
          ).

    ltd_executable=>resetCounter( ).
  endmethod.


  method objectGetsInstanciated.
    " Given
    cut->packageToBeProcessed = value #(
                                  selections = value #( ( ) )
                                ).

    " When
    cut->zif_aps_task~start( ).

    " Then
    cl_abap_unit_assert=>assert_not_initial( ltd_executable=>getCallCounter( ) ).
  endmethod.


  method objectgetsstarted.
    " Given
    cut->packageToBeProcessed = value #(
                                  selections = value #( ( ) )
                                ).

    " When
    cut->zif_aps_task~start( ).

    " Then
    cl_abap_unit_assert=>assert_equals(
      act = ltd_executable=>getCallCounter( )
      exp = 1
    ).
  endmethod.


  method twoobjectsgetstarted.
    " Given
    cut->packageToBeProcessed = value #(
                                  selections = value #( ( ) ( ) )
                                ).

    " When
    cut->zif_aps_task~start( ).

    " Then
    cl_abap_unit_assert=>assert_equals(
      act = ltd_executable=>getCallCounter( )
      exp = 2
    ).
  endmethod.

endclass.
