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
    methods:
      createTask redefinition.

  private section.
    methods:
      createTaskChains
        importing
          i_packages      type zaps_packages
        returning
          value(return)   type zaps_task_chains,

      createJobChains
        importing
          i_taskChains    type zaps_task_chains,

      createJobChain
        importing
          i_taskChain     type ref to zaps_task_chain.
endclass.



class zcl_aps_task_starter_batch implementation.
  method zif_aps_task_starter~start.
    data(taskChains) = createTaskChains( i_packages ).

    createJobChains( taskChains ).
  endmethod.

  method createTask.

  endmethod.

  method createTaskChains.
    data(numberOfNeededChains) = nmin(
                                   val1 = lines( i_packages )
                                   val2 = settings->getmaxparalleltasks( )
                                 ).

    do numberOfNeededChains times.
      append initial line
      to return.
    enddo.

    loop at i_packages
    reference into data(package).
      " Modulo only works with table indices starting at 0. ABAP instead starts counting at 1.
      " This -1/+1 ensures correct indices for tasks n*numberofNeededTasks (last Chain)
      data(chainNumber) = ( ( sy-tabix - 1 ) mod numberOfNeededChains ) + 1.

      " ABAP doesn't like nested tables inside append command ...
      data(chainReference) = ref #( return[ chainNumber ] ).

      append createTask( package )
      to chainReference->*.
    endloop.
  endmethod.

  method createJobChain.

  endmethod.

  method createJobChains.
    loop at i_taskChains
    reference into data(taskChain).
      createJobChain( taskChain ).
    endloop.
  endmethod.

endclass.
