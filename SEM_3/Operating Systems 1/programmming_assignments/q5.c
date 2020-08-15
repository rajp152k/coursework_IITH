// Raj Patil
// CS18BTECH11039
// code explained in the accompanying pdf, hence comments are NOT meant to explain everything


#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <time.h>

int main(){
	srand(time(NULL));
	printf("----------");
	printf("\nCS18Btech11039_prg5.c \n");
	printf("----------\n");
	// program to calculate the statistics of C's pseudorandom number generation facility 
	double A[100];
	int i;
	for(i=0;i<100;i++){
		//A[i] = i; //for a test run to verify if the procedure is correct 
		A[i] = rand();	
	}
	
	// going to calculate the mean of the 100 random numbers in 2 processes

	pid_t pid1,pid2;

	double mean;//used in main calculated using pid1 and pid2
	double halfMean;//name holder for the separate exclusive variable of each child process 
	
	int fd[2];// creating a pipe for IPC
	pipe(fd);

	pid1 = fork();
	if(pid1==0){//child1
		close(fd[0]);
		halfMean= A[0];
		for(i=1;i<50;i++)
			halfMean= halfMean*(((double)i)/(i+1)) + ((double)A[i])/(i+1);
		//don't need to create another iterator as this refers to a diffent i
		//not just summing up first and then dividing to avoid overflow issues
		write(fd[1], &halfMean,sizeof(halfMean));
		printf("first halfMean = %lf \n", halfMean);
		close(fd[1]);		
		exit(0);
	} else { //back in parent
		pid2 = fork();
		if(pid2==0){//child 2
			close(fd[0]);
			halfMean = A[50];
			for(i=1;i<50;i++)
				halfMean = halfMean*(((double)i)/(i+1)) + ((double)A[i+50])/(i+1);
		//i goes in the same range but A[i+50] is accessed 
		//don't need to create another iterator as this refers to a diffent i
		//not just summing up first and then dividing to avoid overflow issues
			waitpid(pid1,NULL,0);
			write(fd[1],&halfMean,sizeof(halfMean));
			printf("second HalfMean = %lf \n",halfMean);
			close(fd[1]);
			exit(0);
		} else { // back in parent
			close(fd[1]);
			waitpid(pid1,NULL,0);
			read(fd[0],&halfMean,sizeof(halfMean));	
			mean = halfMean;
			waitpid(pid2,NULL,0);	
			read(fd[0],&halfMean,sizeof(halfMean));
			mean = mean/2 + halfMean/2;
			close(fd[0]);
			printf("mean : %lf \n", mean);
			return 0;
		}
	}
}
