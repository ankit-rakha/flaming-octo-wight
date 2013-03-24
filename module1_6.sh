#!/bin/bash

. CONFIG_FILE

tar -zxvf "$PWD"/neo4j-community-1.9.M05-unix.tar.gz

mkdir -p "$PWD"/neo4j-community-1.9.M05/data/graph.db

cp "$PWD"/neo4j.properties "$PWD"/neo4j-community-1.9.M05/conf/
cp "$PWD"/neo4j-wrapper.conf "$PWD"/neo4j-community-1.9.M05/conf/
rm "$PWD"/log
"$PWD"/module2.sh "$NODE_FILES"nodes.csv
for file in "$RELATIONSHIPS_DIR"*.csv;do
echo "Processing $file";
"$PWD"/module3.sh "$file";
done
"$PWD"/module4.sh "$NODE_FILES"nodes_index.csv
cat "$PWD"/log
