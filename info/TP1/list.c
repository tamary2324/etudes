#include <stdio.h>
#include <stdlib.h>

typedef struct _list {
    struct _list* next;
    int val;
} list;

list* list_add(list *l, int e){
    list* new = (list*)malloc(sizeof(list));
    new->next = l;
    new->val = e;
    return new;
}

void print_list(list* l){
    printf("[");
    while(l != NULL){
        printf("%d", l->val);
        if (l->next != NULL)
            printf("; ");
        else
            printf("]\n");
        l = l->next;
    }
}

list* list_del(list* l){
    list* next = l->next;
    free(l);
    return next;
}


int main() {
    list* l = NULL;
    l = list_add(l, 7);
    l = list_add(l, -4);
    l = list_add(l, 5);
    l = list_del(l);
    print_list(l);
    return 0;
}

