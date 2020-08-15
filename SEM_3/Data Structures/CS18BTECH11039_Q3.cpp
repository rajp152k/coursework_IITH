//RAJ PATIL
//CS18BTECH11039
//QUESTION 3
#include <iostream>
#include <set>
#include <vector>
#include <queue>
#include <string>
#include <sstream>

using namespace std;

struct Edge{// for queing in input
	pair<int,int> incidence;
   	int weight;	
};

struct Graph{
	set <int> V;//vertices
	vector <vector<int>> Amat;//adjacency matrix
	//using vector to avoid manual dynamic memory allocation
};

void printGraph(struct Graph& G){
	cout<<endl<<"====xxx====xxx====xxx===="<<endl;
	cout<<"ADJACENCY MATRIX"<<endl;
	cout<<"|V|:";
	for(auto i=0;i<G.Amat.size();i++) cout<<i<<" ";
	cout<<endl;
	cout<<"  -";
	for(auto i=0;i<G.Amat.size();i++) cout<<"--";
	cout<<endl;
	for(auto i=0;i<G.Amat.size();i++){
		cout<<i<<" | ";
		for(auto j=0;j<G.Amat.size();j++){
			cout<<G.Amat[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<"====xxx====xxx====xxx===="<<endl;
	cout<<" set of vertices " <<endl;
	for(auto i=G.V.begin();i!=G.V.end();i++){
		cout<<*i<< " " ;
	}
	cout<<endl<<"====xxx====xxx====xxx===="<<endl;
}
//basic procedures 
vector <int>  neighbors(struct Graph& G,int v){
	vector <int> buffer;
	for(auto i=0;i<G.Amat.size();i++){
		if(G.Amat[v][i]!=0) buffer.push_back(i);
	}
	return buffer;
}

set <int> vertices(struct Graph& G){
	return G.V;
}

int edgeWeight(struct Graph& G,int v1,int v2){
	return G.Amat[v1][v2];
}

bool containsVertex(struct Graph& G,int v){
	return G.V.count(v);
}

bool containsEdge(struct Graph& G,int v1,int v2){
	if(G.Amat[v1][v2]!=0) return true;
	else return false;
}

int main(){
	queue <struct Edge*> inputQ;	
	struct Graph G;
	string str;
	char X;
	int Max_vertex=0;
	int V1,V2,wt;
	struct Edge* buffer;
	int x,i;
	i=0;
	getline(cin,str);
	stringstream(str)>>x;
	//IMPORTANT NOTE:
	//TWO WAYS TO BREAK THE INPUT STREAM:
	//	- 2 consecutive empty lines
	//	- iterator exceeds initial number of vertices provided
	while(1){
		getline(cin,str);
		if(str.length()==0){
			getline(cin,str);
			if(str.length()==0) break;
			continue;
		}//continues in case of a single new line as input 	
		//breaks out of the input stream for 2 new lines
		stringstream(str)>>X>>V1>>V2>>wt;
		buffer = new struct Edge; //cleanup done when updating matrix
	       	buffer->incidence = make_pair(V1,V2);
		G.V.emplace(V1);
		G.V.emplace(V2);
		if(Max_vertex<max(V1,V2)) Max_vertex = max(V1,V2);
		buffer->weight = wt;	
		inputQ.push(buffer);
		i++;
		if(i==x) break;
	}
	G.Amat.resize(Max_vertex+1);
	for(auto i=0;i<Max_vertex+1;i++){
		G.Amat[i].resize(Max_vertex+1);
	}
	while(!inputQ.empty()){
		buffer = inputQ.front();
		inputQ.pop();
		G.Amat[buffer->incidence.first][buffer->incidence.second] = buffer->weight;
		delete buffer;
	}
	buffer = NULL;//eliminating dangling pointer after last iteration.

	//because only implementation is asked 
	//printing out the Adjacency matrix and the set of Vertices
	printGraph(G);
	return 0;
}
