//  status: works, taks 0.4 sec

#define N_Missionary 3
#define N_Cannibal 3
#define BOAT_CAPACITY 2

#define BOAT_IS_EMPTY (in_boat[Missionary] + in_boat[Cannibal] == 0)

#define OTHER_BANK (1 - r[Boat])


  // +1 when step_load == 1
  // -1 when step_load == 0
#define MOVE_SIGN (step_load * 2 - 1)


// #define ONE_MORE_FITS (in_boat[Missionary] + in_boat[Cannibal] < BOAT_CAPACITY)
#define ONE_MORE_FITS (in_boat[Missionary] + mi_move + in_boat[Cannibal] + ca_move < BOAT_CAPACITY)

// -- Безопасно, если добавит 
#define SAFE_TO_LOAD (in_boat[Missionary] + in_boat[Cannibal] == 0)

mtype = {Missionary, Cannibal, Boat}; // Missionary == 3 , Cannibal == 2 , Boat == 1
 
#define DONE ((r[Missionary] == N_Missionary) && (r[Cannibal] == N_Cannibal))

#define Bad_Dinner ( \
    ((r[Missionary] > 0) && (r[Missionary] < r[Cannibal])) \
    || \
    ((l[Missionary] > 0) && (l[Missionary] < l[Cannibal])) \
)



mtype prev_dr   = 0;
mtype prev_pass = 0;

/* Global array for positions, initially = 0 */
int r[4];  /*  3+1 */
int l[4];  /*  3+1 */
int in_boat[4];
/* mtypes are assigned from 1, array are indexed from 0, so the r[0] is not used */

inline checkConfig(){
    assert(in_boat[Missionary] <= N_Missionary);
    assert(in_boat[Cannibal]   <= N_Cannibal);

    assert(l[Missionary] <= N_Missionary);
    assert(l[Cannibal]   <= N_Cannibal);
    
    assert(r[Missionary] <= N_Missionary);
    assert(r[Cannibal]   <= N_Cannibal);

    assert(in_boat[Missionary] + r[Missionary] + l[Missionary] == N_Missionary);
    assert(in_boat[Cannibal]   + r[Cannibal]   + l[Cannibal] == N_Cannibal);

}

inline printStatus(){
    
    // printf("Лодка c (%d м. и %d к.) у берега %d (step_load: %d):  левый берег: миссионеров %d, каннибалов %d, правый берег: миссионеров %d, каннибалов %d.\n", 
    
    printf("Лодка c (%d м. и %d к.) у берега %d (step_load: %d):  левый: м. %d, к. %d, правый: м. %d, к. %d.\n", 
                        in_boat[Missionary],
                        in_boat[Cannibal], 
                        r[Boat],
                        step_load, 
                        l[Missionary],
                        l[Cannibal],
                        r[Missionary],
                        r[Cannibal]
    );
    checkConfig();
}

inline printMove()
{
    if
        :: r[Boat] == 0 ->
                printf("На тот берег едут миссионеров: %d, каннибалов: %d.\n", in_boat[Missionary], in_boat[Cannibal]); 
        :: else ->
                printf("Обратно едут миссионеров: %d, каннибалов: %d.\n", in_boat[Missionary], in_boat[Cannibal]); 
    fi;    
}

inline setHereVars(){
    if	
        // Лодка у правого берега
        :: r[Boat] == 1 ->
            mi_here = r[Missionary];
            ca_here = r[Cannibal];
        :: else ->
            mi_here = l[Missionary];
            ca_here = l[Cannibal];
    fi;
}            

inline updateBoat(){

    printf("in_boat[Missionary]: %d \n",  in_boat[Missionary] );
    printf("updateBoat: b4:"); printStatus();

    // in_boat[Missionary] += mi_move;
    // in_boat[Cannibal] += ca_move;
    in_boat[Missionary] = in_boat[Missionary] + mi_move * MOVE_SIGN;
    in_boat[Cannibal] = in_boat[Cannibal] + ca_move * MOVE_SIGN;
    // printStatus();

    // Below is MINUS ... * MOVE_SIGN, since + is for the boat
    if 
        // Лодка у левого берега
        :: r[Boat] == 0 ->
                l[Missionary] = l[Missionary] - mi_move * MOVE_SIGN;
                l[Cannibal]   = l[Cannibal] - ca_move * MOVE_SIGN;
        // Лодка у правого берега
        :: r[Boat] == 1 ->	
                r[Missionary] = r[Missionary] - mi_move * MOVE_SIGN;
                r[Cannibal]   = r[Cannibal] - ca_move * MOVE_SIGN;
        :: else -> 
            printf("Что-то пошло не так: Лодка уплыла совсем");
            assert(0);
    fi;

    printf("updateBoat: af:"); printStatus();
}

inline move()
{
    printStatus();
    // printMove(mi_move, ca_move, r[Boat]);
    printMove();
  
    // update_r(mi_move, ca_move); 

	// printf("update_r boat: %d миссионеров: %d, каннибалов: %d.\n", r[Boat], mi_move, ca_move); 
	// printf("update_r before: boat: %d миссионеров: %d, каннибалов: %d.\n", r[Boat], r[Missionary], r[Cannibal]); 
    // printStatus();

    printStatus();
    // printf("update *_in_boat\n");
    
//    assert(in_boat[Missionary] >= 0);
//    assert(in_boat[Cannibal] >= 0);
   


//   r[Boat] = 1 - r[Boat];
  
  	// printf("update_r after: boat: %d миссионеров: %d, каннибалов: %d.\n", r[Boat], r[Missionary], r[Cannibal]); 



    if          
    :: Bad_Dinner ->  
        /* FAIL */
        printf("Bad_Dinner");
        assert(0);
    :: else ->          
        skip;
    fi;
}



init {

    local byte mi_here    = 0; 
    local byte ca_here    = 0; 

    local short mi_move    = 0;  // May be negative!
    local short ca_move    = 0;  // May be negative!


    local byte step_load = 1;

    in_boat[Missionary]  = 0; 
    in_boat[Cannibal]    = 0; 

    l[Missionary]  = N_Missionary; 
    l[Cannibal]    = N_Cannibal; 


    printStatus();
    /* Run */    
    do
		

        // !!!!!! STEP load - move_boat - step unload
     // Пока не достигнута цель
	 :: ! DONE ->

           
            printf("Loading/Unloading at bank %d\n", r[Boat] ); 
            printStatus(); 
            setHereVars();
			// printf("here boat: %d миссионеров: %d, каннибалов: %d.\n", r[Boat], mi_here, ca_here); 
            printStatus(); 
		
            /* Choose 'random' numbers if it is here */
            mi_move = 0;
            ca_move = 0

                // Загружаем пассажиров
                do
                   // --  *_in_boat <= *_here ;;  *_here stays unchanged here
                   // *_in_move <= *_here ;;  *_here stays unchanged here
                   // #define ONE_MORE_FITS (in_boat[Missionary] + mi_move + in_boat[Cannibal] + ca_move < BOAT_CAPACITY)
                   // Можно ли посадить в лодку еще одного каннибала?
                   //  ONE_MORE_FITS :::: (in_boat[Missionary] + mi_move + in_boat[Cannibal] + ca_move < BOAT_CAPACITY)

                    // :: ONE_MORE_FITS && (ca_move < ca_here) 
                    
                    // Change only in range, pospone checking to exit clauses !
                    :: mi_move < BOAT_CAPACITY -> mi_move++; printf("Adding one missionary. Now planned change to boat is mi: %d, ca: %d.\n",  mi_move, ca_move); 
                    :: mi_move > -BOAT_CAPACITY -> mi_move--;  printf("Removing one missionary. Now planned change to boat is mi: %d, ca: %d.\n",  mi_move, ca_move); 
                    :: ca_move < BOAT_CAPACITY -> ca_move++; printf("Adding one cannibal. Now planned change to boat is mi: %d, ca: %d.\n",  mi_move, ca_move); 
                    :: ca_move > -BOAT_CAPACITY -> ca_move--; printf("Removing one cannibal. Now planned change to boat is mi: %d, ca: %d.\n",  mi_move, ca_move); 

                    // Exit OK:
                    ::  // Boat
                        (in_boat[Missionary] + mi_move <= N_Missionary) && 
                        (in_boat[Cannibal] + ca_move <= N_Cannibal) && 
                        (in_boat[Missionary] + mi_move >= 0) && 
                        (in_boat[Cannibal] + ca_move >= 0) && 
                        (in_boat[Missionary] + mi_move + in_boat[Cannibal] + ca_move <= BOAT_CAPACITY) && 

                        // Non-negative at the river banks
                        (mi_here - mi_move >= 0) && 
                        (ca_here - ca_move >= 0) && 

                        // Eat?
                        (
                            (mi_here - mi_move == 0) ||
                            (ca_here - ca_move == 0) ||
                            (mi_here - mi_move) >= (ca_here - ca_move)
                        ) &&
                        // Anyone moved!!
                        (ca_move != 0)  && (mi_move != 0) 

                        -> 
                        printf("move OK? Now planned change to boat is mi: %d, ca: %d.\n", mi_move, ca_move); 
                        break;
                    :: else
                        ->
                        printf("SMTH WENT WRONG!\n"); 
                od;
                printf("Загрузились в лодку на берегу %d:  миссионеров: %d, каннибалов: %d.\n", 
                        r[Boat], mi_move, ca_move); 
                
                updateBoat();
                
                printStatus(); 

                //in_boat[Missionary] += mi_move


                // move(in_boat[Missionary], in_boat[Cannibal]);

                move();
                // 
                printf("Move boat\n");
                printStatus(); 
                r[Boat] = 1 - r[Boat];
                printStatus(); 

        printf("DONE == %d\n", DONE);
        // printf("DONE: %d\n", ((r[Missionary] == N_Missionary) && (r[Cannibal] == N_Cannibal)));
			
       :: DONE -> printf("Решено!\n"); assert(0); break;
       :: else -> printf("ЧТО?!\n"); assert(0); break; /* Should never happen! */ 
    od;    
}
