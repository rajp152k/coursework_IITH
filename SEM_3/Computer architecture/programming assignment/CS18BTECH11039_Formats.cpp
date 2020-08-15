/*    
Raj Patil
CS18BTECH11039
Computer Architecture programming assignment
*/

#include <iostream>
#include <iomanip>
#include <cmath>
#include <fstream>
#include <sstream>

using namespace std;

int T,E;//defining as global variables for convenience

string bin_str(long long int);//returns a binary string given a decimal integer
string valToStr(double);//returns a string with custom precision given a double 

long long int getIntegerVal(string);//returns a decimal integer given a binary string 
string getFixedPoint(string);//returns the fixed point value given a binary string
string getFP(string);//returns floating point (IEEE 754 FP) given a binary string

long long int strToNum(string);//converts a binary string to integer :- subsidiary function
double strToFrac(string);//returns the mantissa given a binary string
int strToDNum(string s);//returns decimal integer from a decimal string

//driver function
int main(int argc,char** argv){
      ofstream file;
      string indic = argv[3];
      T = strToDNum(argv[1]);
      E = strToDNum(argv[2]);
      long long int total = pow(2,T);
      
      string s;//buffer string :- will be argument of the core functions
      ostringstream name;
      name<<"CS18BTECH11039";

      if(indic[0] == 'A' || indic[0] =='a'){
            name<<"_"<<T<<"_"<<E<<"_"<<"All"<<".txt";
            file.open(name.str());

            file << "combinations";
            file << setw(20)<<"integer";
            file << setw(20) << "fixed point";
            file << setw(40) << "FP8"<<"\n";
      
            for(long long int i=0;i<total;i++){

                  s = bin_str(i);   

                  file << s ;
                  file <<setw(20) << getIntegerVal(s);
                  file << setw(20) <<getFixedPoint(s);
                  file << setw(40) << getFP(s)<<"\n";
            }
            file.close();
      }

      else{
            s = argv[4];
            name<<"_"<<T<<"_"<<E<<"_"<<"Single"<<"_"<<s<<".txt";
            file.open(name.str());

                  file << "combinations";
                  file << setw(20)<<"integer";
                  file << setw(20) << "fixed point";
                  file << setw(40) << "FP8"<<"\n";

                  file << s ;
                  file <<setw(20) << getIntegerVal(s);
                  file << setw(20) <<getFixedPoint(s);
                  file << setw(40) << getFP(s)<<"\n";

            file.close();
      } 
      return 0;
}

//core functions
long long int getIntegerVal(string num){
      long long int ret;
      ret = strToNum(num.substr(1,T-1));
      ret*= pow(-1,int(num[0]) - int('0'));
      return ret;
}
string getFixedPoint(string num){
      double ret;
      double integer = strToNum(num.substr(1,E));
      double frac = strToFrac(num.substr(E+1,T-E-1));

      ret = integer + frac;
      ret*= pow(-1,int(num[0]) - int('0'));

      if(ret==0) {return "0";}

      return valToStr(ret);
}
string getFP(string num){

      double ret;
      long long int bias = pow(2,E-1)-1;
      long long int b_exponent = strToNum(num.substr(1,E));
      double mantissa = strToFrac(num.substr(E+1,T-E-1));
      string ret_str;

      if(b_exponent==0){

            if(mantissa==0){return "0";}

            ret = pow(2,1-bias)*(mantissa);
            ret*= pow(-1,int(num[0]) - int('0'));
            ret_str = valToStr(ret); 
            ret_str = "Denormal number "+ret_str;
            return ret_str;
      }
      
      else{
            if(b_exponent == pow(2,E)-1){
                  if(mantissa==0){
                        if(num[0]=='1'){
                              ret_str = "-infinity";
                        }
                        else ret_str="+infinity";
                        return ret_str;
                  }
                  else{return "NAN";}      
            }
      } 

      ret = pow(2,b_exponent-bias)*(1+mantissa);
      ret*= pow(-1,int(num[0]) - int('0'));
      ret_str = valToStr(ret);
      return ret_str;
}

//subsidiary functions 
long long int strToNum(string s){
      long long int ret=0;
      for(auto i=0;i<s.length();i++){
            ret = 2*ret + int(s[i]) - int('0');
      }
      return ret;
}
double strToFrac(string s){
      double ret=0;
      for(auto i=0;i<s.length();i++){
            ret = ret*2 + int(s[i]) - int('0');
      }
      ret/= pow(2,s.length());
      return ret;
}
string bin_str(long long int val){
      int num_o_bits=0;
      int buffer = val;
      while(buffer){num_o_bits++;buffer/=2;}
      string ret_str;
      for(auto i=0;i<T;i++) {ret_str.append("0");} 
      for(auto i= T - 1  ;i>=T- num_o_bits;i--){
            if(val%2==1){ret_str[i]='1';}
            val = int(val/2);
            }
      return ret_str;
}
string valToStr(double val){
      ostringstream string_stream;
      string_stream<<setprecision(12)<<val;
      return string_stream.str();
}
int strToDNum(string s){
      int ret=0;
      for(auto i=0;i<s.length();i++){
            ret = 10*ret + int(s[i]) - int ('0');
      }
      return ret;
}