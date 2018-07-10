#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 100 //диапазон чисел
#define MM 7
int main()
{
    int inpt;
    int counter = MM;
    srand(time(NULL)); // randomize()
    int x = rand() % N + 1;
    printf("Угадайте загаданное компьютером число от 1 до %d,\nно учтите, у вас %d попыток.\n",N,MM);
    while (1){
        scanf("%d",&inpt);
        counter --;

        if (inpt < x) {
            printf("Загаданное число больше\n");
        }
        if (inpt > x) {
            printf("Загаданное число меньше\n");
        }
        if (inpt == x) {
            printf("В точку!\n");
            break;
        }
        if (counter == 0) {
            printf("Число попыток истекло. Загаданное число: %d\n",x);
            break;
        }
        printf("Попыток осталось: %d\n",counter);
    }

}
