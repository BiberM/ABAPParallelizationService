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
      threePackagesPackageSize3 for testing raising cx_static_check,
      threePackagesPackageSize2 for testing raising cx_static_check,
      threePackagesPackageSize4 for testing raising cx_static_check,
      threeJobsMaxParallel2 for testing raising cx_static_check,
      threeJobsMaxParallel3 for testing raising cx_static_check,
      threeJobsMaxParallel4 for testing raising cx_static_check.
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

    batchJob ?= zcl_aps_batch_job_factory=>provide(
                  i_task                = new ztd_aps_task_object( settings )
                  i_settings            = settings
                  i_chainnumber         = 1
                  i_tasknumberinchain   = 1
                  i_testdoubleclassname = 'ZTD_APS_BATCH_JOB'
                ).

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


  method onepackage.
    " Given
    data(packages) = value zaps_packages( ( ) ).
    settings->setmaxpackagesize( 42 ).
    settings->setmaxparalleltasks( 42 ).

    " When
    try.
      cut->zif_aps_task_starter~start( ref #( packages ) ).
    catch zcx_aps_task_creation_error
          zcx_aps_job_creation_error.
      cl_abap_unit_assert=>fail( 'Unexpected exception' ).
    endtry.
  endmethod.


  method threejobsmaxparallel2.
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  endmethod.


  method threejobsmaxparallel3.
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  endmethod.


  method threejobsmaxparallel4.
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  endmethod.


  method threepackagespackagesize2.
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  endmethod.


  method threepackagespackagesize3.
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  endmethod.


  method threepackagespackagesize4.
    cl_abap_unit_assert=>fail( 'Implement your first test here' ).
  endmethod.

endclass.
