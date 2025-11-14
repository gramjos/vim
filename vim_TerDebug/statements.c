#include<stdlib.h>
#include<stdio.h>

int FuncTown(int n){
	printf("FuncTown, this num: %d\n", n);	
	return n+1 ;
}
int main(int argc, char *argv[] ){
	int buffLen =256 ;
	char ins[buffLen]; 
	scanf("%s", ins);
	int val ;
	val = atoi(ins);
	int FTown = FuncTown(val);
	int x ; 
	x = 8888888;
	printf("func town return %d\nthis num: %d\n", x,FTown);	
	return EXIT_SUCCESS ;
}

