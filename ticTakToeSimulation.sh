#!/bin/bash
#constants
NUM_OF_ROWS=3
NUM_OF_COLUMNS=3
#variables
numOfTurns=0
declare -A board

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

checkWinningConditions(){
	#check row wise
	for (( rows=0; rows<$NUM_OF_ROWS; rows++ ))
	do
		if [ ${board[$rows,0]} != "." ]
		then
			count=1
			for (( columns=1; columns<$NUM_OF_COLUMNS; columns++ ))
			do
				if [ ${board[$rows,0]} == ${board[$rows,$columns]} ]
				then
					((count++))
				fi
			done
			if [ $count = $NUM_OF_COLUMNS ]
			then
				echo Game over player $player won
				printBoard
				exit;
			fi
		fi
	done

	#check column wise

        for (( columns=0; columns<$NUM_OF_COLUMNS; columns++ ))
        do
                if [ ${board[0,$columns]} != "." ]
                then
                        count=1
                        for (( rows=1; rows<$NUM_OF_ROWS; rows++ ))
                        do
                                if [ ${board[0,$columns]} = ${board[$rows,$columns]} ]
                                then
					((count++))
				fi
                        done
                	if [ $count -eq $NUM_OF_ROWS ]
                	then
				echo Game over player $player won
                        	printBoard
				exit;
                	fi
		fi
        done
	#if board is square matrix then check diagonal elements
	if [ $NUM_OF_ROWS = $NUM_OF_COLUMNS ]
	then
		#check diagonal from top left to bottom right
		if [ ${board[0,0]} != "." ]
                then
			count=1
			for (( rows=1; rows<$NUM_OF_ROWS; rows++ ))
			do
                               	if [ ${board[0,0]} == ${board[$rows,$rows]} ]
				then
                               		((count++))
				fi
			done
                	if [ $count -eq $NUM_OF_ROWS ]
                	then
				echo Game over player $player won
				printBoard
				exit;
                	fi
        	fi

		#check diagonal from top right to bottom left
                columns1=$(($NUM_OF_COLUMNS-1))
		columns2=$(($NUM_OF_COLUMNS-2))
		if [ ${board[0,$columns1]} != "." ]
                then
			count=1
			for (( rows=1; rows<$NUM_OF_ROWS; rows++ ))
                	do
                                if [ ${board[0,$columns1]} = ${board[$rows,$columns2]} ]
                                then
                                        ((count++))
                                fi
				columns2=$(($columns2-1))
			done
                        if [ $count -eq $NUM_OF_ROWS ]
                        then
				echo Game over player $player won
                                printBoard
				exit;
                        fi
		fi
	fi

	#condition for draw match
	if [ $numOfTurns = $(($NUM_OF_ROWS*$NUM_OF_COLUMNS)) ]
	then
		echo Game over ..... Draw match
		exit;
	fi

}

chooseCell(){
	printBoard
	echo Choose your cell
	read -p "Enter row number " row
	read -p "Enter column number " column
	if [ ${board[$row,$column]} = "." ]
	then
		board[$row,$column]=$1
	else
		echo invalid choice
		chooseCell $symbol
	fi

}

resetBoard
echo You are player 1 assigned with letter X
letter[1]=X
letter[2]=O
echo ${symbol[1]}
toss=$((RANDOM%2+1))
player=$toss
while true
do
	symbol=${letter[$player]}
	echo player $player turn with symbol $symbol
	numOfTurns=$(($numOfTurns+1))
	chooseCell $symbol
	checkWinningConditions

done
