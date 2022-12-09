#define DAYS_MAX 100000
#define IN_FILE "spacein.txt"
#define OUT_FILE "spaceout.txt"

#include <stdio.h>
int main(void)
{

    int N, F;
    int C[DAYS_MAX];
    int answer = -1;

    FILE *in_file, *out_file;

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");
    fscanf(in_file, "%d %d\n", &N, &F);
    for (int i = 0; i < N; i++)
	fscanf(in_file, "%d\n", &C[i]);

    struct point {
	int index;
	int val;
    };
    struct point start_points[DAYS_MAX];
    struct point end_points[DAYS_MAX];
    int start_index = 0;
    int end_index = 0;

    for (int i = 0; i < N; i++) {
	if (start_index == 0 || C[i] < start_points[start_index - 1].val) {
	    start_points[start_index].index = i;
	    start_points[start_index].val = C[i];
	    start_index++;
	}

    }

    for (int i = N - 1; i >= 0; i--) {
	if (end_index == 0 || C[i] < end_points[end_index - 1].val) {
	    end_points[end_index].index = i;
	    end_points[end_index].val = C[i];
	    end_index++;
	}
    }

    int prev_start = 0;
    for (int i = end_index - 1; i >= 0; i--) {
	while (prev_start < start_index &&
	       end_points[i].val + start_points[prev_start].val > F)
	    prev_start++;
	if (prev_start < start_index &&
	    end_points[i].val + start_points[prev_start].val <= F) {
	    int tmp =
		end_points[i].index - start_points[prev_start].index + 1;
	    if (tmp > answer)
		answer = tmp;
	}
    }
    if (answer == 1)
	answer = -1;

    fprintf(out_file, "%d\n", answer);
    fclose(in_file);
    fclose(out_file);

    return 0;
}
