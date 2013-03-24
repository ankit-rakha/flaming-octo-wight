#!/bin/bash

. CONFIG_FILE

#--MODULE1--#

#tr '\n' ' ' < "$INPUT_PATH""$temp_RDMS_DUMP_NAME" > "$INPUT_PATH""$RDMS_DUMP_NAME"

mkdir -p "$OUTPUT_PATH";
mkdir -p "$SCRIPT_PATH";
mkdir -p "$LOG_PATH";
mkdir -p "$NODE_IND_FILES";
mkdir -p "$NODE_FILES";
mkdir -p "$INDICES_DIR";
mkdir -p "$RELATION_TYPE_DIR";
mkdir -p "$RELATIONSHIPS_DIR";

#--FINISH--#

head=$(which head);
tail=$(which tail);
awk=$(which awk);
sed=$(which sed);
cat=$(which cat);
paste=$(which paste);
wc=$(which wc);

num_proc=$(cat /proc/cpuinfo | grep processor | wc -l);
echo "-- $num_proc processors in this node --";

function countLines(){

	wc -l < "$1";

}

function lineNumFile(){

	sed -n "$1"p "$2";

}

num_lines=$(countLines "$RDMS_FILE");

for ((counter=1;counter<="$num_lines";counter++));do

	#col reqd
	col=$(lineNumFile "$counter" "$RDMS_FILE" | awk -F":" '{print $1}');
	col_name=$(lineNumFile "$counter" "$RDMS_FILE" | awk -F":" '{print $2}');
	
	#col_name reqd.
	
	#Distribute jobs among different cores - USE
	#scheduler for different nodes
	
	echo "Processing field no $col - $col_name";
	rm "$SCRIPT_PATH""$col_name".sh "$LOG_PATH"log_"$col_name";
	echo "#!/bin/bash" >> "$SCRIPT_PATH""$col_name".sh;
	echo "INPUT_PATH=$INPUT_PATH" >> "$SCRIPT_PATH""$col_name".sh;
	echo "OUTPUT_PATH=$OUTPUT_PATH" >> "$SCRIPT_PATH""$col_name".sh;
	echo "RDMS_DUMP_NAME=$RDMS_DUMP_NAME" >> "$SCRIPT_PATH""$col_name".sh;
	echo "RDMS_FILE=$RDMS_FILE" >> "$SCRIPT_PATH""$col_name".sh;
	echo "LOG_PATH=$LOG_PATH" >> "$SCRIPT_PATH""$col_name".sh;
	echo "SCRIPT_PATH=$SCRIPT_PATH" >> "$SCRIPT_PATH""$col_name".sh;
	echo "NODE_IND_FILES=$NODE_IND_FILES" >> "$SCRIPT_PATH""$col_name".sh;
	echo "NODE_FILES=$NODE_FILES" >> "$SCRIPT_PATH""$col_name".sh;
	echo "PACKAGE_DIR=$PACKAGE_DIR" >> "$SCRIPT_PATH""$col_name".sh;
	echo "RELATION_TYPE_DIR=$RELATION_TYPE_DIR" >> "$SCRIPT_PATH""$col_name".sh;
	echo "head=$head">> "$SCRIPT_PATH""$col_name".sh;
	echo "tail=$tail">> "$SCRIPT_PATH""$col_name".sh;
	echo "awk=$awk">> "$SCRIPT_PATH""$col_name".sh;
	echo "sed=$sed">> "$SCRIPT_PATH""$col_name".sh;
	echo "cat=$cat">> "$SCRIPT_PATH""$col_name".sh;
	echo "paste=$paste">> "$SCRIPT_PATH""$col_name".sh;
	echo "wc=$wc">> "$SCRIPT_PATH""$col_name".sh;
	echo "col=$col" >> "$SCRIPT_PATH""$col_name".sh;
	echo "col_name=$col_name" >> "$SCRIPT_PATH""$col_name".sh;
	
	if [[ "$col_name" == "CURRENT_COMPLETION_DATE" || "$col_name" == "EFFECTIVE_DATE" ]];then

		cat contents_date >> "$SCRIPT_PATH""$col_name".sh;

	elif [[ "$col_name" == "ULTIMATE_CONTRACT_VALUE" || "$col_name" == "DOLLARS_OBLIGATED_PER_ACTION" ]];then

		cat contents_money >> "$SCRIPT_PATH""$col_name".sh;

	else
		cat contents_module1 >> "$SCRIPT_PATH""$col_name".sh;

	fi
	chmod +x "$SCRIPT_PATH""$col_name".sh;
	nohup "$SCRIPT_PATH""$col_name".sh > "$LOG_PATH"log_"$col_name" &

done
