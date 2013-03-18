#!/bin/bash

for file in *.csv;do

echo "Processing $file";

/usr5/contracts/RELS/PARALLEL_INSERTOR/insert1.sh "$file";

sleep 2;

done
