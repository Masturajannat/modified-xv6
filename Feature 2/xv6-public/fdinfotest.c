#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void
print_fdinfo(int fd, struct fdinfo *info)
{
  printf(1, "--- FD %d Information ---\n", fd);
  printf(1, "Type: %s (%d)\n",
         info->type == FD_TYPE_INODE ? "INODE" :
         info->type == FD_TYPE_PIPE ? "PIPE" : "NONE",
         info->type);
  printf(1, "Readable: %d, Writable: %d\n", info->readable, info->writable);
  if(info->type == FD_TYPE_INODE){
    printf(1, "Dev: %d, Inode: %d, Links: %d, Size: %d bytes, Offset: %d bytes\n",
           info->dev, info->inum, info->nlink, info->size, info->off);
  }
}

void
test_standard_fds(void)
{
  struct fdinfo info;

  printf(1, "\n[Test 1] Standard File Descriptors (0, 1, 2)...\n");

  if(fdinfo(0, &info) < 0){
    printf(1, "FAIL: fdinfo(0) failed\n");
    return;
  }
  print_fdinfo(0, &info);

  if(fdinfo(1, &info) < 0){
    printf(1, "FAIL: fdinfo(1) failed\n");
    return;
  }
  print_fdinfo(1, &info);

  printf(1, "PASS: Standard file descriptors inspected successfully.\n");
}

void
test_file_lifecycle(void)
{
  struct fdinfo info;
  int fd;
  char buf[32];

  printf(1, "\n[Test 2] Regular File Lifecycle and Offset Tracking...\n");

  unlink("fdinfo_demo.txt");
  fd = open("fdinfo_demo.txt", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "FAIL: open fdinfo_demo.txt failed\n");
    return;
  }

  if(fdinfo(fd, &info) < 0){
    printf(1, "FAIL: fdinfo initial failed\n");
    close(fd);
    return;
  }
  printf(1, "Initial file state (after creation):\n");
  print_fdinfo(fd, &info);

  if(info.off != 0 || info.size != 0 || !info.readable || !info.writable){
    printf(1, "FAIL: unexpected initial values: off=%d size=%d r=%d w=%d\n",
           info.off, info.size, info.readable, info.writable);
  }

  // Write 25 bytes
  char msg[] = "Operating Systems CSE323!";
  write(fd, msg, 25);

  if(fdinfo(fd, &info) < 0){
    printf(1, "FAIL: fdinfo after write failed\n");
    close(fd);
    return;
  }
  printf(1, "\nAfter writing 25 bytes:\n");
  print_fdinfo(fd, &info);

  if(info.off != 25 || info.size != 25){
    printf(1, "FAIL: offset/size mismatch after write: off=%d size=%d\n",
           info.off, info.size);
  }

  close(fd);

  // Reopen read-only
  fd = open("fdinfo_demo.txt", O_RDONLY);
  if(fd < 0){
    printf(1, "FAIL: open read-only failed\n");
    return;
  }

  read(fd, buf, 10);
  if(fdinfo(fd, &info) < 0){
    printf(1, "FAIL: fdinfo after read failed\n");
    close(fd);
    return;
  }
  printf(1, "\nAfter reopening O_RDONLY and reading 10 bytes:\n");
  print_fdinfo(fd, &info);

  if(info.off != 10 || info.size != 25 || !info.readable || info.writable){
    printf(1, "FAIL: read-only offset/permission mismatch: off=%d size=%d r=%d w=%d\n",
           info.off, info.size, info.readable, info.writable);
  }

  close(fd);
  unlink("fdinfo_demo.txt");
  printf(1, "PASS: File lifecycle and offset tracking verified.\n");
}

void
test_pipes(void)
{
  struct fdinfo info;
  int pfd[2];

  printf(1, "\n[Test 3] Pipe Descriptors...\n");

  if(pipe(pfd) < 0){
    printf(1, "FAIL: pipe creation failed\n");
    return;
  }

  // Check read end
  if(fdinfo(pfd[0], &info) < 0 || info.type != FD_TYPE_PIPE || !info.readable || info.writable){
    printf(1, "FAIL: pipe read-end info invalid: type=%d r=%d w=%d\n",
           info.type, info.readable, info.writable);
  } else {
    print_fdinfo(pfd[0], &info);
  }

  // Check write end
  if(fdinfo(pfd[1], &info) < 0 || info.type != FD_TYPE_PIPE || info.readable || !info.writable){
    printf(1, "FAIL: pipe write-end info invalid: type=%d r=%d w=%d\n",
           info.type, info.readable, info.writable);
  } else {
    print_fdinfo(pfd[1], &info);
  }

  close(pfd[0]);
  close(pfd[1]);
  printf(1, "PASS: Pipe descriptors verified.\n");
}

void
test_error_cases(void)
{
  struct fdinfo info;

  printf(1, "\n[Test 4] Error Handling & Boundary Cases...\n");

  if(fdinfo(-1, &info) != -1){
    printf(1, "FAIL: fdinfo(-1) did not return -1\n");
  } else {
    printf(1, "PASS: Negative fd (-1) rejected properly.\n");
  }

  if(fdinfo(99, &info) != -1){
    printf(1, "FAIL: fdinfo(99) did not return -1\n");
  } else {
    printf(1, "PASS: Out-of-bounds fd (99) rejected properly.\n");
  }

  if(fdinfo(1, (struct fdinfo*)0) != -1){
    printf(1, "FAIL: fdinfo with null pointer did not return -1\n");
  } else {
    printf(1, "PASS: Null pointer buffer rejected properly.\n");
  }
}

int
main(void)
{
  printf(1, "========================================\n");
  printf(1, " Running fdinfo() System Call Test Suite\n");
  printf(1, "========================================\n");

  test_standard_fds();
  test_file_lifecycle();
  test_pipes();
  test_error_cases();

  printf(1, "\n========================================\n");
  printf(1, " ALL FDINFO TESTS COMPLETED SUCCESSFULLY\n");
  printf(1, "========================================\n");
  exit();
}
