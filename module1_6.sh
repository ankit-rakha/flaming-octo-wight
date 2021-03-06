#!/bin/bash

#********************************************************************

#--MODULE1_6--#

. CONFIG_FILE

#--CREATE GRAPH DATABASE--#

tar -zxvf "$PWD"/"$neo4j_database"-unix.tar.gz;

mkdir -p "$PWD"/"$neo4j_database"/data/graph.db;

#--CONFIGURE PARAMETERS--#

cp "$PWD"/neo4j.properties "$PWD"/"$neo4j_database"/conf/
cp "$PWD"/neo4j-wrapper.conf "$PWD"/"$neo4j_database"/conf/

rm "$PWD"/log;

#--INSERT NODES--#

"$PWD"/module2_1.sh "$NODE_FILES"nodes.csv;

#--INSERT RELATIONSHIPS--#

for file in "$RELATIONSHIPS_DIR"*.csv;do
	
	echo "Processing $file";
	"$PWD"/module2_2.sh "$file";
	
done

#--INDEXING--#

"$PWD"/module2_3.sh "$NODE_FILES"nodes_index.csv;

echo "MODULE1_6 finished";

#********************************************************************
