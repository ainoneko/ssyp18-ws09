#define N_Lion 3
#define N_Terrorist 3
#define BOAT_CAPACITY 2

#define BOAT_IS_EMPTY (in_BOAT[Lion] + in_BOAT[Terrorist] == 0)


mtype = {Lion,Terrorist,BOAT} // Lion == 3 , Terrorist == 2 , BOAT == 1

#define Bad_Killer ( \
    ((r[Lion] > 0) && (r[Lion] < r[Terrorist])) \
    || \
    ((l[Lion] > 0) && (l[Lion] < l[Terrorist])) \
)



mtype prev_dr   = 0;
mtype prev_pass = 0;

/* Global array for positions, initially = 0 */

 int r[4]
int l[4]
int in_BOAT [4]
/* mtypes are assigned from 1, array are indexed from 0, so the r[0] is not used */

inline checkConfing(){

    //assert(in_BOAT[Lion]);
    //assert(in_BOAT[Terrorist]);

    assert(l[Lion] >= 0);
    assert(l[Terrorist] >= 0);

    assert(r[Lion] >= 0);
    assert(r[Terrorist] >= 0);

    assert(l[Lion] <= N_Lion);
    assert(l[Terrorist] <= N_Terrorist);
    
    assert(r[Lion] <= N_Lion);
    assert(r[Terrorist] <= N_Terrorist);
    
    assert(r[Lion] <= N_Lion)
    assert(r[Terrorist] <= N_Terrorist)

    assert(in_BOAT[Lion] + r[Lion] + l[Lion] == N_Lion);
    assert(in_BOAT[Terrorist] + r[Terrorist] + l[Terrorist] == N_Terrorist)
   
    // assert(in_BOAT[Terrorist]);
}

inline printStatus(){
    //printf"(Лодка с (%d л. и %d т.) у берега %d(step_load: %d) на левом берегу: Львов %d, Террористов %d,Правый берег: Львов %d, Террористов %d). /n", 
// printf ("Лодка с (%d л. и %d т.) у берега %d : на левом : л.%d, п.%d, на правом : л.%d, т.%d.\n",
//     in_BOAT[Lion],
//     in_BOAT[Terrorist],
//     r[BOAT],
//     l[Lion],
//     l[Terrorist],
//     r[Lion],
//     r[Terrorist]
//     ) ;
//     checkConfing();

//printf ("(%d %d) %c (%d, %d) %c (%d, %d).\n",
printf ("(%d %d)%c(%d, %d)%c(%d, %d).\n",
    l[Lion],
    l[Terrorist],
    (r[BOAT] == 0 -> '*' : ' '),
    in_BOAT[Lion],
    in_BOAT[Terrorist],
    (r[BOAT] == 0 -> ' ' : '*'),
    r[Lion],
    r[Terrorist]
    ) ;
    checkConfing();

}                                 

                                 

inline printMove()
{   
    if 
        :: r[BOAT] == 0 ->
             printf("На тот берег едут Львы : %d , Террористы : %d./n", in_BOAT[Lion], in_BOAT[Terrorist]);
        :: else ->   
            printf("Обратно едут Львов : %d , Террористов : %d./n", in_BOAT[Lion], in_BOAT[Terrorist]);
    fi;
}

inline setHereVars()
{
    if
        //Лодка у правого берега
        ::r[BOAT] == 1 ->
        li_here = r[Lion];
        te_here = r[Terrorist];
        :: else -> 
        li_here = l[Lion];
        te_here = l[Terrorist];
    fi
}
inline updateBOAT()
{
// printf("in_BOAT[Lion]: %d \n", in_BOAT[Lion]);
printf("Погрузка в лодку: до:   "); printStatus();
//in_BOAT[Lion] += li_move
//in_BOAT[Lion] += te_move
in_BOAT[Lion] = in_BOAT[Lion] + li_move;
in_BOAT[Terrorist] = in_BOAT[Terrorist] + te_move;
// printStatus();

// printf("l[BOAT]: %d, r[BOAT]: %d\n", l[BOAT], r[BOAT]);

// printf(" В лодку загрузились: (%d, %d) --> \n", li_move, te_move);
 printf("Загрузились в лодку на берегу %d:  Львов: %d, Террористов: %d -->\n", 
                        r[BOAT], li_move, te_move); 
                
//Bellow is MINUS ... , sinse + is for the BOAT
if
    //Лодка у левого берега
    :: r[BOAT] == 0 ->
        l[Lion] = l[Lion] - li_move
        l[Terrorist] = l[Terrorist] - te_move
    //Лодка у правого берега
        // :: l[BOAT] == 0 ->
        :: else ->
        r[Lion] = r[Lion] - li_move
        r[Terrorist] = r[Terrorist] - te_move
        // :: else ->
        //     printf("КАРАМБААААААА!!!")
        //     assert(0);
    fi;

     printf("Погрузка в лодку: после:"); printStatus();
}

inline move()
{
    printStatus()
    
    // printMove(li_move, te_move, r[BOAT]);
    printMove()

    //update_r)(li_move, te_move);

    //printf("update_r BOAT: %d Львов, %d Террористов: %d.\n", r_BOAT li_move, te_move);
    //printf(update_r before:BOAT: %d  Львов: %d, Террористы: %d.\n", r[BOAT], r[Lion], r[Terrorist]);)
    //printStatus();

    printStatus()
    // printf("update *_in_BOAT\n");
    
//    assert(in_BOAT[Lion] >= 0);
//    assert(in_BOAT[Terrorist] >= 0);

//   r[BOAT] = 1 - r[BOAT];
  
  	// printf("update_r after: BOAT: %d Львов: %d, Террористов: %d.\n", r[BOAT], r[Lion], r[Terrorist]); 



    if          
    :: Bad_Killer ->  
        /* FAIL */
        printf("Bad_Killer");
        assert(0);
    :: else ->          
        skip;
    fi;
}



init {

    local byte li_here    = 0; 
    local byte te_here    = 0; 

    local short li_move    = 0;  // May be negative!
    local short te_move    = 0;  // May be negative!

    in_BOAT[Lion]  = 0; 
    in_BOAT[Terrorist]    = 0; 

    l[Lion]  = N_Lion; 
    l[Terrorist]  = N_Terrorist; 

    r[BOAT] = 0;
    // l[BOAT] = 1;

    printStatus();
    /* Run */    
    do
		

        // !!!!!! STEP load - move_BOAT - step unload
     // Пока не достигнута цель
	 #define DONE (r[Lion] == N_Lion && r[Terrorist] == N_Terrorist)
     :: ! DONE ->
           
            // printStatus(); 
            setHereVars();
			// printf("here BOAT: %d миссионеров: %d, каннибалов: %d.\n", r[BOAT], mi_here, ca_here); 
            // printStatus(); 
		
            // printf("HERE VARS: li: %d, te: %d\n", li_here, te_here);
            /* Choose 'random' numbers if it is here */
            li_move = 0;
            te_move = 0;

                // Загружаем пассажиров
                do
                   // --  *_in_BOAT <= *_here ;;  *_here stays unchanged here
                   // *_in_move <= *_here ;;  *_here stays unchanged here
                   // #define ONE_MORE_FITS (in_BOAT[Lion] + li_move + in_BOAT[Terrorist] +te_move < BOAT_CAPACITY)
                   // Можно ли посадить в лодку еще одного террориста?
                   //  ONE_MORE_FITS :::: (in_BOAT[Lion] + li_move + in_BOAT[Terrorist] + te_move < BOAT_CAPACITY)

                    // :: ONE_MORE_FITS && (te_move < te_here) 
                    
                    // Change only in range, pospone checking to exit clauses !
                    :: li_move < BOAT_CAPACITY -> li_move++; // printf("Adding one Lion. Now planned change to BOAT is li: %d, te: %d.\n",  li_move, te_move); 
                    :: li_move > -BOAT_CAPACITY -> li_move--; // printf("Removing one Lion. Now planned change to BOAT is li: %d, te: %d.\n",  li_move, te_move); 
                    :: te_move < BOAT_CAPACITY -> te_move++; // printf("Adding one Terrorist. Now planned change to BOAT is li: %d, te: %d.\n",  li_move, te_move); 
                    :: te_move > -BOAT_CAPACITY -> te_move--; // printf("Removing one Terrorist. Now planned change to BOAT is li: %d, te: %d.\n",  li_move, te_move); 

                    // Exit OK:
                    ::  // BOAT
                        (in_BOAT[Lion] + li_move <= N_Lion) && 
                        (in_BOAT[Terrorist] + te_move <= N_Terrorist) && 
                        (in_BOAT[Lion] + li_move >= 0) && 
                        (in_BOAT[Terrorist] + te_move >= 0) && 
                        (in_BOAT[Lion] + li_move + in_BOAT[Terrorist] + te_move <= BOAT_CAPACITY) && 

                        // Non-negative at the river banks
                        (li_here - li_move >= 0) && 
                        (te_here - te_move >= 0) && 

                        // Kill?
                        (
                            (li_here - li_move == 0) ||
                            (te_here - te_move == 0) ||
                            (li_here - li_move) >= (te_here - te_move)
                        ) &&
                        // Anyone moved!!
                        ((te_move != 0)  || (li_move != 0)) &&
                        // Boat is not empty
                        // (in_BOAT[Lion] + li_move + in_BOAT[Terrorist] + te_move > 0)  
                        // Only terrorists can drive
                        ((in_BOAT[Terrorist] + te_move > 0) ||
                          (r[BOAT] == 1) && 
                          (r[Lion] - li_move == N_Lion) && 
                          (r[Terrorist] - te_move == N_Terrorist)
                        )

                        -> 
                        // printf("move OK? Now planned change to BOAT is li: %d, te: %d.\n", li_move, te_move); 
                        // printf("***33: %d", in_BOAT[Lion] + li_move + in_BOAT[Terrorist] + te_move);
                        break;
                    :: else
                        ->
                        printf("SMTH WENT WRONG!\n"); 
                od;
                // printf("Загрузились в лодку на берегу %d:  Львов: %d, Террористов: %d.\n", 
                        // r[BOAT], li_move, te_move); 
                
                updateBOAT();
                
                // printStatus(); 

                //in_BOAT[Lion] += li_move


                // move(in_BOAT[Lion], in_BOAT[Terrorist]);

                // move();
                // 
                printf("Перемещение лодки\n");
                printStatus(); 
                r[BOAT] = 1 - r[BOAT];
                printf("-->\n");
                // l[BOAT] = 1 - l[BOAT];
                printStatus(); 

        // printf("DONE == %d\n", DONE);
       :: DONE -> printf("Решено!\n"); assert(0); break;
       :: else -> printf("Странно...\n"); assert(0); break; /* Should never happen! */ 
    od;    
}
