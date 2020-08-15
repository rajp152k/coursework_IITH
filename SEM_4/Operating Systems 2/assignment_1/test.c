#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>


long long time_diff_us(struct timeval start,struct timeval end){
	//not considering carryover for now
	//correctness dependent on arguments	
	long long time_diff;
	time_diff = (end.tv_sec - start.tv_sec)*1000000;
	time_diff+= (end.tv_usec - start.tv_usec);
	return time_diff;
}

long long  timer(){
	struct timeval start,end;
	gettimeofday(&start,NULL);
	usleep(500);
	gettimeofday(&end,NULL);
	return time_diff_us(start,end);
}
int main(){
	printf("calculating time\n");
	printf("time taken %lld\n",timer());
	return 0;
}
