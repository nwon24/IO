#define IN_FILE "cookiesin.txt"
#define OUT_FILE "cookiesout.txt"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main(void)
{

    int C0;
    int C1;
    int C2;
    int P1;
    int P2;
    int D;
    int cookies[5];

    int C;
    int P;

    bool f1_bought;
    bool f2_bought;

    int answer;

    FILE *in_file, *out_file;

    in_file = fopen(IN_FILE, "r");
    if (in_file == NULL) {
	fprintf(stderr, "Unable to open input file %s\n", IN_FILE);
	exit(EXIT_FAILURE);
    }
    out_file = fopen(OUT_FILE, "w");
    if (out_file == NULL) {
	fprintf(stderr, "Unable to open output file %s\n", OUT_FILE);
	exit(EXIT_FAILURE);
    };

    fscanf(in_file, "%d %d\n", &D, &C0);
    fscanf(in_file, "%d %d\n", &P1, &C1);
    fscanf(in_file, "%d %d\n", &P2, &C2);

    P = 0;
    C = C0;
    f1_bought = f2_bought = false;
    for (int i = 0; i < D; i++) {
	P += C;
	if (f1_bought == false && P >= P1) {

	    P -= P1;
	    C += C1;
	    f1_bought = true;
	}
	if (f1_bought == true && f2_bought == false && P >= P2) {

	    P -= P2;
	    C += C2;
	    f2_bought = true;
	}
    }
    cookies[0] = P;

    P = 0;
    C = C0;
    f1_bought = f2_bought = false;
    for (int i = 0; i < D; i++) {
	P += C;
	if (f2_bought == true && f1_bought == false && P >= P1) {

	    P -= P1;
	    C += C1;
	    f1_bought = true;
	}

	if (f2_bought == false && P >= P2) {

	    P -= P2;
	    C += C2;
	    f2_bought = true;
	}
    }
    cookies[1] = P;

    P = 0;
    C = C0;
    f1_bought = f2_bought = false;
    for (int i = 0; i < D; i++) {
	P += C;
	if (f1_bought == false && P >= P1) {

	    P -= P1;
	    C += C1;
	    f1_bought = true;
	}
    }
    cookies[2] = P;

    P = 0;
    C = C0;
    f1_bought = f2_bought = false;
    for (int i = 0; i < D; i++) {
	P += C;
	if (f2_bought == false && P >= P2) {

	    P -= P2;
	    C += C2;
	    f2_bought = true;
	}
    }
    cookies[3] = P;

    cookies[4] = D * C0;

    answer = 0;
    for (int i = 0; i < 5; i++) {
	if (cookies[i] > answer) {
	    answer = cookies[i];
	}
    }

    fprintf(out_file, "%d\n", answer);

    fclose(in_file);
    fclose(out_file);

    return 0;
}
