#!/bin/bash

. CONFIG_FILE

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
