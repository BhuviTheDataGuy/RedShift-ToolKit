#!/usr/bin/env bash
# version 1.0
# Developed by: Bhuvanesh (The Data Guy)
# Blog: https://thedataguy.in/

# Set some default values for all the variables
host=unset
user=unset
port=5439
database=unset
schema=unset
tables=unset
blacklisttables=unset
blacklistschemass=unset
wlmslot=1
querygroup=default
analyze=1
analyzethreshold=5
vacuum=1
vacuumoption='SORT ONLY'
vacuumpercent=80
unsortpct=10
statsoffpct=2
dryrun=0

echo `date '+%Y-%m-%d %H:%M:%S'` "Starting the process....."
# Usage function to help other to understand the arguments
usage()
{
  echo "Usage: [ Read the instructions below ]
		-h   RedShift Endpoint
		-u   User name, super admin is required.
		-P   password for the redshift user
		-p   RedShift Port
		-d   Database name
		-s   Schema name to vaccum/analyze, for multiple schemas then use comma (eg: 'schema1,schema2')
		-t   Table name to vaccum/analyze, for multiple tables then use comma (eg: 'table1,table2')
		-b   Blacklisted tables, these tables will be ignored from the vaccum/analyze
		-k   Blacklisted schemas, these schemas will be ignored from the vaccum/analyze
		-w   WLM slot count, Default=1
		-q   querygroup for the vaccum/analyze, Default=default
		-a   Perform analyze or not [Binary value, if 1 then Perform 0 means don't Perform]
		-r   set analyze_threshold_percent, default 5
		-v   Perform vaccum or not [Binary value, if 1 then Perform 0 means don't Perform]
		-o   vacuum options [FULL, SORT ONLY, DELETE ONLY, REINDEX ]
		-c   vacuum threshold percentage, Default=100
		-x   fitler the tables based on unsorted rows from svv_table_info, Default=10
		-f   fitler the tables based on stats_off from svv_table_info, Default=10
		-z   DRY RUN - just print the vacuum and analyze queries on the screen
  "
  exit 2
}

# Get the values from the input and validate them
[ $# -eq 0 ] && usage
while getopts ":h:u:P:p:d:s:t:b:k:w:q:a:r:v:o:c:x:f:z:" arg; do
  case $arg in
 
    h ) host=$OPTARG;;
    u ) user=$OPTARG;;
	P ) password=$OPTARG;;
	p ) port=$OPTARG;;
	d ) database=$OPTARG;;
	s ) schema=$OPTARG;;
	t ) tables=$OPTARG;;
	b ) blacklisttables=$OPTARG;;
	k ) blacklistschemass=$OPTARG;;
	w ) wlmslot=$OPTARG;;
	q ) querygroup=$OPTARG;;
	a ) analyze=$OPTARG;;
	r ) analyzethreshold=$OPTARG;;
	v ) vacuum=$OPTARG;;
	o ) vacuumoption=$OPTARG;;
	c ) vacuumpercent=$OPTARG;;
	x ) unsortpct=$OPTARG;;
	f )	statsoffpct=$OPTARG;;
	z )	dryrun=$OPTARG;;
 	*) echo "Unexpected option: $1 - this should not happen."
      usage
      exit 0
      ;;
  esac
done

echo `date '+%Y-%m-%d %H:%M:%S'` "Validating the Host,User,Database arguments"
# Host, Username, Database are mandatory parameters, exit if one of the argument is not available.
if [[ $host == 'unset' ]]; then
    echo "Host option a was NOT given, exit."
    usage
    exit 1;
elif [[ $user == 'unset' ]]; then
    echo "User option a was NOT given, exit."
    usage
    exit 1;
elif [[ $database == 'unset' ]]; then
    echo "Database option a was NOT given, exit."
    usage
    exit 1;    
fi

echo `date '+%Y-%m-%d %H:%M:%S'` "Perfect all the mandatory arguments are set"

echo `date '+%Y-%m-%d %H:%M:%S'` "Validating the Vacuum and Analyze arguments"
if [ $vacuum == 1 -o $vacuum == 0 ] 
	then echo `date '+%Y-%m-%d %H:%M:%S'` "Vacuum Arguemnt is $vacuum"
else echo `date '+%Y-%m-%d %H:%M:%S'` "Vacuum parameter only accept 1 or 0 [1-Yes 0-No]"
exit 1;
fi

if [ $analyze == 1 -o $analyze == 0 ] 
	then echo `date '+%Y-%m-%d %H:%M:%S'` "Analyze Arguemnt is $analyze"
else echo `date '+%Y-%m-%d %H:%M:%S'` "Analyze parameter only accept 1 or 0 [1-Yes 0-No]"
exit 1;
fi

# Export the password if the user provides, else it'll use pgpass file.
if [[ $password ]]
then
	export PGPASSWORD=$password
	echo `date '+%Y-%m-%d %H:%M:%S'` "User provided password will be used"
else
	echo `date '+%Y-%m-%d %H:%M:%S'` "Password will be taken from pgpass"
fi

#Get the list of schema
echo `date '+%Y-%m-%d %H:%M:%S'` "Getting the list of schema"
if [[ $schema == 'unset' ]]
then
	if [[ $blacklistschemas == 'unset' ]]
	then
	get_schema=$(psql -h  $host -U $user -p $port -d $database -t -c"select DISTINCT(\"schema\") from svv_table_info;" )
	schema=$(echo $get_schema | sed "s/\([^ ]*\)/\'&\'/g"| sed 's/ /,/g')
	else	
	blacklistschemas=$(echo $blacklistschemas | sed "s/\([^,]*\)/\'&\'/g")	
	get_schema=$(psql -h  $host -U $user -p $port -d $database -t -c"select DISTINCT(\"schema\") from svv_table_info where \"schema\" not in ($blacklistschemas);" )
	schema=$(echo $get_schema | sed "s/\([^ ]*\)/\'&\'/g"| sed 's/ /,/g')	
fi
else
schema=$(echo $schema | sed "s/\([^,]*\)/\'&\'/g")
fi	


# Get the list of tables for analyze
echo `date '+%Y-%m-%d %H:%M:%S'` "Getting the list of Tables for analyze"
if [[ $tables == 'unset' ]]
then
	if [[ $blacklisttables == 'unset' ]]
	then
	analyze_get_tables=$(psql -h  $host -U $user -p $port -d $database -t -c"select \"table\" from svv_table_info where stats_off>0 and stats_off > $statsoffpct and \"schema\" in ($schema);" )
	analyze_tables=$(echo $analyze_get_tables | sed "s/\([^ ]*\)/\'&\'/g"| sed 's/ /,/g')
	else	
	blacklisttables=$(echo $blacklisttables | sed "s/\([^,]*\)/\'&\'/g")	
	analyze_get_tables=$(psql -h  $host -U $user -p $port -d $database -t -c"select \"table\" from svv_table_info where \"table\" not in ($blacklisttables) and \"schema\" in ($schema) and stats_off>0 and stats_off > $statsoffpct;" )
	analyze_tables=$(echo $analyze_get_tables | sed "s/\([^ ]*\)/\'&\'/g"| sed 's/ /,/g')

fi
else
analyze_tables=$(echo $tables | sed "s/\([^,]*\)/\'&\'/g")
fi	


# Get the list of tables for vacuum
echo `date '+%Y-%m-%d %H:%M:%S'` "Getting the list of Tables for vacuum"
if [[ $tables == 'unset' ]]
then
	if [[ $blacklisttables == 'unset' ]]
	then
	get_tables=$(psql -h  $host -U $user -p $port -d $database -t -c"select \"table\" from svv_table_info where  \"schema\" in ($schema) and (unsorted IS NULL or unsorted >= $unsortpct) and (stats_off IS NULL or stats_off >= $statsoffpct);" )
	tables=$(echo $get_tables | sed "s/\([^ ]*\)/\'&\'/g"| sed 's/ /,/g')
	else	
	blacklisttables=$(echo $blacklisttables | sed "s/\([^,]*\)/\'&\'/g")	
	get_tables=$(psql -h  $host -U $user -p $port -d $database -t -c"select \"table\" from svv_table_info where \"table\" not in ($blacklisttables) and \"schema\" in ($schema) and (unsorted IS NULL or unsorted >= $unsortpct and  (stats_off IS NULL or stats_off >= $statsoffpct);" )
	tables=$(echo $get_tables | sed "s/\([^ ]*\)/\'&\'/g"| sed 's/ /,/g')
fi
else
tables=$(echo $tables | sed "s/\([^,]*\)/\'&\'/g")
fi	

echo `date '+%Y-%m-%d %H:%M:%S'` "Setting the other arguments"
#Set values from the arguments
if [[ $vacuum == 'unset' ]]
then
	vacuum=1
else
	vacuum=$vacuum
fi



if [[ $vacuumpercent == 'unset' ]]
then vacuumpercent=100
else
	vacuumpercent=$vacuumpercent
fi

if [[ $analyze == 'unset' ]]
then
	analyze=1
else
	analyze=$analyze
fi

if [[ $analyzethreshold == 'unset' ]]
then
	analyzethreshold=0.01
else
	analyzethreshold=$analyzethreshold
fi

if [[ $statsoffpct == 'unset' ]]
then
	statsoffpct=10
else
	statsoffpct=$statsoffpct
fi

if [[ $wlmslot == 'unset' ]]
then
	wlmslot=1
else
	wlmslot=$wlmslot
fi

if [[ $vacuumoption == 'unset' ]]
	then vacuumoption='SORT ONLY'
else
	vacuumoption=$vacuumoption
fi

## Auto vacuum option based on day
## Eg: run vacuum FULL on Saturday and SORT ONLY on other days
#if [[ `date '+%a'` == 'Sat' ]]
#	then  vacuumoption='FULL'
#else 
#	vacuumoption="SORT ONLY"
#fi

#SQL query for pushing the WLM slot and analyze_threshold_percent
slot_count_query="set wlm_query_slot_count to "$wlmslot" ;"
analyze_threshold_query="set analyze_threshold_percent to "$analyzethreshold";"

#Exit if no tables are matched as per the filter
if [[ $tables == "''" ]]
then
	echo `date '+%Y-%m-%d %H:%M:%S'` "NO tables are matched as per the filter, so skipping and exit"
	exit 1
else

# If user set 1 vacuum then start vaccum
if [[ $vacuum == 1 ]] 
then
generate_vacuum_query=$(psql -h $host -U $user -p $port -d $database -t -c"select 'vacuum $vacuumoption '||\"schema\"||'.'||\"table\"||';' from svv_table_info where \"schema\" in ($schema) and \"table\" in ($tables)";)
if [ $dryrun == 1 ]
then
echo ""
echo "DRY RUN for vaccum"
echo "------------------"
echo $generate_vacuum_query  | sed 's/; /;\n/g'
else
echo `date '+%Y-%m-%d %H:%M:%S'` "Vacuum is Starting now, stay tune !!!"
echo $slot_count_query $generate_vacuum_query |  sed 's/; /;\n/g' | psql -h $host -U $user -p $port -d $database > /dev/null 2>&1
echo `date '+%Y-%m-%d %H:%M:%S'` "Vacuum done"
fi
else
echo `date '+%Y-%m-%d %H:%M:%S'` "Vacuum flag is 0, So skipping"
fi

#If the user set 1 for analyze then start analyze
if [[ $analyze == 1 ]]
then 
generate_analyze_query=$(psql -h $host -U $user -p $port -d $database -t -c"select 'analyze '||\"schema\"||'.'||\"table\"||';' from svv_table_info where \"schema\" in ($schema) and \"table\" in ($analyze_tables)";)
if [ $dryrun == 1 ]
then	
echo ""
echo "DRY RUN for Analyze"
echo "-------------------"
echo $generate_analyze_query  | sed 's/; /;\n/g'
else
echo `date '+%Y-%m-%d %H:%M:%S'` "Analyze is Starting now, Please wait..."
echo $analyze_threshold_query $generate_analyze_query |  sed 's/; /;\n/g' | psql -h $host -U $user -p $port -d $database  > /dev/null 2>&1
echo `date '+%Y-%m-%d %H:%M:%S'` "Analyze done"
fi
else
echo `date '+%Y-%m-%d %H:%M:%S'` "Analyze flag is 0, So skipping"
fi
fi
