#include <iostream>
#include <functional>
using namespace std;

int main(){
	int n=10;
	const function <int(int&&,int&&)> fib = [&n,&fib](int&& i,int&& ans){
		if((i++)==n) return ans;
		return fib(move(i),ans*i);//tail call optimized
	};
	cout<<fib(0,1)<<endl;
	return 0;
}
