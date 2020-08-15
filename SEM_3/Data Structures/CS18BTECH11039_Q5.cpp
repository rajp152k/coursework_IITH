//RAJ PATIL
//CS18BTECH11039
//QUESTION 4 
#include <iostream>
#include <vector>
#include <set>
#include <queue>
#include <string>
#include <sstream>

const int INT_MAX = 2147483647 ;
using namespace std;
//struct for Disjoint union datastructure

bool MST_possible = false;// declaring a global variable
//for ease of use in different functions
//so that i don't have to restructure a lot of code

struct Edge{// for queing in input
	pair<int,int> incidence;
   	int weight=0;	
};
struct Graph{
	set <int> V;//vertices
	vector <Edge> E;//for implementing kruskal's algorithm
	vector <vector<int>> Amat;//adjacency matrix
	//using vector to avoid manual dynamic memory allocation
};
struct Element{//an element in the disjoing set
	int val;//the element itself
	int rep;//the representative
};


// implementing the Disjoint set using a vector:
struct DisjointSet{
	vector <struct Element> S_log;//the set log
	int dist_count = 0;//the count of number of distinct representative in the set
};

int Find(struct DisjointSet& DS,int X){//Finding representative of X
	for(auto i=0;i<DS.S_log.size();i++){
		if(DS.S_log[i].val==X) return DS.S_log[i].rep;
	}
	return -1;//the structure assigns only postive representatives
}
void MakeSet(struct DisjointSet& DS,int new_element){
	if(Find(DS,new_element)!=-1){
		cout<<"element already in a set"<<endl;
		return;
	}
	struct Element buffer;
	buffer.val = new_element;
	buffer.rep = ++DS.dist_count;
	DS.S_log.push_back(buffer);
}

void Union(struct DisjointSet& DS,int x,int y){//union of x and y
	// replaces higher representatives by the lower one
	if(Find(DS,x)==-1 ||  Find(DS,y)==-1){
		cout<<"invalid query"<<endl;
	}
	int p,c;//p : stores lower representative : retained
	//c: stores higher representative : replaced by p
	if(Find(DS,x)>Find(DS,y)){
		p = Find(DS,y);
		c = Find(DS,x);
	}
	else if(Find(DS,x)<Find(DS,y)){
		p = Find(DS,x);
		c = Find(DS,y);
	}
	else{
		cout<<"already in one set"<<endl;
		return;
	}
		
	for(auto i = 0;i<DS.S_log.size();i++){
		if(DS.S_log[i].rep==c) DS.S_log[i].rep =  p;
	}
	DS.dist_count--;
}


//building an edge comparator : required for building a set of edges
//when implementing kruskal's algorithm

bool in_set(vector <pair<int,int>>& A, pair<int,int>& E){
	bool ret = false;
	for(auto i=A.begin();i!=A.end();i++){
		ret = ret || ((*i).first==E.first && (*i).second==E.second);
	}
	return ret;
}

void insert(vector <pair<int,int>>& A,pair<int,int>& E){
	if(!in_set(A,E)){
		A.push_back(E);
	}
}
void printEdgeSet(vector <pair<int,int>>& A){//testing purposes
	for(auto i=A.begin();i!=A.end();i++){
		cout<<"("<<i->first<<","<<i->second<<") ";
	}
	cout<<endl;
}

void printG_edgeSet(vector <struct Edge>& V){//testing Purposes
	for(auto i= V.begin();i!=V.end();i++){
		cout<<"("<<(*i).incidence.first<<","<<(*i).incidence.second<<"):"<<(*i).weight<<" ";
	}
	cout<<endl;
}

void edgeSetSort(vector <struct Edge>& V){
	// sorts a vector of edges by their weights
	// using insertion sort
	struct Edge buffer;
	int j;
	for(auto i = 1;i<V.size();i++){
		buffer = V[i];
		j = i-1;
		//cout<<i<<endl;
		while(j>=0 ){
		//	cout<<j<<endl;
			if(V[j].weight>buffer.weight){
				V[j+1] = V[j];	
			}
			j--;
			if(V[j].weight<=buffer.weight) break;
		}
		V[j+1] = buffer;
		//printG_edgeSet(V);
	}
}


void find_MST(struct Graph& G){
	//checking if G is connected
	//MST_possible was updated by the shortest path finder:
	//i.e. by its "found" vector
	//reusing that and not using BFS to reuse a major portion of the code
	if(!MST_possible){
		cout<<"G is not connected-> MST does't exist"<<endl;
		return;
	}
	//MST existence ensured
	//printG_edgeSet(G.E);
	edgeSetSort(G.E);	
	//printG_edgeSet(G.E);
	vector <pair<int,int>> A;//set of included edges
	
	struct DisjointSet DS;
	for(auto i = G.V.begin();i!=G.V.end();i++){
		MakeSet(DS,*i);
	}
	// kruskals implentation
	for(auto i=0;i<G.E.size();i++){
		if(Find(DS,G.E[i].incidence.first)!=Find(DS,G.E[i].incidence.second)){
			insert(A,G.E[i].incidence);
			//printEdgeSet(A);
			Union(DS,G.E[i].incidence.first,G.E[i].incidence.second);
		}
	}		
	//print out the set vector here
	printEdgeSet(A);
}
	
		

	
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

int  extractMin(vector <int>& d,vector <bool>& Q){
	int min_index;
	for(auto i=0;i<Q.size();i++){
		if(Q[i]==true) {
			min_index =i;
			break;
		}
	}
	for(auto i=min_index+1;i<d.size();i++){
		if(Q[i] == true){
			if(d[min_index]>d[i]) min_index = i;
		}
	}
	Q[min_index] = false;	
	return min_index;
}
// subsidiary methods
bool Qisempty(vector <bool>& Q){
	 bool ret= false;
	 for(auto i = Q.begin();i!=Q.end();i++){
		 ret  = ret || *i;
	 }
	return !ret;
}
bool foundisfull(vector <bool>& found){
	bool ret = true;
	for(auto i=found.begin();i!=found.end();i++){
		ret = *i && ret;
	}
	return ret;
}

void bool_vec_printer(vector <bool> vec){
	for(auto i=0;i<vec.size();i++){
		cout<<i<<"|";
	}
	cout<<endl;
	for(auto i=vec.begin();i!=vec.end();i++){
		cout<<*i<<"|";
	}
	cout<<endl;
}
void int_vec_printer(vector <int> vec){
	for(auto i=0;i<vec.size();i++){
		cout<<i<<"|";
	}
	cout<<endl;
	for(auto i=vec.begin();i!=vec.end();i++){
		cout<<*i<<"|";
	}
	cout<<endl;
}
//no need to have a decrease key as implemented using an array

void shortestPath(struct Graph& G,int source){
	// used to determine if Graph is connected
	vector <int> d(G.Amat.size());//stores distances
	vector <bool> Q(G.Amat.size());//The queue
	vector <int> p(G.Amat.size());//stores parent
	vector <bool> found(G.Amat.size());//stores whether its d value has been finalised
	fill(Q.begin(),Q.end(),true);
	fill(d.begin(),d.end(),INT_MAX);
	fill(p.begin(),p.end(),-1);//NULL = -1
	fill(found.begin(),found.end(),false);
	d[source] = 0;
	int u;	
	while(!Qisempty(Q)){
		u = extractMin(d,Q);
		if(d[u]==INT_MAX){
			break;
		}
		found[u] = true;
		for(auto v=0;v<G.Amat.size();v++){
			if(G.Amat[u][v]!=0){
				if(d[u] + G.Amat[u][v] < d[v]){
					d[v] = d[u] + G.Amat[u][v];
					p[v] = u;
				}
			}			
		}
	}
	//reusing code to find if graph is connected
//	bool_vec_printer(found);
	MST_possible = foundisfull(found);
}	

int main(){
	queue <struct Edge*> inputQ;	
	struct Graph G;
	string str;
	char X;
	int Max_vertex=0;
	int V1,V2,wt;
	struct Edge* buffer;
	while(1){
		getline(cin,str);
		if(str.length()==0) break;
		stringstream(str)>>X>>V1>>V2>>wt;
		buffer = new struct Edge; //cleanup done when updating matrix
	       	buffer->incidence = make_pair(V1,V2);
		buffer->weight = wt;
		G.E.push_back(*buffer);
		G.V.emplace(V1);
		G.V.emplace(V2);
		if(Max_vertex<max(V1,V2)) Max_vertex = max(V1,V2);
		buffer->weight = wt;	
		inputQ.push(buffer);
	}
	G.Amat.resize(Max_vertex+1);
	for(auto i=0;i<Max_vertex+1;i++){
		G.Amat[i].resize(Max_vertex+1);
	}	
	while(!inputQ.empty()){
		buffer = inputQ.front();
		inputQ.pop();
		G.Amat[buffer->incidence.first][buffer->incidence.second] = buffer->weight;
		G.Amat[buffer->incidence.second][buffer->incidence.first] = buffer->weight;
		delete buffer;
	}
	buffer = NULL;//eliminating dangling pointer after last iteration.
//	printGraph(G);

	shortestPath(G,*G.V.begin());
//	cout<<MST_possible<<endl;
	find_MST(G);
	return 0;
}
