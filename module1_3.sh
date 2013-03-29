#!/bin/bash

#********************************************************************

. CONFIG_FILE

#--MODULE1_3--#

#--ABSTRACT NODES FROM ONTOLOGY--#

cp ONTOLOGY_NODES_uniq "$NODE_FILES";

#--NODES.CSV--#

mkdir -p "$RELATIONSHIPS_DIR"TEMP;

cat "$NODE_FILES"*_uniq | sort -T "$RELATIONSHIPS_DIR"TEMP/ -u > "$NODE_FILES"temp_nodes;
cat header_nodes.csv "$NODE_FILES"temp_nodes > "$NODE_FILES"nodes.csv;
rm "$NODE_FILES"temp_nodes;
rm -r "$RELATIONSHIPS_DIR"TEMP;

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

	awk 'NR==FNR{a[$2]=$1;next}{$1=a[$1];}1' "$NODE_FILES"nodes_index.csv "$NODE_IND_FILES""$filename"_spaces_trimmed_conversion_to_underscores > "$INDICES_DIR""$filename"_replaced_by_indices;

done

echo "MODULE1_3 finished";

#********************************************************************