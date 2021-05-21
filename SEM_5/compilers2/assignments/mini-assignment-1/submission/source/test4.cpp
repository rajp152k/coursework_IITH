#include <bits/stdc++.h>
using namespace std;

// code to enumerate all possible subsets of {0,..,n-1}


void compute(const int& n){
	vector<int> chosen;
	vector<vector<int>> collect;
	const function<void(int&&)> backtrack = [&n,&chosen,&collect,&backtrack](int&& state){
		if(state==n)
			collect.emplace_back(chosen);
		else{
			chosen.emplace_back(state);
			backtrack(state+1);
			chosen.pop_back();
			backtrack(state+1);
		}
	};
	backtrack(0);
	auto print_vec = [](const vector<int>& v){
		for(auto x:v)
			cout<<x<<" ";
		cout<<endl;
	};
	auto print_collections = [&collect,&print_vec](){
		for(auto v:collect)
			print_vec(v);
	};
	print_collections();
}

int main(){
	int n=10;
	compute(n);
	return 0;
}
