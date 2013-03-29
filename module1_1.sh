#!/bin/bash

#********************************************************************

. CONFIG_FILE

#--MODULE1_1--#

#tr '\n' ' ' < "$INPUT_PATH""$temp_RDMS_DUMP_NAME" > "$INPUT_PATH""$RDMS_DUMP_NAME"

rm -rf "$OUTPUT_PATH";
mkdir -p "$OUTPUT_PATH";
mkdir -p "$SCRIPT_PATH";
mkdir -p "$LOG_PATH";
mkdir -p "$NODE_IND_FILES";
mkdir -p "$NODE_FILES";
mkdir -p "$INDICES_DIR";
mkdir -p "$RELATION_TYPE_DIR";
mkdir -p "$RELATIONSHIPS_DIR";

num_proc=$(cat /proc/cpuinfo | grep processor | wc -l);

echo "-- $num_proc processors in this node --";

num_lines=$(wc -l < "$RDMS_FILE");

for ((counter=1;counter<="$num_lines";counter++));do

	#col reqd
	col=$(sed -n "$counter"p "$RDMS_FILE" | awk -F":" '{print $1}');
	
	#col_name reqd
	col_name=$(sed -n "$counter"p "$RDMS_FILE" | awk -F":" '{print $2}');
	
	#Distribute jobs among different cores - USE
	#scheduler for different nodes	
	echo "Processing field no $col - $col_name";
	echo "#!/bin/bash" >> "$SCRIPT_PATH""$col_name".sh;
	echo ". CONFIG_FILE" >> "$SCRIPT_PATH""$col_name".sh;
	echo "col=$col" >> "$SCRIPT_PATH""$col_name".sh;
	echo "col_name=$col_name" >> "$SCRIPT_PATH""$col_name".sh;
	
	if [[ "$col_name" == "CURRENT_COMPLETION_DATE" || "$col_name" == "EFFECTIVE_DATE" ]];then

		cat contents_date >> "$SCRIPT_PATH""$col_name".sh;

	elif [[ "$col_name" == "ULTIMATE_CONTRACT_VALUE" || "$col_name" == "DOLLARS_OBLIGATED_PER_ACTION" ]];then

		cat contents_money >> "$SCRIPT_PATH""$col_name".sh;

	else
		
		cat contents_module1_1 >> "$SCRIPT_PATH""$col_name".sh;

	fi
	
	chmod +x "$SCRIPT_PATH""$col_name".sh;
	"$SCRIPT_PATH""$col_name".sh > "$LOG_PATH"log_"$col_name" &
	sleep 10;

done

wait;

function relationTypesCreate(){
		
		file="$1"

        awk < "$file" '{print $3}' | sed -e 's/^[ \t]*//;s/[ \t]*$//' >> temp_relation_types;

}

relationTypesCreate rels1;
relationTypesCreate rels2;
relationTypesCreate rels3;

sort -u temp_relation_types > "$PWD"/relation_types;
rm temp_relation_types;

echo "MODULE1_1 finished";

#********************************************************************