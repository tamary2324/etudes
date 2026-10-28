#include <stdio.h>
#include <stdbool.h>

bool dichotomie(int e, int n, int t[n]){
    int m = n/2;
    while(n>0){
        if (t[m] == e)
            return true;
        n/=2;
        if (t[m]<e)
            m-=n;
        else 
            m+=n;
    }
    return false;
}


int main() {
    int e = -56;
    int n = 6;
    int t[6] = {-1, 2, 2, 7, 8, 9};
    printf("%d\n", dichotomie(e, n, t));
    return 0;
}
