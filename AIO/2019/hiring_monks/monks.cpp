/*1:*/
#line 26 "monks.w"

/*16:*/
#line 191 "monks.w"

#include <bits/stdc++.h> 
using namespace std;
/*:16*/
#line 27 "monks.w"

/*11:*/
#line 138 "monks.w"

array<int,100005> x;
array<int,100005> s;
array<int,100005> m;
int N;
int S;
int M;
int answer;
/*:11*//*13:*/
#line 173 "monks.w"

FILE*in_file;
FILE*out_file;
/*:13*/
#line 28 "monks.w"

/*5:*/
#line 86 "monks.w"

int assign_master()
{
int i,j;
int jobs;

j= 0;
jobs= 0;
for(i= 0;i<N;i++){
/*6:*/
#line 108 "monks.w"

while(j<M&&m[j]> x[i])j++;
/*:6*/
#line 95 "monks.w"
;
/*7:*/
#line 111 "monks.w"

if(j==M)return jobs;
/*:7*/
#line 96 "monks.w"
;
jobs++;
j++;
}
return jobs;
}
/*:5*//*8:*/
#line 114 "monks.w"

int assign_student()
{
int i,j;
int jobs;

j= 0;
jobs= 0;
for(i= 0;i<N;i++){
/*9:*/
#line 131 "monks.w"

while(j<S&&s[j]<x[i])j++;
/*:9*/
#line 123 "monks.w"
;
/*10:*/
#line 134 "monks.w"

if(j==S)return jobs;
/*:10*/
#line 124 "monks.w"
;
jobs++;
j++;
}
return jobs;
}
/*:8*/
#line 29 "monks.w"

int main(void)
{
/*14:*/
#line 180 "monks.w"

in_file= fopen("hirein.txt","r");
out_file= fopen("hireout.txt","w");
/*:14*/
#line 32 "monks.w"
;
/*12:*/
#line 157 "monks.w"

fscanf(in_file,"%d\n",&N);
for(int i= 0;i<N;i++){
fscanf(in_file,"%d\n",&x[i]);
}
fscanf(in_file,"%d\n",&S);
for(int i= 0;i<S;i++){
fscanf(in_file,"%d\n",&s[i]);
}
fscanf(in_file,"%d\n",&M);
for(int i= 0;i<M;i++){
fscanf(in_file,"%d\n",&m[i]);
}
/*:12*/
#line 33 "monks.w"
;
/*3:*/
#line 62 "monks.w"

int masters;
int students;
sort(x.begin(),x.begin()+N,greater<int> ());
sort(m.begin(),m.begin()+M,greater<int> ());
masters= assign_master();
sort(x.begin(),x.begin()+N);
sort(s.begin(),s.begin()+S);
students= assign_student();
answer= min(masters+students,N);
/*:3*/
#line 34 "monks.w"
;
/*15:*/
#line 184 "monks.w"

fprintf(out_file,"%d\n",answer);
fclose(in_file);
fclose(out_file);
/*:15*/
#line 35 "monks.w"
;
return 0;
}
/*:1*/
