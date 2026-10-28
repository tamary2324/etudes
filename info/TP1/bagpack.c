#include <stdio.h>
#include <stdlib.h>





// dp[i][j+1] = max(dp[i-w[j+1]][j] + v[j+1], dp[i][j])
// dp[i+1][j] = max(for k = 0 -> (i+1)/2 : dp[i+1-k][j] + dp[k][j])
// dp[0][0] = 0;

int knapsack(int C, int n, int *w, int *v){
    int** m = (int**)malloc(sizeof(int*)*(C+1));
    for (int i=0; i<=C; i++){
        m[i] = (int*)malloc(sizeof(int)*n);
        m[i][0] = 0;
        for (int j = 1; j<n; j++){
            if (i-w[j] >= 0 && m[i-w[j]][j-1] + v[j] > m[i][j-1])
                m[i][j] = m[i-w[j]][j-1] + v[j];
            else 
                m[i][j] = m[i][j-1];
        }
    }
    return m[C][n-1];
}


int main() {
    int C = 5;
    int n = 3;
    int w[3] = {5, 2, 3};
    int v[3] = {10, 6, 5};
    printf("%d\n", knapsack(C, n, w, v));

    return 0;
}
