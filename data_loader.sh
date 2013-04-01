#!/bin/bash

#********************************************************************

echo "--Data Loader starting--";

"$PWD"/module1_1.sh > log_module1_1;

wait;

"$PWD"/module1_2.sh > log_module1_2;

wait;

"$PWD"/module1_3.sh > log_module1_3;

wait;

"$PWD"/module1_4.sh > log_module1_4;

wait;

"$PWD"/module1_5.sh > log_module1_5;

wait;

"$PWD"/module1_6.sh > log_module1_6;

wait;

echo "--Data Loader finished its job--";

#********************************************************************