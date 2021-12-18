# ABAP Parallelization Services
ABAP Parallelization Services are designed to be called from code in order to run a function unit / report / method with multiple parameter combinations in parallel.

## Reason for this project
As I could not find anything from SAP as versatile, easy to use and available on any SAP system able to run ABAP I started this project. I know many companies (customers, addon vendors and consulting companies) do have their own implementation. Most of the time these had been started to solve a certain purpose and have ben generalized after.

This project tries to suit those with a generic approach in order to give every company the possibility to easily run code in parallel without a big barrier to climb before.

## Capabilities
Executables supported: function unit, report, method
Parallelization technique: dialog task, batch task

## Release compatibility
The design has on Premise in mind. Whether this could work in BTP has not yet been discussed.

| on Prem release SAP_BASIS | status |
|---------------------------|:------:|
| 740                       | unclear |
| 750                       | should work |
| 751                       | should work |
| 752                       | should work |
| 753                       | should work |
| 754                       | developed on |
| 755                       | should work |
| 756                       | should work |

## Design and glossary
The caller must supply the following information:
1.	WHAT is to be executed? (type, name) &rarr; this is called ***Application***
2.	HOW is it to be executed? (parallelization technique, how many parallel, package size, …) &rarr; this is called ***Configuration***
3.	Parameter combinations for every call &rarr; this is called ***Parameter Sets*** (one set for one call)

The *Application* information and *Configuration* information are supplied via customizing tables (for reusability and easy change). The *Parameter Sets* must be implemented and the class doing so must be specified in the *Application*.

Using the max package size from the *Configuration* a so called ***Packetizer*** groups the *Parameter Sets* into ***Packages***. Every *Package* is then assigned to one ***Task***, which can be a ***Dialog Task*** or a ***Batch Task***. A ***Task Starter*** (scheduler) then starts the *Tasks* regarding the max parallel settings from the *Configuration* and collects final states of the tasks including the results. When all *Tasks* are finished the caller can then retrieve the results if needed to further process them.

## Installation
ABAPgit currently does not support SM62-event to be stored in git. Therefor the customer event ***ZAPS_JOB_START*** must be created manually using transaction SM62. 

This is used for batch jobs to be started after creation.

## Demo Reports
The development package ***ZAPS_DEMO*** contains demo reports that show how to use the ABAP Parallelization Services in different situations.

| Demo Report Name | demoed functionality |
|------------------|----------------------|
| zaps_demo_execute_funcunit | Execute a function unit with batch jobs and receive results |
| zaps_demo_execute_func_dia | Execute a function unit with aRFC and receive results |
| zaps_demo_execute_report | Execute a report with batch jobs (no results possible) |
| zaps_demo_execute_object | Execute a method with batch jobs |

## Disclaimer
The current state has never been used in real world scenarios. All demo reports work as expected and the unit test are running fine.

Ideas for stabilization and enhancement are welcome!
