#include <stdio.h>

int recherche(char *m, char *text){
   int i,j = 0;
   while (text[i] != '\0'){
      if (m[j] == '\0') 
         break;
      if (m[j] == text[i]){
         i++;
         j++;
      }
      else{
         i = i-j+1;
         j=0;
      }
   }
   if (m[j] == '\0')
      return i-j;
   else 
      return -1;
}


int main() {
   char* m = "jem";
   char* text = "je joue a lol tout les jours !"; 
   printf("%d\n", recherche(m, text));
   return 0;
}