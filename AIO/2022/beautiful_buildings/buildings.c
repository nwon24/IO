
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

int N;
int H[100005];
int answer;

FILE *in_file;
FILE *out_file;

int ugliness(int *heights)
{
    int sum = 0;
    for (int i = 0; i < N - 1; i++) {
	sum += abs(heights[i] - heights[i + 1]);
    }
    return sum;
}

int main(void)
{

    in_file = fopen("buildin.txt", "r");
    out_file = fopen("buildout.txt", "w");

    fscanf(in_file, "%d\n", &N);
    for (int i = 0; i < N; i++) {
	fscanf(in_file, "%d ", &H[i]);
    }

    int max_diff;
    int building_to_change;

    building_to_change = 1;
    max_diff = abs(H[0] - H[1]);
    for (int i = 1; i < N - 1; i++) {
	if ((H[i] < H[i - 1] && H[i] < H[i + 1])
	    || (H[i] > H[i - 1] && H[i] > H[i + 1])
	    ) {

	    int diff =
		abs(H[i - 1] - H[i]) + abs(H[i] - H[i + 1]) -
		abs(H[i - 1] - H[i + 1]);
	    if (diff > max_diff) {
		max_diff = diff;
		building_to_change = i + 1;
	    }
	}
    }
    if (abs(H[N - 1] - H[N - 2]) > max_diff) {
	max_diff = abs(H[N - 1] - H[N - 2]);
	building_to_change = N;
    }

    if (building_to_change == 1) {
	H[0] = H[1];
    } else if (building_to_change == N) {
	H[N - 1] = H[N - 2];
    } else {
	H[building_to_change - 1] = H[building_to_change];
    }
    answer = ugliness(H);

    fprintf(out_file, "%d\n", answer);

    return 0;
}
