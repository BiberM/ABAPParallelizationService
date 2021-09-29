interface zif_aps_batch_job
  public.
    constants:
      c_jobStartEvent type btceventid value 'ZAPS_JOB_START' ##NO_TEXT.

    methods:
      getJobName
        returning
          value(return)     type btcjob,

      getJobUniqueId
        returning
          value(return)     type btcjobcnt,

      create
        raising
          zcx_aps_task_job_creation,

      addStep
        raising
          zcx_aps_task_job_submit,

      planAsEventTriggered
        raising
          zcx_aps_task_job_release,

      planAsSuccessor
        importing
          i_predecessor type ref to zif_aps_batch_job
        raising
          zcx_aps_task_job_release.
endinterface.
