#!/bin/bash

# PATH to push_swap directory
PS_DIR="./"

# DO NOT TOUCH THIS VARIABLES
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
SET='\033[0m'

BONUS="FALSE"
LOOP=0
CORRECT=0
RANGEARRAY="2 3 4 5 10 50 100 200 500"
NBTEST=10
MOVEMAX=0
MOVEMIN=0
MOVETMP=0
MOVE=0
ERROR=0
RESULT=$BOLD$YELLOW"RANGE: CORRECT_ANSWERS: AVERAGE_NB_MOVE: MIN_MOVE: MAX_MOVE:\n"$SET

print_usage()
{
	echo -n $BOLD$YELLOW"USAGE:$SET"
	echo "\tsh push_swap_tester.sh [OPTIONS]\n"
	echo $BOLD$YELLOW"OPTIONS:"$SET
	echo $BOLD"\t -r, --range RANGE_LIST"$SET
	echo "\t\tUse a custom RANGE_LIST to test. RANGE_LIST must be a string of digits. ex: \"1 2 3\""
	echo $BOLD"\t -n, --nb-test NB_TEST"$SET
	echo "\t\tTest each range NB_TEST times."
	echo $BOLD"\t -b, --bonus"$SET
	echo "\t\tTest reverse sorting bonus.\n"
}

verification_and_set_options()
{
	cd $PS_DIR

	if [ -e "status.log" ]; then
		rm -f status.log
	fi
	if [ -e "op.log" ]; then
		rm -f op.log
	fi

	while [ $# -gt 0 ]
	do
		KEY="$1"
		case $KEY in
			-b|--bonus)
				BONUS="TRUE"
				shift
				;;
			-r|--range)
				expr "$2" : '^\( *[0-9]* *\)*$' > /dev/null
				if [ $? -ne "0" ]; then
					echo $BOLD$RED"Error parsing: "$SET"RANGE_LIST contains a non digit value.\n"
					print_usage
					exit 1
				else
					RANGE=$2
				fi
				shift
				shift
				;;
			-n|--nb-test)
				expr "$2" : '^\( *[0-9]* *\)$' > /dev/null
				if [ $? -ne "0" ]; then
					echo $BOLD$RED"Error parsing: "$SET"NB_TEST is a non numeric value.\n"
					print_usage
					exit 1
				else
					NBTEST=$2
				fi
				shift
				shift
				;;
			*)
				echo $BOLD$RED"Error parsing:$SET command is invalid for some reason.\n"
				print_usage
				exit 1
				shift
				;;
		esac
	done

	if [ ! -e "push_swap" ] || [ ! -e "checker" ]; then
		echo "Push swap or checker not found trying to build project..."
		if [ ! -e "Makefile" ]; then
			echo "Makefile not found exiting."
			exit
		fi
		make
		if [ $? -ne 0 ]; then
			echo "Push_swap_tester: Make failed: exiting."
			exit 1
		fi
	fi

}

display_header()
{
	clear
	echo
	echo "  $GREEN""██████╗ ██╗   ██╗███████╗██╗  ██╗        ███████╗██╗    ██╗ █████╗ ██████╗     "
	echo "  $GREEN""██╔══██╗██║   ██║██╔════╝██║  ██║        ██╔════╝██║    ██║██╔══██╗██╔══██╗    "
	echo "  $GREEN""██████╔╝██║   ██║███████╗███████║        ███████╗██║ █╗ ██║███████║██████╔╝    "
	echo "  $GREEN""██╔═══╝ ██║   ██║╚════██║██╔══██║        ╚════██║██║███╗██║██╔══██║██╔═══╝     "
	echo "  $GREEN""██║     ╚██████╔╝███████║██║  ██║███████╗███████║╚███╔███╔╝██║  ██║██║         "
	echo "  $GREEN""╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝         "
	echo $BOLD$YELLOW"\nAUTHOR:$SET Nnevalti (github) / vdescham@42.student.fr\n"
	print_usage
	echo -n $BOLD$YELLOW"RANGE_LIST$SET: ["
	echo -n $RANGEARRAY | sed "s/ /, /g"
	echo "]\n"
	echo -n $BOLD$YELLOW"BONUS:"$SET
	if [ "$BONUS" = "TRUE" ]; then
		echo "\tYes\n"
	else
		echo "\tNo\n"
	fi
	echo "This script will test push_swap and checker $NBTEST times for each range in RANGE_LIST."
	echo "It will generate a random array for each test.$SET"
	echo "Press enter to start the test !"
	read -r REPLY
}

calc_move_min_and_max()
{
	MOVETMP=$(wc -l op.log | cut -d ' ' -f1)
	if [ $((MOVETMP)) -gt "$MOVEMAX" ]; then
		MOVEMAX=$MOVETMP
	fi
	if [ "$MOVEMIN" -eq 0 ]; then
		MOVEMIN=$MOVETMP
	elif [ "$MOVETMP" -lt "$MOVEMIN" ]; then
		MOVEMIN=$MOVETMP;
	fi
	MOVE=$((MOVE+MOVETMP))
	MOVETMP=0
}

display_progress()
{
	printf "\033[2K"
	echo "RANGE 1-$RANGE"
	echo "Test completed $LOOP/$NBTEST"
	printf "\033[2A"
}

display_progress_check()
{
	if [ $ERROR -eq 0 ]; then
		printf "\033[2K"
		echo $GREEN"RANGE 1-$RANGE\t [ ✅]$SET"
		printf "\033[2K"
	else
		printf "\033[2K"
		echo $RED"RANGE 1-$RANGE\t [ ❌]$SET"
		printf "\033[2K"
	fi
	ERROR=0
}

calc_result()
{
	while read LINE
	do
		if [ "$LINE" = "OK" ]; then
			CORRECT=$((CORRECT+1))
		fi
	done < status.log
	rm -f status.log
	RESULT=$RESULT"1..$RANGE\t"
	if [ "$CORRECT" = "$NBTEST" ]; then
		RESULT=$RESULT$GREEN"$CORRECT/$NBTEST[✅]$SET "
	elif [ "$CORRECT" -gt 0 ]; then
		COLOR=$YELLOW
		RESULT=$RESULT$YELLOW"$CORRECT/$NBTEST[-]$SET "
	else
		COLOR=$RED
		RESULT=$RESULT$RED"$CORRECT/$NBTEST[❌]$SET "
	fi

	RESULT=$RESULT$((MOVE/NBTEST))" "
	RESULT=$RESULT"$MOVEMIN "

	if [ "$RANGE" -le 3 -a "$MOVEMAX" -gt 3 ] || [ "$RANGE" -le 5 -a "$MOVEMAX" -gt 12 ] || [ "$RANGE" -le 100 -a "$MOVEMAX" -gt 700 ] || [ "$RANGE" -le 500 -a "$MOVEMAX" -gt 5500 ]; then
		RESULT=$RESULT$RED$MOVEMAX"[❌]$SET\n"
	else
		RESULT=$RESULT$GREEN$MOVEMAX"[✅]$SET\n"
	fi
}

reset_variable()
{
	MOVE=0
	MOVEMAX=0
	MOVEMIN=0
	LOOP=0
	CORRECT=0
}

start_test()
{
	for RANGE in $RANGEARRAY
	do
		while [ "$LOOP" != "$NBTEST" ]; do
			display_progress
			ARG=`ruby -e "puts (1..$RANGE).to_a.shuffle.join(' ')"`; ./push_swap $ARG > op.log
			ERROR=$?
			./checker $ARG < op.log >> status.log
			ERROR=$((ERROR+$?))
			calc_move_min_and_max
			LOOP=$((LOOP+1))
		done
		display_progress_check
		calc_result
		reset_variable
		RANGE=$((RANGE+1))
	done
	rm op.log
}

start_test_reverse()
{
	for RANGE in $RANGEARRAY
	do
		while [ "$LOOP" != "$NBTEST" ]; do
			display_progress
			ARG=`ruby -e "puts (1..$RANGE).to_a.shuffle.join(' ')"`; ./push_swap -r $ARG > op.log
			ERROR=$?
			./checker -r $ARG < op.log >> status.log
			ERROR=$((ERROR+$?))
			calc_move_min_and_max
			LOOP=$((LOOP+1))
		done
		display_progress_check
		calc_result
		reset_variable
		RANGE=$((RANGE+1))
	done
	rm op.log
}

# START SCRIPT
verification_and_set_options "$@"
display_header
if [ "$BONUS" = "TRUE" ]; then
	echo $BOLD"Testing bonus (reverse) part :"$SET
	RESULT=$BOLD$YELLOW"RANGE: CORRECT_ANSWERS: AVERAGE_NB_MOVE: MIN_MOVE: MAX_MOVE:\n"$SET
	start_test_reverse
	echo $BOLD"\nRESULT REVERSE SORTING:\n"$SET
	echo $RESULT | column -t -e
else
	echo $BOLD"Testing mandatory part :"$SET
	start_test
	echo $BOLD"\nRESULT :\n"$SET
	echo $RESULT | column -t -e
fi
