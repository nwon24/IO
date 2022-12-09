#define MAX_SQUARE_LEN 200000

#include <stdio.h>
#include <stdlib.h>

int main(void)
{

    int N;
    char A[MAX_SQUARE_LEN * 2];
    char B[MAX_SQUARE_LEN * 2];
    int answer;

    if (freopen("laserin.txt", "r", stdin) == NULL) {
	fprintf(stderr, "Unable to open input file laserin.txt\n");
	exit(EXIT_FAILURE);
    }
    if (freopen("laserout.txt", "w", stdout) == NULL) {
	fprintf(stderr, "Unable to open output file laserout.txt\n");
	exit(EXIT_FAILURE);
    }

    scanf("%d\n", &N);
    scanf("%s\n%s", A, B);

    int length = 0;
    answer = 0;
    for (int i = 0; i < 2 * N; i++) {
	if (A[i] != B[i]) {
	    length += (A[i] == 'D') ? 1 : -1;
	    if (length > answer)
		answer = length;
	}
    }

    printf("%d\n", answer);

    fclose(stdin);
    fclose(stdout);
    return 0;
}
