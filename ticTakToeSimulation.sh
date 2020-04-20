#!/bin/bash
#variables
numOfTurns=0
gameStatus=1
declare -A board

resetBoard(){
	for ((row=0;row<$numOfRows;row++))
	do
		for ((column=0;column<$numOfColumns;column++))
		do
			board[$row,$column]=.
		done
	done
}
printBoard(){
	echo -----------------
	echo "   "TIC-TAC-TOE"   "
	echo -----------------
	printf "%4s"
	for ((column=0;column<$numOfColumns;column++))
	do
    		printf "%2s" $(($column+1)) " "
	done
	echo
	for ((row=0;row<$numOfRows;row++))
	do
		printf  "%2s" $(($row+1)) " "
		for ((column=0;column<$numOfColumns;column++))
		do
			printf "%2s" ${board[$row,$column]} " "
		done
		echo
	done
}
checkRowWise(){
        for (( rows=0; rows<$numOfRows; rows++ ))
        do
                if [ ${board[$rows,0]} != "." ]
                then
                        count=1
                        for (( columns=1; columns<$numOfColumns; columns++ ))
                        do
                                if [ ${board[$rows,0]} = ${board[$rows,$columns]} ]
                                then
                                        ((count++))
                                fi
                        done
                        if [ $count = $numOfColumns ]
                        then
                                gameStatus=0
                                return;
                        fi
                fi
        done
}
checkColumnWise(){
        for (( columns=0; columns<$numOfColumns; columns++ ))
        do
                if [ ${board[0,$columns]} != "." ]
                then
                        count=1
                        for (( rows=1; rows<$numOfRows; rows++ ))
                        do
                                if [ ${board[0,$columns]} = ${board[$rows,$columns]} ]
                                then
                                        ((count++))
                                fi
                        done
                        if [ $count = $numOfRows ]
                        then
                                gameStatus=0
                                return;
                   	fi
                fi
        done
}
#check diagonal from top left to bottom right
checkFirstDiagonal(){
	if [ ${board[0,0]} != "." ]
        then
        	count=1
                for (( rows=1; rows<$numOfRows; rows++ ))
                do
                	if [ ${board[0,0]} = ${board[$rows,$rows]} ]
                        then
                        	((count++))
                        fi
                done
                if [ $count = $numOfRows ]
                then
                        gameStatus=0
                        return;
	        fi
        fi
}
#check diagonal from top right to bottom left
checkSecondDiagonal(){
	tempColumn=$(($numOfColumns-2))
        if [ ${board[0,$(($numOfColumns-1))]} != "." ]
        then
                count=1
                for (( rows=1; rows<$numOfRows; rows++ ))
                do
                        if [ ${board[0,$(($numOfColumns-1))]} = ${board[$rows,$tempColumn]} ]
                        then
                                ((count++))
                        fi
                        tempColumn=$(($tempColumn-1))
                done
                if [ $count = $numOfRows ]
                then
                        gameStatus=0
                        return;

                fi
        fi
}
checkWinningConditions(){
	checkRowWise
	if [ $gameStatus = 1 ]
	then
		checkColumnWise
	fi
	#if board is square matrix then check diagonal elements
	if [ $numOfRows = $numOfColumns ]
	then
	        if [ $gameStatus = 1 ]
        	then
               		checkFirstDiagonal
		fi
		if [ $gameStatus = 1 ]
		then
			checkSecondDiagonal
		fi
	fi
}
#check whether computer can win with a move
findWinningMove(){
        for (( row=0; row<$numOfRows; row++ ))
        do
                for (( column=0; column<$numOfColumns; column++ ))
                do
                        if [ ${board[$row,$column]} = "." ]
                        then
                                board[$row,$column]=${letter[$player]}
                                #invoke function to check winning condition
                                checkWinningConditions
                                if [ $gameStatus = 1 ]
                                then
                                        board[$row,$column]=.
                                else
                                        #invoke function to print board
                                        printBoard
                                        echo Game over
                                        echo ----------------------
                                        echo "  "Player $player won"  "
                                        echo ----------------------
                                        exit
                                fi
                        fi
                done
        done
}
#check whether opponent can win with a move and block it
blockOpponentMove(){
        for (( row=0; row<$numOfRows; row++ ))
        do
                for (( column=0; column<$numOfColumns; column++ ))
                do
                	if [ ${board[$row,$column]} = "." ]
                        then
                                board[$row,$column]=${letter[$(($player%2+1))]}
                                #invoke function to check winning condition
                                checkWinningConditions
                                if [ $gameStatus != 0 ]
                                then
                                        board[$row,$column]=.
                                else
                                        board[$row,$column]=${letter[$player]}
                                        gameStatus=1
					movesOfComputerPerTurn=1
                                        return;
                                fi
                        fi
                done
        done
}
#move to corners of board
moveToCorners(){
        if [ ${board[0,0]} = "." ]
        then
                board[0,0]=${letter[$player]}
		movesOfComputerPerTurn=1
                return
        elif [ ${board[$(($numOfRows-1)),0]} = "." ]
        then
                board[$(($numOfRows-1)),0]=${letter[$player]}
		movesOfComputerPerTurn=1
                return
        elif [ ${board[0,$(($numOfColumns-1))]} = "." ]
        then
                board[0,$(($numOfColumns-1))]=${letter[$player]}
		movesOfComputerPerTurn=1
                return
        elif [ ${board[$(($numOfRows-1)),$(($numOfColumns-1))]} = "." ]
        then
                board[$(($numOfRows-1)),$(($numOfColumns-1))]=${letter[$player]}
		movesOfComputerPerTurn=1
	fi
}
#move to centre of the board
moveToCentre(){
        if [ ${board[$(($numOfRows/2)),$(($numOfColumns/2))]} = "." ]
        then
                board[$(($numOfRows/2)),$(($numOfColumns/2))]=${letter[$player]}
		movesOfComputerPerTurn=1
        fi
}
#move across sides of the board
moveAcrossSides(){
        for (( row=0; row<$numOfRows; row++ ))
        do
                for (( column=0; column<$numOfColumns; column++ ))
                do
                        if [ ${board[$row,$column]} = "." ]
                        then
                                board[$row,$column]=${letter[$player]}
				movesOfComputerPerTurn=1
                                return;
                        fi
                done
        done
}
findComputerMove(){
	movesOfComputerPerTurn=0
	findWinningMove
	blockOpponentMove
	if [ $movesOfComputerPerTurn = 0 ]
	then
		moveToCorners
	fi
        if [ $movesOfComputerPerTurn = 0 ]
        then
                moveToCentre
        fi
        if [ $movesOfComputerPerTurn = 0 ]
        then
		moveAcrossSides
	fi
}
findPlayerMove(){
	#invoke function to print board
	printBoard
	echo Player $player turn with letter ${letter[$player]}
	echo Choose your cell
	read -p "Enter row number " row
	read -p "Enter column number " column
	if [ $row -ge 1 -a $row -le $numOfRows -a $column -ge 1 -a $column -le $numOfColumns ]
	then
		if [ ${board[$(($row-1)),$(($column-1))]} = "." ]
		then
			board[$(($row-1)),$(($column-1))]=$1
		else
			echo ------ Invalid choice ------
			echo Your choice is occupied
			echo Enter a valid choice
			#invoke function to find move of player
			findPlayerMove ${letter[$player]}
		fi
	else
                echo ------ Invalid choice ------
		echo Your choice is out of range
		echo Enter a valid choice
		#invoke function to find move of player
                findPlayerMove ${letter[$player]}
	fi
}
checkGameStatus(){
	if [ $gameStatus = 0 ]
        then
		#invoke function to print board
                printBoard
		echo Game over
                echo ----------------------
                echo "  "Player $player won"  "
                echo ----------------------
                exit;
	elif [ $numOfTurns = $(($numOfRows*$numOfColumns)) ]
        then
        	#invoke function to print board
                printBoard
                echo Game over
                echo ----------------------
                echo "      "Draw Match"      "
                echo ----------------------
                exit
	else
                player=$(($player%2+1))
        fi
}
singlePlayerGame(){
	echo you are player 1 assigned with letter ${letter[1]}
	echo Toss won by player $player
        while true
        do
                numOfTurns=$(($numOfTurns+1))
                if [ $player = 1 ]
                then
                        #invoke function to find move of player
                        findPlayerMove ${letter[$player]}
                        #invoke function to check winning conditions
                        checkWinningConditions
                else
                        echo Computer turn with letter ${letter[$player]}
                        #invoke funcion to find move of computer
                        findComputerMove
                fi

                checkGameStatus
        done
}
doublePlayerGame(){
        echo Toss won by player $player
	while true
        do
		numOfTurns=$(($numOfTurns+1))
 		#invoke function to find move of player
                findPlayerMove ${letter[$player]}
                #invoke function to check winning conditions
                checkWinningConditions
		checkGameStatus
	done
}
startTheGame(){
	echo ----------------------
	echo WELCOME TO TIC-TAC-TOE
	echo ----------------------
	echo Choose board size
	read -p "Enter number of rows " numOfRows
	read -p "Enter number of columns " numOfColumns
	read -p "Enter 1 for single player game and 2 for double player game " numOfPlayers
        #invoke function to reset board
        resetBoard
	printBoard
	random=$((RANDOM%2+1))
	letter[$random]=X
	letter[$(($random%2+1))]=O
        player=$((RANDOM%2+1))
	case $numOfPlayers in
		1)
			singlePlayerGame
		;;
		2)
			doublePlayerGame
		;;
		*)
			echo Invalid choice
			startTheGame
		;;
	esac
}
startTheGame
