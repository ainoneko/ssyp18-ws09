#define N_1 10
#define N_2 20
#define N_3 30
#define N_4 40
#define N_5 50
#define MAX 60
#define MIN 30
#define BOAT_IS_EMPTY (in_boat[1] + in_boat[2] + in_boat[3] + in_boat[4] + in_boat[5]== 0)
#define BOAT_IS_HEAVY_ENOUGH (in_boat[1] + in_boat[2] + in_boat[3] + in_boat[4] + in_boat[5]>= MIN)
#define BOAT_IS_TOO_HEAVY (in_boat[1] + in_boat[2] + in_boat[3] + in_boat[4] + in_boat[5]> MAX)
#define BOAT_IS_TOO_LIGHT (in_boat[1] + in_boat[2] + in_boat[3] + in_boat[4] + in_boat[5] < MIN)
#define DONE (r[1]==10 && r[2]==20 && r[3]==30 && r[4]==40 && r[5]==50)
#define Boat 0
#define ALL_OK (BOAT_IS_HEAVY_ENOUGH && ! BOAT_IS_TOO_HEAVY )
int r[6]=0
int l[6]={1,10,20,30,40,50}
int in_boat[6]
inline printStatus(){
        printf("Лодка слева:%d, справа:%d \n", l[Boat], r[Boat]);
     printf ("в лодке 1 %d, 2 %d, 3 %d, 4 %d,5 %d \n",in_boat[1],in_boat[2],in_boat[3],in_boat[4],in_boat[5])        
       printf ("слева 1 %d, 2 %d, 3 %d, 4 %d,5 %d \n",l[1],l[2],l[3],l[4],l[5])        
       printf ("справа 1 %d, 2 %d, 3 %d, 4 %d,5 %d \n",r[1],r[2],r[3],r[4],r[5])        
  

}
init
{
do
 :: ! DONE ->      
        int here[6];
        byte i;
        i=1
        printf("NOT DONE\n")
        printStatus()
        do
                :: i>5; break
                :: else;
                        in_boat [i]=0
                        if 
                        :: r[Boat] == 0;here [i]=l[i]
                        :: else;
                        here [i]=r[i]
                        fi
                        i++
                od
        do
            :: here [1]>0 && in_boat[1]==0; in_boat [1] = here [1]
            :: in_boat [1]>0 ; in_boat[1]=0
            :: here [2]>0 && in_boat[2]==0; in_boat [2] = here [2]
            :: in_boat [2]>0 ; in_boat[2]=0
            :: here [3]>0 && in_boat[3]==0; in_boat [3] = here [3]
            :: in_boat [3]>0 ; in_boat[3]=0
            :: here [4]>0 && in_boat[4]==0; in_boat [4] = here [4]
            :: in_boat [4]>0 ; in_boat[4]=0
            :: here [5]>0 && in_boat[5]==0; in_boat [5] = here [5]
            :: in_boat [5]>0 ; in_boat[5]=0
            :: ALL_OK -> break
       od;
       printf("Выбрали людей для поездки\n");
//        printf ("в лодке 1 %d, 2 %d, 3 %d, 4 %d,5 %d \n",in_boat[1],in_boat[2],in_boat[3],in_boat[4],in_boat[5])        
//        printf ("слева 1 %d, 2 %d, 3 %d, 4 %d,5 %d \n",l[1],l[2],l[3],l[4],l[5])        
//        printf ("справа 1 %d, 2 %d, 3 %d, 4 %d,5 %d \n",r[1],r[2],r[3],r[4],r[5])        
        printStatus()
       i=1
       do
          :: i>5; break
          :: else;
           if 
             :: r[Boat] == 0;r[i]=r[i]+in_boat[i];l[i]=l[i]-in_boat[i]
             :: else;
               r[i]=r[i]-in_boat[i];l[i]=l[i]+in_boat[i]
           fi
          in_boat [i]=0
          i++
       od
        r[Boat]=1-r[Boat]
        l[Boat]=1-l[Boat]
       printStatus()	
       :: DONE -> printf("Решено!\n"); assert(0); break;
       :: else -> printf("ЧТО?!\n"); assert(0); break; 
        od;    
}
