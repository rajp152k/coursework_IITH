//RAJ PATIL
//CS18BTECH11039
//QUESTION 2
#include <iostream>
#include <sstream>
#include <string>

using namespace std;

struct Node{
	int key;
	struct Node* p;//parent
	struct Node* l;//left child
	struct Node* r;//right child
};
//< in left subtree and >= in the right subtree
void insert(struct Node* root,int val){
	if(val<root->key){
		if(root->l == NULL){
			struct Node* buffer;
			buffer = new struct Node;
			buffer->key = val;
			buffer->r = NULL;
			buffer->l = NULL;
			buffer->p = root;
			root->l = buffer;
		}
		else insert(root->l,val);
	}
	else{
		if(root->r==NULL){
			struct Node* buffer;
			buffer = new struct Node;
			buffer->key = val;
			buffer->r = NULL;
			buffer->l = NULL;
			buffer->p = root;
			root->r = buffer;
		}
		else insert(root->r,val);
	}
}

int maximum(struct Node* root){
	if(root->r == NULL) return root->key;
	else return maximum(root->r);
}

int minimum(struct Node* root){
	if(root->l == NULL) return root->key;
	else return minimum(root->l);
}

struct Node* search(struct Node* root,int val){
	if (root ==NULL) return NULL;
	if(root->key ==val) return root;
	else if(root->key <= val) return search(root->r,val);
	else return search(root->l,val);
}

int predecessor(struct Node* root,int val){
	struct Node* buffer = search(root,val);
	if (buffer==NULL) {
		cout<<"invalid query"<<endl;
		return val;
	}
	if(buffer->l!=NULL) return maximum(buffer->l);
	struct Node* buffer2 = buffer->p;
	while(buffer2!=NULL && buffer==buffer2->l){
		buffer = buffer2;
		buffer2 = buffer2->p;
	}
	if (buffer2==NULL) {
		cout<<"no predecessor for this node"<<endl;
		return val;
	}
	return buffer2->key;	
}

int successor(struct Node* root,int val){
	struct Node* buffer = search(root,val);
	if(buffer==NULL){
		cout<<"invalid query"<<endl;
		return val;
	}
	if(buffer->r!=NULL) return minimum(buffer->r);
	struct Node* buffer2 = buffer->p;
	while(buffer2!=NULL && buffer==buffer2->r){
		buffer =buffer2;
		buffer2 = buffer2->p;
	}
	if(buffer2==NULL){
		cout<<"no successor for this node"<<endl;
		return val;
	}
	return buffer2->key;
}

int lowest_common_ancestor(struct Node* root,int val1,int val2){
	struct Node* node1 = search(root,val1);
	struct Node* node2 = search(root,val2);
	if(node1==NULL || node2== NULL) {
		cout<<"invalid query"<<endl;
		return val1;
	}
	if(search(node1,node2->key)!=NULL){
		if(node1==root){
			cout<< "no lowest common ancestor exists"<<endl;
			return val1;
		}
		else return node1->p->key;
	}
	if(search(node2,node1->key)!=NULL){
		if(node2==root){
			cout<<"no lowest common ancestor exists"<<endl;
			return val2;
		}
		else return node2->p->key;
	}
	struct Node* buffer = node1;
	while(search(buffer,node2->key)==NULL){
		buffer = buffer->p;
	}
	return buffer->key;
}

void cleanup(struct Node* root){// freeing up all the allocated memory
	if(root==NULL) return ;
	cleanup(root->l);
	cleanup(root->r);
	delete root;	
}

void inorder(struct Node* root) {// for testing purposes
	if(root==NULL) return;
	inorder(root->l);
	cout<<" "<<root->key<<" ";
	inorder(root->r);
}

void interact(struct Node* root){
	string str;//for streaming purposes
	int v1,v2;
	char X;
	while(1){
		getline(cin,str);
		if(str.length()==0) break;
		X = str[0];
		if(X=='M'){
			stringstream(str)>>X>>v1;
			cout<<minimum(search(root,v1))<<" "<<maximum(search(root,v1))<<endl;
		}
		else if(X=='P'){
			stringstream(str)>>X>>v1;
			cout<<predecessor(root,v1)<<endl;
		}
		else if(X=='S'){
			stringstream(str)>>X>>v1;
			cout<<successor(root,v1)<<endl;
		}
		else if(X=='C'){
			stringstream(str)>>X>>v1>>v2;
			cout<<lowest_common_ancestor(root,v1,v2);
		}
	}
}
int main(){
	//input
	struct Node* root;
	root = NULL;
	int buffer;
	cin>>buffer;
	root = new struct Node;
	root->key = buffer;
	root->p = NULL;
	root->l = NULL;
	root->r = NULL;
	while(cin.get()!='\n'){
		cin>>buffer;
		insert(root,buffer);
	}
	//inorder(root); - quick check if working correctly
	interact(root);
	//freeing up dynamic memory allocated to each node
	cleanup(root);
	return 0;
}
