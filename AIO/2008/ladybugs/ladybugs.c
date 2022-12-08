#include <stdio.h>

int main(void)
{
    int N;
    int min, max;

    freopen("ladyin.txt", "r", stdin);
    freopen("ladyout.txt", "w", stdout);
    max = 0;
    min = 1000000001;
    scanf("%d\n", &N);
    for (int i = 0; i < N; i++) {
	int p;

	scanf("%d\n", &p);
	if (p > max)
	    max = p;
	if (p < min)
	    min = p;
    }
    printf("%d\n", max - min + 1);
    return 0;
}
