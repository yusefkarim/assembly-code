#include<stdio.h>

int f(void);
int g(void);
int h(void);

int main(void)
{
    printf("Function f returned %d\n", f());
    printf("Function g returned %d\n", g());
    printf("Function h returned %d\n", h());

    return 0;
}
