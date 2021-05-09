#include <stdio.h>

    int main(){    
        
        //declare array from MIPS assembly program
        int arr[] = { 35,-34,82,-95,-2,22,-17,80,-67,-39,64,94,-96,95,-70,-63,69,-3,75,-10 };
        
        int arr1[10]; //MIPS assembly program variable data1
        int arr2[10]; //data2 
        
        int a3_size20 = 20; //size0
        int s4_size10 = 10; //size12

        prepareData(arr, arr1, arr2, a3_size20);
        
        int s5 = processData(arr1, s4_size10);
        int s6 = processData(arr2, s4_size10);
        
        displayResult(s5, s6);

        return 0;
    }

    void displayResult(int s5, int s6){
        
        int temp0 = s5 + s6;
        printf("Assignment 3\n");
        printf("------------\n");
        printf("Result:  %d\n", temp0);
    }

    void prepareData(int arr[], int arr1[], int arr2[], int a3_size20){

        int arr1_temp = 0;
        int arr2_temp = 0;
        
      for(int temp0 = 0; temp0 < a3_size20; temp0++ ){
            
            int temp3 = arr[temp0];
            int remainder = temp3 % 2;
            
            if(remainder != 0){

                arr1[arr1_temp] = temp3;
                arr1_temp = arr1_temp + 1;
                //printf("arr 1: %d\n", arr1[temp0]);
            } else{
                arr2[arr2_temp] = temp3;
                arr2_temp = arr2_temp + 1;
               // printf("arr 2: %d\n", arr2[temp0]);
            }
        }
    }
    
    int processData(int arr1[], int s4_size10){
        
        int temp1 = 100;
        
        for(int temp0 = 0; temp0 < s4_size10; temp0++){
            
            int temp4 = arr1[temp0];
            //printf("temp3 = %d\n", temp4);
            int remainder = temp0 % 2;
            
            if(remainder != 0){

                temp1 = temp1 - temp4;
            }else{
                temp1 = temp1 + temp4;
            }
        }
        int v0 = temp1;
       // printf("v0 = %d\n", v0);
        return v0; // Return the appropriate value
    }