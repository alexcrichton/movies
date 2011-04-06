#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>

#define N 7000
#define M 200

int max = 0, n = 0;
int adj[N][M];
int adjl[N];
int used[N];

int path[400];
int maxpath[400];
int done;

int is_file(char *name) {
  FILE *f;

  if ((f = fopen(name, "r")) != NULL) {
    fclose(f);
    return 1;
  }

  return 0;
}

void record_max() {
  char fname[100];
  int i;
  sprintf(fname, "max/max-%04d", max);

  if (is_file(fname)) {
    return;
  }

  FILE *f = fopen(fname, "wb");

  for (i = 0; i < max; i++) {
    fprintf(f, "%d ", path[i]);
  }
  
  fclose(f);
}

int traverse(int cur, int depth) {
  int i;

  if (used[cur] || done) return;
  used[cur] = 1;
  path[depth] = cur;

  if (depth > max) {
    max = depth;
    record_max();
  }

  for (i = 0; i < adjl[cur]; i++) {
    traverse(adj[cur][i], depth + 1);
  }
  used[cur] = 0;
}

void sigalarm(int sig) {
  done = 1;
}

int main(int argc, char **argv) {
  int i, j;

  if (argc <= 2) {
    printf("Usage: %s <start> <run-time>\n", argv[0]);
    exit(1);
  }

  int start = atol(argv[1]);
  int t = atol(argv[2]);

  FILE *f = fopen("adj.lst", "r");

  for (n = 0; fscanf(f, "%d", &adjl[n]) == 1; n++) {
    for (i = 0; i < adjl[n]; i++) {
      fscanf(f, "%d", &adj[n][i]);
    }
  }

  fclose(f);

  printf("Starting at node: %d\n", start);
  fflush(stdout);

  for (i = 0; i < adjl[start]; i++) {
    signal(SIGALRM, sigalarm);
    alarm(t);
    done = 0;

    used[start] = 1;
    traverse(adj[start][i], 1);
    memset(used, 0, sizeof(used));

    printf("\tmax so far: %d, switching...\n", max);
    fflush(stdout);
  }

  return 0;
}