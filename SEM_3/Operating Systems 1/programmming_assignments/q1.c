#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>
int main(){
	printf("--------- \n");
	printf("CS18BTECH11039_prg1.c");
	printf("\n --------- \n");
	pid_t pid1,pid2;// pid's for child 1 and 2 respectively

	pid1 = fork();//creating the first child
	if(pid1==0){//child 1
		while(1){
			printf("hey from (child 1)process # : %d \n",getpid());
			sleep(1);
			printf("hey from (child 1)process # : %d \n",getpid());
		}
	} else { // back in the parent
		pid2 = fork();//creating the second child
		if(pid2==0){//in the second child now 
			printf("hey from (child 2)process # : %d \n",getpid());
			sleep(10);
			printf("hey from (child 2)process # : %d \n",getpid());
			kill(pid1,SIGKILL);
			printf("hey from (child 2)process # : %d \n",getpid());
			sleep;(10);
			printf("hey from (child 2)process # : %d \n",getpid());
		}else{//back in the parent again
		        printf("hey from (parent)process # : %d \n",getpid());	
			waitpid(pid1,NULL,0);
			printf("hey from (parent)process # : %d \n",getpid());
			waitpid(pid2,NULL,0);
			printf("hey from (parent)process # : %d \n",getpid());
			return 0;
		}
	}
}

