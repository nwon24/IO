#define IN_FILE "piratein.txt"
#define OUT_FILE "pirateout.txt" \

#include <stdio.h>
int main(void)
{

    FILE *in_file, *out_file;

    int L, X, Y;
    int answer;

    in_file = fopen(IN_FILE, "r");
    out_file = fopen(OUT_FILE, "w");

    fscanf(in_file, "%d\n", &L);
    fscanf(in_file, "%d\n", &X);
    fscanf(in_file, "%d\n", &Y);

    int west, east;
    west = X + Y;
    east = (L - X) + (L - Y);
    answer = (west < east) ? west : east;

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
