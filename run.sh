#!/usr/bin/env bash

declare -r BOARD_SIZE=9
declare -r DEFAULT_SQUARE_VALUE=-
declare -ra PLAYERS=(O X)

draw_board() {
    for i in {1..3}
    do
        echo "${1:- }|${2:- }|${3:- }"
        shift 3
    done
}


get_placement() {
    while :
    do
        echo "Please enter a valid move (0-$((BOARD_SIZE - 1)))"
        read n
        echo

        digit_pattern="^[0-$((BOARD_SIZE-1))]\$"
        args=("$@")
        if [[ $n =~ $digit_pattern ]] && [[ ${args[$n]} == $DEFAULT_SQUARE_VALUE ]]
        then
            placement=$n
            return
        fi

    done
}

# sets $ended to whether the game has ended and $winner to the winner
get_winner() {
    ended=1
    possible_draw=1

    # check for draw
    for square in $@
    do
        if [[ $square == $DEFAULT_SQUARE_VALUE ]]
        then
            possible_draw=0
            break
        fi
    done

    # check for winners
    if [[ ${PLAYERS[*]} =~ "$1" ]] && [[ ${PLAYERS[*]} =~ "$5" ]] && [[ ${PLAYERS[*]} =~ "$9" ]]
    then
        if [[ "$1" == "$5"  ]] && [[ "$5" == "$9" ]]
        then
            winner=$1
            return
        fi
    fi

    if [[ ${PLAYERS[*]} =~ "$3" ]] && [[ ${PLAYERS[*]} =~ "$5" ]] && [[ ${PLAYERS[*]} =~ "$7" ]]
    then
        if [[ "$3" == "$5"  ]] && [[ "$5" == "$7" ]]
        then
            winner=$3
            return
        fi
    fi

    for i in {1..3}
    do
        if [[ ${PLAYERS[*]} =~ "$1" ]] && [[ ${PLAYERS[*]} =~ "$2" ]] && [[ ${PLAYERS[*]} =~ "$3" ]]
        then
            if [[ "$1" == "$2"  ]] && [[ "$2" == "$3" ]]
            then
                winner=$1
                return
            fi
        fi

        if [[ ${PLAYERS[*]} =~ "$1" ]] && [[ ${PLAYERS[*]} =~ "$4" ]] && [[ ${PLAYERS[*]} =~ "$7" ]]
        then
            if [[ "$1" == "$4"  ]] && [[ "$4" == "$7" ]]
            then
                winner=$1
                return
            fi
        fi

        shift 3
    done

    winner=''

    if [[ $possible_draw == 1 ]]
    then
        return
    fi

    ended=0

} 

board=( $(for i in $(seq 1 $BOARD_SIZE); do echo "$DEFAULT_SQUARE_VALUE"; done) )
current_turn="O"

while :
do
    draw_board ${board[@]}
    get_placement ${board[@]}
    board[$placement]=$current_turn
    get_winner ${board[@]}    

    if [[ "$ended" == 1 ]]
    then
        if [ -n "$winner" ]
        then
            echo "$winner has won!"
            echo
            draw_board ${board[@]}
        else
            echo "Draw!"
            echo
            draw_board ${board[@]}
        fi

        exit
    fi

    [[ $current_turn == ${PLAYERS[0]} ]] && current_turn=${PLAYERS[1]} || current_turn=${PLAYERS[0]}

    echo -en "\n\n\n"
done


