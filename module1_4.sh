#!/bin/bash

. CONFIG_FILE

#--CREATE RELATIONSHIPS--#

#--rels1 -> instance - instance--#
#--rels2 -> instance - abstract--#
#--rels3 -> abstract - abstract--#

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

		cat "$PWD"/rels1_contents >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh

	elif [[ "$relationshipFile" == "rels2" ]];then

		cat "$PWD"/rels2_contents >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh

	elif [[ "$relationshipFile" == "rels3" ]];then

		cat "$PWD"/rels3_contents >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
	
	fi

	cat "$PWD"/module1_4_contents >> "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
	chmod +x "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh
	nohup "$SCRIPT_PATH""$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2".sh > "$LOG_PATH"log_"$relationshipFile"_"$counter"_"$node1"_"$relation"_"$node2" &
	sleep 60
done

}

createRelationships rels1;
createRelationships rels2;
#createRelationships rels3;
