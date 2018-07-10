#include <stdio.h>
#include <stdlib.h>
#include <locale.h>

int main()
{
    setlocale(LC_ALL, "UTF8"); // Чтобы русские буквы правильно читались в scanf()

    printf("Hello world!\n");

    char str[80];

    printf("Как тебя зовут?\n");
    scanf("%s", str);

    printf("Привет, %s! Меня зовут Компик, как дела?", str);
    scanf("%s", str);

    return 0;
}
