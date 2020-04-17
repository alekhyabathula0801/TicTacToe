#!/bin/bash
#constants
NUM_OF_ROWS=3
NUM_OF_COLUMNS=3
#variables
declare -A board

echo You are assigned with letter X
player[1]=X
player[2]=O

toss=$((RANDOM%2))
if [ $toss -eq 1 ]
then
	echo player 1 start the game
else
	echo player 2 start the game
fi

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

echo Choose your cell
read -p "Enter row number " row
read -p "Enter column number " column
board[$row,$column]=X
