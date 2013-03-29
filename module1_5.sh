#!/bin/bash

#********************************************************************

. CONFIG_FILE

#--MODULE1_5--#

#--CREATE BATCHES BASED ON RELATIONSHIP-TYPES--#

num_lines3=$(wc -l < "$PWD"/"$RELATION_TYPE_FILE");
num_count=1

for ((counter=1;counter<="$num_lines3";counter++));do

        line=$(sed -n "$counter"p "$PWD"/"$RELATION_TYPE_FILE");
        echo "Processing $line relation type ..";
		rm -r "$RELATIONSHIPS_DIR""$line";
        mkdir -p "$RELATIONSHIPS_DIR""$line";
		flag=0;
		
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
		
		echo "$line not found ..";
		
	fi
	
	echo "#!/bin/bash" >> "$SCRIPT_PATH"module1_5_"$line".sh;
	echo "line=$line" >> "$SCRIPT_PATH"module1_5_"$line".sh;
	echo "num_count=$num_count" >> "$SCRIPT_PATH"module1_5_"$line".sh;
	cat contents_module1_5 >> "$SCRIPT_PATH"module1_5_"$line".sh;
	chmod +x "$SCRIPT_PATH"module1_5_"$line".sh;
	"$SCRIPT_PATH"module1_5_"$line".sh > "$LOG_PATH"log_module1_5_"$line" &
	sleep 20;
	num_count=$((num_count+1));
	
done

wait;

echo "MODULE1_5 finished";

#********************************************************************
