#!/bin/bash

#--MODULE1--#

#--COMMAND-LINE ARGUMENTS--#

INPUT_PATH="/usr2/contracts_dump/";
#input_path="$1"
OUTPUT_PATH="/usr2/contracts_dump/OUTPUT/";
#output_path="$2"
RDMS_DUMP_NAME="all_awardidv.nsv.gz";
#rdms_dump_name="$3"
RDMS_FILE="RDMS_COLUMNS.txt";
#rdms_file="$4"
LOG_PATH="$OUTPUT_PATH""LOGS/";
SCRIPT_PATH="$OUTPUT_PATH""SCRIPTS/";
NODE_IND_FILES="$OUTPUT_PATH""NODE_IND_FILES/";
NODE_FILES="$OUTPUT_PATH""NODE_FILES/";
PACKAGE_DIR="$PWD""/";
INDICES_DIR="$OUTPUT_PATH""REPLACED_BY_INDICES/";
RELATIONSHIP_FILE="relationships";
RELATION_TYPE_DIR="$OUTPUT_PATH""RELATION_TYPES/";
RELATIONSHIPS_DIR="$OUTPUT_PATH"RELATIONSHIPS/

mkdir -p "$SCRIPT_PATH";
mkdir -p "$LOG_PATH";
mkdir -p "$OUTPUT_PATH";
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

	while (ps -A | grep -v grep | grep "$col_name" > /dev/null); do sleep 1; done


done

#--COMBINATION--#

function flushCycle(){

        sed -e 's/^[ \t]*//;s/[ \t]*$//' "$1""$2" > "$1""$2"_spaces_trimmed;
        sed -e 's/[ \t]\+/_/g' -e 's/,//g' "$1""$2"_spaces_trimmed > "$1""$2"_spaces_trimmed_conversion_to_underscores;
        sed -e '/^$/d' "$1""$2"_spaces_trimmed_conversion_to_underscores > "$1""$2"_spaces_trimmed_conversion_to_underscores_removed_blank_spaces;
        sort -u "$1""$2"_spaces_trimmed_conversion_to_underscores_removed_blank_spaces > "$1""$2"_uniq;
        rm "$1""$2" "$1""$2"_spaces_trimmed "$1""$2"_spaces_trimmed_conversion_to_underscores_removed_blank_spaces;
        mv "$1""$2"_uniq "$NODE_FILES";
}

function nameTrim(){

	echo "$1" | sed 's/_spaces_trimmed_conversion_to_underscores//g';

}

function combination(){

	name1=$(nameTrim "$2");
	name2=$(nameTrim "$3");

	paste -d "_" "$1""$2" "$1""$3" > "$1""$name1"_"$name2";
	flushCycle "$1" "$name1"_"$name2";
}

combination "$NODE_IND_FILES" EFFECTIVE_DATE_DATE_spaces_trimmed_conversion_to_underscores CURRENT_COMPLETION_DATE_DATE_spaces_trimmed_conversion_to_underscores;
combination "$NODE_IND_FILES" POP_LOCATION_STATE_NAME_spaces_trimmed_conversion_to_underscores POP_ZIP_CODE_spaces_trimmed_conversion_to_underscores;

#--ABSTRACT NODES FROM ONTOLOGY--#

cp EXTRA_NODES_uniq "$NODE_FILES";

#--NODES.CSV--#

cat "$NODE_FILES"*_uniq | sort -u > "$NODE_FILES"temp_nodes;
cat header_nodes.csv "$NODE_FILES"temp_nodes > "$NODE_FILES"nodes.csv;
rm "$NODE_FILES"temp_nodes;


#--NODES_INDEX.CSV--#

nl -v 0 "$NODE_FILES"nodes.csv | sed -e 's/^[ \t]*//g' > "$NODE_FILES"nodes_index.csv;

#--REPLACE BY INDICES--#

for file in "$NODE_IND_FILES"*_underscores;do

	temp1=$(echo "$file" | tr '/' '-')
	temp2=$(echo "$NODE_IND_FILES" | tr '/' '-')
	filename=$(echo "$temp1" | sed -e "s/$temp2//g" -e 's/_spaces_trimmed_conversion_to_underscores//g')

		if [[ "$filename" ==  "CURRENT_COMPLETION_DATE_DATE" ]];then
			filename='COMPLETION_DATE'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "CURRENT_COMPLETION_DATE_DAY" ]];then
			filename='COMPLETION_DAY'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "CURRENT_COMPLETION_DATE_MONTH" ]];then
			filename='COMPLETION_MONTH'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "CURRENT_COMPLETION_DATE_YEAR" ]];then
			filename='COMPLETION_YEAR'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "EFFECTIVE_DATE_DATE" ]];then
			filename='EFFECTIVE_DATE'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "EFFECTIVE_DATE_DAY" ]];then
			filename='EFFECTIVE_DAY'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "EFFECTIVE_DATE_MONTH" ]];then
			filename='EFFECTIVE_MONTH'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "EFFECTIVE_DATE_YEAR" ]];then
			filename='EFFECTIVE_YEAR'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "EFFECTIVE_DATE_DATE_CURRENT_COMPLETION_DATE_DATE" ]];then
			filename='DATE_RANGE'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores

		elif [[ "$filename" ==  "POP_LOCATION_STATE_NAME_POP_ZIP_CODE" ]];then
			filename='STATE_ZIP'
			mv "$file" "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores
fi

awk 'NR==FNR{a[$2]=$1;next}{$1=a[$1];}1' "$NODE_FILES"nodes_index.csv "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores > "$INDICES_DIR""$filename"_replaced_by_indices

done

#--CREATE RELATIONSHIPS--#

num_lines1=$(countLines "$PWD"/rels1)

for ((counter=1;counter<="$num_lines1";counter++));do

	node1=$(sed -n "$counter"p "$PWD"/rels1 | awk '{print $1}')
	node2=$(sed -n "$counter"p "$PWD"/rels1 | awk '{print $2}')
	relation=$(sed -n "$counter"p "$PWD"/rels1 | awk '{print $3}')

	num_lines2=$(countLines "$INDICES_DIR""$node1"_replaced_by_indices)

	#printf "$relation\n%.0s" {1..100} > "$RELATION_TYPE_DIR""$relation"
	#awk -v relation="$relation" num_lines2="$num_lines2" 'BEGIN{for (i=1;i<=num_lines2;i++) print relation}'
	yes "$relation" | head -n "$num_lines2" > "$RELATION_TYPE_DIR""$relation"

	paste -d"\t" "$INDICES_DIR""$node1"_replaced_by_indices "$INDICES_DIR""$node2"_replaced_by_indices "$RELATION_TYPE_DIR""$relation" > "$RELATIONSHIPS_DIR"rels1_"$counter" 
	awk -F"\t"< "$RELATIONSHIPS_DIR"rels1_"$counter" '{if ($1!="" && $2!="") print}' > "$RELATIONSHIPS_DIR"rels1_"$counter"_temp_final
	sed -e '/^$/d' "$RELATIONSHIPS_DIR"rels1_"$counter"_temp_final > "$RELATIONSHIPS_DIR"rels1_"$counter"_final
	awk < "$RELATIONSHIPS_DIR"rels1_"$counter"_final '{if ($1<=$2) {print $1} else {print $2}}' > "$RELATIONSHIPS_DIR"rels1_"$counter"_PHASE1
	mkdir -p "$RELATIONSHIPS_DIR"TEMP_"$counter"
	paste -d"\t" "$RELATIONSHIPS_DIR"rels1_"$counter"_PHASE1 "$RELATIONSHIPS_DIR"rels1_"$counter"_final | sort -T "$RELATIONSHIPS_DIR"TEMP_"$counter"/ -u | sort -T "$RELATIONSHIPS_DIR"TEMP_"$counter"/ -n -k 1,1 | sed -e 's/[ \t]/\t/g' > "$RELATIONSHIPS_DIR"rels1_"$counter"_PHASE2
	awk < "$RELATIONSHIPS_DIR"rels1_"$counter"_PHASE2 '{print $2,"\t",$3,"\t",$4}' | sed -e 's/[ \t]/-/g' -e 's/---/\t/g' > "$RELATIONSHIPS_DIR"rels1_"$counter"_only_rels
	cat header_rels.csv "$RELATIONSHIPS_DIR"rels1_"$counter"_only_rels > "$RELATIONSHIPS_DIR"rels1_"$counter".csv
	rm "$RELATIONSHIPS_DIR"rels1_"$counter"_only_rels "$RELATIONSHIPS_DIR"rels1_"$counter"_temp_final "$RELATIONSHIPS_DIR"rels1_"$counter"_PHASE1 "$RELATIONSHIPS_DIR"rels1_"$counter"_final "$RELATIONSHIPS_DIR"rels1_"$counter"_PHASE2

done

rm -r "$RELATIONSHIPS_DIR"TEMP_*

tar -zxvf "$PWD"/neo4j-community-1.9.M05-unix.tar.gz

mkdir -p "$PWD"/neo4j-community-1.9.M05/data/graph.db

cp neo4j.properties "$PWD"/neo4j-community-1.9.M05/conf/
cp neo4j-wrapper.conf "$PWD"/neo4j-community-1.9.M05/conf/
rm "$PWD"/log
"$PWD"/module2.sh "$NODE_FILES"nodes.csv
for file in "$RELATIONSHIPS_DIR"*.csv;do
echo "Processing $file";
"$PWD"/module3.sh "$file";
done
"$PWD"/module4.sh "$NODE_FILES"nodes_index.csv
cat "$PWD"/log
