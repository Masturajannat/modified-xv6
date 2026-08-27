#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void
show(char *label, int fd)
{
  struct fdinfo info;

  if(fdinfo(fd, &info) < 0){
    printf(1, "%s: fdinfo failed\n", label);
    return;
  }

  printf(1, "%s: fd=%d type=%d size=%d off=%d r=%d w=%d\n",
         label, info.fd, info.filetype, info.size,
         info.off, info.readable, info.writable);
}

int
main(void)
{
  int fd;
  int pfd[2];
  char buf[20];

  char msg[] = "Operating Systems CSE323 fdinfo test message";

  fd = open("fdinfo_demo.txt", O_CREATE | O_RDWR);
  show("after create", fd);

  write(fd, msg, strlen(msg));
  show("after first write", fd);

  write(fd, msg, strlen(msg));
  show("after second write", fd);

  close(fd);

  fd = open("fdinfo_demo.txt", O_RDONLY);
  show("after reopen read-only", fd);

  read(fd, buf, 10);
  show("after read 10 bytes", fd);

  close(fd);

  pipe(pfd);
  show("pipe read end", pfd[0]);
  show("pipe write end", pfd[1]);

  close(pfd[0]);
  close(pfd[1]);

  if(fdinfo(-1, 0) < 0)
    printf(1, "invalid fd test: passed\n");

  exit();
}

