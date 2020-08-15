//RAJ PATIL
//CS18BTECH11039
//QUESTION 1

#include <iostream>
#include <string>
#include <sstream>
using namespace std;

struct Node{
	char C = '\0';
	struct Node* next; 
	bool fo = true;//stores if its the first occurence 
};

struct Distinct{
	char C = '\0';
	int num=0;//number of occurences of C
}; 
//function declarations : in case of definitions being below usage
void dist_sort(struct Distinct* dist_arr,int num_distincts);
void prune_dup(struct Node& head, int max_o);
void sorted_print(struct Distinct* dist_arr,int num_distincts);

void list_print(struct Node& head){//testing purposes
	struct Node* buffer;
	buffer = head.next;
	while(buffer!=NULL){
		cout<<"| "<< buffer->C<< " " << buffer->fo<<" |";
		buffer = buffer->next;
	}
	cout<<endl;
}

void org_print(struct Node& head){//printing as demanded by the question statement
	struct Node* buffer;
	buffer = head.next;
	while(buffer!=NULL){
		cout<<buffer->C;
		buffer = buffer->next;
	}
	cout<<endl;
}

//prints out array of distincts
void dist_arr_print(struct Distinct* dist_arr,int& num_distincts){
	for(int i=0;i<num_distincts;i++){
		cout<<dist_arr[i].C<<" "<<dist_arr[i].num<<" ";
	}
	cout<<endl;
}

void store(struct Node& head){
	struct Node* buffer = head.next;
	while(buffer->next!=NULL) buffer = buffer->next;
	cout<<head.next->C<<" "<<buffer->C<<endl;
}

void post_updater(struct Node& head,struct Distinct* dist_arr,int& num_distincts,int rm_num){// updates list parameters for other queries to be functional after calling a remove
		delete [] dist_arr;
		num_distincts=0;
		
		struct Node* buffer;
		buffer = head.next;
		struct Node* buffer2;
		while(buffer != NULL){
			buffer2 = head.next;
			while(buffer2!=buffer){
				if(buffer2->C == buffer->C){
					buffer->fo = false;
					break;
				}
				buffer2 = buffer2->next;
			}
			buffer = buffer->next;
		}	

		//updating number of distincts based on fo data
		//fo : first occurence
		buffer=head.next;
		while(buffer!=NULL){
			if(buffer->fo) num_distincts+=1;
			buffer = buffer->next;
		}
		//updating number of copies of the fo in the list
		//building a new array : dist_arr --> look at the struct definition for a distinct
		dist_arr = new struct Distinct[num_distincts];
		int i=0;
		buffer = head.next;
		while(buffer!=NULL){
			if(buffer->fo){
				dist_arr[i].C = buffer->C;
				i++;
			}
			buffer = buffer->next;
		}
		for(i=0;i<num_distincts;i++){
			buffer  = head.next;
			while(buffer!=NULL){
				if(buffer->C==dist_arr[i].C) dist_arr[i].num++;
				buffer = buffer->next;
			}
			
		}
}
void interact(struct Node& head,struct Distinct* dist_arr,int& num_distincts,int rm_num){
	//prepping up the list for queries
	// 	storing first occurences : used in managing duplicates and sorting
		struct Node* buffer;
		buffer = head.next;
		struct Node* buffer2;
		while(buffer != NULL){
			buffer2 = head.next;
			while(buffer2!=buffer){
				if(buffer2->C == buffer->C){
					buffer->fo = false;
					break;
				}
				buffer2 = buffer2->next;
			}
			buffer = buffer->next;
		}	

		//updating number of distincts based on fo data
		//fo : first occurence
		buffer=head.next;
		while(buffer!=NULL){
			if(buffer->fo) num_distincts+=1;
			buffer = buffer->next;
		}
		//updating number of copies of the fo in the list
		//building a new array : dist_arr --> look at the struct definition for a distinct
		dist_arr = new struct Distinct[num_distincts];
		int i=0;
		buffer = head.next;
		while(buffer!=NULL){
			if(buffer->fo){
				dist_arr[i].C = buffer->C;
				i++;
			}
			buffer = buffer->next;
		}
		for(i=0;i<num_distincts;i++){
			buffer  = head.next;
			while(buffer!=NULL){
				if(buffer->C==dist_arr[i].C) dist_arr[i].num++;
				buffer = buffer->next;
			}
			
		}

	string S,str;//for streaming purposes	
	bool flag = false;//indicator whether store has been called
	while(1){
		getline(cin,str);
		if(str.length()==0) break;
		stringstream(str)>>S;
		if(S=="Store"){
			store(head);
			flag = true;
		}
		if(!flag){
			cout<<"list hasn't been stored yet; invalid query"<<endl;
			continue;
		}
		else if(S=="Print"){
			dist_arr_print(dist_arr,num_distincts);
		}	
		else if(S=="Sort"){//only prints out a sorted view
			dist_sort(dist_arr,num_distincts);
			sorted_print(dist_arr,num_distincts);
			
		}
		else if(S=="Remove"){//updates the list : can call different queries post this 
			stringstream(str)>>S>>rm_num;
			prune_dup(head,rm_num);
			org_print(head);
			post_updater(head,dist_arr,num_distincts,rm_num);
		}
		// REMOVE AND SORT can be called after calling a Remove
	}
		delete [] dist_arr;//freeing up dynamically allocated Distinct array
}

void sorted_print(struct Distinct* dist_arr,int num_distincts){
	for(auto i=0;i<num_distincts;i++){
		cout<<dist_arr[i].C<<" ";
	}
	cout<<endl;
}

void dist_sort(struct Distinct* dist_arr,int num_distincts){
	//using insertion sort
	int i,j;
	struct Distinct buffer_distinct;	
	for(i=1;i<num_distincts;i++){
		j = i-1;
		//Distinct_assigner(buffer_distinct,dist_arr[i]);
		buffer_distinct = dist_arr[i];
		while(j>=0 &&  dist_arr[j].num < buffer_distinct.num){
		//	Distinct_assigner(dist_arr[j+1],dist_arr[j]);
			dist_arr[j+1] = dist_arr[j];
			j--;
		}
		//Distinct_assigner(dist_arr[j+1],buffer_distinct);
		dist_arr[j+1] = buffer_distinct;
	}
}
	
void prune_dup(struct Node& head, int max_o){//prunes out duplicates after desired value of occurences
	//works on the list
	struct Node* p;
	struct Node* b;
	int ctr=1;
	b = head.next;
	while( b->next != NULL){
		p = b;
		b = p->next;
		if(p->C == b->C){
			ctr++;
		}
		else{
			ctr=1;
		}
		if(ctr>max_o){
			while( b->C == p->C){
				p->next = b->next;
				delete b;
				b = p->next;
				if(b==NULL) break;
			}
			ctr=1;
		}
		if(b == NULL) break;
	}
}


int main(){
	struct Node head;
	head.C = '\0';
	head.next = NULL;
	struct Node* tail;
	//input
	string S;
	string str;//streaming buffer
	int rm_num;//provided to execute remove
	getline(cin,str);//the get line takes care of the end of the input
	stringstream(str)>>S>>rm_num;
	struct Node* buffer;
	struct Node* prev = &head;
	for(int i=0;i<S.length();i++){
		buffer = new struct Node;//freeing up in the end
		buffer->C = S[i];
		buffer->next = NULL;
		prev->next = buffer;
		prev = buffer;
	}
	tail = prev;

	struct Distinct* dist_arr;
	int num_distincts=0;
	interact(head,dist_arr,num_distincts,rm_num);

	//freeing up the list
	prev = head.next;
	buffer = prev->next;
	while(buffer!=NULL){
		delete prev;
		prev = buffer;
		buffer = buffer->next;
	}
	delete prev;
	prev = NULL;
	buffer = NULL;
	//eliminating dangling pointers
	return 0;
}
