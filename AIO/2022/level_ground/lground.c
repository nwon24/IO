
#include <stdio.h>

int N;
int A[100005];
int answer;

FILE *in_file;

FILE *out_file;

int main(void)
{

    in_file = fopen("groundin.txt", "r");
    out_file = fopen("groundout.txt", "w");

    fscanf(in_file, "%d\n", &N);
    for (int i = 0; i < N; i++) {
	fscanf(in_file, "%d ", &A[i]);
    }

    answer = 0;
    for (int i = 0; i < N;) {

	int height;
	int intensity;
	int length;

	height = A[i];
	length = 0;
	while (i < N && A[i] == height) {
	    i++;
	    length++;
	}

	intensity = height * length;
	if (intensity > answer)
	    answer = intensity;
    }

    fprintf(out_file, "%d\n", answer);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
