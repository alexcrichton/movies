#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N 7000
#define M 100
#define M2 150

char words[N][M];
int num_words = 0;

int tokenize(char *s, int *arr) {
  int word, i, max = strlen(s);
  s[max - 1] = '\0';
  max--;
  
  char *end = s, *finish = s + max;
  
  for (word = 0; end < finish; word++) {
    while (*end != ' ' && *end != '\0') end++;
    *end = '\0';

    for (i = 0; i < num_words; i++) {
      if (strcmp(words[i], s) == 0) {
        arr[word] = i;
        break;
      }
    }

    if (i == num_words) {
      strcpy(words[i], s);
      arr[word] = num_words++;
    }

    *end = ' ';
    s = end + 1;
    end = s;
  }

  *(end - 1) = '\0';

  return word;
}

int connected(int *a, int alen, int *b, int blen) {
  int aend = alen - 1, i;

  while (aend >= 0) {
    for (i = 0; i < alen - aend && i < blen; i++) {
      if (a[aend + i] != b[i]) {
        break;
      } else if (i == alen - aend - 1 && i < blen) {
        return 1;
      }
    }

    aend--;
  }

  return 0;
}

int main() {
  char tokens[N][M];
  int codes[N][M];
  int lengths[N];
  int n, i, j;
  int c[N][M2];
  int conn_len[N];

  FILE *f = fopen("movies.lst", "r");

  for (n = 0; fgets(tokens[n], M, f); n++) {
    lengths[n] = tokenize(tokens[n], codes[n]);
  }

  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      if (i == j) { continue; }

      if (connected(codes[i], lengths[i], codes[j], lengths[j])) {
        if (conn_len[i] == M2) {
          printf("oh hoes noes!\n");
          exit(1);
        }

        // printf("Connected: '%s' and '%s'\n", tokens[i], tokens[j]);

        c[i][conn_len[i]++] = j;
      }
    }
  }

  for (i = 0; i < n; i++) {
    printf("%d ", conn_len[i]);
    for (j = 0; j < conn_len[i]; j++) {
      printf("%d ", c[i][j]);
    }
    printf("\n");
  }

  return 0;
}
