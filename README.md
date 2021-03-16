# Push_swap_tester.sh

This script will test checker and push_swap multiple times for different range and then display the result of each tested range. (number of correct answers, average number moves, minimum and maximum move used to sort the stack) It will generate a random list of numbers for each test.

**Note:** The script worked under Linux Xubuntu (42 VirtualMachine). I haven't tried it on MacOS or other Linux distribution. You can always fork the project and adapt it if you want.

## Usage:	
`sh push_swap_tester.sh [OPTIONS]`

## Options:

> **-r, --range RANGE_LIST** <br>
> Use a custom RANGE_LIST to test. RANGE_LIST must be a string of digits. ex: "1 2 3"
> 
> **-n, --nb-test NB_TEST** <br>
> Test each range NB_TEST times.
> 
> **-b, --bonus** <br>
>	Test reverse sorting bonus.

![Alt text](push_swap_tester.png?raw=true "Screenshot 1")

![Alt text](push_swap_tester1.png?raw=true "Screenshot 2")
