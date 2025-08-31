.globl binary_search

//R0 contains the address of the first element of the list
//R1 contains the desired search value
//R2 contains the number of elements in the list


binary_search:

        //R4 will be the start index of the list, which is 0
        MOV r4, #0
        //R5 will be the end index of the list, which is the length of the list minus 1
        SUB r5, r2, #1 // r5 is end index (length - 1)
        //R6 will be the middle index, which is the end index divided by 2
        MOV r6, r5, LSR #1
        //R7 will hold the key (which index of the list contains the desired value) once it is found
        //for now it's 1
        MOV r7, #1
        //R8 will hold the number of iterations
        MOV r8, #-1

        //while the key has not been found (is still 1)
        While:  
                CMP r7, #1
                //If not equal, branch to Exit
                BNE Exit
                //Compare the start and the end index
                CMP r4, r5
                //If the start index is greater than the end index, break
                BGT Break
                //Take the address of the first element of the list and add the middle index*4 to it
                //This the the address of the element at the middle index of the list, store it into R9
                ADD r9, r0, r6, LSL #2 
                //Load the value at the middle index of the list into R10
                LDR r10, [r9, #0]
                //Compare the middle index value in R10 to the key value
                CMP r10, r1
                //If the values are equal, branch to Correct
                BEQ Correct
                //If the middle value is greater, branch to Greater
                BGT Greater
                //If the middle value is less, branch to Less
                BLT Less

        Return: 
                //Set the value just compared to the negative of the number of iterations
                STR r8, [r9, #0]
                //Subtract the start index of the list from the end index of the list
                //Store the range of the list in R11
                SUB r11, r5, r4 
                //Divide the range by 2
                MOV r11, r11, LSR #1
                //Add the start index and the quarter of the range and store in R6
                ADD r6, r11, r4
                //increment the number of iterations
                SUB r8, r8, #1


Break:
        //Store -1 to R7, indicating the key did not exist in the list
        mov r7, #-1
        //Branch to While to return to the list to look for the key
        B While

Correct:
        //Move the current middle index to R7
        mov r7, r6
        //Branch to Return, to readjust the middle index for the final comparison search loop, which will exit
        B Return
           
Greater:
        //Take the middle index and subtract 1, store it as the end index
        SUB r5, r6, #1
        //Branch to Return, to readjust the middle index and reenter the comparison search loop
        B Return
             
Less:    
        //Take the middle index and add 1, store it as the start index
        add r4, r6, #1
        //Branch to Return, to readjust the middle index and reenter the comparison search loop 
        B Return

Exit: 
        //Move the index of where the key is into r0
        mov r0, r7
        //Return to main
        mov pc,lr
