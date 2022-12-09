#define IN_FILE "baublesin.txt"
#define OUT_FILE "baublesout.txt"

#include <stdio.h>
#include <stdlib.h>

int main(void)
{

    int olaf_red;
    int olaf_blue;
    int spare;
    int order_red;
    int order_blue;

    int red_needed;
    int blue_needed;

    int answer;

    FILE *in_file;
    FILE *out_file;

    in_file = fopen(IN_FILE, "r");
    if (in_file == NULL) {
	fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
	exit(1);
    }
    out_file = fopen(OUT_FILE, "w");
    if (out_file == NULL) {
	fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
	exit(1);
    }

    fscanf(in_file, "%d %d %d %d %d\n", &olaf_red, &olaf_blue, &spare,
	   &order_red, &order_blue);

    answer = 0;

    red_needed = order_red - olaf_red;
    blue_needed = order_blue - olaf_blue;

    if (red_needed <= 0 && blue_needed <= 0) {
	if (order_red == 0) {
	    answer += -blue_needed + 1;
	    olaf_blue -= answer;
	} else if (order_blue == 0) {
	    answer += -red_needed + 1;
	    olaf_red -= answer;
	} else if (red_needed > blue_needed) {
	    answer += -red_needed + 1;
	    olaf_red -= answer;
	} else {
	    answer += -blue_needed + 1;
	    olaf_blue -= answer;
	}
    };

    int spare_needed;
    red_needed = order_red - olaf_red;
    blue_needed = order_blue - olaf_blue;
    spare_needed = 0;
    if (red_needed > 0)
	spare_needed += red_needed;
    if (blue_needed > 0)
	spare_needed += blue_needed;
    if (spare_needed <= spare && spare != 0)
	answer += spare - spare_needed + 1;

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
