
#include <stdio.h>

int N;
int L[100005];
int R[100005];
char *answer;

FILE *in_file;
FILE *out_file;

int main(void)
{

    in_file = fopen("tspin.txt", "r");
    out_file = fopen("tspout.txt", "w");

    fscanf(in_file, "%d\n", &N);
    for (int i = 0; i < N; i++) {
	fscanf(in_file, "%d ", &L[i]);
    }
    for (int i = 0; i < N; i++) {
	fscanf(in_file, "%d ", &R[i]);
    }

    answer = "YES";

    int yesterday = 0;

    for (int i = 0; i < N; i++) {

	int tomatoes;

	tomatoes = (L[i] > yesterday) ? L[i] : yesterday;
	if (tomatoes > R[i]) {
	    answer = "NO";
	    break;
	}
	yesterday = tomatoes;
    }

    fprintf(out_file, "%s\n", answer);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
