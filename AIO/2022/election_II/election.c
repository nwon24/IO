
#include <stdio.h>

int main(void)
{

    int A = 0;
    int B = 0;
    int C = 0;
    int N;
    char votes[100005];
    int answer;

    FILE *in_file, *out_file;

    in_file = fopen("elecin.txt", "r");
    out_file = fopen("elecout.txt", "w");

    fscanf(in_file, "%d\n%s", &N, votes);

    for (int i = 0; i < N; i++) {
	switch (votes[i]) {
	case 'A':
	    A++;
	    break;
	case 'B':
	    B++;
	    break;
	case 'C':
	    C++;
	    break;
	}
    }

    if (A > B && A > C) {
	answer = 'A';
    } else if (B > A && B > C) {
	answer = 'B';
    } else if (C > A && C > B) {
	answer = 'C';
    } else {
	answer = 'T';
    }

    fprintf(out_file, "%c\n", answer);
    fclose(in_file);
    fclose(out_file);
    return 0;
}
