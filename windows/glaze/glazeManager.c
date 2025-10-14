#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
char *command = "glazewm sub -e window_managed";
void flip(void) { system("glazewm command toggle-tiling-direction"); }

void handler(char *cmdOutput) {
  static char *key = "\"tilingSize\":";
  char *found = strstr(cmdOutput, key);
  if (found) {
    found += strlen(key);
    double value = strtod(found, NULL);
    if (value <= .7) {
      flip();
    }
    printf("found %f\n", value);
  }
}
int main(void) {
  FILE *infile = NULL;
  FILE *outfile = NULL;
  if ((infile = popen(command, "r")) == NULL) {
    printf("failed to open pipe\n");
    exit(1);
  }

  //  if ((outfile = fopen("out.json", "w")) == NULL) {
  //    printf("failed to open pipe\n");
  //    exit(1);
  // }
  char result[1024];
  while (fgets(result, 1024, infile)) {
     // if ((outfile = fopen("out.json", "a")) == NULL) {
     //   printf("failed to open pipe\n");
     //   exit(1);
     // }
    handler(result);
    // fprintf(outfile, result);
  }
  fclose(infile);
  return 0;
}
