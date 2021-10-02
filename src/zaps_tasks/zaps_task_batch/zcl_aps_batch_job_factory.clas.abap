class zcl_aps_batch_job_factory definition
  public
  final
  create public.

  public section.
    class-methods:
      provide
        importing
          i_task              type ref to zif_aps_task
          i_settings          type ref to zif_aps_settings
          i_chainNumber       type sytabix
          i_taskNumberInChain type sytabix
          i_testDoubleClassName type classname default space
        returning
          value(result)       type ref to zif_aps_batch_job.
  protected section.
  private section.
    types:
      begin of ty_instanceBufferLine,
        chainNumber       type sytabix,
        taskNumberInChain type sytabix,
        instance          type ref to zif_aps_batch_job,
      end of ty_instanceBufferLine.

    class-data:
      instanceBuffer      type hashed table
                               of ty_instanceBufferLine
                               with unique key chainNumber
                                               taskNumberInChain.
endclass.



class zcl_aps_batch_job_factory implementation.
  method provide.
    try.
      result = instanceBuffer[
                 chainNumber        = i_chainNumber
                 taskNumberInChain  = i_taskNumberInChain
               ]-instance.
    catch cx_sy_itab_line_not_found.
      if not i_testDoubleClassName is initial.
        " We must not create instances of productive classes given by classname here!
        " This is only for test double injection!
        " As we now define that they must be global classes we can always check against
        " ABAP system tables.
        select single @abap_true
        from seoclassdf
        where clsname eq @i_testDoubleClassName
          and category  eq '05'     "Unit Test Class --> FOR TESTING
        into @data(isUnitTestClass).

        if sy-subrc eq 0.
          create object result
          type (i_testDoubleClassName)
          exporting
            i_task              = i_task
            i_settings          = i_settings
            i_chainNumber       = i_chainNumber
            i_taskNumberInChain = i_taskNumberInChain.

        endif.

        if not result is bound
        or i_testDoubleClassName is initial.
          result = new zcl_aps_batch_job(
                         i_task              = i_task
                         i_settings          = i_settings
                         i_chainNumber       = i_chainNumber
                         i_taskNumberInChain = i_taskNumberInChain
                       ).
        endif.

        insert value #(
          chainNumber       = i_chainNumber
          taskNumberInChain = i_taskNumberInChain
          instance          = result
        )
        into table instanceBuffer.
      endif.
    endtry.
  endmethod.

endclass.
