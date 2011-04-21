#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define N 7000
#define M 146

int max = 0, n = 0;
int adj[N][M];
int adjl[N];
int used[N];

int path[400];
int maxpath[400];
int done, t, maxdepth;

void sigalarm(int sig) {
  done = 1;
  printf("\tmax so far: %d, switching...\n", max);
  fflush(stdout);
}

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
  if (f == NULL) {
    printf("please 'mkdir max'\n");
    exit(1);
  }

  for (i = 0; i < max; i++) {
    fprintf(f, "%d ", path[i]);
  }
  
  fclose(f);
}

void traverse(int cur, int depth) {
  int i, l, n, d2 = depth + 1;

  if (done) return;

  if (depth > max) {
    max = depth;

    if (depth > 260) {
      record_max();
    }
  }

  if (depth == maxdepth) {
    signal(SIGALRM, sigalarm);
    alarm(t);
    done = 0;
  }

  l = adjl[cur];
  for (i = 0; i < l; i++) {
    n = adj[cur][i];
    if (used[n]) continue;

    used[n] = 1;
    path[depth] = n;
    traverse(n, d2);
    used[n] = 0;
  }

  if (depth == maxdepth) {
    alarm(10000);
    done = 0;
  }
}

int main(int argc, char **argv) {
  int i;

  if (argc <= 3) {
    printf("Usage: %s <start> <run-time> <timeout-depth>\n", argv[0]);
    exit(1);
  }

  int start = atol(argv[1]);
  t = atol(argv[2]);
  maxdepth = atol(argv[3]);

  FILE *f = fopen("adj.lst", "r");
  if (f == NULL) {
    printf("run 'make adjacent' first\n");
    exit(1);
  }

  for (n = 0; fscanf(f, "%d", &adjl[n]) == 1; n++) {
    for (i = 0; i < adjl[n]; i++) {
      fscanf(f, "%d", &adj[n][i]);
    }
  }

  fclose(f);

  printf("Starting at node: %d\n", start);
  fflush(stdout);

  used[start] = 1;
  path[0] = start;
  traverse(start, 1);

  return 0;
}
