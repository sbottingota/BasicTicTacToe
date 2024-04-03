#!/usr/bin/env bash

declare -r BOARD_SIZE=9
declare -r DEFAULT_SQUARE_VALUE=-
declare -ra PLAYERS=(O X)
declare -ra WINNING_COMBINATIONS=("1 2 3" "4 5 6" "7 8 9" "1 4 7" "2 5 8" "3 6 9" "1 5 9" "3 5 7")

print_move_indices() {
    echo "Move indices:"
    echo "1|2|3"
    echo "4|5|6"
    echo "7|8|9"
    echo
}

draw_board() {
    shift
    for i in {1..3}
    do
        echo "$1|$2|$3"
        shift 3
    done
}


get_placement() {
shift
    while true
    do
        echo "Please enter a valid move (1-$BOARD_SIZE)"
        read -r n
        echo

        if [[ "$n" -gt 0 ]] && [[ "$n" -le "$BOARD_SIZE" ]] && [[ "${!n}" == "$DEFAULT_SQUARE_VALUE" ]]
        then
            placement=$n
            return
        fi

    done
}

is_draw() {
    shift
    for square in "$@"
    do
        if [[ "$square" == "$DEFAULT_SQUARE_VALUE" ]]
        then
            return 1
        fi
    done
    return 0
}

is_winner() {
    shift

    for combination in "${WINNING_COMBINATIONS[@]}"
    do
        is_win=1
        first_square="${combination:0:1}"
        for square in $combination
        do
            if [[ "${!square}" == "$DEFAULT_SQUARE_VALUE" ]] || [[ "${!square}" != "${!first_square}" ]]
            then
                is_win=0
                break
            fi
        done

        if [[ $is_win -eq 1 ]]
        then
            return 0
        fi
    done

    return 1

} 

board=( "/" $(for i in $(seq 1 $BOARD_SIZE); do echo "$DEFAULT_SQUARE_VALUE"; done) ) # dummy value at index 0 so that indices start from 1
current_turn="O"

print_move_indices

while true
do
    echo -e "$current_turn's turn\n"

    draw_board "${board[@]}"
    get_placement "${board[@]}"
    board[placement]="$current_turn"

    if is_draw "${board[@]}"
    then
        echo "Draw!"
        echo
        draw_board "${board[@]}"
        exit
    elif is_winner "${board[@]}"
    then
        echo "$current_turn is the winner!"
        draw_board "${board[@]}"
        exit
    fi

    [[ "$current_turn" == "${PLAYERS[0]}" ]] && current_turn=${PLAYERS[1]} || current_turn=${PLAYERS[0]}

    echo -en "\n\n\n"
done
