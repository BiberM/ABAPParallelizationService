class zcl_aps_task_starter_batch definition
  public
  inheriting from zcl_aps_task_starter
  final
  create private
  global friends zcl_aps_task_starter_factory.

  public section.
    methods:
      zif_aps_task_starter~start redefinition.

  protected section.

  private section.
    methods:
      createTaskChains
        importing
          i_packages      type ref to zaps_packages
        returning
          value(result)   type zaps_task_chains
        raising
          zcx_aps_task_creation_error,

      createJobChains
        importing
          i_taskChains    type zaps_task_chains
        raising
          zcx_aps_job_creation_error,

      createJobChain
        importing
          i_taskChain     type ref to zaps_task_chain
          i_chainNumber   type sytabix
        raising
          zcx_aps_job_creation_error.
endclass.



class zcl_aps_task_starter_batch implementation.
  method zif_aps_task_starter~start.
    data(taskChains) = createTaskChains( i_packages ).

    createJobChains( taskChains ).

    " When all job chains have been created successfully, raise the event to start them
    cl_batch_event=>raise(
      exporting
        i_eventid                      = zif_aps_batch_job=>c_jobStartEvent
        i_eventparm                    = conv btcevtparm( appId )
      exceptions
        excpt_raise_failed             = 1
        excpt_server_accepts_no_events = 2
        excpt_raise_forbidden          = 3
        excpt_unknown_event            = 4
        excpt_no_authority             = 5
        others                         = 6
    ).

    if sy-subrc <> 0.
      data(detailledError) = new zcx_aps_task_job_event_raise(
                               i_eventname = zif_aps_batch_job=>c_jobStartEvent
                               i_errorcode = sy-subrc
                             ).

      raise exception
      type zcx_aps_job_creation_error
      exporting
        i_previous  = detailledError.
    endif.
  endmethod.

  method createTaskChains.
    data(numberOfNeededChains) = nmin(
                                   val1 = lines( i_packages->* )
                                   val2 = settings->getmaxparalleltasks( )
                                 ).

    do numberOfNeededChains times.
      append initial line
      to result.
    enddo.

    loop at i_packages->*
    reference into data(package).
      " Modulo only works with table indices starting at 0. ABAP instead starts counting at 1.
      " This -1/+1 ensures correct indices for tasks n*numberofNeededTasks (last Chain)
      data(chainNumber) = ( ( sy-tabix - 1 ) mod numberOfNeededChains ) + 1.

      " ABAP doesn't like nested tables inside append command ...
      data(chainReference) = ref #( result[ chainNumber ] ).

      append createTask( package )
      to chainReference->*.
    endloop.
  endmethod.

  method createJobChain.
    data:
      previousJob     type ref to zif_aps_batch_job.

    try.
      loop at i_taskChain->*
      into data(task).
        data(taskNumberInChain) = sy-tabix.
        data(isFirstTaskOfChain) = switch abap_bool(
                                     sy-tabix
                                     when 1 then abap_true
                                     else abap_false
                                   ).

        zcl_aps_task_storage_factory=>provide( )->storetask( task ).

        data(job) = zcl_aps_batch_job_factory=>provide(
                      i_task                = task
                      i_settings            = settings
                      i_chainnumber         = i_chainNumber
                      i_tasknumberinchain   = taskNumberInChain
                    ).

        job->create( ).

        job->addstep( ).

        " The first job of each chain is started by an event
        " If it would start directly it could have been finished before the successor is even released
        if isFirstTaskOfChain = abap_true.
          job->planAsEventTriggered( ).
        else.
          job->planAsSuccessor( previousJob ).
        endif.

        previousJob = job.
      endloop.
    catch zcx_aps_task_job_creation
          zcx_aps_task_job_submit
          zcx_aps_task_job_release
    into data(detailledJobError).
      raise exception
      type zcx_aps_job_creation_error
      exporting
        i_previous  = detailledJobError.
    endtry.
  endmethod.

  method createJobChains.
    loop at i_taskChains
    reference into data(taskChain).
      createJobChain(
        i_taskchain   = taskChain
        i_chainnumber = sy-tabix
      ).
    endloop.
  endmethod.

endclass.
