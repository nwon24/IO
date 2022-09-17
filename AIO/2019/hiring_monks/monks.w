\input eplain
\enablehyperlinks
@* Introduction.
This program is a solution to a problem from
the 2019 Australian Informatics Olympiad called {\bf Hiring Monks}.
The problem statement can be found
\href{https://orac2.info/problem/aio19hire/}{{\bf here}}.

There are $N$ monks, the $i$th of which has skill level $x_i$.
There are $S$ student jobs available, numbered from $1$ to $S$,
and the $j$th student job can be taken only by monks that
have a skill level at most $s_j$. Additionally, there are $M$
master jobs, likewise numbered from $1$ to $M$, and the $k$th
master job can be taken only by monks with a skill level of
at least $m_k$. Given that each monk can be given at most one
job and that each job can be assigned to at most one monk, our
program needs to determine the largest number of monks that
can be assigned to jobs.

Note that this program is written in C++.
To make the output look a bit nicer, we need a few format definitions.
You can ignore these; this has to do with the {\tt CWEB} language.
@f greater make_pair
@f array make_pair

@c
@<Include files@>@;
@<Global variables@>@;
@<Functions@>@;
int main(void)
{
  @<Open the input and output files@>;
  @<Read the input data from the input file@>;
  @<Calculate the answer@>;
  @<Write the answer to the ouptut file and close the files@>;
  return 0;
}
@*Solving the problem.
This problem is an example of one that can be solved using a
greedy algorithm. The basic idea behind our algorithm is that
the monk with the highest skill has the most jobs available.
Thus our algorithm consists of finding the monk with the highest
skill, assigning the job with the highest possible skill to it,
and then repeating.

Since there are student and master jobs, we first try to assign
as many master jobs as possible. Then we try to assign student
jobs to the remaining monks. The only thing we need to worry
about is when there is overlap and some monks are assigned two jobs.
If we have assigned $x$ student jobs and $y$ master jobs, and if
$x+y>N$, then our answer is just $N$.

@ Assume we have delcared and red in the data for the following
local variables: |N|, the number of monks, |x|, an array containing
the skill level of each monk, |S|, the number of student jobs available,
|s|, an array containing the maximum skill level of each student job,
|M|, the number of master jobs, and |m|, an array containing the
minimum skill level of each master job.

Also assume that we have a variable |answer| to store our answer,
the maximum number of monks that can be assigned jobs.
@<Calculate the answer@>=
int masters; /* Number of master jobs assigned */
int students; /* Number of student jobs assigned */
sort(x.begin(), x.begin()+N, greater<int>());
sort(m.begin(), m.begin()+M, greater<int>());
masters = assign_master(); /* Assign the master jobs */
sort(x.begin(), x.begin()+N);
sort(s.begin(), s.begin()+S);
students = assign_student(); /* Assign the student jobs */
answer = min(masters+students,N);
@ Now we can write our functions |assign_master| and |assign_student|.
Both subroutines are virtually the same. Since our arrays
have been conveniently sorted in descending order, the code isn't too
complicated.

For the master jobs assignment, we first ignore any jobs that require
too much skill; that is, jobs that cannot be assigned to any monk.
Then assigning the job is simply a matter of incrementing our counter
of jobs assigned and the index of job.

The algorithm is exactly the same for the student jobs, except we
ignore the jobs at the start that have such low skill requirements
that no monk can be assigned to them.
@
@<Functions@>=
int assign_master()
{
    int i, j;
    int jobs; /* Number of jobs we can assign */

    j = 0;
    jobs = 0;
    for (i = 0; i < N; i++) {
	@<Ignore jobs that have too high skill level@>;
	@<If out of master jobs, |return jobs|@>;
	jobs++;
	j++;
    }
    return jobs;
}
@ The array |m| is sorted in descending order, so
while |m[j]>x[i]|, the job with skill level |m[j]|
cannot be assigned to any monk because |x[i]| is the
skill level of the most skilled monk.
Of course, we also have to check if all the master
jobs have too much skill.
@<Ignore jobs that have too high...@>=
while (j < M && m[j] > x[i]) j++;
@
@<If out of master jobs, |return jobs|@>=
if (j == M) return jobs;
@ Here is the same function, but for the student jobs.
@<Functions@>=
int assign_student()
{
    int i, j;
    int jobs; /* Number of student jobs we can assign */

    j = 0;
    jobs = 0;
    for (i = 0; i < N; i++) {
	@<Ignore jobs that have too low skill level@>;
	@<If out of student jobs, |return jobs|@>;
	jobs++;
	j++;
    }
    return jobs;
}
@
@<Ignore jobs that have too low...@>=
while (j < S && s[j] < x[i]) j++;
@
@<If out of student jobs...@>=
if (j == S) return jobs;
@ Now let's declare the local variables that we will need
for our program.
@<Global variables@>=
array<int, 100005> x; /* Skill level of the monks */
array<int, 100005> s; /* Student jobs and their required skill level */
array<int, 100005> m; /* Master jobs and their required skill level */
int N; /* The number of monks */
int S; /* The number of student jobs */
int M; /* The number of master jobs */
int answer; /* Our answer: the maximum number of monks that can be assigned to jobs */
@*Getting the input data.
The input file is formatted in the following way.
The first line contains |N|, followed by |N| lines, the $i$th
of which contains $x_i$, the skill level of monk $i$.
The next line contains |S|, and likewise the next |S| lines
contain the maximum skill level of the student jobs.
Then the data for the master jobs follows, in the same format
as the student jobs.

Assume that we have two variables |in_file| and |out_file| that
point to the input and output files.
@<Read the...@>=
fscanf(in_file, "%d\n", &N);
for (int i = 0; i < N; i++) {
    fscanf(in_file, "%d\n", &x[i]);
}
fscanf(in_file, "%d\n", &S);
for (int i = 0; i < S; i++) {
    fscanf(in_file, "%d\n", &s[i]);
}
fscanf(in_file, "%d\n", &M);
for (int i =0; i < M; i++) {
    fscanf(in_file, "%d\n", &m[i]);
}
@*File input/output. Even though we are using C++, we can
still use routines from the C standard library for input and output.
Let's declare the two variables |in_file| and |out_file|.
@<Global variables@>=
FILE *in_file;
FILE *out_file;
@ Opening the files requires simple calls to |fopen|. Normally a good
program would do error checking here, but we don't need to because we
can assume the input and output files will exist can be opened with
the necessary permissions.
@<Open...@>=
in_file = fopen("hirein.txt", "r");
out_file = fopen("hireout.txt", "w");
@
@<Write...@>=
fprintf(out_file, "%d\n", answer);
fclose(in_file);
fclose(out_file);
@*Include files. Let's just include the entire C++ standard library.
Also we need to include the line |using namespace std| because
we haven't prefixed anything with |std::|.
@<Include files@>=
#include <bits/stdc++.h>
using namespace std;
@*Index.
