#!/bin/bash

streak=0

while true; do
    num1=$((1 + RANDOM % 10))
    num2=$((1 + RANDOM % 10))
    operators=("+" "-" "*" "/")
    operator=${operators[$RANDOM % ${#operators[@]}]}

    # Calculate the correct answer and ensure it's an integer (for division)
    correct_answer=0
    case $operator in
        "+")
            correct_answer=$((num1 + num2))
            ;;
        "-")
            correct_answer=$((num1 - num2))
            ;;
        "*")
            correct_answer=$((num1 * num2))
            ;;
        "/")
            # Ensure num2 is not 0
            while [ "$num2" -eq 0 ]; do
                num2=$((1 + RANDOM % 10))
            done
            correct_answer=$((num1 / num2))
            ;;
    esac

    # Ask the user to solve the equation
    user_answer=$(zenity --entry --title="Algebra Quiz" --text="$num1 $operator $num2 =" --entry-text="" --width=200)

    # Check if the user left the answer field empty or pressed cancel, will finish the quiz
    if [ -z "$user_answer" ]; then
        break
    fi

    # Check if the user's answer is a valid integer then correct
    if [[ "$user_answer" =~ ^[0-9]+$ ]]; then
        if [ "$user_answer" -eq "$correct_answer" ]; then
            streak=$((streak + 1))
            zenity --info --title="Correct!" --text="Good job! Your streak is now $streak."
        else
            zenity --error --title="Incorrect" --text="Sorry, the correct answer is $correct_answer. Your streak was $streak."
            streak=0
        fi
    else
        zenity --error --title="Invalid Input" --text="Please enter a valid integer."
    fi
done

zenity --info --title="Quiz Ended" --text="Your final streak: $streak"
