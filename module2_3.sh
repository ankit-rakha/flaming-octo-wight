#!/bin/bash

#********************************************************************

#--MODULE2_3--#

. CONFIG_FILE

index_path="$1";

java -Xmx90G -Xms90G -server -d64 -Xmn3g -XX:SurvivorRatio=2 -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:ParallelCMSThreads=4 -XX:+CMSParallelRemarkEnabled -XX:+CMSIncrementalMode -XX:+CMSIncrementalPacing -XX:CMSIncrementalDutyCycle=10 -XX:CMSFullGCsBeforeCompaction=1 -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:gc.log -cp "$PWD"/batch-import/target/batch-import-jar-with-dependencies.jar org.neo4j.batchimport.Importer "$PWD"/"$neo4j_database"/data/graph.db "$PWD"/header_nodes.csv "$PWD"/header_rels.csv node_index contractsNodesIndex exact "$index_path"  >> log

echo "MODULE2_3 finished";

#********************************************************************