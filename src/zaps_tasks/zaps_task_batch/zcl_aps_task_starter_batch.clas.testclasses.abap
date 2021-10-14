*"* use this source file for your ABAP unit test classes
class ltcl_task_starter_batch definition deferred.
class zcl_aps_task_starter_batch definition
  local friends ltcl_task_starter_batch.

class ltcl_task_starter_batch definition final for testing
  duration short
  risk level harmless.

  private section.
    data:
      cut       type ref to zcl_aps_task_starter_batch,
      settings  type ref to ztd_aps_settings,
      batchJob  type ref to ztd_aps_batch_job.

    methods:
      setup,

      noPackages for testing raising cx_static_check,
      onePackage for testing raising cx_static_check,
      threeJobsMaxParallel2 for testing raising cx_static_check,
      threeJobsMaxParallel3 for testing raising cx_static_check,
      threeJobsMaxParallel4 for testing raising cx_static_check,
      errorJobCreation for testing raising cx_static_check,
      errorJobReportSubmit for testing raising cx_static_check,
      errorJobReleaseEvent for testing raising cx_static_check,
      errorJobReleaseSuccessor for testing raising cx_static_check.
endclass.


class ltcl_task_starter_batch implementation.

  method setup.
    " Intialize Doubles
    settings = new #( ).

    settings->setappdefinition( value #(
                                  appid = 'UNITTEST'
                                  typeofexecutable = 'O'
                                  nameofexecutable = 'ZTD_APS_TASK_OBJECT'
                                )
    ).

    settings->setparallelconfiguration( value #(
                                          appid = 'UNITTEST'
                                          configid = 'UNITTESTCONFIG'
                                          parallelizationtype = 'B'
                                          jobnameprefix = 'UNIT'
                                        )
    ).

    ztd_aps_batch_job=>resetInstanceCounter( ).
    zcl_aps_batch_job_factory=>resetInstanceBuffer( ).

    cut = new zcl_aps_task_starter_batch( settings ).
  endmethod.


  method noPackages.
    " Given
    data(packages) = value zaps_packages( ).

    " When
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error
          zcx_aps_job_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    endtry.
  endmethod.


  method onePackage.
    " Given
    data(packages) = value zaps_packages( ( ) ).
    settings->setmaxpackagesize( 42 ).
    settings->setmaxparalleltasks( 42 ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    " When
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error
          zcx_aps_job_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    endtry.

    " Then
    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getChainCount( )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getTotalInstanceCount( )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 1 )
      exp = 1
    ).
  endmethod.


  method threejobsmaxparallel2.
    " Given
    data(packages) = value zaps_packages( ( ) ( ) ( ) ).
    settings->setmaxpackagesize( 1 ).
    settings->setmaxparalleltasks( 2 ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 2
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 2
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    " When
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error
          zcx_aps_job_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    endtry.

    " Then
    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getChainCount( )
      exp = 2
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getTotalInstanceCount( )
      exp = 3
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 1 )
      exp = 2
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 2 )
      exp = 1
    ).
  endmethod.


  method threejobsmaxparallel3.
    " Given
    data(packages) = value zaps_packages( ( ) ( ) ( ) ).
    settings->setmaxpackagesize( 1 ).
    settings->setmaxparalleltasks( 3 ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 2
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 3
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    " When
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error
          zcx_aps_job_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    endtry.

    " Then
    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getChainCount( )
      exp = 3
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getTotalInstanceCount( )
      exp = 3
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 1 )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 2 )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 3 )
      exp = 1
    ).
  endmethod.


  method threejobsmaxparallel4.
    " Given
    data(packages) = value zaps_packages( ( ) ( ) ( ) ).
    settings->setmaxpackagesize( 1 ).
    settings->setmaxparalleltasks( 4 ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 2
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 3
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    " When
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error
          zcx_aps_job_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    endtry.

    " Then
    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getChainCount( )
      exp = 3
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getTotalInstanceCount( )
      exp = 3
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 1 )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 2 )
      exp = 1
    ).

    cl_abap_unit_assert=>assert_equals(
      act = ztd_aps_batch_job=>getInstanceCountInChain( 3 )
      exp = 1
    ).
  endmethod.


  method errorjobcreation.
    " Given
    data(packages) = value zaps_packages( ( ) ).
    settings->setmaxpackagesize( 1 ).
    settings->setmaxparalleltasks( 1 ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).
    batchJob->setCreateFailure( ).

    " When + Then
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    catch zcx_aps_job_creation_error.
      " This is the desired result!
    endtry.
  endmethod.


  method errorjobreleaseevent.
    " Given
    data(packages) = value zaps_packages( ( ) ).
    settings->setmaxpackagesize( 1 ).
    settings->setmaxparalleltasks( 1 ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).
    batchJob->setEventTriggeredFailure( ).

    " When + Then
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    catch zcx_aps_job_creation_error.
      " This is the desired result!
    endtry.
  endmethod.


  method errorjobreleasesuccessor.
    " Given
    data(packages) = value zaps_packages( ( ) ( ) ).
    settings->setmaxpackagesize( 1 ).
    settings->setmaxparalleltasks( 1 ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 2
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

    batchJob->setSuccessorFailure( ).

    " When + Then
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    catch zcx_aps_job_creation_error.
      " This is the desired result!
    endtry.
  endmethod.


  method errorjobreportsubmit.
    " Given
    data(packages) = value zaps_packages( ( ) ).
    settings->setmaxpackagesize( 1 ).
    settings->setmaxparalleltasks( 1 ).

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).
    batchJob->setAddStepFailure( ).

    " When + Then
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    catch zcx_aps_job_creation_error.
      " This is the desired result!
    endtry.
  endmethod.

endclass.
