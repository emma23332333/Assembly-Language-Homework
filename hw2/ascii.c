/* ascii.c */
#include <stdio.h>
int main(void)
{
    char c = 'a';
    int row, col;
    for (row = 0; row < 2; row++) {        
        for (col = 0; col < 13; col++) {  
            putchar(c);          
            putchar(' ');        
            c++;                       
        }
        putchar('\n');     
    }
    return 0;
}
