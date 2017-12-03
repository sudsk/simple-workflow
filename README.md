# simple-workflow
simple-workflow is a simple Oracle based solution for ETL process management originated at http://bobjankovsky.org.

Implementing ETL or ELT processes based on PL/SQL modules there is usually one important task in the queue - Schedule execution of atomic modules following internal dependencies and another rules. Enterprise-wide schedulers usually do not fulfill requirements of fine grain dependencies and rules, so they are often used as trigger of ETL batch managed by local ETL scheduler. Most of schedulers built-in into standard ETL tools are too static and rigid, not scaleable. This gave rise to a simple oracle based workflow solution.



Copyright (c) 2008 Ludek Bob Jankovsky, bobjankovsky.org 

The Universal Permissive License (UPL), Version 1.0 
