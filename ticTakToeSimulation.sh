#!/bin/bash
#constants
NUM_OF_ROWS=3
NUM_OF_COLUMNS=3
#variables
declare -A board

echo You are assigned with letter X
player[1]=X
player[2]=O

resetBoard(){
	for ((i=0;i<$NUM_OF_ROWS;i++))
	do
		for ((j=0;j<$NUM_OF_COLUMNS;j++))
		do
			board[$i,$j]=.
		done
	done
}

printBoard(){
	printf "%4s"
	for ((i=0;i<$NUM_OF_COLUMNS;i++))
	do
    		printf "%2s" $i " "
	done
	echo
	for ((i=0;i<$NUM_OF_ROWS;i++))
	do
		printf  "%2s" $i " "
		for ((j=0;j<$NUM_OF_COLUMNS;j++))
		do
			printf "%2s" ${board[$i,$j]} " "
		done
		echo
	done
}

resetBoard
printBoard
