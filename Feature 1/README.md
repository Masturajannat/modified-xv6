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

## Main Modified Files

- `proc.h` - Adds per-process MLFQ fields such as priority and tick count.
- `proc.c` - Initializes MLFQ fields and changes the scheduler to scan queues by priority.
- `trap.c` - Uses timer interrupts to count CPU ticks and demote CPU-bound processes.
- `Makefile` - Adds the MLFQ test program to the xv6 filesystem image.
- `mlfqtest.c` - User-level test program for demonstrating scheduler behavior.

## Test Program

The user program `mlfqtest.c` uses `fork()` to create two types of behavior:

- CPU-bound child process: performs heavy computation without sleeping.
- I/O-bound parent process: sleeps frequently and gives up the CPU.

Expected behavior:

- The CPU-bound child is demoted from Queue 0 to Queue 1 and then Queue 2.
- The sleeping parent remains in Queue 0 or Queue 1 more often.

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
```

## Result

This feature demonstrates that xv6 can schedule processes based on behavior. CPU-heavy processes are gradually moved to lower priority queues, while interactive or sleeping processes receive faster CPU access.
