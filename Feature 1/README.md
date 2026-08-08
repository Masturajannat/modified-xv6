# Feature 1: Multi-Level Feedback Queue Scheduler

This feature implements a Multi-Level Feedback Queue (MLFQ) scheduler in xv6. The goal is to improve the default round-robin scheduler by prioritizing short or interactive processes while gradually lowering the priority of CPU-bound processes.

## Overview

The scheduler uses three priority queues:

| Queue | Priority | Time Slice | Behavior |
| --- | --- | --- | --- |
| Queue 0 | Highest | 1 tick | New and interactive processes start here |
| Queue 1 | Medium | 2 ticks | Processes demoted once run here |
| Queue 2 | Lowest | 8 ticks | CPU-bound processes eventually run here |

Every new process begins in Queue 0. If a process uses its full time slice, it is treated as CPU-bound and demoted to a lower queue. If a process sleeps or yields frequently, it remains in a higher priority queue for better responsiveness.

## Priority Boosting

Priority boosting is added to prevent starvation. Without boosting, a long-running process could remain in Queue 2 for too long while higher-priority processes continue to run.

The implementation uses a global tick counter. After every 100 timer ticks:

- All processes are promoted back to Queue 0.
- Each process's consumed tick count is reset to 0.
- The global boost counter is reset.

This allows low-priority processes to periodically get another chance at the highest priority level.

## File Organization

The Feature 1 implementation is divided into kernel files and user files.

### Kernel Files

These files change the xv6 kernel behavior:

| File | Purpose |
| --- | --- |
| `proc.h` | Adds per-process MLFQ fields such as `priority` and `ticks`. |
| `proc.c` | Initializes each process at Queue 0, defines the global boost counter, boosts all processes every 100 ticks, and changes the scheduler to scan Queue 0, then Queue 1, then Queue 2. |
| `trap.c` | Uses timer interrupts to count CPU ticks, increment the global boost counter, and demote CPU-bound processes when they use their full time slice. |

### User Files

These files are used to test and run the feature from user space:

| File | Purpose |
| --- | --- |
| `mlfqtest.c` | User-level test program that creates CPU-bound and I/O-bound behavior using `fork()`. |
| `Makefile` | Adds `_mlfqtest` to `UPROGS` so the program is copied into the xv6 filesystem image. |

## Test Program

The user program `mlfqtest.c` uses `fork()` to create two types of behavior:

- CPU-bound child process: performs heavy computation without sleeping.
- I/O-bound parent process: sleeps frequently and gives up the CPU.

Expected behavior:

- The CPU-bound child is demoted from Queue 0 to Queue 1 and then Queue 2.
- The sleeping parent remains in Queue 0 or Queue 1 more often.
- After 100 global ticks, processes are boosted back to Queue 0.

## How to Run

From the xv6 project directory:

```bash
make clean
make qemu
```

Inside xv6, run:

```text
mlfqtest
```

Expected scheduler output includes messages showing process IDs running in different queues, such as:

```text
pid 4 running in queue 0
pid 4 running in queue 1
pid 4 running in queue 2
MLFQ boost: all processes moved to queue 0
```

## Result

This feature demonstrates that xv6 can schedule processes based on behavior. CPU-heavy processes are gradually moved to lower priority queues, while interactive or sleeping processes receive faster CPU access. Priority boosting prevents starvation by periodically returning all processes to Queue 0.

## Diff Report

For a `diff_report.txt` comparing the original xv6 codebase with the modified xv6 codebase: The required diff should include only `.c` and `.h` files.

Example workflow:

```bash
mkdir compare_repo
cd compare_repo
git init

cp -r ../xv6-original/* .
git add .
git commit -m "original"

cp -r ../xv6-modified/* .
git add .
git commit -m "modified"

git diff HEAD~1 HEAD '*.c' '*.h' > ../diff_report.txt
```

For Feature 1, the diff report should include changes from files such as:

- `proc.h`
- `proc.c`
- `trap.c`
- `mlfqtest.c`

The `Makefile` change is needed to run the test program, but it may not appear in `diff_report.txt` because the guideline asks for only `.c` and `.h` files.
