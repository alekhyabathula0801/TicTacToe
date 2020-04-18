#!/bin/bash
#constants
NUM_OF_ROWS=3
NUM_OF_COLUMNS=3
#variables
numOfTurns=0
gameStatus=1
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
				gameStatus=0
				return;
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
                	if [ $count = $NUM_OF_ROWS ]
                	then
				gameStatus=0
				return;
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
                               	if [ ${board[0,0]} = ${board[$rows,$rows]} ]
				then
                               		((count++))
				fi
			done
                	if [ $count = $NUM_OF_ROWS ]
                	then
				gameStatus=0
				return;
                	fi
        	fi

		#check diagonal from top right to bottom left
		tempColumn=$(($NUM_OF_COLUMNS-2))
		if [ ${board[0,$(($NUM_OF_COLUMNS-1))]} != "." ]
                then
			count=1
			for (( rows=1; rows<$NUM_OF_ROWS; rows++ ))
                	do
                                if [ ${board[0,$(($NUM_OF_COLUMNS-1))]} = ${board[$rows,$tempColumn]} ]
                                then
                                        ((count++))
                                fi
				tempColumn=$(($tempColumn-1))
			done
                        if [ $count = $NUM_OF_ROWS ]
                        then
				gameStatus=0
				return;
                        fi
		fi
	fi
}

computerMove(){
	#option 1 - check whether computer can win with a move
	for (( row=0; row<$NUM_OF_ROWS; row++ ))
	do
		for (( column=0; column<$NUM_OF_COLUMNS; column++ ))
		do
			if [ ${board[$row,$column]} = "." ]
			then
				board[$row,$column]=O
				#invoke function to check winning condition
				checkWinningConditions
				if [ $gameStatus = 1 ]
				then
					board[$row,$column]=.
				else
					echo Game over ... player $player won
					#invoke function to print board
                        		printBoard
					exit
				fi
			fi
		done
	done
	#option 2 - check whether opponent win with a move and block it
       	for (( row=0; row<$NUM_OF_ROWS; row++ ))
        do
                for (( column=0; column<$NUM_OF_COLUMNS; column++ ))
                do
                        if [ ${board[$row,$column]} = "." ]
                       	then
                               	board[$row,$column]=X
				#invoke function to check winning condition
                               	checkWinningConditions
                               	if [ $gameStatus != 0 ]
                               	then
                                       	board[$row,$column]=.
				else
					board[$row,$column]=O
					gameStatus=1
					return;
	                        fi
                        fi
                done
        done
	#option 3 - move to corners of board
	if [ ${board[0,0]} = "." ]
        then
                board[0,0]=O
		return
	elif [ ${board[0,$(($NUM_OF_COLUMNS-1))]} = "." ]
        then
                board[0,$(($NUM_OF_COLUMNS-1))]=O
		return
	elif [ ${board[$(($NUM_OF_ROWS-1)),0]} = "." ]
        then
                board[$(($NUM_OF_ROWS-1)),0]=O
		return
	elif [ ${board[$(($NUM_OF_ROWS-1)),$(($NUM_OF_COLUMNS-1))]} = "." ]
	then
		board[$(($NUM_OF_ROWS-1)),$(($NUM_OF_COLUMNS-1))]=O
                return
	fi
	# option 4 - move to centre of the board
        if [ ${board[$(($NUM_OF_ROWS/2)),$(($NUM_OF_COLUMNS/2))]} = "." ]
        then
		board[$(($NUM_OF_ROWS/2)),$(($NUM_OF_COLUMNS/2))]=O
		return
	fi

	#option 5 - move across sides of the board
	for (( row=0; row<$NUM_OF_ROWS; row++ ))
        do
               	for (( column=0; column<$NUM_OF_COLUMNS; column++ ))
               	do
                       	if [ ${board[$row,$column]} = "." ]
                       	then
                               	board[$row,$column]=O
                               	return;
			fi
		done
	done

}

chooseCell(){
	#invoke function to print board
	printBoard
	echo Choose your cell
	read -p "Enter row number " row
	read -p "Enter column number " column
	if [ ${board[$row,$column]} = "." ]
	then
		board[$row,$column]=X
	else
		echo invalid choice
		#invoke function to choose cell
		chooseCell
	fi

}

startTheGame(){
	##invoke function to reset board
	resetBoard
	echo ----------------------
	echo WELCOME TO TIC-TAC-TOE
	echo ----------------------
	echo You are player 1 assigned with letter X
	player=$((RANDOM%2+1))
	echo Toss won by player $player

	while true
	do
		numOfTurns=$(($numOfTurns+1))
		if [ $player = 1 ]
		then
			echo Your turn with symbol X
			#invoke function to choose cell
			chooseCell
		else
			echo Computer turn with symbol O
			#invoke funcion to choose cell by computer
			computerMove
		fi
		#invoke function to check winning conditions
		checkWinningConditions
		if [ $gameStatus = 0 ]
		then
			echo Game over ... player $player won
			#invoke function to print board
			printBoard
			exit;
		elif [ $numOfTurns = $(($NUM_OF_ROWS*$NUM_OF_COLUMNS)) ]
        	then
                	echo Game over ..... Draw match
			#invoke function to print board
			printBoard
			exit
		else
			player=$(($player%2+1))
		fi
	done
}

startTheGame
