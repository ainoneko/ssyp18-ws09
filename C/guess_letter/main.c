#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 26
int main()
{

    char str[10000];
    int inpt;
    srand(time(NULL)); // randomize();
    int x = rand() % N + 'A';

    // printf("x = %c",x);

    int counter = 0;
    while (inpt != x){
       printf("Угадайте букву английского алфавита от A до Z (Большие!!!)\n");
       scanf("%s", str);
       inpt = toupper (str[0]);
       counter --;
       if (inpt > x){
            printf("Идите к началу алфавита ");
       }
       if (inpt < x){
            printf("Идите к концу алфавита ");
       }
    }
    printf("Поздравляю вы угадали букву, вы молодцы!");
}
