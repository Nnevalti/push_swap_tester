# Push_swap_tester.sh

This script will test checker and push_swap multiple times for different range and then display the result of each tested range (number of correct answers, average number moves, minimum and maximum move used to sort the stack). It will generate a random list of numbers for each test.

**Note:** The script worked under Linux Xubuntu (42 VirtualMachine) and on the Dump Linux at 42 school Paris. It doesn't work on MacOS. You can always fork the project and adapt it if you want.

Informations:
Your main should return 0 if everything went well. I use the return value of push_swap main to determine if an error occur during the tests.
[source](https://www.geeksforgeeks.org/return-0-vs-return-1-in-c/)

---

## Usage:	
First you need to open the file and set the variable $PS_DIR to the path of your push_swap project directory or place push_swap_tester directly in the directory of the project. Then you can run it using :
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

---

## Screenshots
![Alt text](img/push_swap_tester.png?raw=true "Screenshot 1")

![Alt text](img/push_swap_tester1.png?raw=true "Screenshot 2")
