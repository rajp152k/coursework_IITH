//RAJ PATIL
//CS18BTECH11039
//QUESTION 4 
#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
#include <set>


const int INT_MAX = 2147483647;
using namespace std;

struct Edge{// for queing in input
	pair<int,int> incidence;
   	int weight;	
};

struct Graph{
	set <int> V;//vertices
	//using vector to avoid manual dynamic memory allocation
	vector <vector<int>> Amat;//the undirected version of the graph
	vector <vector<int>> Amat_dir;//the directed version of the graph
};

void bool_vec_printer(vector <bool> vec);
void int_vec_printer(vector <int> vec);
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

//using a recursive DFS algorithm: uses the stack of the system itself
//not using my own stack to avoid use of libraries
void DFS_rec(struct Graph& G,int v,vector <int>& visited,stringstream& S){
	visited[v] = 1;
	S<<v<<" ";	
	//recursive call on its neighbors
	for(auto i=0;i<G.Amat[v].size();i++){
		if(visited[i]==0 && G.Amat[v][i]!=0) DFS_rec(G,i,visited,S);
	}
}

void connectedComponents(struct Graph& G){
	vector <int> visited(G.Amat.size());
	for(auto i=visited.begin();i!=visited.end();i++){	
		*i = 0;
	}
	int num_components=0;//
	stringstream S;
	for(auto i=0;i<G.Amat.size();i++){
		if(!G.V.count(i)) continue;// only call DFS on it if is present int the set of vertices initially determined by the input;
		//have to do this otherwise, the output doesn't distinguish between isolated vertices and ones that are not there in the graph
		if(visited[i]==0) {
			num_components++;
			DFS_rec(G,i,visited,S);
			S<<endl;
		}
	} 	
	//output
	cout<<num_components<<" components"<<endl;
	cout<<S.str();
}


int  extractMin(vector <int>& d,vector <bool>& Q){
	int min_index;
	for(auto i=0;i<Q.size();i++){
		if(Q[i]) {
			min_index =i;
			break;
		}
	}
	for(auto i=min_index+1;i<d.size();i++){
		if(Q[i]){
			if(d[min_index]>d[i]) min_index = i;
		}
	}
	Q[min_index] = false;	
	return min_index;
}

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
	vector <int> d(G.Amat_dir.size());//stores distances
	vector <bool> Q(G.Amat_dir.size());//The queue
	vector <int> p(G.Amat_dir.size());//stores parent
	vector <bool> found(G.Amat_dir.size());//stores whether its d value has been finalised
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
		for(auto v=0;v<G.Amat_dir.size();v++){
			if(G.Amat_dir[u][v]!=0){
				if(d[u] + G.Amat_dir[u][v] < d[v]){
					d[v] = d[u] + G.Amat_dir[u][v];
					p[v] = u;
				}
			}			
		}
	}
//	int_vec_printer(p);
//	int_vec_printer(d);
//	bool_vec_printer(found);
	int x;
	int path_length=0;
	for(auto i=0;i<G.Amat_dir.size();i++){
		if(found[i]){
			path_length=0;
			x = i;
			cout<<source<<" "<<x;
			while(x!=source){		
				path_length+= G.Amat_dir[p[x]][x];
				x = p[x];
			}
			cout<<" "<<path_length;
			cout<<endl;
		}
	}
	//printing distances to all vertex if G is connected
	if(foundisfull(found)){
		//printing shortest distance to all other vertices
		cout<<"shortest distance to each vertex"<<endl;
		for(auto i=0;i<d.size();i++){
			cout<<i<<"|-->"<<d[i]<<endl;
		}
	}
}	
	
void interact(struct Graph& G){//to handle queries
	string str;
	int source;//holder for source vertex
	while(1){//an empty line breaks the input stream an exits interactive mode
		getline(cin,str);
		if(str.length()==0) break;
		if(str[0]=='F'){//finding 
			connectedComponents(G);
		}
		else if(str[0]=='S'){//shortest distance
			stringstream(str)>>str>>source;
			shortestPath(G,source);
		}
	}
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
	G.Amat_dir.resize(Max_vertex+1);
	for(auto i=0;i<Max_vertex+1;i++){
		G.Amat_dir[i].resize(Max_vertex+1);
	}
	while(!inputQ.empty()){
		buffer = inputQ.front();
		inputQ.pop();
		//Amat for undirected
		//Amat_dir for undirected
		G.Amat[buffer->incidence.first][buffer->incidence.second] = buffer->weight;
		G.Amat[buffer->incidence.second][buffer->incidence.first] = buffer->weight;
		G.Amat_dir[buffer->incidence.first][buffer->incidence.second] = buffer->weight;
		delete buffer;
	}
	buffer = NULL;//eliminating dangling pointer after last iteration.

	interact(G);
	return 0;
}
