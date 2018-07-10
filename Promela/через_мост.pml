//status: works, taks 0.13x s
//Version: 1.1
//Author: SOBOLEV
mtype:bubusky = {m,M1,M2,M5,M10}
//нужные массивы
int tm[6] = {0, 10, 5, 2, 1, 0}
int l[6] = {0,1,1,1,1,1}
int r[6]
int ib[6]
int vr[6]
//константы
#define pm 2
#define MAX_TM 27
#define ggwp ((r[1] == 1) && (r[2] == 1) && (r[3] == 1) && (r[4] == 1))
//пишет статус
inline print_status(){
    printf("STATUS: \n On the left: M10- %d M5- %d M2- %d M1- %d\n On the right: M10- %d M5- %d M2- %d M1- %d\n On the bridge: M10-%d M5- %d M2- %d M1- %d\n", l[1], l[2], l[3], l[4], r[1], r[2], r[3], r[4], ib[1], ib[2], ib[3], ib[4]) 
}

inline BtS(){
    if
        :: r[m] == 1 ->
        printf("Разгрузка на правом берегу")
        r[M1] = r[M1] + ib[M1]
        r[M2] = r[M2] + ib[M2]
        r[M5] = r[M5] + ib[M5]
        r[M10] = r[M10] + ib[M10] 
        :: r[m] == 0 ->
        printf("Разгрузка на левом берегу")
        l[M1] = l[M1] + ib[M1]
        l[M2] = l[M2] + ib[M2]
        l[M5] = l[M5] + ib[M5]
        l[M10] = l[M10] + ib[M10]
        :: else ->
        printf("error 404: light not found")
    
    fi;
    ib[M1] = 0
    ib[M2] = 0
    ib[M5] = 0
    ib[M10] = 0 
}

// inline update(){
    
// }


init{
    local byte ag;
    local byte time;
    local byte timeh;
    local short times;

    // //  Для отладки:
    //  printf("идет мин 2 %d",tm[M2]);
    //  printf("идет мин 5 %d",tm[M5]);
    //  printf("идет мин 1 %d",tm[M1]);
    //  printf("идет мин 10 %d",tm[M10]);
    do
        // пока решение не найдено:
        :: ! ggwp ->
            print_status();
            printf("Начаю погрузку на стороне %d \n", r[m])
            if
            :: r[m] == 0 -> 
                do
                :: (tm[M1] + timeh + time <= MAX_TM) && (l[M1] == 1) && (vr[M1] == 0) ->
                    printf("+M1\n");
                    vr[M1] ++;
                    ag ++;

                    if 
                    :: timeh < 1 -> timeh = 1;
                    :: else -> skip;
                    fi;
                :: (tm[M2] + timeh + time <= MAX_TM) && (l[M2] == 1) && (vr[M2] == 0) ->
                    printf("+M2\n");
                    vr[M2] ++;
                    ag ++;
                    if 
                    :: timeh < 2 -> timeh = 2;
                    :: else -> skip;
                    fi;
                :: (tm[M5] + timeh + time <= MAX_TM) && (l[M5] == 1) && (vr[M5] == 0) ->
                    printf("+M5\n");
                    vr[M5] ++;
                    ag ++;
                    if 
                    :: timeh < 5 -> timeh = 5;
                    :: else -> skip;
                    fi;                    
                :: (tm[M10] + timeh + time <= MAX_TM) && (l[M10] == 1) && (vr[M10] == 0) ->
                    printf("+M10\n");
                    vr[M10] ++;
                    ag ++;
                    if 
                    :: timeh < 10 -> timeh = 10;
                    :: else -> skip;
                    fi;

                :: (l[M1] == 0) && (vr[M1] == 1) ->
                    printf("-M1\n");
                    vr[M1] --;
                    ag --;

                    if 
                    :: timeh < 1 -> timeh == 0;
                    :: else -> skip;
                    fi;
                :: (l[M2] == 0) && (vr[M2] == 1) ->
                    printf("-M2\n");
                    vr[M2] --;
                    ag --;
                    if 
                    :: vr[M1] == 1 -> timeh = 1;
                    :: ag == 0  -> timeh = 0;
                    :: else -> skip;
                    fi;
                ::  (l[M5] == 0) && (vr[M5] == 1) ->
                    printf("-M5\n");
                    vr[M5] --;
                    ag --;
                    if
                    :: vr[M2] == 1 -> timeh = 2;
                    :: vr[M1] == 1 -> timeh = 1;
                    :: ag == 0  -> timeh = 0;
                    :: else -> skip
                    fi;                    
                ::  (l[M10] == 0) && (vr[M10] == 1) ->
                    printf("-M10\n");
                    vr[M10] --;
                    ag --;
                    if 
                    :: vr[M5] == 1 -> timeh = 5;
                    :: vr[M2] == 1 -> timeh = 2;
                    :: vr[M1] == 1 -> timeh = 1;
                    :: ag == 0  -> timeh = 0;
                    :: else -> printf("STHG WNT WRNG\n")
                    fi;
                ::  (timeh + time <= MAX_TM) && (ag > 0) && (ag <= pm) ->
                    ib[M1] = vr[M1];
                    ib[M2] = vr[M2];
                    ib[M5] = vr[M5];
                    ib[M10] = vr[M10];
                    vr[M1] = 0;
                    vr[M2] = 0;
                    vr[M5] = 0;
                    vr[M10] = 0;
                    l[M1] = l[M1] - ib[M1];
                    l[M2] = l[M2] - ib[M2];
                    l[M5] = l[M5] - ib[M5];
                    l[M10] = l[M10] - ib[M10];
                    l[m] = 0;
                    r[m] = 1;
                    times ++;
                    time = time + timeh;
                    timeh = 0;
                    ag = 0;
                    BtS();
                    break;

                :: else -> printf("Что-то пошло не так.")    
                od;
            :: r[m] == 1 ->
                do
                :: (tm[M1] + timeh + time <= MAX_TM) && (r[M1] == 1) && (vr[M1] == 0) ->
                    printf("+M1\n");
                    vr[M1] ++;
                    ag ++;

                    if 
                    :: timeh < 1 -> timeh = 1;
                    :: else -> skip;
                    fi;
                :: (tm[M2] + timeh + time <= MAX_TM) && (r[M2] == 1) && (vr[M2] == 0) ->
                    printf("+M2\n");
                    vr[M2] ++;
                    ag ++;
                    if 
                    :: timeh < 2 -> timeh = 2;
                    :: else -> skip;
                    fi;
                :: (tm[M5] + timeh + time <= MAX_TM) && (r[M5] == 1) && (vr[M5] == 0) ->
                    printf("+M5\n");
                    vr[M5] ++;
                    ag ++;
                    if 
                    :: timeh < 5 -> timeh = 5;
                    :: else -> skip;
                    fi;                    
                :: (tm[M10] + timeh + time <= MAX_TM) && (r[M10] == 1) && (vr[M10] == 0) ->
                    printf("+M10\n");
                    vr[M10] ++;
                    ag ++;
                    if 
                    :: timeh < 10 -> timeh = 10;
                    :: else -> skip;
                    fi;

                :: (r[M1] == 0) && (vr[M1] == 1) ->
                    printf("-M1\n");
                    vr[M1] --;
                    ag --;

                    if 
                    :: timeh < 1 -> timeh == 0;
                    :: else -> skip;
                    fi;
                :: (r[M2] == 0) && (vr[M2] == 1) ->
                    printf("-M2\n");
                    vr[M2] --;
                    ag --;
                    if 
                    :: vr[M1] == 1 -> timeh = 1;
                    :: ag == 0  -> timeh = 0;
                    :: else -> skip;
                    fi;
                ::  (r[M5] == 0) && (vr[M5] == 1) ->
                    printf("-M5/n");
                    vr[M5] --;
                    ag --;
                    if
                    :: vr[M2] == 1 -> timeh = 2;
                    :: vr[M1] == 1 -> timeh = 1;
                    :: ag == 0  -> timeh = 0;
                    :: else -> skip
                    fi;                    
                ::  (r[M10] == 0) && (vr[M10] == 1) ->
                    printf("-M10\n");
                    vr[M10] --;
                    ag --;
                    if 
                    :: vr[M5] == 1 -> timeh = 5;
                    :: vr[M2] == 1 -> timeh = 2;
                    :: vr[M1] == 1 -> timeh = 1;
                    :: ag == 0  -> timeh = 0;
                    :: else -> printf("STHG WNT WRNG\n")
                    fi;
                ::  (timeh + time <= MAX_TM) && (ag > 0) && (ag <= pm) ->
                    ib[M1] = vr[M1];
                    ib[M2] = vr[M2];
                    ib[M5] = vr[M5];
                    ib[M10] = vr[M10];
                    vr[M1] = 0;
                    vr[M2] = 0;
                    vr[M5] = 0;
                    vr[M10] = 0;
                    r[M1] = r[M1] - ib[M1];
                    r[M2] = r[M2] - ib[M2];
                    r[M5] = r[M5] - ib[M5];
                    r[M10] = r[M10] - ib[M10];
                    r[m] = 0;
                    l[m] = 1;
                    time = time + timeh;
                    timeh = 0;
                    ag = 0;
                    times ++;
                    BtS();
                    break;
                :: else ->
                    printf("Something went wrong")



                od;
            fi;
            printf("Погрузка завершена")
            print_status();

        // если решение найдено:
        :: ggwp ->
            printf("Решено! Ходв потрачено: %d \n",times);
            assert(0);
            break;

        :: else ->
            printf("Поздравляем! Вы сломали прогу!"); //Братаны, это никогда не случтся! Слышите? НИ-КО-ГДА!
            assert(0);
            break;

    od;
    
}
