/*
 * Program: Speedup calculation of matrix multiplication with
 *          multi-processing and multi-threading.
 * Author: Raj Patil 
 * Roll# : CS18BTECH11039 
 */

#include <stdlib.h> /* for exit, atoi, rand */
#include <stdio.h>  /* for firintf */
#include <errno.h>  /* for error code eg. E2BIG */
#include <getopt.h> /* for getopt */
#include <assert.h> /* for assert */
#include <stdbool.h> /* using a boolean somewhere*/
#include <pthread.h> /* threading api */
#include <sys/shm.h> /* for handling shared memory in multiprocess */
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <semaphore.h>
#include <sys/time.h>

#define Nthreads 8
#define Nprocs 8

struct Args{// a store of the common args for cleaner code
	int ar,ac,br,bc;
	int interactive;
};
struct Targs{
	struct Args args;
	int *A,*B,*C;
	long long int Nele;
	int temp_index;
};

//struct timeval being used from sys/time.h
long long
time_diff_us(struct timeval start,struct timeval end){
	//not considering carryovers right now
	//correctness dependent on the arguments being passed
	long long time_diff;
	time_diff = end.tv_sec - start.tv_sec;
	time_diff = time_diff*1000000 + end.tv_usec - start.tv_usec;
	return time_diff;
}

struct Targs targs;
// a set of global variables when working with mutliple threads

sem_t t_mutex;//mutex for threads
sem_t p_mutex;//mutex for processes

long long int t_step;
int nt;//number of threads to be dispatched
long int* threads=NULL;
volatile int t_number;//number of threads dispatched; usage of volatile explained in report
long long int ix,iy;//indexes of C within which a thread will operate
/*
 * Forward declarations
 */

//existing subroutines
void
usage(int argc,
      char *argv[]);

void
input_matrix(int *mat,
	     int nrows,
	     int ncols);

void
output_matrix(int *mat,
	      int nrows,
	      int ncols);

void
init_matrix(int* A,
	    int* B,
	    struct Args args);

unsigned long long
single_thread_mm(int* A,
		 int* B,
		 struct Args args);

unsigned long long
multi_thread_mm(int* A,
		int* B,
		struct Args args);

unsigned long long
multi_process_mm(struct Args args);

//created subroutines

void*
job(void* jargs);//job function(in mutlithreading) to calculate elements indexed from i to j

void
proc_job(int* A,
	 int*B,
	 int* C,
	 long long int i,
	 long long int j,
	 struct Args args,
	 volatile int* go_flag);
//analogous to job from processes

int main(int argc,
	 char *argv[])
{
	sem_destroy(&t_mutex);
	sem_destroy(&p_mutex);
	int arows, acols, brows, bcols;
	char interactive = 0;
	int c;
	/* Loop through each option (and its's arguments) and populate variables */
	while (1) {
		int this_option_optind = optind ? optind : 1;
		int option_index = 0;
		static struct option long_options[] = {
			{"help",	no_argument,		0, 'h'},
			{"ar",		required_argument,	0, '1'},
			{"ac",		required_argument,	0, '2'},
			{"br",		required_argument,	0, '3'},
			{"bc",		required_argument,	0, '4'},
			{"interactive",	no_argument,		0, '5'},
			{0,		0,			0,  0 }
		};

		c = getopt_long(argc, argv, "h1:2:3:4:5", long_options, &option_index);
		if (c == -1)
			break;

		switch (c) {
		case 0:
			fprintf(stdout, "option %s", long_options[option_index].name);
			if (optarg)
				fprintf(stdout, " with arg %s", optarg);
				fprintf(stdout, "\n");
			break;

		case '1':
			arows = atoi(optarg);
			break;

		case '2':
			acols = atoi(optarg);
			break;

		case '3':
			brows = atoi(optarg);
			break;

		case '4':
			bcols = atoi(optarg);
			break;

		case '5':
			interactive = 1;
			break;

		case 'h':
		case '?':
			usage(argc, argv);

		default:
			fprintf(stdout, "?? getopt returned character code 0%o ??\n", c);
			usage(argc, argv);
		}
	}
	if (optind != argc) {
		fprintf(stderr, "Unexpected arguments\n");
		usage(argc, argv);
	}

	/* My code */
	//initializing args
	sem_init(&t_mutex,0,1);
	sem_init(&p_mutex,1,1);
	int* A;
	int* B;
	struct Args args =  {arows,acols,brows,bcols,interactive};
	if (acols!=brows) {
		fprintf(stderr,"incompatible matrices\n");
		return 1;
	}
	unsigned long long time_single, time_multi_process, time_multi_thread;
	A = (int*)malloc(sizeof(int)*args.ar*args.ac);
	B = (int*)malloc(sizeof(int)*args.br*args.bc);
	time_single = single_thread_mm(A,B,args);
	time_multi_thread = multi_thread_mm(A,B,args);
	free(A);
	free(B);
	// shifting operations to shared memory
	time_multi_process = multi_process_mm(args);

	sem_destroy(&t_mutex);
	sem_destroy(&p_mutex);

	/* TODO */

	fprintf(stdout, "Time taken for single threaded: %llu us\n",
			time_single);
	fprintf(stdout, "Time taken for multi process: %llu us\n",
			time_multi_process);
	fprintf(stdout, "Time taken for multi threaded: %llu us\n",
			time_multi_thread);
	fprintf(stdout, "Speedup for multi process : %4.2f x\n",
			(double)time_single/time_multi_process);
	fprintf(stdout, "Speedup for multi threaded : %4.2f x\n",
			(double)time_single/time_multi_thread);

	exit(EXIT_SUCCESS);
}

/*
 * Show usage of the program
 */
void
usage(int argc, char *argv[])
{
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "%s --ar <rows_in_A>  --ac <cols_in_A>"
			" --br <rows_in_B>  --bc <cols_in_B>"
			" [--interactive]",
			argv[0]);
	exit(EXIT_FAILURE);
}

/*
 * Input a given 2D matrix
 */
void
input_matrix(int *mat, int rows, int cols)
{
	for (int i=0; i<rows; i++) {
		for (int j=0; j<cols; j++) {
			fscanf(stdin, "%d",mat + cols*i + j) ;
		}
	}
}

/*
 * Output a given 2D matrix
 */
void
output_matrix( int *mat, int rows, int cols)
{
	for (int i=0; i<rows; i++) {
		for (int j=0; j<cols; j++) {
			fprintf(stdout, "%d ", *(mat + cols*i + j));
		}
		fprintf(stdout, "\n");
	}
}
//
//initializing A and B
//
void init_matrix(int* A,int* B,struct Args args){
	if (args.interactive==1){
		fprintf(stdout,"Enter A:\n");
		input_matrix(A,args.ar,args.ac);
		fprintf(stdout,"Enter B:\n");
		input_matrix(B,args.br,args.bc);
	}
	else {
		//initialize using random numbers
		for(int i=0;i<args.ar;i++){
			for(int j=0;j<args.ac;j++){
				*(A + i*args.ac + j) = rand();
			}
		}
		for(int i=0;i<args.br;i++){
			for(int j=0;j<args.bc;j++){
				*(B + i*args.bc + j) = rand();
			}
		}
	}
}
//
//Matrix multiplication
//

int ele_ij(int i,int j,int* A,int* B,struct Args args){
	int sum=0;
	for(int k=0;k<args.ac;k++){
		sum += *(A + args.ac*i + k)*(*(B + args.bc*k + j));
	}
	return sum;
}

unsigned long long single_thread_mm(int* A,int* B,struct Args args){
	struct timeval start,end;
	init_matrix(A,B,args);
	int* C = (int*)malloc(sizeof(int)*args.ar*args.bc);
	// C will be of size args.ar*args.bc
	gettimeofday(&start,NULL);
	for(int i=0;i<args.ar;i++){
		for(int j=0;j<args.bc;j++){
			*(C+args.bc*i + j) = ele_ij(i,j,A,B,args);
		}
	}
	gettimeofday(&end,NULL);
	if (args.interactive==1){
		fprintf(stdout,"Result:\n");
		output_matrix(C,args.ar,args.bc);
	}
	free(C);
	long long time_diff = time_diff_us(start,end);
	return time_diff;
}

unsigned long long multi_thread_mm(int* A,int* B,struct Args args){
	struct timeval start,end;
	init_matrix(A,B,args);
	int* C;
	C =(int*)malloc(sizeof(int)*args.ar*args.bc);

	nt = (args.ar*args.bc<Nthreads)?args.ar*args.bc:Nthreads;
	threads = (long int*)malloc(sizeof(long int)*nt);
	t_number=0;
	t_step = ((1ll)*args.ar*args.bc)/nt;
	targs.Nele = (1ll)*args.ar*args.bc;
	targs.args = args;
	targs.A = A;
	targs.B = B;
	targs.C = C;
	//until the last one hasn't passed a certain point of execution
	//see reports for why there is the need for this
	//dispatching threads;
	for(int i=0;i<nt;i++){
		sem_wait(&t_mutex);//explained in report
		targs.temp_index=i;
		pthread_create(&threads[i],NULL,job,(void*)&targs);
		//t_ready is set in the job function
	}
	while (t_number<nt)
		continue;
	gettimeofday(&start,NULL);
	for(int i=0;i<nt;i++){
		pthread_join(threads[i],NULL);
	}
	gettimeofday(&end,NULL);
	if (args.interactive==1){
		fprintf(stdout,"Result:\n");
		output_matrix(targs.C,args.ar,args.bc);
	}
	free(C);
	free(threads);
	long long time_diff = time_diff_us(start,end);
	return time_diff;
}

unsigned long long multi_process_mm(struct Args args){
	//taking in A_ and B_ in case of interactive mode
	long long int  Nele = (1ull * args.ar*args.bc);
	int   np  = (Nprocs>Nele ? Nele:Nprocs);

	// preparing shared memory segments
	int *A,*B,*C;
	volatile int* process_count;
	int* process_ids;
	int* n_procs;
	struct timeval *start,*end;
	volatile int* go_flag;
	int* starter_process;
	int A_seg_id = shmget(IPC_PRIVATE,sizeof(int)*args.ar*args.ac,IPC_CREAT|0666);
	int B_seg_id = shmget(IPC_PRIVATE,sizeof(int)*args.br*args.bc,IPC_CREAT|0666);
	int C_seg_id = shmget(IPC_PRIVATE,sizeof(int)*args.ar*args.bc,IPC_CREAT|0666);
	int process_ids_seg_id = shmget(IPC_PRIVATE,sizeof(int)*np,IPC_CREAT|0666);
	int process_count_seg_id = shmget(IPC_PRIVATE,sizeof(int),IPC_CREAT|0666);
	int n_procs_seg_id = shmget(IPC_PRIVATE,sizeof(int),IPC_CREAT|0666);
	int start_seg_id = shmget(IPC_PRIVATE,sizeof(struct timeval),IPC_CREAT|0666);
	int end_seg_id = shmget(IPC_PRIVATE,sizeof(struct timeval),IPC_CREAT|0666);
	int go_flag_seg_id = shmget(IPC_PRIVATE,sizeof(int),IPC_CREAT|0666);
	int starter_process_seg_id = shmget(IPC_PRIVATE,sizeof(int),IPC_CREAT|0666);

	A = (int*)shmat(A_seg_id,NULL,0);
	B = (int*)shmat(B_seg_id,NULL,0);
	C = (int*)shmat(C_seg_id,NULL,0);

	process_count = (volatile int*)shmat(process_count_seg_id,NULL,0);
	process_ids = (int*)shmat(process_ids_seg_id,NULL,0);
	n_procs = (int*)shmat(n_procs_seg_id,NULL,0);
	start = (struct timeval*)shmat(start_seg_id,NULL,0);
	end = (struct timeval*)shmat(end_seg_id,NULL,0);
	go_flag = (volatile int*)shmat(go_flag_seg_id,NULL,0);
	starter_process = (int*)shmat(starter_process_seg_id,NULL,0);
	init_matrix(A,B,args);
	long long int step = ((1ll)*args.ar*args.bc)/np;
	*n_procs =np;
	*process_count = 0;
	*go_flag=0;

	int itr=0;
	int cpid;
	long long int x,y;
	//creating a starter process: coordinates timer
	fflush(stdout);//discussed in report
	cpid = fork();
	if (cpid==0){
		while (*process_count<*n_procs)
			continue;
		gettimeofday(start,NULL);
		*go_flag=1;
		exit(0);
	}
	while (itr<np){
		(*process_count)++;
		fflush(stdout);
		cpid=fork();
		if (cpid==0){
			//sem_wait(&p_mutex);
			x = itr*step;
			if (itr==np-1)
				y = Nele -1;
			else
				y = x+ step -1;
			//sem_post(&p_mutex);
			//waiting inside proc_job for all processes to be ready
			proc_job(A,B,C,x,y,args,go_flag);
			exit(0);
		}
		else if (cpid!=0){
			process_ids[itr] = cpid;
			itr++;
			continue;
		}
	}
	for(int i=0;i<np;i++){
		waitpid(process_ids[i],NULL,0);
	}
	gettimeofday(end,NULL);
	if (args.interactive==1){
		fprintf(stdout,"Result:\n");
		output_matrix(C,args.ar,args.bc);
	}
	long long time_diff = time_diff_us(*start,*end);

	shmdt(A);
	shmdt(B);
	shmdt(C);
	shmdt((const void*)process_count);//explained in report
	shmdt(process_ids);
	shmdt(n_procs);
	shmdt(start);
	shmdt(end);
	shmdt((const void*)go_flag);//explained in report

	shmctl(A_seg_id,IPC_RMID,NULL);
	shmctl(B_seg_id,IPC_RMID,NULL);
	shmctl(C_seg_id,IPC_RMID,NULL);
	shmctl(process_count_seg_id,IPC_RMID,NULL);
	shmctl(process_ids_seg_id,IPC_RMID,NULL);
	shmctl(n_procs_seg_id,IPC_RMID,NULL);
	shmctl(start_seg_id,IPC_RMID,NULL);
	shmctl(end_seg_id,IPC_RMID,NULL);
	shmctl(go_flag_seg_id,IPC_RMID,NULL);

	return time_diff;
}
/*
 * Subroutine definitions
 */
void* job(void* temp_targs){
	struct Targs targs = *(struct Targs*)temp_targs;
	t_number++;
	sem_post(&t_mutex);
	long long int x,y;
	x = targs.temp_index*t_step;
	if (targs.temp_index==nt-1){
		y = targs.Nele-1;
	}
	else{
		y = x+t_step-1;
	}
	while (t_number<nt)
		continue;
	int i,j;
	for(long long itr=x;itr<=y;itr++){
		i = itr/targs.args.bc;
		j = itr%targs.args.bc;
		*(targs.C+targs.args.bc*i+j)=ele_ij(i,j,targs.A,targs.B,targs.args);
	}
}


void proc_job(int* A,
	      int*B,
	      int*C,
	      long long int i,
	      long long int j,
	      struct Args args,
	      volatile int* go_flag){
	int x,y;
	while (!*go_flag)
		continue;
	for(long long int itr=i;itr<=j;itr++){
		x = itr/args.bc;
		y = itr%args.bc;
		*(C+args.bc*x+y) = ele_ij(x,y,A,B,args);
	}
}
