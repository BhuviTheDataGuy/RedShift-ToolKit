# Vacuum Analyze Utility

A shell script based Utility to manage the RedShift vacuum and analyze with more efficient and easy. Its inspired by the [AnalyzeVacuumUtilty from AWS community](https://github.com/awslabs/amazon-redshift-utils/tree/master/src/AnalyzeVacuumUtility) based python utility.

**Get more Updates on this from my blog:** https://thedataguy.in/automate-redshift-vacuum-analyze-using-shell-script-utility/

## Script Arguments:

To trigger the vacuum you need to provide three mandatory things. 

1. RedShift Endpoint
2. User Name
3. Database Name

This utility will not support cross database vacuum, it's the PostgreSQL limitation. 
There are some other parameters that will get generated automatically if you didn't pass them as an argument. Please refer to the below table.

| Argument | Details                                                                                    | Default         |
|----------|--------------------------------------------------------------------------------------------|-----------------|
| -h       | RedShift Endpoint                                                                          |                 |
| -u       | User name (super admin user)                                                               |                 |
| -P       | password for the redshift user                                                             | use pgpass file |
| -p       | RedShift Port                                                                              | 5439            |
| -d       | Database name                                                                              |                 |
| -s       | Schema name to vacuum/analyze, for multiple schemas then use comma (eg: 'schema1,schema2') | ALL             |
| -t       | Table name to vacuum/analyze, for multiple tables then use comma (eg: 'table1,table2')     | ALL             |
| -b       | Blacklisted tables, these tables will be ignored from the vacuum/analyze                   | Nothing         |
| -k       | Blacklisted schemas, these schemas will be ignored from the vacuum/analyze                 | Nothing         |
| -w       | WLM slot count to allocate limited memory                                                  | 1               |
| -q       | querygroup for the vacuum/analyze, Default=default (for now I didn't use this in script)   | default         |
| -a       | Perform analyze or not [Binary value, if 1 then Perform 0 means don't Perform]             | 1               |
| -r       | set analyze_threshold_percent                                                              | 5               |
| -v       | Perform vacuum or not [Binary value, if 1 then Perform 0 means don't Perform]              | 1               |
| -o       | vacuum options [FULL, SORT ONLY, DELETE ONLY, REINDEX ]                                    | SORT ONLY       |
| -c       | vacuum threshold percentage                                                                | 80              |
| -x       | Filter the tables based on unsorted rows from svv_table_info                               | 10              |
| -f       | Filter the tables based on stats_off from svv_table_info                                   | 10              |
| -z       | DRY RUN - just print the vacuum and analyze queries on the screen [1 Yes, 0 No]            | 0               |

## Installation:

For this, you just need `psql client` only, no need to install any other tools/software.

## Example Commands:

Run vacuum and Analyze on all the tables.
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev 
```
Run vacuum and Analyze on the schema sc1, sc2.
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -s 'sc1,sc2'
```
Run vacuum FULL on all the tables in all the schema except the schema sc1. But don't want Analyze
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -k sc1 -o FULL -a 0 -v 1
or
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -k sc1 -o FULL -a 0
```
Run Analyze only on all the tables except the tables tb1,tbl3.
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -b 'tbl1,tbl3' -a 1 -v 0
or 
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -b 'tbl1,tbl3' -v 0
```
Use a password on the command line.
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -P bhuvipassword
```
Run vacuum and analyze on the tables where unsorted rows are greater than 10%.
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -v 1 -a 1 -x 10
or
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -x 10
```
Run the Analyze on all the tables in schema sc1 where stats_off is greater than 5.
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -v 0 -a 1 -f 5
```
Run the vacuum only on the table tbl1 which is in the schema sc1 with the Vacuum threshold 90%.
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -s sc1 -t tbl1 -a 0 -c 90
```
Run analyze only the schema sc1 but set the [analyze_threshold_percent=0.01](https://docs.aws.amazon.com/redshift/latest/dg/r_analyze_threshold_percent.html)
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -s sc1 -t tbl1 -a 1 -v 0 -r 0.01
```
Do a dry run (generate SQL queries) for analyze all the tables on the schema sc2.
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -s sc2 -z 1
```
Do a dry run (generate SQL queries) for both vacuum and analyze for the table tbl3 on all the schema. 
```
./vacuum-analyze-utility.sh -h endpoint -u bhuvi -d dev -t tbl3 -z 1
```

## Change Log

* 2020-04-16 - Released the first version
* 2020-05-13 - Fixed bug (#3) Imporved analyze tables filter 