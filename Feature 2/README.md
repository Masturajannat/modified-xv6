# Feature 2: File Descriptor Information System Call (`fdinfo`)

This feature implements a kernel-level file descriptor inspection system call named `fdinfo()` in xv6. The goal is to provide user-space processes with detailed runtime metadata regarding any open file descriptor, bridging user space with kernel-level data structures including the per-process open file table, system file table (`struct file`), and disk/memory inodes (`struct inode`).

## Overview

The `fdinfo()` system call takes an open file descriptor index and a pointer to a `struct fdinfo` allocated in user space. The kernel validates the descriptor, retrieves the corresponding file and inode state, and copies the metadata back to the user buffer.

### System Call Signature

```c
int fdinfo(int fd, struct fdinfo *info);
```

### Data Structure (`stat.h`)

```c
#define FD_TYPE_NONE  0
#define FD_TYPE_PIPE  1
#define FD_TYPE_INODE 2

struct fdinfo {
  int type;          // File type (FD_TYPE_NONE, FD_TYPE_PIPE, FD_TYPE_INODE)
  int dev;           // File system disk device number (for inodes)
  uint inum;         // Inode number (for inodes)
  short nlink;       // Number of hard links to file
  uint size;         // Size of file in bytes
  uint off;          // Current read/write file offset
  char readable;     // 1 if opened for reading, 0 otherwise
  char writable;     // 1 if opened for writing, 0 otherwise
};
```

## Kernel Implementation Details

1. **Descriptor Lookup (`sysfile.c`)**:
   - Uses `argfd(0, &fd, &f)` to safely extract the file descriptor and pointer to `struct file *f` from the calling process table (`myproc()->ofile[fd]`).
   - Ensures `0 <= fd < NOFILE` and that the file descriptor is currently allocated.

2. **Pointer & Memory Safety**:
   - Uses `argptr(1, (char**)&info, sizeof(*info))` to guarantee that the destination buffer is within the caller's valid address space.
   - Clears the destination buffer with `memset` before populating.

3. **Metadata Extraction & Concurrency Safety**:
   - Retrieves `f->readable` and `f->writable`.
   - **For Inodes (`FD_INODE`)**: Acquires the inode sleep lock via `ilock(f->ip)` to safely read `dev`, `inum`, `nlink`, `size`, and `off` (`f->off`), then releases the lock with `iunlock(f->ip)`.
   - **For Pipes (`FD_PIPE`)**: Marks `type = FD_TYPE_PIPE` and records read/write endpoint permissions.

4. **Error Handling**:
   - Returns `0` on success.
   - Returns `-1` on invalid descriptors, closed descriptors, or invalid user memory pointers.

## File Organization

| File | Purpose |
| --- | --- |
| `stat.h` | Defines `struct fdinfo` and `FD_TYPE_*` macros. |
| `syscall.h` | Defines `SYS_fdinfo` (number 23). |
| `syscall.c` | Registers `sys_fdinfo` handler in kernel dispatch table. |
| `sysfile.c` | Implements `sys_fdinfo()` kernel logic and inode locking. |
| `user.h` | Declares `struct fdinfo` and `fdinfo()` prototype for user space. |
| `usys.S` | Defines system call assembly trap entry for user programs. |
| `fdinfotest.c` | Comprehensive user test suite verifying files, offsets, pipes, and error cases. |
| `Makefile` | Adds `_fdinfotest` to `UPROGS`. |

## How to Run & Verify

From the xv6 directory:

```bash
make clean
make qemu
```

Inside xv6 shell, run:

```text
fdinfotest
```

### Expected Output

```text
========================================
 Running fdinfo() System Call Test Suite
========================================

[Test 1] Standard File Descriptors (0, 1, 2)...
--- FD 0 Information ---
Type: INODE (2)
Readable: 1, Writable: 0
Dev: 1, Inode: 1, Links: 1, Size: 0 bytes, Offset: 0 bytes
--- FD 1 Information ---
Type: INODE (2)
Readable: 0, Writable: 1
Dev: 1, Inode: 1, Links: 1, Size: 0 bytes, Offset: 0 bytes
PASS: Standard file descriptors inspected successfully.

[Test 2] Regular File Lifecycle and Offset Tracking...
Initial file state (after creation):
--- FD 3 Information ---
Type: INODE (2)
Readable: 1, Writable: 1
Dev: 1, Inode: 24, Links: 1, Size: 0 bytes, Offset: 0 bytes

After writing 25 bytes:
--- FD 3 Information ---
Type: INODE (2)
Readable: 1, Writable: 1
Dev: 1, Inode: 24, Links: 1, Size: 25 bytes, Offset: 25 bytes

After reopening O_RDONLY and reading 10 bytes:
--- FD 3 Information ---
Type: INODE (2)
Readable: 1, Writable: 0
Dev: 1, Inode: 24, Links: 1, Size: 25 bytes, Offset: 10 bytes
PASS: File lifecycle and offset tracking verified.

[Test 3] Pipe Descriptors...
--- FD 3 Information ---
Type: PIPE (1)
Readable: 1, Writable: 0
--- FD 4 Information ---
Type: PIPE (1)
Readable: 0, Writable: 1
PASS: Pipe descriptors verified.

[Test 4] Error Handling & Boundary Cases...
PASS: Negative fd (-1) rejected properly.
PASS: Out-of-bounds fd (99) rejected properly.
PASS: Null pointer buffer rejected properly.

========================================
 ALL FDINFO TESTS COMPLETED SUCCESSFULLY
========================================
```
