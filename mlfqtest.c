#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  int pid = fork();

  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  if(pid == 0){
    int i, j;
    printf(1, "CPU-bound child started\n");

    for(i = 0; i < 20; i++){
      for(j = 0; j < 10000000; j++){
      }
      printf(1, "CPU child loop %d\n", i);
    }

    exit();
  } else {
    int i;
    printf(1, "I/O-bound parent started\n");

    for(i = 0; i < 20; i++){
      printf(1, "Parent sleep loop %d\n", i);
      sleep(10);
    }

    wait();
    exit();
  }
}
