#include <stdio.h>
#include <stdlib.h>

#define N 100

int thck = N / 2;
int inpt;
int min = 0;
int max = N + 1;
int lie = 0;
int past;
int pasta;

int main()
{
printf("Я угадаю ваше число от 1 до %d! Просто напишите, ваше число больше, меньше или равно моему, когда я назову число.\nНачинаем!\n",N);
while (1){
    past = thck;
    printf("Ваше число - %d?\n",thck);
    scanf("%s",&inpt);
    if (inpt == '<') {
        max = thck;
    }
    if (inpt == '>') {
        min = thck;
    }
    if (inpt == '=') {
        printf("Ура! Я угадал ваше число! Мне нравится играть с вами!\n");
        break;
    }
    thck = (min + max) / 2;
    printf("min: %d, max: %d\n",min,max);
    if (past == thck){
        printf("Меня не обмануть. Я знаю, вы отвечали врассыпную. Я не хочу больше с вами играть.");
        break;
    }


}

}
