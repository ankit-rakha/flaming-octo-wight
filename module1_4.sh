#!/bin/bash

#********************************************************************

. CONFIG_FILE

#--MODULE1_4--#

#--CREATE RELATIONSHIPS--#

#--rels1 -> abstract - abstract--#
#--rels2 -> instance - abstract--#
#--rels3 -> instance - instance--#

function createRelationships(){

relationshipFile="$1"

echo "Processing $1 .."

num_lines1=$(wc -l < "$PWD"/"$relationshipFile")

for ((counter=1;counter<="$num_lines1";counter++));do

        node1=$(sed -n "$counter"p "$PWD"/"$relationshipFile" | awk '{print $1}')
        node2=$(sed -n "$counter"p "$PWD"/"$relationshipFile" | awk '{print $2}')
        relation=$(sed -n "$counter"p "$PWD"/"$relationshipFile" | awk '{print $3}')

		echo "#!/bin/bash" >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
        echo ". CONFIG_FILE" >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
		echo "counter=$counter" >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
        echo "node1=$node1" >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
        echo "node2=$node2" >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
        echo "relation=$relation" >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
        echo "relationshipFile=$relationshipFile" >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh


	if [[ "$relationshipFile" == "rels1" ]];then
		
		cat "$PWD"/contents_rels1 >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh

	elif [[ "$relationshipFile" == "rels2" ]];then

		cat "$PWD"/contents_rels2 >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh

	elif [[ "$relationshipFile" == "rels3" ]];then

		cat "$PWD"/contents_rels3 >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
	
	fi

	cat "$PWD"/contents_module1_4 >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
	chmod +x "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
	"$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh > "$LOG_PATH"log_"$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2" &
	
	if [[ "$relationshipFile" == "rels1" ]];then
	
		sleep 2
	
	else
		
		sleep 20
		
	fi
	
	
	
done

}

createRelationships rels1;
createRelationships rels2;
createRelationships rels3;

wait;

echo "MODULE1_4 finished";

#********************************************************************
