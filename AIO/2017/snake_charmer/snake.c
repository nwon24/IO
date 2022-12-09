
#include <stdio.h>

int x, y;

FILE *in_file, *out_file;

void calculate(void)
{
    if (x < 0) {
	fprintf(out_file, "L");
	if (x == -1 && y == 0)
	    return;
	x++;

	int tmp;
	tmp = x;
	x = y;
	y = -tmp;

    } else {
	fprintf(out_file, "R");
	if (x == 1 && y == 0)
	    return;
	x--;

	int tmp;
	tmp = x;
	x = -y;
	y = tmp;

    }
    calculate();
}

int main(void)
{

    in_file = fopen("snakein.txt", "r");
    out_file = fopen("snakeout.txt", "w");

    fscanf(in_file, "%d %d\n", &x, &y);
    calculate();

    fclose(in_file);
    fclose(out_file);
    return 0;
}
