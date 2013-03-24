#!/bin/bash

. CONFIG_FILE

#--CREATE BATCHES BASED ON RELATIONSHIP-TYPES--#

num_lines3=$(wc -l < "$PWD"/"$RELATION_TYPE_FILE");
num_count=1

for ((counter=1;counter<="$num_lines3";counter++));do

        line=$(sed -n "$counter"p "$PWD"/"$RELATION_TYPE_FILE")
        echo "Processing $line relation type .."
	rm -r "$RELATIONSHIPS_DIR""$line"
        mkdir -p "$RELATIONSHIPS_DIR""$line"
	flag=0
        for filename in "$RELATIONSHIPS_DIR"*_only_rels;do

        if [ -f "$filename" ];then

		dir1=$(head -n 1 "$filename" | awk -F"\t" '{print $3}')

		
			if [[ "$dir1" == "$line"  ]];then
		
				echo " Processing $filename .."
                		cp "$filename" "$RELATIONSHIPS_DIR""$dir1"
				flag=1
			fi
        fi

        done

	if (("$flag"==0));then
		echo "$line not found .."
	fi

	cat "$RELATIONSHIPS_DIR""$line"/*_only_rels > "$RELATIONSHIPS_DIR""$line"/BATCH_"$num_count"_"$line"
	rm "$RELATIONSHIPS_DIR""$line"/*_only_rels
	cat "$PWD"/header_rels.csv "$RELATIONSHIPS_DIR""$line"/BATCH_"$num_count"_"$line" > "$RELATIONSHIPS_DIR"BATCH_"$num_count"_"$line".csv
	rm -r "$RELATIONSHIPS_DIR""$line"
	num_count=$((num_count+1))

done
