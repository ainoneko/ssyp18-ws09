#include <stdio.h>
#include <stdlib.h>
#include <locale.h>

int main()

{
    setlocale(LC_ALL, "UTF8");
    char str [300];
    for(;;){
       Start: printf("How will you call your chinchilla?\n");
        scanf ("%s",str);
        printf("%s it is a cool name.\n");
        printf("Will you feed %s?\n");
            scanf ("%s",str);
        if(strcmp(str, "yes") == 0){
            printf("OK\n");
        }
        else {
            printf("He is dead.Try again\n");
            goto Start;
        }
        printf("He is ill.Heal him?(answer yes or no)\n");
        scanf ("%s",str);
        if(strcmp(str, "yes") == 0){
            printf("OK\n");
        }
        else {
            printf("He is dead.Try again\n");
        }
        printf("Will you play with him?\n");
            scanf ("%s",str);
        if(strcmp(str, "yes") == 0){
            printf("OK\n");
        }
        else {
            printf("He is dead.Try again\n");
            goto Start;

    }
    printf("Will you carry him or her to the toilet?\n");
            scanf ("%s",str);
        if(strcmp(str, "yes") == 0){
            printf("OK\n");
        }
        else {
            printf("She or he pooped.Try again\n");
            goto Start;

    }
    printf("Will you place his or her cage in front of the window?\n");
            scanf ("%s",str);
        if(strcmp(str, "no") == 0){
            printf("OK\n");
        }
        else {
            printf("She or he is dead.Try again\n");
            goto Start;

    }
     printf("Well done.Do you like the game?\n");
            scanf ("%s",str);
        if(strcmp(str, "yes") == 0){
            printf("OK\n");
        }
        else {
            printf("Ok ;(\n");
            goto Start;

    }
    return 0;
}}
