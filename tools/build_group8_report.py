from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_JUSTIFY
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    BaseDocTemplate,
    Frame,
    PageBreak,
    PageTemplate,
    Paragraph,
    Preformatted,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "output" / "pdf" / "Group8_report.pdf"


def page_frame(canvas, doc):
    canvas.saveState()
    canvas.setFont("Times-Roman", 9)
    canvas.setFillColor(colors.HexColor("#555555"))
    canvas.drawString(0.72 * inch, 0.38 * inch, "CSE323 Project Report - Group 8")
    canvas.drawRightString(A4[0] - 0.72 * inch, 0.38 * inch, f"Page {doc.page}")
    canvas.setStrokeColor(colors.HexColor("#AAAAAA"))
    canvas.setLineWidth(0.3)
    canvas.line(0.72 * inch, 0.58 * inch, A4[0] - 0.72 * inch, 0.58 * inch)
    canvas.restoreState()


def document():
    doc = BaseDocTemplate(
        str(OUT),
        pagesize=A4,
        leftMargin=0.72 * inch,
        rightMargin=0.72 * inch,
        topMargin=0.68 * inch,
        bottomMargin=0.75 * inch,
    )
    frame = Frame(doc.leftMargin, doc.bottomMargin, doc.width, doc.height, id="main")
    doc.addPageTemplates([PageTemplate(id="main", frames=[frame], onPage=page_frame)])
    return doc


styles = getSampleStyleSheet()
styles.add(
    ParagraphStyle(
        name="ReportTitle",
        parent=styles["Title"],
        fontName="Times-Bold",
        fontSize=17,
        leading=21,
        alignment=TA_CENTER,
        spaceAfter=8,
    )
)
styles.add(
    ParagraphStyle(
        name="ReportSubtitle",
        parent=styles["Normal"],
        fontName="Times-Roman",
        fontSize=10.5,
        leading=13,
        alignment=TA_CENTER,
        spaceAfter=12,
    )
)
styles.add(
    ParagraphStyle(
        name="SectionTitle",
        parent=styles["Heading2"],
        fontName="Times-Bold",
        fontSize=12.5,
        leading=15,
        spaceBefore=9,
        spaceAfter=5,
    )
)
styles.add(
    ParagraphStyle(
        name="SubsectionTitle",
        parent=styles["Heading3"],
        fontName="Times-Bold",
        fontSize=10.5,
        leading=13,
        spaceBefore=6,
        spaceAfter=3,
    )
)
styles.add(
    ParagraphStyle(
        name="Body",
        parent=styles["BodyText"],
        fontName="Times-Roman",
        fontSize=9.7,
        leading=12.6,
        alignment=TA_JUSTIFY,
        spaceAfter=5,
    )
)
styles.add(
    ParagraphStyle(
        name="Mono",
        fontName="Courier",
        fontSize=7.0,
        leading=8.2,
        spaceBefore=3,
        spaceAfter=5,
    )
)


def p(text, style="Body"):
    return Paragraph(text, styles[style])


def section(text):
    return p(text, "SectionTitle")


def subsection(text):
    return p(text, "SubsectionTitle")


def code(text):
    tbl = Table(
        [[Preformatted(text.strip("\n"), styles["Mono"])]],
        colWidths=[6.85 * inch],
    )
    tbl.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#F7F7F7")),
                ("BOX", (0, 0), (-1, -1), 0.35, colors.HexColor("#B8B8B8")),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 5),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
            ]
        )
    )
    return tbl


def table(rows, widths):
    tbl = Table(rows, colWidths=widths, hAlign="LEFT")
    tbl.setStyle(
        TableStyle(
            [
                ("FONTNAME", (0, 0), (-1, 0), "Times-Bold"),
                ("FONTNAME", (0, 1), (-1, -1), "Times-Roman"),
                ("FONTSIZE", (0, 0), (-1, -1), 8.7),
                ("LEADING", (0, 0), (-1, -1), 10.5),
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#ECECEC")),
                ("GRID", (0, 0), (-1, -1), 0.3, colors.HexColor("#888888")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 4),
                ("RIGHTPADDING", (0, 0), (-1, -1), 4),
                ("TOPPADDING", (0, 0), (-1, -1), 4),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
            ]
        )
    )
    return tbl


story = []

story.append(p("Enhancing xv6 with an MLFQ Scheduler", "ReportTitle"))
story.append(
    p(
        "CSE323 Project Report - Group 8<br/>"
        "Feature 1: Multi-Level Feedback Queue CPU Scheduling",
        "ReportSubtitle",
    )
)

story.append(section("1. Project Goals"))
story.append(
    p(
        "This report describes the implementation and validation of Feature 1: a Multi-Level "
        "Feedback Queue (MLFQ) scheduler in xv6. The goal is to replace xv6's default "
        "round-robin scheduling behavior with an adaptive scheduler that reacts to process "
        "execution patterns."
    )
)
story.append(
    p(
        "The default xv6 scheduler scans the process table and runs RUNNABLE processes in a "
        "simple round-robin style. It does not distinguish between CPU-bound processes that "
        "consume long CPU bursts and I/O-bound or interactive processes that sleep frequently. "
        "The added MLFQ scheduler improves the kernel by giving short or interactive tasks "
        "higher priority while gradually moving CPU-heavy tasks to lower-priority queues."
    )
)
story.append(
    table(
        [
            ["Queue", "Priority", "Time Slice", "Role"],
            ["Queue 0", "Highest", "1 tick", "New and interactive processes start here."],
            ["Queue 1", "Medium", "2 ticks", "Processes demoted once run here."],
            ["Queue 2", "Lowest", "8 ticks", "Long-running CPU-bound work runs here."],
        ],
        [0.9 * inch, 1.0 * inch, 1.0 * inch, 3.95 * inch],
    )
)
story.append(Spacer(1, 5))
story.append(
    p(
        "A starvation-prevention rule is also included: after every 100 global timer ticks, "
        "all processes are promoted back to Queue 0 and their per-queue tick counters are reset."
    )
)

story.append(section("2. Modifications"))
story.append(
    p(
        "The implementation required changes to process metadata, process initialization, "
        "scheduler selection, timer-interrupt handling, and user-level testing support. No new "
        "system call is required for Feature 1; existing xv6 mechanisms such as fork(), sleep(), "
        "wait(), timer interrupts, and yield() are sufficient to demonstrate the scheduler."
    )
)

story.append(subsection("2.1 Kernel Data Structure Changes"))
story.append(
    p(
        "The process structure was extended with two fields. The priority field records the "
        "current MLFQ queue, and ticks records how many CPU ticks the process has consumed in "
        "that queue."
    )
)
story.append(
    code(
        """
// proc.h, inside struct proc
int priority;   // current queue: 0, 1, or 2
int ticks;      // ticks consumed at current priority
"""
    )
)

story.append(subsection("2.2 Process Initialization"))
story.append(
    p(
        "Every newly allocated process begins in Queue 0 with zero consumed ticks. This ensures "
        "that new work initially receives the best response time."
    )
)
story.append(
    code(
        """
// proc.c, inside allocproc(), after p->pid = nextpid++;
p->priority = 0;
p->ticks = 0;
"""
    )
)

story.append(subsection("2.3 Global Boost Counter"))
story.append(
    p(
        "A global counter named total tracks elapsed scheduler ticks for priority boosting. "
        "It is defined in proc.c and referenced from trap.c."
    )
)
story.append(
    code(
        """
// proc.c
int nextpid = 1;
int total = 0;   // global counter for priority boosting

// trap.c
extern int total;
"""
    )
)

story.append(subsection("2.4 Priority-Based Scheduler"))
story.append(
    p(
        "The scheduler was changed to scan Queue 0 first, then Queue 1, and finally Queue 2. "
        "A lower queue is considered only after the scheduler checks higher queues. Before each "
        "scan, the scheduler also checks whether the global boost threshold has been reached."
    )
)
story.append(
    code(
        """
// proc.c, inside scheduler(), after acquire(&ptable.lock)
if(total >= 100){
  struct proc *pr;
  for(pr = ptable.proc; pr < &ptable.proc[NPROC]; pr++){
    pr->priority = 0;
    pr->ticks = 0;
  }
  total = 0;
  cprintf("MLFQ boost: all processes moved to queue 0\\n");
}

for(q = 0; q < 3; q++){
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state != RUNNABLE)
      continue;
    if(p->priority != q)
      continue;

    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;
    cprintf("pid %d running in queue %d\\n", p->pid, p->priority);
    swtch(&(c->scheduler), p->context);
    switchkvm();
    c->proc = 0;
  }
}
"""
    )
)

story.append(subsection("2.5 Timer Interrupt Feedback and Demotion"))
story.append(
    p(
        "Timer interrupts provide feedback about CPU usage. Each running process increments its "
        "own tick counter, and the global total counter is incremented for boosting. If a process "
        "uses its full queue time slice, it is demoted."
    )
)
story.append(
    code(
        """
// trap.c, timer interrupt section
if(myproc() && myproc()->state == RUNNING &&
   tf->trapno == T_IRQ0+IRQ_TIMER){

  myproc()->ticks++;
  total++;

  if(myproc()->priority == 0 && myproc()->ticks >= 1){
    myproc()->priority = 1;
    myproc()->ticks = 0;
    yield();
  } else if(myproc()->priority == 1 && myproc()->ticks >= 2){
    myproc()->priority = 2;
    myproc()->ticks = 0;
    yield();
  } else if(myproc()->priority == 2 && myproc()->ticks >= 8){
    myproc()->ticks = 0;
    yield();
  }
}
"""
    )
)

story.append(section("3. Evaluation"))
story.append(
    p(
        "The scheduler was evaluated with a user-level program named mlfqtest.c. The program "
        "uses fork() to create two different workloads. The parent behaves like an I/O-bound "
        "process by sleeping frequently, while the child behaves like a CPU-bound process by "
        "performing heavy computation."
    )
)
story.append(
    code(
        """
// mlfqtest.c
#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  int pid = fork();

  if(pid < 0){
    printf(1, "fork failed\\n");
    exit();
  }

  if(pid == 0){
    int i, j;
    printf(1, "CPU-bound child started\\n");
    for(i = 0; i < 20; i++){
      for(j = 0; j < 10000000; j++){
      }
      printf(1, "CPU child loop %d\\n", i);
    }
    exit();
  } else {
    int i;
    printf(1, "I/O-bound parent started\\n");
    for(i = 0; i < 20; i++){
      printf(1, "Parent sleep loop %d\\n", i);
      sleep(10);
    }
    wait();
    exit();
  }
}
"""
    )
)
story.append(
    table(
        [
            ["Observed Output", "Meaning"],
            ["pid 4 running in queue 0 -> queue 1 -> queue 2", "A CPU-bound process uses full slices and is demoted."],
            ["Parent sleep loop 0 ... 19", "The parent repeatedly sleeps, modeling an I/O-bound process."],
            ["MLFQ boost: all processes moved to queue 0", "The starvation-prevention boost fired after 100 global ticks."],
            ["pid 2 running in queue 0 after boost", "A previously lower-priority process received high priority again."],
        ],
        [2.7 * inch, 4.15 * inch],
    )
)
story.append(Spacer(1, 5))
story.append(
    p(
        "These outcomes demonstrate the required behavior: CPU-bound work is demoted step by "
        "step, interactive or sleeping work remains responsive, and priority boosting prevents "
        "long-running low-priority processes from starving."
    )
)

story.append(section("4. Conclusions"))
story.append(
    p(
        "Feature 1 was completed by replacing the original round-robin style scheduling behavior "
        "with an MLFQ scheduler using three queues, time slices of 1, 2, and 8 ticks, CPU-usage "
        "based demotion, and 100-tick priority boosting. The implementation connects timer "
        "interrupts, process metadata, and scheduler selection into one observable scheduling policy."
    )
)
story.append(
    p(
        "A limitation of this implementation is that the debug printing is intentionally verbose "
        "for demonstration. A production-style scheduler would avoid printing during every "
        "scheduling decision and would expose statistics through a cleaner system call instead. "
        "Future improvements could include per-process wait-time accounting, a statistics syscall, "
        "and less intrusive evaluation output."
    )
)
story.append(
    p(
        "For final submission, this report should be submitted with diff_report.txt. The diff "
        "report must compare the original and modified xv6 folders and include only .c and .h "
        "file differences, as required by the project guideline."
    )
)

story.append(PageBreak())
story.append(section("Appendix: Diff Report Command"))
story.append(
    p(
        "The required diff report can be generated from a temporary comparison repository after "
        "placing xv6-original and xv6-modified in the same parent directory."
    )
)
story.append(
    code(
        """
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
"""
    )
)


if __name__ == "__main__":
    OUT.parent.mkdir(parents=True, exist_ok=True)
    document().build(story)
    print(OUT)
