
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 56 11 80       	mov    $0x801156d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 31 10 80       	mov    $0x801031d0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 75 10 80       	push   $0x80107580
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 e5 45 00 00       	call   80104640 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 0d                	jmp    80100086 <binit+0x46>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
    b->next = bcache.head.next;
80100086:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100089:	83 ec 08             	sub    $0x8,%esp
8010008c:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008f:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100096:	68 87 75 10 80       	push   $0x80107587
8010009b:	50                   	push   %eax
8010009c:	e8 6f 44 00 00       	call   80104510 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a6:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a9:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ac:	89 d8                	mov    %ebx,%eax
801000ae:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b4:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000bf:	c9                   	leave
801000c0:	c3                   	ret
801000c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000cf:	00 

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 77 47 00 00       	call   80104860 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 4f                	jmp    8010016a <bread+0x9a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 1d                	jne    8010014b <bread+0x7b>
8010012e:	eb 7e                	jmp    801001ae <bread+0xde>
80100130:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100137:	00 
80100138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010013f:	00 
80100140:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100143:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100149:	74 63                	je     801001ae <bread+0xde>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010014e:	85 c0                	test   %eax,%eax
80100150:	75 ee                	jne    80100140 <bread+0x70>
80100152:	f6 03 04             	testb  $0x4,(%ebx)
80100155:	75 e9                	jne    80100140 <bread+0x70>
      b->dev = dev;
80100157:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010015a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010015d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100163:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010016a:	83 ec 0c             	sub    $0xc,%esp
8010016d:	68 20 a5 10 80       	push   $0x8010a520
80100172:	e8 89 46 00 00       	call   80104800 <release>
      acquiresleep(&b->lock);
80100177:	8d 43 0c             	lea    0xc(%ebx),%eax
8010017a:	89 04 24             	mov    %eax,(%esp)
8010017d:	e8 ce 43 00 00       	call   80104550 <acquiresleep>
      return b;
80100182:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100185:	f6 03 02             	testb  $0x2,(%ebx)
80100188:	74 0e                	je     80100198 <bread+0xc8>
    iderw(b);
  }
  return b;
}
8010018a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010018d:	89 d8                	mov    %ebx,%eax
8010018f:	5b                   	pop    %ebx
80100190:	5e                   	pop    %esi
80100191:	5f                   	pop    %edi
80100192:	5d                   	pop    %ebp
80100193:	c3                   	ret
80100194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100198:	83 ec 0c             	sub    $0xc,%esp
8010019b:	53                   	push   %ebx
8010019c:	e8 1f 22 00 00       	call   801023c0 <iderw>
801001a1:	83 c4 10             	add    $0x10,%esp
}
801001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801001a7:	89 d8                	mov    %ebx,%eax
801001a9:	5b                   	pop    %ebx
801001aa:	5e                   	pop    %esi
801001ab:	5f                   	pop    %edi
801001ac:	5d                   	pop    %ebp
801001ad:	c3                   	ret
  panic("bget: no buffers");
801001ae:	83 ec 0c             	sub    $0xc,%esp
801001b1:	68 8e 75 10 80       	push   $0x8010758e
801001b6:	e8 e5 01 00 00       	call   801003a0 <panic>
801001bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001c0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001c0:	55                   	push   %ebp
801001c1:	89 e5                	mov    %esp,%ebp
801001c3:	53                   	push   %ebx
801001c4:	83 ec 10             	sub    $0x10,%esp
801001c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801001cd:	50                   	push   %eax
801001ce:	e8 1d 44 00 00       	call   801045f0 <holdingsleep>
801001d3:	83 c4 10             	add    $0x10,%esp
801001d6:	85 c0                	test   %eax,%eax
801001d8:	74 0f                	je     801001e9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001da:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001dd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001e3:	c9                   	leave
  iderw(b);
801001e4:	e9 d7 21 00 00       	jmp    801023c0 <iderw>
    panic("bwrite");
801001e9:	83 ec 0c             	sub    $0xc,%esp
801001ec:	68 9f 75 10 80       	push   $0x8010759f
801001f1:	e8 aa 01 00 00       	call   801003a0 <panic>
801001f6:	66 90                	xchg   %ax,%ax
801001f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ff:	00 

80100200 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100200:	55                   	push   %ebp
80100201:	89 e5                	mov    %esp,%ebp
80100203:	56                   	push   %esi
80100204:	53                   	push   %ebx
80100205:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100208:	8d 73 0c             	lea    0xc(%ebx),%esi
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 43 00 00       	call   801045f0 <holdingsleep>
80100214:	83 c4 10             	add    $0x10,%esp
80100217:	85 c0                	test   %eax,%eax
80100219:	74 63                	je     8010027e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	56                   	push   %esi
8010021f:	e8 8c 43 00 00       	call   801045b0 <releasesleep>

  acquire(&bcache.lock);
80100224:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010022b:	e8 30 46 00 00       	call   80104860 <acquire>
  b->refcnt--;
80100230:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100233:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100236:	83 e8 01             	sub    $0x1,%eax
80100239:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 2c                	jne    8010026c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	8b 43 50             	mov    0x50(%ebx),%eax
80100246:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100249:	8b 53 54             	mov    0x54(%ebx),%edx
8010024c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010024f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100254:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010025b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010025e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100263:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100266:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010026c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100273:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100276:	5b                   	pop    %ebx
80100277:	5e                   	pop    %esi
80100278:	5d                   	pop    %ebp
  release(&bcache.lock);
80100279:	e9 82 45 00 00       	jmp    80104800 <release>
    panic("brelse");
8010027e:	83 ec 0c             	sub    $0xc,%esp
80100281:	68 a6 75 10 80       	push   $0x801075a6
80100286:	e8 15 01 00 00       	call   801003a0 <panic>
8010028b:	66 90                	xchg   %ax,%ax
8010028d:	66 90                	xchg   %ax,%ax
8010028f:	66 90                	xchg   %ax,%ax
80100291:	66 90                	xchg   %ax,%ax
80100293:	66 90                	xchg   %ax,%ax
80100295:	66 90                	xchg   %ax,%ax
80100297:	66 90                	xchg   %ax,%ax
80100299:	66 90                	xchg   %ax,%ax
8010029b:	66 90                	xchg   %ax,%ax
8010029d:	66 90                	xchg   %ax,%ax
8010029f:	90                   	nop

801002a0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002a0:	55                   	push   %ebp
801002a1:	89 e5                	mov    %esp,%ebp
801002a3:	57                   	push   %edi
801002a4:	56                   	push   %esi
801002a5:	53                   	push   %ebx
801002a6:	83 ec 18             	sub    $0x18,%esp
801002a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002af:	ff 75 08             	push   0x8(%ebp)
  target = n;
801002b2:	89 df                	mov    %ebx,%edi
  iunlock(ip);
801002b4:	e8 97 16 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
801002b9:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002c0:	e8 9b 45 00 00       	call   80104860 <acquire>
  while(n > 0){
801002c5:	83 c4 10             	add    $0x10,%esp
801002c8:	85 db                	test   %ebx,%ebx
801002ca:	0f 8e 94 00 00 00    	jle    80100364 <consoleread+0xc4>
    while(input.r == input.w){
801002d0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002db:	74 25                	je     80100302 <consoleread+0x62>
801002dd:	eb 59                	jmp    80100338 <consoleread+0x98>
801002df:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002e0:	83 ec 08             	sub    $0x8,%esp
801002e3:	68 20 ef 10 80       	push   $0x8010ef20
801002e8:	68 00 ef 10 80       	push   $0x8010ef00
801002ed:	e8 9e 3f 00 00       	call   80104290 <sleep>
    while(input.r == input.w){
801002f2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002f7:	83 c4 10             	add    $0x10,%esp
801002fa:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100300:	75 36                	jne    80100338 <consoleread+0x98>
      if(myproc()->killed){
80100302:	e8 39 38 00 00       	call   80103b40 <myproc>
80100307:	8b 48 24             	mov    0x24(%eax),%ecx
8010030a:	85 c9                	test   %ecx,%ecx
8010030c:	74 d2                	je     801002e0 <consoleread+0x40>
        release(&cons.lock);
8010030e:	83 ec 0c             	sub    $0xc,%esp
80100311:	68 20 ef 10 80       	push   $0x8010ef20
80100316:	e8 e5 44 00 00       	call   80104800 <release>
        ilock(ip);
8010031b:	5a                   	pop    %edx
8010031c:	ff 75 08             	push   0x8(%ebp)
8010031f:	e8 4c 15 00 00       	call   80101870 <ilock>
        return -1;
80100324:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100327:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010032a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010032f:	5b                   	pop    %ebx
80100330:	5e                   	pop    %esi
80100331:	5f                   	pop    %edi
80100332:	5d                   	pop    %ebp
80100333:	c3                   	ret
80100334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100338:	8d 50 01             	lea    0x1(%eax),%edx
8010033b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100341:	89 c2                	mov    %eax,%edx
80100343:	83 e2 7f             	and    $0x7f,%edx
80100346:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010034d:	80 f9 04             	cmp    $0x4,%cl
80100350:	74 37                	je     80100389 <consoleread+0xe9>
    *dst++ = c;
80100352:	83 c6 01             	add    $0x1,%esi
    --n;
80100355:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100358:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010035b:	83 f9 0a             	cmp    $0xa,%ecx
8010035e:	0f 85 64 ff ff ff    	jne    801002c8 <consoleread+0x28>
  release(&cons.lock);
80100364:	83 ec 0c             	sub    $0xc,%esp
80100367:	68 20 ef 10 80       	push   $0x8010ef20
8010036c:	e8 8f 44 00 00       	call   80104800 <release>
  ilock(ip);
80100371:	58                   	pop    %eax
80100372:	ff 75 08             	push   0x8(%ebp)
80100375:	e8 f6 14 00 00       	call   80101870 <ilock>
  return target - n;
8010037a:	89 f8                	mov    %edi,%eax
8010037c:	83 c4 10             	add    $0x10,%esp
}
8010037f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100382:	29 d8                	sub    %ebx,%eax
}
80100384:	5b                   	pop    %ebx
80100385:	5e                   	pop    %esi
80100386:	5f                   	pop    %edi
80100387:	5d                   	pop    %ebp
80100388:	c3                   	ret
      if(n < target){
80100389:	39 fb                	cmp    %edi,%ebx
8010038b:	73 d7                	jae    80100364 <consoleread+0xc4>
        input.r--;
8010038d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100392:	eb d0                	jmp    80100364 <consoleread+0xc4>
80100394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100398:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010039f:	00 

801003a0 <panic>:
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	53                   	push   %ebx
801003a4:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003a7:	fa                   	cli
  cons.locking = 0;
801003a8:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
801003af:	00 00 00 
  getcallerpcs(&s, pcs);
801003b2:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
801003b5:	e8 46 26 00 00       	call   80102a00 <lapicid>
801003ba:	83 ec 08             	sub    $0x8,%esp
801003bd:	50                   	push   %eax
801003be:	68 ad 75 10 80       	push   $0x801075ad
801003c3:	e8 08 03 00 00       	call   801006d0 <cprintf>
  cprintf(s);
801003c8:	58                   	pop    %eax
801003c9:	ff 75 08             	push   0x8(%ebp)
801003cc:	e8 ff 02 00 00       	call   801006d0 <cprintf>
  cprintf("\n");
801003d1:	c7 04 24 63 7a 10 80 	movl   $0x80107a63,(%esp)
801003d8:	e8 f3 02 00 00       	call   801006d0 <cprintf>
  getcallerpcs(&s, pcs);
801003dd:	8d 45 08             	lea    0x8(%ebp),%eax
801003e0:	5a                   	pop    %edx
801003e1:	59                   	pop    %ecx
801003e2:	53                   	push   %ebx
801003e3:	50                   	push   %eax
801003e4:	e8 77 42 00 00       	call   80104660 <getcallerpcs>
  for(i=0; i<10; i++)
801003e9:	83 c4 10             	add    $0x10,%esp
801003ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003f0:	83 ec 08             	sub    $0x8,%esp
801003f3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003f5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003f8:	68 c1 75 10 80       	push   $0x801075c1
801003fd:	e8 ce 02 00 00       	call   801006d0 <cprintf>
  for(i=0; i<10; i++)
80100402:	8d 45 f8             	lea    -0x8(%ebp),%eax
80100405:	83 c4 10             	add    $0x10,%esp
80100408:	39 c3                	cmp    %eax,%ebx
8010040a:	75 e4                	jne    801003f0 <panic+0x50>
  panicked = 1; // freeze other CPU
8010040c:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
80100413:	00 00 00 
  for(;;)
80100416:	eb fe                	jmp    80100416 <panic+0x76>
80100418:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010041f:	00 

80100420 <consputc.part.0>:
consputc(int c)
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
80100429:	3d 00 01 00 00       	cmp    $0x100,%eax
8010042e:	0f 84 cc 00 00 00    	je     80100500 <consputc.part.0+0xe0>
    uartputc(c);
80100434:	83 ec 0c             	sub    $0xc,%esp
80100437:	89 c3                	mov    %eax,%ebx
80100439:	50                   	push   %eax
8010043a:	e8 91 5c 00 00       	call   801060d0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100444:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100449:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044a:	ba d5 03 00 00       	mov    $0x3d5,%edx
8010044f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100450:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100453:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100458:	b8 0f 00 00 00       	mov    $0xf,%eax
8010045d:	c1 e1 08             	shl    $0x8,%ecx
80100460:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100461:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100466:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100467:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
8010046a:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010046d:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010046f:	83 fb 0a             	cmp    $0xa,%ebx
80100472:	75 74                	jne    801004e8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100474:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100479:	f7 e2                	mul    %edx
8010047b:	c1 ea 06             	shr    $0x6,%edx
8010047e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100481:	c1 e0 04             	shl    $0x4,%eax
80100484:	8d 78 50             	lea    0x50(%eax),%edi
  if(pos < 0 || pos > 25*80)
80100487:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010048d:	0f 8f 23 01 00 00    	jg     801005b6 <consputc.part.0+0x196>
  if((pos/80) >= 24){  // Scroll up.
80100493:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100499:	0f 8f c1 00 00 00    	jg     80100560 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010049f:	89 f8                	mov    %edi,%eax
  outb(CRTPORT+1, pos);
801004a1:	89 fb                	mov    %edi,%ebx
  crt[pos] = ' ' | 0x0700;
801004a3:	8d bc 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%edi
  outb(CRTPORT+1, pos>>8);
801004aa:	0f b6 f4             	movzbl %ah,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bd:	89 f0                	mov    %esi,%eax
801004bf:	ee                   	out    %al,(%dx)
801004c0:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c5:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004ca:	ee                   	out    %al,(%dx)
801004cb:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004d0:	89 d8                	mov    %ebx,%eax
801004d2:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d3:	b8 20 07 00 00       	mov    $0x720,%eax
801004d8:	66 89 07             	mov    %ax,(%edi)
}
801004db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004de:	5b                   	pop    %ebx
801004df:	5e                   	pop    %esi
801004e0:	5f                   	pop    %edi
801004e1:	5d                   	pop    %ebp
801004e2:	c3                   	ret
801004e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004e8:	0f b6 db             	movzbl %bl,%ebx
801004eb:	8d 78 01             	lea    0x1(%eax),%edi
801004ee:	80 cf 07             	or     $0x7,%bh
801004f1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004f8:	80 
801004f9:	eb 8c                	jmp    80100487 <consputc.part.0+0x67>
801004fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 c6 5b 00 00       	call   801060d0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ba 5b 00 00       	call   801060d0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ae 5b 00 00       	call   801060d0 <uartputc>
80100522:	b8 0e 00 00 00       	mov    $0xe,%eax
80100527:	ba d4 03 00 00       	mov    $0x3d4,%edx
8010052c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010052d:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100532:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100533:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100536:	ba d4 03 00 00       	mov    $0x3d4,%edx
8010053b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100540:	c1 e3 08             	shl    $0x8,%ebx
80100543:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100544:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100549:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010054a:	0f b6 c8             	movzbl %al,%ecx
    if(pos > 0) --pos;
8010054d:	83 c4 10             	add    $0x10,%esp
80100550:	09 d9                	or     %ebx,%ecx
80100552:	74 54                	je     801005a8 <consputc.part.0+0x188>
80100554:	8d 79 ff             	lea    -0x1(%ecx),%edi
80100557:	e9 2b ff ff ff       	jmp    80100487 <consputc.part.0+0x67>
8010055c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100560:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100563:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	8d bc 3f 60 7f 0b 80 	lea    -0x7ff480a0(%edi,%edi,1),%edi
  outb(CRTPORT+1, pos);
8010056d:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100572:	68 60 0e 00 00       	push   $0xe60
80100577:	68 a0 80 0b 80       	push   $0x800b80a0
8010057c:	68 00 80 0b 80       	push   $0x800b8000
80100581:	e8 8a 44 00 00       	call   80104a10 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100586:	b8 80 07 00 00       	mov    $0x780,%eax
8010058b:	83 c4 0c             	add    $0xc,%esp
8010058e:	29 d8                	sub    %ebx,%eax
80100590:	01 c0                	add    %eax,%eax
80100592:	50                   	push   %eax
80100593:	6a 00                	push   $0x0
80100595:	57                   	push   %edi
80100596:	e8 e5 43 00 00       	call   80104980 <memset>
  outb(CRTPORT+1, pos);
8010059b:	83 c4 10             	add    $0x10,%esp
8010059e:	e9 0a ff ff ff       	jmp    801004ad <consputc.part.0+0x8d>
801005a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801005a8:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
801005ad:	31 db                	xor    %ebx,%ebx
801005af:	31 f6                	xor    %esi,%esi
801005b1:	e9 f7 fe ff ff       	jmp    801004ad <consputc.part.0+0x8d>
    panic("pos under/overflow");
801005b6:	83 ec 0c             	sub    $0xc,%esp
801005b9:	68 c5 75 10 80       	push   $0x801075c5
801005be:	e8 dd fd ff ff       	call   801003a0 <panic>
801005c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801005c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801005cf:	00 

801005d0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 18             	sub    $0x18,%esp
801005d9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005dc:	ff 75 08             	push   0x8(%ebp)
801005df:	e8 6c 13 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
801005e4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005eb:	e8 70 42 00 00       	call   80104860 <acquire>
  for(i = 0; i < n; i++)
801005f0:	83 c4 10             	add    $0x10,%esp
801005f3:	85 f6                	test   %esi,%esi
801005f5:	7e 28                	jle    8010061f <consolewrite+0x4f>
801005f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005fa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005fd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100603:	85 d2                	test   %edx,%edx
80100605:	74 09                	je     80100610 <consolewrite+0x40>
  asm volatile("cli");
80100607:	fa                   	cli
    for(;;)
80100608:	eb fe                	jmp    80100608 <consolewrite+0x38>
8010060a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100610:	0f b6 03             	movzbl (%ebx),%eax
  for(i = 0; i < n; i++)
80100613:	83 c3 01             	add    $0x1,%ebx
80100616:	e8 05 fe ff ff       	call   80100420 <consputc.part.0>
8010061b:	39 fb                	cmp    %edi,%ebx
8010061d:	75 de                	jne    801005fd <consolewrite+0x2d>
  release(&cons.lock);
8010061f:	83 ec 0c             	sub    $0xc,%esp
80100622:	68 20 ef 10 80       	push   $0x8010ef20
80100627:	e8 d4 41 00 00       	call   80104800 <release>
  ilock(ip);
8010062c:	58                   	pop    %eax
8010062d:	ff 75 08             	push   0x8(%ebp)
80100630:	e8 3b 12 00 00       	call   80101870 <ilock>

  return n;
}
80100635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100638:	89 f0                	mov    %esi,%eax
8010063a:	5b                   	pop    %ebx
8010063b:	5e                   	pop    %esi
8010063c:	5f                   	pop    %edi
8010063d:	5d                   	pop    %ebp
8010063e:	c3                   	ret
8010063f:	90                   	nop

80100640 <printint>:
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	89 d3                	mov    %edx,%ebx
80100648:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010064b:	85 c0                	test   %eax,%eax
8010064d:	79 05                	jns    80100654 <printint+0x14>
8010064f:	83 e1 01             	and    $0x1,%ecx
80100652:	75 5d                	jne    801006b1 <printint+0x71>
80100654:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010065b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010065d:	31 f6                	xor    %esi,%esi
8010065f:	90                   	nop
    buf[i++] = digits[x % base];
80100660:	89 c8                	mov    %ecx,%eax
80100662:	31 d2                	xor    %edx,%edx
80100664:	89 f7                	mov    %esi,%edi
80100666:	f7 f3                	div    %ebx
80100668:	8d 76 01             	lea    0x1(%esi),%esi
  }while((x /= base) != 0);
8010066b:	39 d9                	cmp    %ebx,%ecx
    buf[i++] = digits[x % base];
8010066d:	0f b6 92 b4 7a 10 80 	movzbl -0x7fef854c(%edx),%edx
  }while((x /= base) != 0);
80100674:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
80100676:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
8010067a:	73 e4                	jae    80100660 <printint+0x20>
  if(sign)
8010067c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010067f:	85 d2                	test   %edx,%edx
80100681:	74 07                	je     8010068a <printint+0x4a>
    buf[i++] = '-';
80100683:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
80100688:	89 f7                	mov    %esi,%edi
  while(--i >= 0)
8010068a:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010068d:	01 df                	add    %ebx,%edi
  if(panicked){
8010068f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100694:	85 c0                	test   %eax,%eax
80100696:	74 08                	je     801006a0 <printint+0x60>
80100698:	fa                   	cli
    for(;;)
80100699:	eb fe                	jmp    80100699 <printint+0x59>
8010069b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801006a0:	0f be 07             	movsbl (%edi),%eax
801006a3:	e8 78 fd ff ff       	call   80100420 <consputc.part.0>
  while(--i >= 0)
801006a8:	39 fb                	cmp    %edi,%ebx
801006aa:	74 10                	je     801006bc <printint+0x7c>
801006ac:	83 ef 01             	sub    $0x1,%edi
801006af:	eb de                	jmp    8010068f <printint+0x4f>
  if(sign && (sign = xx < 0))
801006b1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006b8:	f7 d8                	neg    %eax
801006ba:	eb 9f                	jmp    8010065b <printint+0x1b>
}
801006bc:	83 c4 2c             	add    $0x2c,%esp
801006bf:	5b                   	pop    %ebx
801006c0:	5e                   	pop    %esi
801006c1:	5f                   	pop    %edi
801006c2:	5d                   	pop    %ebp
801006c3:	c3                   	ret
801006c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801006cf:	00 

801006d0 <cprintf>:
{
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	56                   	push   %esi
801006d5:	53                   	push   %ebx
801006d6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006d9:	8b 15 54 ef 10 80    	mov    0x8010ef54,%edx
  if (fmt == 0)
801006df:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006e2:	85 d2                	test   %edx,%edx
801006e4:	0f 85 06 01 00 00    	jne    801007f0 <cprintf+0x120>
  if (fmt == 0)
801006ea:	85 f6                	test   %esi,%esi
801006ec:	0f 84 c2 01 00 00    	je     801008b4 <cprintf+0x1e4>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f2:	0f b6 06             	movzbl (%esi),%eax
801006f5:	85 c0                	test   %eax,%eax
801006f7:	74 57                	je     80100750 <cprintf+0x80>
801006f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  argp = (uint*)(void*)(&fmt + 1);
801006fc:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ff:	31 db                	xor    %ebx,%ebx
    if(c != '%'){
80100701:	83 f8 25             	cmp    $0x25,%eax
80100704:	75 5a                	jne    80100760 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100706:	83 c3 01             	add    $0x1,%ebx
80100709:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
8010070d:	85 d2                	test   %edx,%edx
8010070f:	74 34                	je     80100745 <cprintf+0x75>
    switch(c){
80100711:	83 fa 70             	cmp    $0x70,%edx
80100714:	0f 84 b6 00 00 00    	je     801007d0 <cprintf+0x100>
8010071a:	7f 74                	jg     80100790 <cprintf+0xc0>
8010071c:	83 fa 25             	cmp    $0x25,%edx
8010071f:	74 4f                	je     80100770 <cprintf+0xa0>
80100721:	83 fa 64             	cmp    $0x64,%edx
80100724:	75 78                	jne    8010079e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100726:	8b 07                	mov    (%edi),%eax
80100728:	b9 01 00 00 00       	mov    $0x1,%ecx
8010072d:	ba 0a 00 00 00       	mov    $0xa,%edx
80100732:	83 c7 04             	add    $0x4,%edi
80100735:	e8 06 ff ff ff       	call   80100640 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010073a:	83 c3 01             	add    $0x1,%ebx
8010073d:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100741:	85 c0                	test   %eax,%eax
80100743:	75 bc                	jne    80100701 <cprintf+0x31>
80100745:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if(locking)
80100748:	85 d2                	test   %edx,%edx
8010074a:	0f 85 c9 00 00 00    	jne    80100819 <cprintf+0x149>
}
80100750:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100753:	5b                   	pop    %ebx
80100754:	5e                   	pop    %esi
80100755:	5f                   	pop    %edi
80100756:	5d                   	pop    %ebp
80100757:	c3                   	ret
80100758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010075f:	00 
  if(panicked){
80100760:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100766:	85 c9                	test   %ecx,%ecx
80100768:	74 18                	je     80100782 <cprintf+0xb2>
8010076a:	fa                   	cli
    for(;;)
8010076b:	eb fe                	jmp    8010076b <cprintf+0x9b>
8010076d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100770:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100775:	85 c0                	test   %eax,%eax
80100777:	0f 85 1b 01 00 00    	jne    80100898 <cprintf+0x1c8>
8010077d:	b8 25 00 00 00       	mov    $0x25,%eax
80100782:	e8 99 fc ff ff       	call   80100420 <consputc.part.0>
      break;
80100787:	eb b1                	jmp    8010073a <cprintf+0x6a>
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 fa 73             	cmp    $0x73,%edx
80100793:	0f 84 95 00 00 00    	je     8010082e <cprintf+0x15e>
80100799:	83 fa 78             	cmp    $0x78,%edx
8010079c:	74 32                	je     801007d0 <cprintf+0x100>
  if(panicked){
8010079e:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007a4:	85 c9                	test   %ecx,%ecx
801007a6:	0f 85 e5 00 00 00    	jne    80100891 <cprintf+0x1c1>
801007ac:	b8 25 00 00 00       	mov    $0x25,%eax
801007b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007b4:	e8 67 fc ff ff       	call   80100420 <consputc.part.0>
801007b9:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007be:	85 c0                	test   %eax,%eax
801007c0:	0f 84 da 00 00 00    	je     801008a0 <cprintf+0x1d0>
801007c6:	fa                   	cli
    for(;;)
801007c7:	eb fe                	jmp    801007c7 <cprintf+0xf7>
801007c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007d0:	8b 07                	mov    (%edi),%eax
801007d2:	31 c9                	xor    %ecx,%ecx
801007d4:	ba 10 00 00 00       	mov    $0x10,%edx
801007d9:	83 c7 04             	add    $0x4,%edi
801007dc:	e8 5f fe ff ff       	call   80100640 <printint>
      break;
801007e1:	e9 54 ff ff ff       	jmp    8010073a <cprintf+0x6a>
801007e6:	66 90                	xchg   %ax,%ax
801007e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801007ef:	00 
    acquire(&cons.lock);
801007f0:	83 ec 0c             	sub    $0xc,%esp
801007f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801007f6:	68 20 ef 10 80       	push   $0x8010ef20
801007fb:	e8 60 40 00 00       	call   80104860 <acquire>
  if (fmt == 0)
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	85 f6                	test   %esi,%esi
80100805:	0f 84 a9 00 00 00    	je     801008b4 <cprintf+0x1e4>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010080b:	0f b6 06             	movzbl (%esi),%eax
8010080e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100811:	85 c0                	test   %eax,%eax
80100813:	0f 85 e0 fe ff ff    	jne    801006f9 <cprintf+0x29>
    release(&cons.lock);
80100819:	83 ec 0c             	sub    $0xc,%esp
8010081c:	68 20 ef 10 80       	push   $0x8010ef20
80100821:	e8 da 3f 00 00       	call   80104800 <release>
80100826:	83 c4 10             	add    $0x10,%esp
80100829:	e9 22 ff ff ff       	jmp    80100750 <cprintf+0x80>
      if((s = (char*)*argp++) == 0)
8010082e:	8d 57 04             	lea    0x4(%edi),%edx
80100831:	8b 3f                	mov    (%edi),%edi
80100833:	85 ff                	test   %edi,%edi
80100835:	74 21                	je     80100858 <cprintf+0x188>
      for(; *s; s++)
80100837:	0f be 07             	movsbl (%edi),%eax
8010083a:	84 c0                	test   %al,%al
8010083c:	74 6f                	je     801008ad <cprintf+0x1dd>
8010083e:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100841:	89 fb                	mov    %edi,%ebx
80100843:	89 f7                	mov    %esi,%edi
80100845:	89 d6                	mov    %edx,%esi
  if(panicked){
80100847:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010084d:	85 d2                	test   %edx,%edx
8010084f:	74 22                	je     80100873 <cprintf+0x1a3>
80100851:	fa                   	cli
    for(;;)
80100852:	eb fe                	jmp    80100852 <cprintf+0x182>
80100854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
80100858:	89 f7                	mov    %esi,%edi
8010085a:	89 d6                	mov    %edx,%esi
  if(panicked){
8010085c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        s = "(null)";
80100862:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100865:	b8 28 00 00 00       	mov    $0x28,%eax
8010086a:	bb d8 75 10 80       	mov    $0x801075d8,%ebx
  if(panicked){
8010086f:	85 d2                	test   %edx,%edx
80100871:	75 de                	jne    80100851 <cprintf+0x181>
80100873:	e8 a8 fb ff ff       	call   80100420 <consputc.part.0>
      for(; *s; s++)
80100878:	0f be 43 01          	movsbl 0x1(%ebx),%eax
8010087c:	83 c3 01             	add    $0x1,%ebx
8010087f:	84 c0                	test   %al,%al
80100881:	75 c4                	jne    80100847 <cprintf+0x177>
      if((s = (char*)*argp++) == 0)
80100883:	89 f2                	mov    %esi,%edx
80100885:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100888:	89 fe                	mov    %edi,%esi
8010088a:	89 d7                	mov    %edx,%edi
8010088c:	e9 a9 fe ff ff       	jmp    8010073a <cprintf+0x6a>
80100891:	fa                   	cli
    for(;;)
80100892:	eb fe                	jmp    80100892 <cprintf+0x1c2>
80100894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100898:	fa                   	cli
80100899:	eb fe                	jmp    80100899 <cprintf+0x1c9>
8010089b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801008a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008a3:	e8 78 fb ff ff       	call   80100420 <consputc.part.0>
      break;
801008a8:	e9 8d fe ff ff       	jmp    8010073a <cprintf+0x6a>
      if((s = (char*)*argp++) == 0)
801008ad:	89 d7                	mov    %edx,%edi
801008af:	e9 86 fe ff ff       	jmp    8010073a <cprintf+0x6a>
    panic("null fmt");
801008b4:	83 ec 0c             	sub    $0xc,%esp
801008b7:	68 df 75 10 80       	push   $0x801075df
801008bc:	e8 df fa ff ff       	call   801003a0 <panic>
801008c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801008cf:	00 

801008d0 <consoleintr>:
{
801008d0:	55                   	push   %ebp
801008d1:	89 e5                	mov    %esp,%ebp
801008d3:	57                   	push   %edi
801008d4:	56                   	push   %esi
  int c, doprocdump = 0;
801008d5:	31 f6                	xor    %esi,%esi
{
801008d7:	53                   	push   %ebx
801008d8:	83 ec 28             	sub    $0x28,%esp
801008db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801008de:	68 20 ef 10 80       	push   $0x8010ef20
801008e3:	e8 78 3f 00 00       	call   80104860 <acquire>
  while((c = getc()) >= 0){
801008e8:	83 c4 10             	add    $0x10,%esp
801008eb:	ff d3                	call   *%ebx
801008ed:	85 c0                	test   %eax,%eax
801008ef:	78 20                	js     80100911 <consoleintr+0x41>
    switch(c){
801008f1:	83 f8 15             	cmp    $0x15,%eax
801008f4:	74 42                	je     80100938 <consoleintr+0x68>
801008f6:	7f 78                	jg     80100970 <consoleintr+0xa0>
801008f8:	83 f8 08             	cmp    $0x8,%eax
801008fb:	74 78                	je     80100975 <consoleintr+0xa5>
801008fd:	83 f8 10             	cmp    $0x10,%eax
80100900:	0f 85 37 01 00 00    	jne    80100a3d <consoleintr+0x16d>
80100906:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
8010090b:	ff d3                	call   *%ebx
8010090d:	85 c0                	test   %eax,%eax
8010090f:	79 e0                	jns    801008f1 <consoleintr+0x21>
  release(&cons.lock);
80100911:	83 ec 0c             	sub    $0xc,%esp
80100914:	68 20 ef 10 80       	push   $0x8010ef20
80100919:	e8 e2 3e 00 00       	call   80104800 <release>
  if(doprocdump) {
8010091e:	83 c4 10             	add    $0x10,%esp
80100921:	85 f6                	test   %esi,%esi
80100923:	0f 85 7a 01 00 00    	jne    80100aa3 <consoleintr+0x1d3>
}
80100929:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010092c:	5b                   	pop    %ebx
8010092d:	5e                   	pop    %esi
8010092e:	5f                   	pop    %edi
8010092f:	5d                   	pop    %ebp
80100930:	c3                   	ret
80100931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100938:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010093d:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100943:	74 a6                	je     801008eb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100945:	83 e8 01             	sub    $0x1,%eax
80100948:	89 c2                	mov    %eax,%edx
8010094a:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010094d:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100954:	74 95                	je     801008eb <consoleintr+0x1b>
  if(panicked){
80100956:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010095c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100961:	85 d2                	test   %edx,%edx
80100963:	74 3b                	je     801009a0 <consoleintr+0xd0>
80100965:	fa                   	cli
    for(;;)
80100966:	eb fe                	jmp    80100966 <consoleintr+0x96>
80100968:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010096f:	00 
    switch(c){
80100970:	83 f8 7f             	cmp    $0x7f,%eax
80100973:	75 4b                	jne    801009c0 <consoleintr+0xf0>
      if(input.e != input.w){
80100975:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010097a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100980:	0f 84 65 ff ff ff    	je     801008eb <consoleintr+0x1b>
        input.e--;
80100986:	83 e8 01             	sub    $0x1,%eax
80100989:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010098e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100993:	85 c0                	test   %eax,%eax
80100995:	0f 84 f9 00 00 00    	je     80100a94 <consoleintr+0x1c4>
8010099b:	fa                   	cli
    for(;;)
8010099c:	eb fe                	jmp    8010099c <consoleintr+0xcc>
8010099e:	66 90                	xchg   %ax,%ax
801009a0:	b8 00 01 00 00       	mov    $0x100,%eax
801009a5:	e8 76 fa ff ff       	call   80100420 <consputc.part.0>
      while(input.e != input.w &&
801009aa:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009af:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009b5:	75 8e                	jne    80100945 <consoleintr+0x75>
801009b7:	e9 2f ff ff ff       	jmp    801008eb <consoleintr+0x1b>
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009c0:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
801009c6:	89 d1                	mov    %edx,%ecx
801009c8:	2b 0d 00 ef 10 80    	sub    0x8010ef00,%ecx
801009ce:	83 f9 7f             	cmp    $0x7f,%ecx
801009d1:	0f 87 14 ff ff ff    	ja     801008eb <consoleintr+0x1b>
  if(panicked){
801009d7:	8b 3d 58 ef 10 80    	mov    0x8010ef58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801009dd:	8d 4a 01             	lea    0x1(%edx),%ecx
801009e0:	83 e2 7f             	and    $0x7f,%edx
801009e3:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
801009e9:	88 82 80 ee 10 80    	mov    %al,-0x7fef1180(%edx)
  if(panicked){
801009ef:	85 ff                	test   %edi,%edi
801009f1:	0f 85 b8 00 00 00    	jne    80100aaf <consoleintr+0x1df>
801009f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801009fa:	e8 21 fa ff ff       	call   80100420 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100a02:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
80100a08:	83 f8 0a             	cmp    $0xa,%eax
80100a0b:	74 15                	je     80100a22 <consoleintr+0x152>
80100a0d:	83 f8 04             	cmp    $0x4,%eax
80100a10:	74 10                	je     80100a22 <consoleintr+0x152>
80100a12:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100a17:	83 e8 80             	sub    $0xffffff80,%eax
80100a1a:	39 d0                	cmp    %edx,%eax
80100a1c:	0f 85 c9 fe ff ff    	jne    801008eb <consoleintr+0x1b>
          wakeup(&input.r);
80100a22:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a25:	89 15 04 ef 10 80    	mov    %edx,0x8010ef04
          wakeup(&input.r);
80100a2b:	68 00 ef 10 80       	push   $0x8010ef00
80100a30:	e8 1b 39 00 00       	call   80104350 <wakeup>
80100a35:	83 c4 10             	add    $0x10,%esp
80100a38:	e9 ae fe ff ff       	jmp    801008eb <consoleintr+0x1b>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a3d:	85 c0                	test   %eax,%eax
80100a3f:	0f 84 a6 fe ff ff    	je     801008eb <consoleintr+0x1b>
80100a45:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
80100a4b:	89 d1                	mov    %edx,%ecx
80100a4d:	2b 0d 00 ef 10 80    	sub    0x8010ef00,%ecx
80100a53:	83 f9 7f             	cmp    $0x7f,%ecx
80100a56:	0f 87 8f fe ff ff    	ja     801008eb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  if(panicked){
80100a5f:	8b 3d 58 ef 10 80    	mov    0x8010ef58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100a65:	83 e2 7f             	and    $0x7f,%edx
        c = (c == '\r') ? '\n' : c;
80100a68:	83 f8 0d             	cmp    $0xd,%eax
80100a6b:	0f 85 72 ff ff ff    	jne    801009e3 <consoleintr+0x113>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a71:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100a77:	c6 82 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%edx)
  if(panicked){
80100a7e:	85 ff                	test   %edi,%edi
80100a80:	75 2d                	jne    80100aaf <consoleintr+0x1df>
80100a82:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a87:	e8 94 f9 ff ff       	call   80100420 <consputc.part.0>
          input.w = input.e;
80100a8c:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
80100a92:	eb 8e                	jmp    80100a22 <consoleintr+0x152>
80100a94:	b8 00 01 00 00       	mov    $0x100,%eax
80100a99:	e8 82 f9 ff ff       	call   80100420 <consputc.part.0>
80100a9e:	e9 48 fe ff ff       	jmp    801008eb <consoleintr+0x1b>
}
80100aa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa6:	5b                   	pop    %ebx
80100aa7:	5e                   	pop    %esi
80100aa8:	5f                   	pop    %edi
80100aa9:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100aaa:	e9 91 39 00 00       	jmp    80104440 <procdump>
80100aaf:	fa                   	cli
    for(;;)
80100ab0:	eb fe                	jmp    80100ab0 <consoleintr+0x1e0>
80100ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ab8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100abf:	00 

80100ac0 <consoleinit>:

void
consoleinit(void)
{
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ac6:	68 e8 75 10 80       	push   $0x801075e8
80100acb:	68 20 ef 10 80       	push   $0x8010ef20
80100ad0:	e8 6b 3b 00 00       	call   80104640 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ad5:	58                   	pop    %eax
80100ad6:	5a                   	pop    %edx
80100ad7:	6a 00                	push   $0x0
80100ad9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100adb:	c7 05 0c f9 10 80 d0 	movl   $0x801005d0,0x8010f90c
80100ae2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ae5:	c7 05 08 f9 10 80 a0 	movl   $0x801002a0,0x8010f908
80100aec:	02 10 80 
  cons.locking = 1;
80100aef:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100af6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100af9:	e8 82 1a 00 00       	call   80102580 <ioapicenable>
}
80100afe:	83 c4 10             	add    $0x10,%esp
80100b01:	c9                   	leave
80100b02:	c3                   	ret
80100b03:	66 90                	xchg   %ax,%ax
80100b05:	66 90                	xchg   %ax,%ax
80100b07:	66 90                	xchg   %ax,%ax
80100b09:	66 90                	xchg   %ax,%ax
80100b0b:	66 90                	xchg   %ax,%ax
80100b0d:	66 90                	xchg   %ax,%ax
80100b0f:	90                   	nop

80100b10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
80100b16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b1c:	e8 1f 30 00 00       	call   80103b40 <myproc>
80100b21:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b27:	e8 b4 23 00 00       	call   80102ee0 <begin_op>

  if((ip = namei(path)) == 0){
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	push   0x8(%ebp)
80100b32:	e8 59 16 00 00       	call   80102190 <namei>
80100b37:	83 c4 10             	add    $0x10,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 84 30 03 00 00    	je     80100e72 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b42:	83 ec 0c             	sub    $0xc,%esp
80100b45:	89 c7                	mov    %eax,%edi
80100b47:	50                   	push   %eax
80100b48:	e8 23 0d 00 00       	call   80101870 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b53:	6a 34                	push   $0x34
80100b55:	6a 00                	push   $0x0
80100b57:	50                   	push   %eax
80100b58:	57                   	push   %edi
80100b59:	e8 32 10 00 00       	call   80101b90 <readi>
80100b5e:	83 c4 20             	add    $0x20,%esp
80100b61:	83 f8 34             	cmp    $0x34,%eax
80100b64:	0f 85 01 01 00 00    	jne    80100c6b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b6a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b71:	45 4c 46 
80100b74:	0f 85 f1 00 00 00    	jne    80100c6b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b7a:	e8 c1 66 00 00       	call   80107240 <setupkvm>
80100b7f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b85:	85 c0                	test   %eax,%eax
80100b87:	0f 84 de 00 00 00    	je     80100c6b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b94:	00 
80100b95:	0f 84 a7 02 00 00    	je     80100e42 <exec+0x332>
  sz = 0;
80100b9b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ba2:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba5:	8b 9d 40 ff ff ff    	mov    -0xc0(%ebp),%ebx
80100bab:	31 f6                	xor    %esi,%esi
80100bad:	e9 8c 00 00 00       	jmp    80100c3e <exec+0x12e>
80100bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bb8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bbf:	75 6c                	jne    80100c2d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100bc1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bc7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bcd:	0f 82 87 00 00 00    	jb     80100c5a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bd3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bd9:	72 7f                	jb     80100c5a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bdb:	83 ec 04             	sub    $0x4,%esp
80100bde:	50                   	push   %eax
80100bdf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100be5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100beb:	e8 80 64 00 00       	call   80107070 <allocuvm>
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	74 5d                	je     80100c5a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bfd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c03:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c08:	75 50                	jne    80100c5a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c0a:	83 ec 0c             	sub    $0xc,%esp
80100c0d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c13:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c19:	57                   	push   %edi
80100c1a:	50                   	push   %eax
80100c1b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c21:	e8 7a 63 00 00       	call   80106fa0 <loaduvm>
80100c26:	83 c4 20             	add    $0x20,%esp
80100c29:	85 c0                	test   %eax,%eax
80100c2b:	78 2d                	js     80100c5a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c2d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c34:	83 c6 01             	add    $0x1,%esi
80100c37:	83 c3 20             	add    $0x20,%ebx
80100c3a:	39 f0                	cmp    %esi,%eax
80100c3c:	7e 52                	jle    80100c90 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c3e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c44:	6a 20                	push   $0x20
80100c46:	53                   	push   %ebx
80100c47:	50                   	push   %eax
80100c48:	57                   	push   %edi
80100c49:	e8 42 0f 00 00       	call   80101b90 <readi>
80100c4e:	83 c4 10             	add    $0x10,%esp
80100c51:	83 f8 20             	cmp    $0x20,%eax
80100c54:	0f 84 5e ff ff ff    	je     80100bb8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c5a:	83 ec 0c             	sub    $0xc,%esp
80100c5d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c63:	e8 58 65 00 00       	call   801071c0 <freevm>
  if(ip){
80100c68:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c6b:	83 ec 0c             	sub    $0xc,%esp
80100c6e:	57                   	push   %edi
80100c6f:	e8 9c 0e 00 00       	call   80101b10 <iunlockput>
    end_op();
80100c74:	e8 d7 22 00 00       	call   80102f50 <end_op>
80100c79:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c84:	5b                   	pop    %ebx
80100c85:	5e                   	pop    %esi
80100c86:	5f                   	pop    %edi
80100c87:	5d                   	pop    %ebp
80100c88:	c3                   	ret
80100c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c90:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c96:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c9c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca2:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100ca8:	83 ec 0c             	sub    $0xc,%esp
80100cab:	57                   	push   %edi
80100cac:	e8 5f 0e 00 00       	call   80101b10 <iunlockput>
  end_op();
80100cb1:	e8 9a 22 00 00       	call   80102f50 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb6:	83 c4 0c             	add    $0xc,%esp
80100cb9:	53                   	push   %ebx
80100cba:	56                   	push   %esi
80100cbb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cc1:	56                   	push   %esi
80100cc2:	e8 a9 63 00 00       	call   80107070 <allocuvm>
80100cc7:	83 c4 10             	add    $0x10,%esp
80100cca:	89 c7                	mov    %eax,%edi
80100ccc:	85 c0                	test   %eax,%eax
80100cce:	0f 84 86 00 00 00    	je     80100d5a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd4:	83 ec 08             	sub    $0x8,%esp
80100cd7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100cdd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cdf:	50                   	push   %eax
80100ce0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100ce1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce3:	e8 f8 65 00 00       	call   801072e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ceb:	83 c4 10             	add    $0x10,%esp
80100cee:	8b 10                	mov    (%eax),%edx
80100cf0:	85 d2                	test   %edx,%edx
80100cf2:	0f 84 56 01 00 00    	je     80100e4e <exec+0x33e>
80100cf8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cfe:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100d01:	eb 23                	jmp    80100d26 <exec+0x216>
80100d03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d08:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100d0b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100d12:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100d18:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100d1b:	85 d2                	test   %edx,%edx
80100d1d:	74 51                	je     80100d70 <exec+0x260>
    if(argc >= MAXARG)
80100d1f:	83 f8 20             	cmp    $0x20,%eax
80100d22:	74 36                	je     80100d5a <exec+0x24a>
80100d24:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d26:	83 ec 0c             	sub    $0xc,%esp
80100d29:	52                   	push   %edx
80100d2a:	e8 51 3e 00 00       	call   80104b80 <strlen>
80100d2f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d31:	58                   	pop    %eax
80100d32:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d35:	83 eb 01             	sub    $0x1,%ebx
80100d38:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3b:	e8 40 3e 00 00       	call   80104b80 <strlen>
80100d40:	83 c0 01             	add    $0x1,%eax
80100d43:	50                   	push   %eax
80100d44:	ff 34 b7             	push   (%edi,%esi,4)
80100d47:	53                   	push   %ebx
80100d48:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d4e:	e8 4d 67 00 00       	call   801074a0 <copyout>
80100d53:	83 c4 20             	add    $0x20,%esp
80100d56:	85 c0                	test   %eax,%eax
80100d58:	79 ae                	jns    80100d08 <exec+0x1f8>
    freevm(pgdir);
80100d5a:	83 ec 0c             	sub    $0xc,%esp
80100d5d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d63:	e8 58 64 00 00       	call   801071c0 <freevm>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	e9 0c ff ff ff       	jmp    80100c7c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d70:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d77:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d7d:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100d83:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d86:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d89:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d90:	00 00 00 00 
  ustack[1] = argc;
80100d94:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d9a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100da1:	ff ff ff 
  ustack[1] = argc;
80100da4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100daa:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100dac:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dae:	29 d0                	sub    %edx,%eax
80100db0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100db6:	56                   	push   %esi
80100db7:	51                   	push   %ecx
80100db8:	53                   	push   %ebx
80100db9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dbf:	e8 dc 66 00 00       	call   801074a0 <copyout>
80100dc4:	83 c4 10             	add    $0x10,%esp
80100dc7:	85 c0                	test   %eax,%eax
80100dc9:	78 8f                	js     80100d5a <exec+0x24a>
  for(last=s=path; *s; s++)
80100dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80100dce:	8b 55 08             	mov    0x8(%ebp),%edx
80100dd1:	0f b6 00             	movzbl (%eax),%eax
80100dd4:	84 c0                	test   %al,%al
80100dd6:	74 17                	je     80100def <exec+0x2df>
80100dd8:	89 d1                	mov    %edx,%ecx
80100dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100de0:	83 c1 01             	add    $0x1,%ecx
80100de3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100de5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100de8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100deb:	84 c0                	test   %al,%al
80100ded:	75 f1                	jne    80100de0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100def:	83 ec 04             	sub    $0x4,%esp
80100df2:	6a 10                	push   $0x10
80100df4:	52                   	push   %edx
80100df5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dfb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dfe:	50                   	push   %eax
80100dff:	e8 2c 3d 00 00       	call   80104b30 <safestrcpy>
  curproc->pgdir = pgdir;
80100e04:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e0a:	89 f0                	mov    %esi,%eax
80100e0c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100e0f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100e11:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e14:	89 c1                	mov    %eax,%ecx
80100e16:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e1c:	8b 40 18             	mov    0x18(%eax),%eax
80100e1f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e22:	8b 41 18             	mov    0x18(%ecx),%eax
80100e25:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e28:	89 0c 24             	mov    %ecx,(%esp)
80100e2b:	e8 e0 5f 00 00       	call   80106e10 <switchuvm>
  freevm(oldpgdir);
80100e30:	89 34 24             	mov    %esi,(%esp)
80100e33:	e8 88 63 00 00       	call   801071c0 <freevm>
  return 0;
80100e38:	83 c4 10             	add    $0x10,%esp
80100e3b:	31 c0                	xor    %eax,%eax
80100e3d:	e9 3f fe ff ff       	jmp    80100c81 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e42:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e47:	31 f6                	xor    %esi,%esi
80100e49:	e9 5a fe ff ff       	jmp    80100ca8 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e4e:	be 10 00 00 00       	mov    $0x10,%esi
80100e53:	ba 04 00 00 00       	mov    $0x4,%edx
80100e58:	b8 03 00 00 00       	mov    $0x3,%eax
80100e5d:	c7 85 e8 fe ff ff 00 	movl   $0x0,-0x118(%ebp)
80100e64:	00 00 00 
80100e67:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e6d:	e9 17 ff ff ff       	jmp    80100d89 <exec+0x279>
    end_op();
80100e72:	e8 d9 20 00 00       	call   80102f50 <end_op>
    cprintf("exec: fail\n");
80100e77:	83 ec 0c             	sub    $0xc,%esp
80100e7a:	68 f0 75 10 80       	push   $0x801075f0
80100e7f:	e8 4c f8 ff ff       	call   801006d0 <cprintf>
    return -1;
80100e84:	83 c4 10             	add    $0x10,%esp
80100e87:	e9 f0 fd ff ff       	jmp    80100c7c <exec+0x16c>
80100e8c:	66 90                	xchg   %ax,%ax
80100e8e:	66 90                	xchg   %ax,%ax
80100e90:	66 90                	xchg   %ax,%ax
80100e92:	66 90                	xchg   %ax,%ax
80100e94:	66 90                	xchg   %ax,%ax
80100e96:	66 90                	xchg   %ax,%ax
80100e98:	66 90                	xchg   %ax,%ax
80100e9a:	66 90                	xchg   %ax,%ax
80100e9c:	66 90                	xchg   %ax,%ax
80100e9e:	66 90                	xchg   %ax,%ax

80100ea0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ea6:	68 fc 75 10 80       	push   $0x801075fc
80100eab:	68 60 ef 10 80       	push   $0x8010ef60
80100eb0:	e8 8b 37 00 00       	call   80104640 <initlock>
}
80100eb5:	83 c4 10             	add    $0x10,%esp
80100eb8:	c9                   	leave
80100eb9:	c3                   	ret
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ec0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec4:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100ec9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ecc:	68 60 ef 10 80       	push   $0x8010ef60
80100ed1:	e8 8a 39 00 00       	call   80104860 <acquire>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb 10                	jmp    80100eeb <filealloc+0x2b>
80100edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ee0:	83 c3 18             	add    $0x18,%ebx
80100ee3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ee9:	74 25                	je     80100f10 <filealloc+0x50>
    if(f->ref == 0){
80100eeb:	8b 43 04             	mov    0x4(%ebx),%eax
80100eee:	85 c0                	test   %eax,%eax
80100ef0:	75 ee                	jne    80100ee0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ef5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 fa 38 00 00       	call   80104800 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f06:	89 d8                	mov    %ebx,%eax
      return f;
80100f08:	83 c4 10             	add    $0x10,%esp
}
80100f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f0e:	c9                   	leave
80100f0f:	c3                   	ret
  release(&ftable.lock);
80100f10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f13:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f15:	68 60 ef 10 80       	push   $0x8010ef60
80100f1a:	e8 e1 38 00 00       	call   80104800 <release>
}
80100f1f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f21:	83 c4 10             	add    $0x10,%esp
}
80100f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f27:	c9                   	leave
80100f28:	c3                   	ret
80100f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 10             	sub    $0x10,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f3a:	68 60 ef 10 80       	push   $0x8010ef60
80100f3f:	e8 1c 39 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80100f44:	8b 43 04             	mov    0x4(%ebx),%eax
80100f47:	83 c4 10             	add    $0x10,%esp
80100f4a:	85 c0                	test   %eax,%eax
80100f4c:	7e 1a                	jle    80100f68 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f4e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f51:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f54:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f57:	68 60 ef 10 80       	push   $0x8010ef60
80100f5c:	e8 9f 38 00 00       	call   80104800 <release>
  return f;
}
80100f61:	89 d8                	mov    %ebx,%eax
80100f63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f66:	c9                   	leave
80100f67:	c3                   	ret
    panic("filedup");
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	68 03 76 10 80       	push   $0x80107603
80100f70:	e8 2b f4 ff ff       	call   801003a0 <panic>
80100f75:	8d 76 00             	lea    0x0(%esi),%esi
80100f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7f:	00 

80100f80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 28             	sub    $0x28,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f8c:	68 60 ef 10 80       	push   $0x8010ef60
80100f91:	e8 ca 38 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80100f96:	8b 43 04             	mov    0x4(%ebx),%eax
80100f99:	83 c4 10             	add    $0x10,%esp
80100f9c:	85 c0                	test   %eax,%eax
80100f9e:	0f 8e a8 00 00 00    	jle    8010104c <fileclose+0xcc>
    panic("fileclose");
  if(--f->ref > 0){
80100fa4:	83 e8 01             	sub    $0x1,%eax
80100fa7:	89 43 04             	mov    %eax,0x4(%ebx)
80100faa:	75 44                	jne    80100ff0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fac:	8b 43 0c             	mov    0xc(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100faf:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fb2:	8b 33                	mov    (%ebx),%esi
  f->type = FD_NONE;
80100fb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fba:	0f b6 7b 09          	movzbl 0x9(%ebx),%edi
80100fbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100fc1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fc7:	68 60 ef 10 80       	push   $0x8010ef60
80100fcc:	e8 2f 38 00 00       	call   80104800 <release>

  if(ff.type == FD_PIPE)
80100fd1:	83 c4 10             	add    $0x10,%esp
80100fd4:	83 fe 01             	cmp    $0x1,%esi
80100fd7:	74 57                	je     80101030 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fd9:	83 fe 02             	cmp    $0x2,%esi
80100fdc:	74 2a                	je     80101008 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe1:	5b                   	pop    %ebx
80100fe2:	5e                   	pop    %esi
80100fe3:	5f                   	pop    %edi
80100fe4:	5d                   	pop    %ebp
80100fe5:	c3                   	ret
80100fe6:	66 90                	xchg   %ax,%ax
80100fe8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fef:	00 
    release(&ftable.lock);
80100ff0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffa:	5b                   	pop    %ebx
80100ffb:	5e                   	pop    %esi
80100ffc:	5f                   	pop    %edi
80100ffd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ffe:	e9 fd 37 00 00       	jmp    80104800 <release>
80101003:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101008:	e8 d3 1e 00 00       	call   80102ee0 <begin_op>
    iput(ff.ip);
8010100d:	83 ec 0c             	sub    $0xc,%esp
80101010:	ff 75 e0             	push   -0x20(%ebp)
80101013:	e8 88 09 00 00       	call   801019a0 <iput>
    end_op();
80101018:	83 c4 10             	add    $0x10,%esp
}
8010101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010101e:	5b                   	pop    %ebx
8010101f:	5e                   	pop    %esi
80101020:	5f                   	pop    %edi
80101021:	5d                   	pop    %ebp
    end_op();
80101022:	e9 29 1f 00 00       	jmp    80102f50 <end_op>
80101027:	90                   	nop
80101028:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010102f:	00 
    pipeclose(ff.pipe, ff.writable);
80101030:	89 f8                	mov    %edi,%eax
80101032:	83 ec 08             	sub    $0x8,%esp
80101035:	0f be c0             	movsbl %al,%eax
80101038:	50                   	push   %eax
80101039:	ff 75 e4             	push   -0x1c(%ebp)
8010103c:	e8 2f 26 00 00       	call   80103670 <pipeclose>
80101041:	83 c4 10             	add    $0x10,%esp
}
80101044:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101047:	5b                   	pop    %ebx
80101048:	5e                   	pop    %esi
80101049:	5f                   	pop    %edi
8010104a:	5d                   	pop    %ebp
8010104b:	c3                   	ret
    panic("fileclose");
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	68 0b 76 10 80       	push   $0x8010760b
80101054:	e8 47 f3 ff ff       	call   801003a0 <panic>
80101059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101060 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	53                   	push   %ebx
80101064:	83 ec 04             	sub    $0x4,%esp
80101067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010106a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010106d:	75 31                	jne    801010a0 <filestat+0x40>
    ilock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 73 10             	push   0x10(%ebx)
80101075:	e8 f6 07 00 00       	call   80101870 <ilock>
    stati(f->ip, st);
8010107a:	58                   	pop    %eax
8010107b:	5a                   	pop    %edx
8010107c:	ff 75 0c             	push   0xc(%ebp)
8010107f:	ff 73 10             	push   0x10(%ebx)
80101082:	e8 d9 0a 00 00       	call   80101b60 <stati>
    iunlock(f->ip);
80101087:	59                   	pop    %ecx
80101088:	ff 73 10             	push   0x10(%ebx)
8010108b:	e8 c0 08 00 00       	call   80101950 <iunlock>
    return 0;
  }
  return -1;
}
80101090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	31 c0                	xor    %eax,%eax
}
80101098:	c9                   	leave
80101099:	c3                   	ret
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801010a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010a8:	c9                   	leave
801010a9:	c3                   	ret
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010b0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 0c             	sub    $0xc,%esp
801010b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801010bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010c6:	74 60                	je     80101128 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010c8:	8b 03                	mov    (%ebx),%eax
801010ca:	83 f8 01             	cmp    $0x1,%eax
801010cd:	74 41                	je     80101110 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cf:	83 f8 02             	cmp    $0x2,%eax
801010d2:	75 5b                	jne    8010112f <fileread+0x7f>
    ilock(f->ip);
801010d4:	83 ec 0c             	sub    $0xc,%esp
801010d7:	ff 73 10             	push   0x10(%ebx)
801010da:	e8 91 07 00 00       	call   80101870 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010df:	57                   	push   %edi
801010e0:	ff 73 14             	push   0x14(%ebx)
801010e3:	56                   	push   %esi
801010e4:	ff 73 10             	push   0x10(%ebx)
801010e7:	e8 a4 0a 00 00       	call   80101b90 <readi>
801010ec:	83 c4 20             	add    $0x20,%esp
801010ef:	89 c6                	mov    %eax,%esi
801010f1:	85 c0                	test   %eax,%eax
801010f3:	7e 03                	jle    801010f8 <fileread+0x48>
      f->off += r;
801010f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010f8:	83 ec 0c             	sub    $0xc,%esp
801010fb:	ff 73 10             	push   0x10(%ebx)
801010fe:	e8 4d 08 00 00       	call   80101950 <iunlock>
    return r;
80101103:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	89 f0                	mov    %esi,%eax
8010110b:	5b                   	pop    %ebx
8010110c:	5e                   	pop    %esi
8010110d:	5f                   	pop    %edi
8010110e:	5d                   	pop    %ebp
8010110f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101110:	8b 43 0c             	mov    0xc(%ebx),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010111d:	e9 fe 26 00 00       	jmp    80103820 <piperead>
80101122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101128:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010112d:	eb d7                	jmp    80101106 <fileread+0x56>
  panic("fileread");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 15 76 10 80       	push   $0x80107615
80101137:	e8 64 f2 ff ff       	call   801003a0 <panic>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101140 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 1c             	sub    $0x1c,%esp
80101149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010114c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010114f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101152:	8b 45 10             	mov    0x10(%ebp),%eax
80101155:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80101158:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
8010115c:	0f 84 b3 00 00 00    	je     80101215 <filewrite+0xd5>
    return -1;
  if(f->type == FD_PIPE)
80101162:	8b 17                	mov    (%edi),%edx
80101164:	83 fa 01             	cmp    $0x1,%edx
80101167:	0f 84 b7 00 00 00    	je     80101224 <filewrite+0xe4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010116d:	83 fa 02             	cmp    $0x2,%edx
80101170:	0f 85 c0 00 00 00    	jne    80101236 <filewrite+0xf6>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101176:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    int i = 0;
80101179:	31 f6                	xor    %esi,%esi
    while(i < n){
8010117b:	85 d2                	test   %edx,%edx
8010117d:	7f 2e                	jg     801011ad <filewrite+0x6d>
8010117f:	e9 8c 00 00 00       	jmp    80101210 <filewrite+0xd0>
80101184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101188:	01 47 14             	add    %eax,0x14(%edi)
      iunlock(f->ip);
8010118b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010118e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101191:	51                   	push   %ecx
80101192:	e8 b9 07 00 00       	call   80101950 <iunlock>
      end_op();
80101197:	e8 b4 1d 00 00       	call   80102f50 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010119c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010119f:	83 c4 10             	add    $0x10,%esp
801011a2:	39 d8                	cmp    %ebx,%eax
801011a4:	75 5d                	jne    80101203 <filewrite+0xc3>
        panic("short filewrite");
      i += r;
801011a6:	01 c6                	add    %eax,%esi
    while(i < n){
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	7e 63                	jle    80101210 <filewrite+0xd0>
      int n1 = n - i;
801011ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
      if(n1 > max)
801011b0:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801011b5:	29 f3                	sub    %esi,%ebx
      if(n1 > max)
801011b7:	39 c3                	cmp    %eax,%ebx
801011b9:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011bc:	e8 1f 1d 00 00       	call   80102ee0 <begin_op>
      ilock(f->ip);
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	ff 77 10             	push   0x10(%edi)
801011c7:	e8 a4 06 00 00       	call   80101870 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011cc:	53                   	push   %ebx
801011cd:	ff 77 14             	push   0x14(%edi)
801011d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d3:	01 f0                	add    %esi,%eax
801011d5:	50                   	push   %eax
801011d6:	ff 77 10             	push   0x10(%edi)
801011d9:	e8 b2 0a 00 00       	call   80101c90 <writei>
      iunlock(f->ip);
801011de:	8b 4f 10             	mov    0x10(%edi),%ecx
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011e1:	83 c4 20             	add    $0x20,%esp
801011e4:	85 c0                	test   %eax,%eax
801011e6:	7f a0                	jg     80101188 <filewrite+0x48>
      iunlock(f->ip);
801011e8:	83 ec 0c             	sub    $0xc,%esp
801011eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011ee:	51                   	push   %ecx
801011ef:	e8 5c 07 00 00       	call   80101950 <iunlock>
      end_op();
801011f4:	e8 57 1d 00 00       	call   80102f50 <end_op>
      if(r < 0)
801011f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011fc:	83 c4 10             	add    $0x10,%esp
801011ff:	85 c0                	test   %eax,%eax
80101201:	75 0d                	jne    80101210 <filewrite+0xd0>
        panic("short filewrite");
80101203:	83 ec 0c             	sub    $0xc,%esp
80101206:	68 1e 76 10 80       	push   $0x8010761e
8010120b:	e8 90 f1 ff ff       	call   801003a0 <panic>
    }
    return i == n ? n : -1;
80101210:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101213:	74 05                	je     8010121a <filewrite+0xda>
    return -1;
80101215:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
8010121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121d:	89 f0                	mov    %esi,%eax
8010121f:	5b                   	pop    %ebx
80101220:	5e                   	pop    %esi
80101221:	5f                   	pop    %edi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
80101224:	8b 47 0c             	mov    0xc(%edi),%eax
80101227:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010122a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122d:	5b                   	pop    %ebx
8010122e:	5e                   	pop    %esi
8010122f:	5f                   	pop    %edi
80101230:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101231:	e9 da 24 00 00       	jmp    80103710 <pipewrite>
  panic("filewrite");
80101236:	83 ec 0c             	sub    $0xc,%esp
80101239:	68 24 76 10 80       	push   $0x80107624
8010123e:	e8 5d f1 ff ff       	call   801003a0 <panic>
80101243:	66 90                	xchg   %ax,%ax
80101245:	66 90                	xchg   %ax,%ax
80101247:	66 90                	xchg   %ax,%ax
80101249:	66 90                	xchg   %ax,%ax
8010124b:	66 90                	xchg   %ax,%ax
8010124d:	66 90                	xchg   %ax,%ax
8010124f:	90                   	nop

80101250 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010125f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 8a 00 00 00    	je     801012f4 <balloc+0xa4>
8010126a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010126c:	89 f8                	mov    %edi,%eax
8010126e:	83 ec 08             	sub    $0x8,%esp
80101271:	89 fe                	mov    %edi,%esi
80101273:	c1 f8 0c             	sar    $0xc,%eax
80101276:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010127c:	50                   	push   %eax
8010127d:	ff 75 dc             	push   -0x24(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
80101285:	83 c4 10             	add    $0x10,%esp
80101288:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010128b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010128e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101293:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101296:	31 c0                	xor    %eax,%eax
80101298:	eb 32                	jmp    801012cc <balloc+0x7c>
8010129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 49                	je     80101308 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801012cf:	72 cf                	jb     801012a0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012d1:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012d4:	83 ec 0c             	sub    $0xc,%esp
801012d7:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012da:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012e0:	e8 1b ef ff ff       	call   80100200 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012e5:	83 c4 10             	add    $0x10,%esp
801012e8:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012ee:	0f 82 78 ff ff ff    	jb     8010126c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012f4:	83 ec 0c             	sub    $0xc,%esp
801012f7:	68 2e 76 10 80       	push   $0x8010762e
801012fc:	e8 9f f0 ff ff       	call   801003a0 <panic>
80101301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101308:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010130b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010130e:	09 da                	or     %ebx,%edx
80101310:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101314:	57                   	push   %edi
80101315:	e8 a6 1d 00 00       	call   801030c0 <log_write>
        brelse(bp);
8010131a:	89 3c 24             	mov    %edi,(%esp)
8010131d:	e8 de ee ff ff       	call   80100200 <brelse>
  bp = bread(dev, bno);
80101322:	58                   	pop    %eax
80101323:	5a                   	pop    %edx
80101324:	56                   	push   %esi
80101325:	ff 75 dc             	push   -0x24(%ebp)
80101328:	e8 a3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010132d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101330:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101332:	8d 40 5c             	lea    0x5c(%eax),%eax
80101335:	68 00 02 00 00       	push   $0x200
8010133a:	6a 00                	push   $0x0
8010133c:	50                   	push   %eax
8010133d:	e8 3e 36 00 00       	call   80104980 <memset>
  log_write(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 76 1d 00 00       	call   801030c0 <log_write>
  brelse(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 ae ee ff ff       	call   80100200 <brelse>
}
80101352:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101355:	89 f0                	mov    %esi,%eax
80101357:	5b                   	pop    %ebx
80101358:	5e                   	pop    %esi
80101359:	5f                   	pop    %edi
8010135a:	5d                   	pop    %ebp
8010135b:	c3                   	ret
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 d7                	mov    %edx,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
8010136a:	89 c3                	mov    %eax,%ebx
8010136c:	83 ec 28             	sub    $0x28,%esp
  acquire(&icache.lock);
8010136f:	68 60 f9 10 80       	push   $0x8010f960
80101374:	e8 e7 34 00 00       	call   80104860 <acquire>
80101379:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137c:	b8 94 f9 10 80       	mov    $0x8010f994,%eax
80101381:	eb 19                	jmp    8010139c <iget+0x3c>
80101383:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101388:	39 18                	cmp    %ebx,(%eax)
8010138a:	0f 84 b0 00 00 00    	je     80101440 <iget+0xe0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101390:	05 90 00 00 00       	add    $0x90,%eax
80101395:	3d b4 15 11 80       	cmp    $0x801115b4,%eax
8010139a:	74 24                	je     801013c0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010139c:	8b 50 08             	mov    0x8(%eax),%edx
8010139f:	85 d2                	test   %edx,%edx
801013a1:	7f e5                	jg     80101388 <iget+0x28>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a3:	89 c1                	mov    %eax,%ecx
801013a5:	85 f6                	test   %esi,%esi
801013a7:	75 4f                	jne    801013f8 <iget+0x98>
801013a9:	85 d2                	test   %edx,%edx
801013ab:	0f 85 be 00 00 00    	jne    8010146f <iget+0x10f>
      empty = ip;
801013b1:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	05 90 00 00 00       	add    $0x90,%eax
801013b8:	3d b4 15 11 80       	cmp    $0x801115b4,%eax
801013bd:	75 dd                	jne    8010139c <iget+0x3c>
801013bf:	90                   	nop
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c0:	85 f6                	test   %esi,%esi
801013c2:	0f 84 c3 00 00 00    	je     8010148b <iget+0x12b>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cb:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
801013cd:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
801013d0:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013d7:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013de:	68 60 f9 10 80       	push   $0x8010f960
801013e3:	e8 18 34 00 00       	call   80104800 <release>

  return ip;
801013e8:	83 c4 10             	add    $0x10,%esp
}
801013eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ee:	89 f0                	mov    %esi,%eax
801013f0:	5b                   	pop    %ebx
801013f1:	5e                   	pop    %esi
801013f2:	5f                   	pop    %edi
801013f3:	5d                   	pop    %ebp
801013f4:	c3                   	ret
801013f5:	8d 76 00             	lea    0x0(%esi),%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013f8:	05 90 00 00 00       	add    $0x90,%eax
801013fd:	3d b4 15 11 80       	cmp    $0x801115b4,%eax
80101402:	74 c4                	je     801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101404:	8b 50 08             	mov    0x8(%eax),%edx
80101407:	85 d2                	test   %edx,%edx
80101409:	0f 8f 79 ff ff ff    	jg     80101388 <iget+0x28>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010140f:	8d 81 20 01 00 00    	lea    0x120(%ecx),%eax
80101415:	81 f9 94 14 11 80    	cmp    $0x80111494,%ecx
8010141b:	74 a3                	je     801013c0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141d:	8b 50 08             	mov    0x8(%eax),%edx
80101420:	85 d2                	test   %edx,%edx
80101422:	0f 8f 60 ff ff ff    	jg     80101388 <iget+0x28>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101428:	89 c1                	mov    %eax,%ecx
8010142a:	05 90 00 00 00       	add    $0x90,%eax
8010142f:	3d b4 15 11 80       	cmp    $0x801115b4,%eax
80101434:	75 ce                	jne    80101404 <iget+0xa4>
80101436:	eb 90                	jmp    801013c8 <iget+0x68>
80101438:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010143f:	00 
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101440:	39 78 04             	cmp    %edi,0x4(%eax)
80101443:	0f 85 47 ff ff ff    	jne    80101390 <iget+0x30>
      release(&icache.lock);
80101449:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
8010144c:	83 c2 01             	add    $0x1,%edx
8010144f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101452:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101455:	68 60 f9 10 80       	push   $0x8010f960
8010145a:	e8 a1 33 00 00       	call   80104800 <release>
      return ip;
8010145f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101462:	83 c4 10             	add    $0x10,%esp
}
80101465:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101468:	5b                   	pop    %ebx
80101469:	89 f0                	mov    %esi,%eax
8010146b:	5e                   	pop    %esi
8010146c:	5f                   	pop    %edi
8010146d:	5d                   	pop    %ebp
8010146e:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010146f:	05 90 00 00 00       	add    $0x90,%eax
80101474:	3d b4 15 11 80       	cmp    $0x801115b4,%eax
80101479:	74 10                	je     8010148b <iget+0x12b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010147b:	8b 50 08             	mov    0x8(%eax),%edx
8010147e:	85 d2                	test   %edx,%edx
80101480:	0f 8f 02 ff ff ff    	jg     80101388 <iget+0x28>
80101486:	e9 1e ff ff ff       	jmp    801013a9 <iget+0x49>
    panic("iget: no inodes");
8010148b:	83 ec 0c             	sub    $0xc,%esp
8010148e:	68 44 76 10 80       	push   $0x80107644
80101493:	e8 08 ef ff ff       	call   801003a0 <panic>
80101498:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010149f:	00 

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801014a3:	89 d0                	mov    %edx,%eax
801014a5:	c1 e8 0c             	shr    $0xc,%eax
{
801014a8:	89 e5                	mov    %esp,%ebp
801014aa:	56                   	push   %esi
801014ab:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801014ac:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801014b2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801014b4:	83 ec 08             	sub    $0x8,%esp
801014b7:	50                   	push   %eax
801014b8:	51                   	push   %ecx
801014b9:	e8 12 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014be:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014c0:	c1 fb 03             	sar    $0x3,%ebx
801014c3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801014c6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801014c8:	83 e1 07             	and    $0x7,%ecx
801014cb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801014d0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801014d6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801014d8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801014dd:	85 c1                	test   %eax,%ecx
801014df:	74 23                	je     80101504 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801014e1:	f7 d0                	not    %eax
  log_write(bp);
801014e3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014e6:	21 c8                	and    %ecx,%eax
801014e8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014ec:	56                   	push   %esi
801014ed:	e8 ce 1b 00 00       	call   801030c0 <log_write>
  brelse(bp);
801014f2:	89 34 24             	mov    %esi,(%esp)
801014f5:	e8 06 ed ff ff       	call   80100200 <brelse>
}
801014fa:	83 c4 10             	add    $0x10,%esp
801014fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101500:	5b                   	pop    %ebx
80101501:	5e                   	pop    %esi
80101502:	5d                   	pop    %ebp
80101503:	c3                   	ret
    panic("freeing free block");
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	68 54 76 10 80       	push   $0x80107654
8010150c:	e8 8f ee ff ff       	call   801003a0 <panic>
80101511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101518:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010151f:	00 

80101520 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	89 c6                	mov    %eax,%esi
80101526:	53                   	push   %ebx
80101527:	83 ec 10             	sub    $0x10,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010152a:	83 fa 0b             	cmp    $0xb,%edx
8010152d:	0f 86 8d 00 00 00    	jbe    801015c0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101533:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101536:	83 fb 7f             	cmp    $0x7f,%ebx
80101539:	0f 87 a8 00 00 00    	ja     801015e7 <bmap+0xc7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
8010153f:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101545:	85 c0                	test   %eax,%eax
80101547:	74 67                	je     801015b0 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	50                   	push   %eax
8010154d:	ff 36                	push   (%esi)
8010154f:	e8 7c eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	8d 4c 98 5c          	lea    0x5c(%eax,%ebx,4),%ecx
    bp = bread(ip->dev, addr);
8010155b:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010155d:	8b 19                	mov    (%ecx),%ebx
8010155f:	85 db                	test   %ebx,%ebx
80101561:	74 1d                	je     80101580 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101563:	83 ec 0c             	sub    $0xc,%esp
80101566:	52                   	push   %edx
80101567:	e8 94 ec ff ff       	call   80100200 <brelse>
8010156c:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
8010156f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101572:	89 d8                	mov    %ebx,%eax
80101574:	5b                   	pop    %ebx
80101575:	5e                   	pop    %esi
80101576:	5d                   	pop    %ebp
80101577:	c3                   	ret
80101578:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157f:	00 
80101580:	89 45 f4             	mov    %eax,-0xc(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101583:	8b 06                	mov    (%esi),%eax
80101585:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80101588:	e8 c3 fc ff ff       	call   80101250 <balloc>
8010158d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
      log_write(bp);
80101590:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101593:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101596:	89 c3                	mov    %eax,%ebx
80101598:	89 01                	mov    %eax,(%ecx)
      log_write(bp);
8010159a:	52                   	push   %edx
8010159b:	e8 20 1b 00 00       	call   801030c0 <log_write>
801015a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a3:	83 c4 10             	add    $0x10,%esp
801015a6:	eb bb                	jmp    80101563 <bmap+0x43>
801015a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015af:	00 
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015b0:	8b 06                	mov    (%esi),%eax
801015b2:	e8 99 fc ff ff       	call   80101250 <balloc>
801015b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015bd:	eb 8a                	jmp    80101549 <bmap+0x29>
801015bf:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801015c0:	83 c2 14             	add    $0x14,%edx
801015c3:	8b 5c 90 0c          	mov    0xc(%eax,%edx,4),%ebx
801015c7:	85 db                	test   %ebx,%ebx
801015c9:	75 a4                	jne    8010156f <bmap+0x4f>
      ip->addrs[bn] = addr = balloc(ip->dev);
801015cb:	8b 00                	mov    (%eax),%eax
801015cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
801015d0:	e8 7b fc ff ff       	call   80101250 <balloc>
801015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d8:	89 c3                	mov    %eax,%ebx
801015da:	89 44 96 0c          	mov    %eax,0xc(%esi,%edx,4)
}
801015de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015e1:	89 d8                	mov    %ebx,%eax
801015e3:	5b                   	pop    %ebx
801015e4:	5e                   	pop    %esi
801015e5:	5d                   	pop    %ebp
801015e6:	c3                   	ret
  panic("bmap: out of range");
801015e7:	83 ec 0c             	sub    $0xc,%esp
801015ea:	68 67 76 10 80       	push   $0x80107667
801015ef:	e8 ac ed ff ff       	call   801003a0 <panic>
801015f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ff:	00 

80101600 <readsb>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101608:	83 ec 08             	sub    $0x8,%esp
8010160b:	6a 01                	push   $0x1
8010160d:	ff 75 08             	push   0x8(%ebp)
80101610:	e8 bb ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101615:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101618:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010161a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010161d:	6a 1c                	push   $0x1c
8010161f:	50                   	push   %eax
80101620:	56                   	push   %esi
80101621:	e8 ea 33 00 00       	call   80104a10 <memmove>
  brelse(bp);
80101626:	83 c4 10             	add    $0x10,%esp
80101629:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010162c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010162f:	5b                   	pop    %ebx
80101630:	5e                   	pop    %esi
80101631:	5d                   	pop    %ebp
  brelse(bp);
80101632:	e9 c9 eb ff ff       	jmp    80100200 <brelse>
80101637:	90                   	nop
80101638:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010163f:	00 

80101640 <iinit>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101649:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010164c:	68 7a 76 10 80       	push   $0x8010767a
80101651:	68 60 f9 10 80       	push   $0x8010f960
80101656:	e8 e5 2f 00 00       	call   80104640 <initlock>
  for(i = 0; i < NINODE; i++) {
8010165b:	83 c4 10             	add    $0x10,%esp
8010165e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101660:	83 ec 08             	sub    $0x8,%esp
80101663:	68 81 76 10 80       	push   $0x80107681
80101668:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101669:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010166f:	e8 9c 2e 00 00       	call   80104510 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101674:	83 c4 10             	add    $0x10,%esp
80101677:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010167d:	75 e1                	jne    80101660 <iinit+0x20>
  bp = bread(dev, 1);
8010167f:	83 ec 08             	sub    $0x8,%esp
80101682:	6a 01                	push   $0x1
80101684:	ff 75 08             	push   0x8(%ebp)
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010168c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010168f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101691:	8d 40 5c             	lea    0x5c(%eax),%eax
80101694:	6a 1c                	push   $0x1c
80101696:	50                   	push   %eax
80101697:	68 b4 15 11 80       	push   $0x801115b4
8010169c:	e8 6f 33 00 00       	call   80104a10 <memmove>
  brelse(bp);
801016a1:	89 1c 24             	mov    %ebx,(%esp)
801016a4:	e8 57 eb ff ff       	call   80100200 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016a9:	ff 35 cc 15 11 80    	push   0x801115cc
801016af:	ff 35 c8 15 11 80    	push   0x801115c8
801016b5:	ff 35 c4 15 11 80    	push   0x801115c4
801016bb:	ff 35 c0 15 11 80    	push   0x801115c0
801016c1:	ff 35 bc 15 11 80    	push   0x801115bc
801016c7:	ff 35 b8 15 11 80    	push   0x801115b8
801016cd:	ff 35 b4 15 11 80    	push   0x801115b4
801016d3:	68 c8 7a 10 80       	push   $0x80107ac8
801016d8:	e8 f3 ef ff ff       	call   801006d0 <cprintf>
}
801016dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016e0:	83 c4 30             	add    $0x30,%esp
801016e3:	c9                   	leave
801016e4:	c3                   	ret
801016e5:	8d 76 00             	lea    0x0(%esi),%esi
801016e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016ef:	00 

801016f0 <ialloc>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	57                   	push   %edi
801016f4:	56                   	push   %esi
801016f5:	53                   	push   %ebx
801016f6:	83 ec 1c             	sub    $0x1c,%esp
801016f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801016fc:	8b 75 08             	mov    0x8(%ebp),%esi
801016ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101702:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
80101709:	0f 86 91 00 00 00    	jbe    801017a0 <ialloc+0xb0>
8010170f:	bf 01 00 00 00       	mov    $0x1,%edi
80101714:	eb 21                	jmp    80101737 <ialloc+0x47>
80101716:	66 90                	xchg   %ax,%ax
80101718:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010171f:	00 
    brelse(bp);
80101720:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101723:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101726:	53                   	push   %ebx
80101727:	e8 d4 ea ff ff       	call   80100200 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010172c:	83 c4 10             	add    $0x10,%esp
8010172f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101735:	73 69                	jae    801017a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101737:	89 f8                	mov    %edi,%eax
80101739:	83 ec 08             	sub    $0x8,%esp
8010173c:	c1 e8 03             	shr    $0x3,%eax
8010173f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101745:	50                   	push   %eax
80101746:	56                   	push   %esi
80101747:	e8 84 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010174c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010174f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101751:	89 f8                	mov    %edi,%eax
80101753:	83 e0 07             	and    $0x7,%eax
80101756:	c1 e0 06             	shl    $0x6,%eax
80101759:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010175d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101761:	75 bd                	jne    80101720 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101763:	83 ec 04             	sub    $0x4,%esp
80101766:	6a 40                	push   $0x40
80101768:	6a 00                	push   $0x0
8010176a:	51                   	push   %ecx
8010176b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010176e:	e8 0d 32 00 00       	call   80104980 <memset>
      dip->type = type;
80101773:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101777:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010177a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010177d:	89 1c 24             	mov    %ebx,(%esp)
80101780:	e8 3b 19 00 00       	call   801030c0 <log_write>
      brelse(bp);
80101785:	89 1c 24             	mov    %ebx,(%esp)
80101788:	e8 73 ea ff ff       	call   80100200 <brelse>
      return iget(dev, inum);
8010178d:	83 c4 10             	add    $0x10,%esp
}
80101790:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101793:	89 fa                	mov    %edi,%edx
}
80101795:	5b                   	pop    %ebx
      return iget(dev, inum);
80101796:	89 f0                	mov    %esi,%eax
}
80101798:	5e                   	pop    %esi
80101799:	5f                   	pop    %edi
8010179a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010179b:	e9 c0 fb ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801017a0:	83 ec 0c             	sub    $0xc,%esp
801017a3:	68 87 76 10 80       	push   $0x80107687
801017a8:	e8 f3 eb ff ff       	call   801003a0 <panic>
801017ad:	8d 76 00             	lea    0x0(%esi),%esi

801017b0 <iupdate>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017bb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017be:	83 ec 08             	sub    $0x8,%esp
801017c1:	c1 e8 03             	shr    $0x3,%eax
801017c4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017ca:	50                   	push   %eax
801017cb:	ff 73 a4             	push   -0x5c(%ebx)
801017ce:	e8 fd e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801017d3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
  dip->type = ip->type;
801017e5:	66 89 54 06 5c       	mov    %dx,0x5c(%esi,%eax,1)
  dip->major = ip->major;
801017ea:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
801017ee:	66 89 54 06 5e       	mov    %dx,0x5e(%esi,%eax,1)
  dip->minor = ip->minor;
801017f3:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017f7:	66 89 54 06 60       	mov    %dx,0x60(%esi,%eax,1)
  dip->nlink = ip->nlink;
801017fc:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101800:	66 89 54 06 62       	mov    %dx,0x62(%esi,%eax,1)
  dip->size = ip->size;
80101805:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101808:	89 54 06 64          	mov    %edx,0x64(%esi,%eax,1)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010180c:	8d 44 06 68          	lea    0x68(%esi,%eax,1),%eax
80101810:	6a 34                	push   $0x34
80101812:	53                   	push   %ebx
80101813:	50                   	push   %eax
80101814:	e8 f7 31 00 00       	call   80104a10 <memmove>
  log_write(bp);
80101819:	89 34 24             	mov    %esi,(%esp)
8010181c:	e8 9f 18 00 00       	call   801030c0 <log_write>
  brelse(bp);
80101821:	83 c4 10             	add    $0x10,%esp
80101824:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101827:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182a:	5b                   	pop    %ebx
8010182b:	5e                   	pop    %esi
8010182c:	5d                   	pop    %ebp
  brelse(bp);
8010182d:	e9 ce e9 ff ff       	jmp    80100200 <brelse>
80101832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101838:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010183f:	00 

80101840 <idup>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	53                   	push   %ebx
80101844:	83 ec 10             	sub    $0x10,%esp
80101847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010184a:	68 60 f9 10 80       	push   $0x8010f960
8010184f:	e8 0c 30 00 00       	call   80104860 <acquire>
  ip->ref++;
80101854:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101858:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010185f:	e8 9c 2f 00 00       	call   80104800 <release>
}
80101864:	89 d8                	mov    %ebx,%eax
80101866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101869:	c9                   	leave
8010186a:	c3                   	ret
8010186b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101870 <ilock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	53                   	push   %ebx
80101874:	83 ec 14             	sub    $0x14,%esp
80101877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010187a:	85 db                	test   %ebx,%ebx
8010187c:	0f 84 bb 00 00 00    	je     8010193d <ilock+0xcd>
80101882:	8b 53 08             	mov    0x8(%ebx),%edx
80101885:	85 d2                	test   %edx,%edx
80101887:	0f 8e b0 00 00 00    	jle    8010193d <ilock+0xcd>
  acquiresleep(&ip->lock);
8010188d:	83 ec 0c             	sub    $0xc,%esp
80101890:	8d 43 0c             	lea    0xc(%ebx),%eax
80101893:	50                   	push   %eax
80101894:	e8 b7 2c 00 00       	call   80104550 <acquiresleep>
  if(ip->valid == 0){
80101899:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010189c:	83 c4 10             	add    $0x10,%esp
8010189f:	85 c0                	test   %eax,%eax
801018a1:	74 0d                	je     801018b0 <ilock+0x40>
}
801018a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a6:	c9                   	leave
801018a7:	c3                   	ret
801018a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018af:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018b0:	8b 43 04             	mov    0x4(%ebx),%eax
801018b3:	83 ec 08             	sub    $0x8,%esp
801018b6:	c1 e8 03             	shr    $0x3,%eax
801018b9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801018bf:	50                   	push   %eax
801018c0:	ff 33                	push   (%ebx)
801018c2:	e8 09 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ca:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018cc:	8b 43 04             	mov    0x4(%ebx),%eax
801018cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
801018d2:	83 e0 07             	and    $0x7,%eax
801018d5:	c1 e0 06             	shl    $0x6,%eax
801018d8:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    ip->type = dip->type;
801018dc:	0f b7 08             	movzwl (%eax),%ecx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018df:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018e2:	66 89 4b 50          	mov    %cx,0x50(%ebx)
    ip->major = dip->major;
801018e6:	0f b7 48 f6          	movzwl -0xa(%eax),%ecx
801018ea:	66 89 4b 52          	mov    %cx,0x52(%ebx)
    ip->minor = dip->minor;
801018ee:	0f b7 48 f8          	movzwl -0x8(%eax),%ecx
801018f2:	66 89 4b 54          	mov    %cx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018f6:	0f b7 48 fa          	movzwl -0x6(%eax),%ecx
801018fa:	66 89 4b 56          	mov    %cx,0x56(%ebx)
    ip->size = dip->size;
801018fe:	8b 48 fc             	mov    -0x4(%eax),%ecx
80101901:	89 4b 58             	mov    %ecx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101904:	6a 34                	push   $0x34
80101906:	50                   	push   %eax
80101907:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010190a:	50                   	push   %eax
8010190b:	e8 00 31 00 00       	call   80104a10 <memmove>
    brelse(bp);
80101910:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101913:	89 14 24             	mov    %edx,(%esp)
80101916:	e8 e5 e8 ff ff       	call   80100200 <brelse>
    ip->valid = 1;
8010191b:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101922:	83 c4 10             	add    $0x10,%esp
80101925:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010192a:	0f 85 73 ff ff ff    	jne    801018a3 <ilock+0x33>
      panic("ilock: no type");
80101930:	83 ec 0c             	sub    $0xc,%esp
80101933:	68 9f 76 10 80       	push   $0x8010769f
80101938:	e8 63 ea ff ff       	call   801003a0 <panic>
    panic("ilock");
8010193d:	83 ec 0c             	sub    $0xc,%esp
80101940:	68 99 76 10 80       	push   $0x80107699
80101945:	e8 56 ea ff ff       	call   801003a0 <panic>
8010194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101950 <iunlock>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	56                   	push   %esi
80101954:	53                   	push   %ebx
80101955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101958:	85 db                	test   %ebx,%ebx
8010195a:	74 28                	je     80101984 <iunlock+0x34>
8010195c:	83 ec 0c             	sub    $0xc,%esp
8010195f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101962:	56                   	push   %esi
80101963:	e8 88 2c 00 00       	call   801045f0 <holdingsleep>
80101968:	83 c4 10             	add    $0x10,%esp
8010196b:	85 c0                	test   %eax,%eax
8010196d:	74 15                	je     80101984 <iunlock+0x34>
8010196f:	8b 43 08             	mov    0x8(%ebx),%eax
80101972:	85 c0                	test   %eax,%eax
80101974:	7e 0e                	jle    80101984 <iunlock+0x34>
  releasesleep(&ip->lock);
80101976:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101979:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010197c:	5b                   	pop    %ebx
8010197d:	5e                   	pop    %esi
8010197e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010197f:	e9 2c 2c 00 00       	jmp    801045b0 <releasesleep>
    panic("iunlock");
80101984:	83 ec 0c             	sub    $0xc,%esp
80101987:	68 ae 76 10 80       	push   $0x801076ae
8010198c:	e8 0f ea ff ff       	call   801003a0 <panic>
80101991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010199f:	00 

801019a0 <iput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 28             	sub    $0x28,%esp
801019a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801019af:	56                   	push   %esi
801019b0:	e8 9b 2b 00 00       	call   80104550 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019b5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 d2                	test   %edx,%edx
801019bd:	74 07                	je     801019c6 <iput+0x26>
801019bf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019c4:	74 32                	je     801019f8 <iput+0x58>
  releasesleep(&ip->lock);
801019c6:	83 ec 0c             	sub    $0xc,%esp
801019c9:	56                   	push   %esi
801019ca:	e8 e1 2b 00 00       	call   801045b0 <releasesleep>
  acquire(&icache.lock);
801019cf:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801019d6:	e8 85 2e 00 00       	call   80104860 <acquire>
  ip->ref--;
801019db:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019df:	83 c4 10             	add    $0x10,%esp
801019e2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
801019e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ec:	5b                   	pop    %ebx
801019ed:	5e                   	pop    %esi
801019ee:	5f                   	pop    %edi
801019ef:	5d                   	pop    %ebp
  release(&icache.lock);
801019f0:	e9 0b 2e 00 00       	jmp    80104800 <release>
801019f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	68 60 f9 10 80       	push   $0x8010f960
80101a00:	e8 5b 2e 00 00       	call   80104860 <acquire>
    int r = ip->ref;
80101a05:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101a08:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a0f:	e8 ec 2d 00 00       	call   80104800 <release>
    if(r == 1){
80101a14:	83 c4 10             	add    $0x10,%esp
80101a17:	83 ff 01             	cmp    $0x1,%edi
80101a1a:	75 aa                	jne    801019c6 <iput+0x26>
80101a1c:	89 f7                	mov    %esi,%edi
80101a1e:	89 d9                	mov    %ebx,%ecx
80101a20:	8d b3 8c 00 00 00    	lea    0x8c(%ebx),%esi
80101a26:	83 c3 5c             	add    $0x5c,%ebx
80101a29:	eb 0c                	jmp    80101a37 <iput+0x97>
80101a2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a30:	83 c3 04             	add    $0x4,%ebx
80101a33:	39 f3                	cmp    %esi,%ebx
80101a35:	74 21                	je     80101a58 <iput+0xb8>
    if(ip->addrs[i]){
80101a37:	8b 13                	mov    (%ebx),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a3d:	8b 01                	mov    (%ecx),%eax
80101a3f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101a42:	e8 59 fa ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
80101a47:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101a4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a50:	eb de                	jmp    80101a30 <iput+0x90>
80101a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a58:	8b 81 8c 00 00 00    	mov    0x8c(%ecx),%eax
80101a5e:	89 fe                	mov    %edi,%esi
80101a60:	89 cb                	mov    %ecx,%ebx
80101a62:	85 c0                	test   %eax,%eax
80101a64:	75 2d                	jne    80101a93 <iput+0xf3>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a66:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a69:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a70:	53                   	push   %ebx
80101a71:	e8 3a fd ff ff       	call   801017b0 <iupdate>
      ip->type = 0;
80101a76:	31 c0                	xor    %eax,%eax
80101a78:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a7c:	89 1c 24             	mov    %ebx,(%esp)
80101a7f:	e8 2c fd ff ff       	call   801017b0 <iupdate>
      ip->valid = 0;
80101a84:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a8b:	83 c4 10             	add    $0x10,%esp
80101a8e:	e9 33 ff ff ff       	jmp    801019c6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a93:	83 ec 08             	sub    $0x8,%esp
80101a96:	50                   	push   %eax
80101a97:	ff 31                	push   (%ecx)
80101a99:	e8 32 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a9e:	83 c4 10             	add    $0x10,%esp
80101aa1:	89 d9                	mov    %ebx,%ecx
80101aa3:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa6:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101aa9:	8d 70 5c             	lea    0x5c(%eax),%esi
80101aac:	8d 98 5c 02 00 00    	lea    0x25c(%eax),%ebx
80101ab2:	eb 13                	jmp    80101ac7 <iput+0x127>
80101ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ab8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101abf:	00 
80101ac0:	83 c6 04             	add    $0x4,%esi
80101ac3:	39 de                	cmp    %ebx,%esi
80101ac5:	74 15                	je     80101adc <iput+0x13c>
      if(a[j])
80101ac7:	8b 16                	mov    (%esi),%edx
80101ac9:	85 d2                	test   %edx,%edx
80101acb:	74 f3                	je     80101ac0 <iput+0x120>
        bfree(ip->dev, a[j]);
80101acd:	8b 01                	mov    (%ecx),%eax
80101acf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101ad2:	e8 c9 f9 ff ff       	call   801014a0 <bfree>
80101ad7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ada:	eb e4                	jmp    80101ac0 <iput+0x120>
    brelse(bp);
80101adc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101adf:	83 ec 0c             	sub    $0xc,%esp
80101ae2:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101ae5:	89 cb                	mov    %ecx,%ebx
80101ae7:	50                   	push   %eax
80101ae8:	e8 13 e7 ff ff       	call   80100200 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101aed:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101af3:	8b 03                	mov    (%ebx),%eax
80101af5:	e8 a6 f9 ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b04:	00 00 00 
80101b07:	e9 5a ff ff ff       	jmp    80101a66 <iput+0xc6>
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b10 <iunlockput>:
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	56                   	push   %esi
80101b14:	53                   	push   %ebx
80101b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b18:	85 db                	test   %ebx,%ebx
80101b1a:	74 34                	je     80101b50 <iunlockput+0x40>
80101b1c:	83 ec 0c             	sub    $0xc,%esp
80101b1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b22:	56                   	push   %esi
80101b23:	e8 c8 2a 00 00       	call   801045f0 <holdingsleep>
80101b28:	83 c4 10             	add    $0x10,%esp
80101b2b:	85 c0                	test   %eax,%eax
80101b2d:	74 21                	je     80101b50 <iunlockput+0x40>
80101b2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b32:	85 c0                	test   %eax,%eax
80101b34:	7e 1a                	jle    80101b50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b36:	83 ec 0c             	sub    $0xc,%esp
80101b39:	56                   	push   %esi
80101b3a:	e8 71 2a 00 00       	call   801045b0 <releasesleep>
  iput(ip);
80101b3f:	83 c4 10             	add    $0x10,%esp
80101b42:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101b45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b48:	5b                   	pop    %ebx
80101b49:	5e                   	pop    %esi
80101b4a:	5d                   	pop    %ebp
  iput(ip);
80101b4b:	e9 50 fe ff ff       	jmp    801019a0 <iput>
    panic("iunlock");
80101b50:	83 ec 0c             	sub    $0xc,%esp
80101b53:	68 ae 76 10 80       	push   $0x801076ae
80101b58:	e8 43 e8 ff ff       	call   801003a0 <panic>
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi

80101b60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	8b 55 08             	mov    0x8(%ebp),%edx
80101b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b69:	8b 0a                	mov    (%edx),%ecx
80101b6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b83:	8b 52 58             	mov    0x58(%edx),%edx
80101b86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b89:	5d                   	pop    %ebp
80101b8a:	c3                   	ret
80101b8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b9c:	8b 75 08             	mov    0x8(%ebp),%esi
80101b9f:	8b 7d 10             	mov    0x10(%ebp),%edi
80101ba2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101ba5:	8b 45 14             	mov    0x14(%ebp),%eax
80101ba8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bab:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
80101bb0:	0f 84 aa 00 00 00    	je     80101c60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bb6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101bb9:	8b 56 58             	mov    0x58(%esi),%edx
80101bbc:	39 fa                	cmp    %edi,%edx
80101bbe:	0f 82 bd 00 00 00    	jb     80101c81 <readi+0xf1>
80101bc4:	89 f9                	mov    %edi,%ecx
80101bc6:	31 db                	xor    %ebx,%ebx
80101bc8:	01 c1                	add    %eax,%ecx
80101bca:	0f 92 c3             	setb   %bl
80101bcd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101bd0:	0f 82 ab 00 00 00    	jb     80101c81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101bd6:	89 d3                	mov    %edx,%ebx
80101bd8:	29 fb                	sub    %edi,%ebx
80101bda:	39 ca                	cmp    %ecx,%edx
80101bdc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bdf:	85 c0                	test   %eax,%eax
80101be1:	74 73                	je     80101c56 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101be3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101be6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101bf3:	89 fa                	mov    %edi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 d8                	mov    %ebx,%eax
80101bfa:	e8 21 f9 ff ff       	call   80101520 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 33                	push   (%ebx)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c14:	89 f8                	mov    %edi,%eax
80101c16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1b:	29 f3                	sub    %esi,%ebx
80101c1d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c1f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c23:	39 d9                	cmp    %ebx,%ecx
80101c25:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c28:	83 c4 0c             	add    $0xc,%esp
80101c2b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c2c:	01 de                	add    %ebx,%esi
80101c2e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c30:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101c33:	50                   	push   %eax
80101c34:	ff 75 e0             	push   -0x20(%ebp)
80101c37:	e8 d4 2d 00 00       	call   80104a10 <memmove>
    brelse(bp);
80101c3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c3f:	89 14 24             	mov    %edx,(%esp)
80101c42:	e8 b9 e5 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c4d:	83 c4 10             	add    $0x10,%esp
80101c50:	39 de                	cmp    %ebx,%esi
80101c52:	72 9c                	jb     80101bf0 <readi+0x60>
80101c54:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c59:	5b                   	pop    %ebx
80101c5a:	5e                   	pop    %esi
80101c5b:	5f                   	pop    %edi
80101c5c:	5d                   	pop    %ebp
80101c5d:	c3                   	ret
80101c5e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c60:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101c64:	66 83 fa 09          	cmp    $0x9,%dx
80101c68:	77 17                	ja     80101c81 <readi+0xf1>
80101c6a:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101c71:	85 d2                	test   %edx,%edx
80101c73:	74 0c                	je     80101c81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c75:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7b:	5b                   	pop    %ebx
80101c7c:	5e                   	pop    %esi
80101c7d:	5f                   	pop    %edi
80101c7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c7f:	ff e2                	jmp    *%edx
      return -1;
80101c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c86:	eb ce                	jmp    80101c56 <readi+0xc6>
80101c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c8f:	00 

80101c90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	83 ec 1c             	sub    $0x1c,%esp
80101c99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c9c:	8b 75 14             	mov    0x14(%ebp),%esi
80101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca2:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101ca5:	8b 7d 10             	mov    0x10(%ebp),%edi
80101ca8:	89 75 e0             	mov    %esi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cab:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101cb0:	0f 84 ba 00 00 00    	je     80101d70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cb6:	39 78 58             	cmp    %edi,0x58(%eax)
80101cb9:	0f 82 ea 00 00 00    	jb     80101da9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101cbf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101cc2:	89 f2                	mov    %esi,%edx
80101cc4:	01 fa                	add    %edi,%edx
80101cc6:	0f 82 dd 00 00 00    	jb     80101da9 <writei+0x119>
80101ccc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101cd2:	0f 87 d1 00 00 00    	ja     80101da9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cd8:	85 f6                	test   %esi,%esi
80101cda:	0f 84 81 00 00 00    	je     80101d61 <writei+0xd1>
80101ce0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101ce7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cf0:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101cf3:	89 fa                	mov    %edi,%edx
80101cf5:	c1 ea 09             	shr    $0x9,%edx
80101cf8:	89 f0                	mov    %esi,%eax
80101cfa:	e8 21 f8 ff ff       	call   80101520 <bmap>
80101cff:	83 ec 08             	sub    $0x8,%esp
80101d02:	50                   	push   %eax
80101d03:	ff 36                	push   (%esi)
80101d05:	e8 c6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d15:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d17:	89 f8                	mov    %edi,%eax
80101d19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d20:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d24:	39 d9                	cmp    %ebx,%ecx
80101d26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d29:	83 c4 0c             	add    $0xc,%esp
80101d2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d2d:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101d2f:	ff 75 dc             	push   -0x24(%ebp)
80101d32:	50                   	push   %eax
80101d33:	e8 d8 2c 00 00       	call   80104a10 <memmove>
    log_write(bp);
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 80 13 00 00       	call   801030c0 <log_write>
    brelse(bp);
80101d40:	89 34 24             	mov    %esi,(%esp)
80101d43:	e8 b8 e4 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d54:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80101d57:	72 97                	jb     80101cf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d5c:	39 78 58             	cmp    %edi,0x58(%eax)
80101d5f:	72 37                	jb     80101d98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d67:	5b                   	pop    %ebx
80101d68:	5e                   	pop    %esi
80101d69:	5f                   	pop    %edi
80101d6a:	5d                   	pop    %ebp
80101d6b:	c3                   	ret
80101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d74:	66 83 f8 09          	cmp    $0x9,%ax
80101d78:	77 2f                	ja     80101da9 <writei+0x119>
80101d7a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101d81:	85 c0                	test   %eax,%eax
80101d83:	74 24                	je     80101da9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101d85:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d8b:	5b                   	pop    %ebx
80101d8c:	5e                   	pop    %esi
80101d8d:	5f                   	pop    %edi
80101d8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d8f:	ff e0                	jmp    *%eax
80101d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d98:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d9b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d9e:	50                   	push   %eax
80101d9f:	e8 0c fa ff ff       	call   801017b0 <iupdate>
80101da4:	83 c4 10             	add    $0x10,%esp
80101da7:	eb b8                	jmp    80101d61 <writei+0xd1>
      return -1;
80101da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dae:	eb b4                	jmp    80101d64 <writei+0xd4>

80101db0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101db6:	6a 0e                	push   $0xe
80101db8:	ff 75 0c             	push   0xc(%ebp)
80101dbb:	ff 75 08             	push   0x8(%ebp)
80101dbe:	e8 bd 2c 00 00       	call   80104a80 <strncmp>
}
80101dc3:	c9                   	leave
80101dc4:	c3                   	ret
80101dc5:	8d 76 00             	lea    0x0(%esi),%esi
80101dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dcf:	00 

80101dd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 1c             	sub    $0x1c,%esp
80101dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ddc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101de1:	0f 85 8d 00 00 00    	jne    80101e74 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101de7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dea:	31 ff                	xor    %edi,%edi
80101dec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101def:	85 d2                	test   %edx,%edx
80101df1:	74 46                	je     80101e39 <dirlookup+0x69>
80101df3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dff:	00 
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e00:	6a 10                	push   $0x10
80101e02:	57                   	push   %edi
80101e03:	56                   	push   %esi
80101e04:	53                   	push   %ebx
80101e05:	e8 86 fd ff ff       	call   80101b90 <readi>
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	83 f8 10             	cmp    $0x10,%eax
80101e10:	75 55                	jne    80101e67 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101e12:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e17:	74 18                	je     80101e31 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101e19:	83 ec 04             	sub    $0x4,%esp
80101e1c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e1f:	6a 0e                	push   $0xe
80101e21:	50                   	push   %eax
80101e22:	ff 75 0c             	push   0xc(%ebp)
80101e25:	e8 56 2c 00 00       	call   80104a80 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e2a:	83 c4 10             	add    $0x10,%esp
80101e2d:	85 c0                	test   %eax,%eax
80101e2f:	74 17                	je     80101e48 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e31:	83 c7 10             	add    $0x10,%edi
80101e34:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e37:	72 c7                	jb     80101e00 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e3c:	31 c0                	xor    %eax,%eax
}
80101e3e:	5b                   	pop    %ebx
80101e3f:	5e                   	pop    %esi
80101e40:	5f                   	pop    %edi
80101e41:	5d                   	pop    %ebp
80101e42:	c3                   	ret
80101e43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101e48:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4b:	85 c0                	test   %eax,%eax
80101e4d:	74 05                	je     80101e54 <dirlookup+0x84>
        *poff = off;
80101e4f:	8b 45 10             	mov    0x10(%ebp),%eax
80101e52:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e54:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e58:	8b 03                	mov    (%ebx),%eax
80101e5a:	e8 01 f5 ff ff       	call   80101360 <iget>
}
80101e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e62:	5b                   	pop    %ebx
80101e63:	5e                   	pop    %esi
80101e64:	5f                   	pop    %edi
80101e65:	5d                   	pop    %ebp
80101e66:	c3                   	ret
      panic("dirlookup read");
80101e67:	83 ec 0c             	sub    $0xc,%esp
80101e6a:	68 c8 76 10 80       	push   $0x801076c8
80101e6f:	e8 2c e5 ff ff       	call   801003a0 <panic>
    panic("dirlookup not DIR");
80101e74:	83 ec 0c             	sub    $0xc,%esp
80101e77:	68 b6 76 10 80       	push   $0x801076b6
80101e7c:	e8 1f e5 ff ff       	call   801003a0 <panic>
80101e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e8f:	00 

80101e90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	89 c3                	mov    %eax,%ebx
80101e98:	83 ec 1c             	sub    $0x1c,%esp
80101e9b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e9e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ea1:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ea4:	0f 84 bc 01 00 00    	je     80102066 <namex+0x1d6>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eaa:	e8 91 1c 00 00       	call   80103b40 <myproc>
  acquire(&icache.lock);
80101eaf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101eb2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101eb5:	68 60 f9 10 80       	push   $0x8010f960
80101eba:	e8 a1 29 00 00       	call   80104860 <acquire>
  ip->ref++;
80101ebf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ec3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101eca:	e8 31 29 00 00       	call   80104800 <release>
80101ecf:	83 c4 10             	add    $0x10,%esp
80101ed2:	eb 0f                	jmp    80101ee3 <namex+0x53>
80101ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101edf:	00 
    path++;
80101ee0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ee3:	0f b6 03             	movzbl (%ebx),%eax
80101ee6:	3c 2f                	cmp    $0x2f,%al
80101ee8:	74 f6                	je     80101ee0 <namex+0x50>
  if(*path == 0)
80101eea:	84 c0                	test   %al,%al
80101eec:	0f 84 16 01 00 00    	je     80102008 <namex+0x178>
  while(*path != '/' && *path != 0)
80101ef2:	0f b6 03             	movzbl (%ebx),%eax
80101ef5:	84 c0                	test   %al,%al
80101ef7:	0f 84 23 01 00 00    	je     80102020 <namex+0x190>
80101efd:	89 df                	mov    %ebx,%edi
80101eff:	3c 2f                	cmp    $0x2f,%al
80101f01:	0f 84 19 01 00 00    	je     80102020 <namex+0x190>
80101f07:	90                   	nop
80101f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f0f:	00 
80101f10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f17:	3c 2f                	cmp    $0x2f,%al
80101f19:	74 04                	je     80101f1f <namex+0x8f>
80101f1b:	84 c0                	test   %al,%al
80101f1d:	75 f1                	jne    80101f10 <namex+0x80>
  len = path - s;
80101f1f:	89 f8                	mov    %edi,%eax
80101f21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f23:	83 f8 0d             	cmp    $0xd,%eax
80101f26:	0f 8e b4 00 00 00    	jle    80101fe0 <namex+0x150>
    memmove(name, s, DIRSIZ);
80101f2c:	83 ec 04             	sub    $0x4,%esp
80101f2f:	6a 0e                	push   $0xe
80101f31:	53                   	push   %ebx
80101f32:	89 fb                	mov    %edi,%ebx
80101f34:	ff 75 e4             	push   -0x1c(%ebp)
80101f37:	e8 d4 2a 00 00       	call   80104a10 <memmove>
80101f3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f42:	75 14                	jne    80101f58 <namex+0xc8>
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f4f:	00 
    path++;
80101f50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f56:	74 f8                	je     80101f50 <namex+0xc0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	56                   	push   %esi
80101f5c:	e8 0f f9 ff ff       	call   80101870 <ilock>
    if(ip->type != T_DIR){
80101f61:	83 c4 10             	add    $0x10,%esp
80101f64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f69:	0f 85 bd 00 00 00    	jne    8010202c <namex+0x19c>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f72:	85 c0                	test   %eax,%eax
80101f74:	74 09                	je     80101f7f <namex+0xef>
80101f76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f79:	0f 84 fd 00 00 00    	je     8010207c <namex+0x1ec>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f7f:	83 ec 04             	sub    $0x4,%esp
80101f82:	6a 00                	push   $0x0
80101f84:	ff 75 e4             	push   -0x1c(%ebp)
80101f87:	56                   	push   %esi
80101f88:	e8 43 fe ff ff       	call   80101dd0 <dirlookup>
80101f8d:	83 c4 10             	add    $0x10,%esp
80101f90:	89 c7                	mov    %eax,%edi
80101f92:	85 c0                	test   %eax,%eax
80101f94:	0f 84 92 00 00 00    	je     8010202c <namex+0x19c>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f9a:	83 ec 0c             	sub    $0xc,%esp
80101f9d:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101fa0:	51                   	push   %ecx
80101fa1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101fa4:	e8 47 26 00 00       	call   801045f0 <holdingsleep>
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	85 c0                	test   %eax,%eax
80101fae:	0f 84 08 01 00 00    	je     801020bc <namex+0x22c>
80101fb4:	8b 56 08             	mov    0x8(%esi),%edx
80101fb7:	85 d2                	test   %edx,%edx
80101fb9:	0f 8e fd 00 00 00    	jle    801020bc <namex+0x22c>
  releasesleep(&ip->lock);
80101fbf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101fc2:	83 ec 0c             	sub    $0xc,%esp
80101fc5:	51                   	push   %ecx
80101fc6:	e8 e5 25 00 00       	call   801045b0 <releasesleep>
  iput(ip);
80101fcb:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101fce:	89 fe                	mov    %edi,%esi
  iput(ip);
80101fd0:	e8 cb f9 ff ff       	call   801019a0 <iput>
80101fd5:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101fd8:	e9 06 ff ff ff       	jmp    80101ee3 <namex+0x53>
80101fdd:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fe3:	01 c2                	add    %eax,%edx
80101fe5:	89 55 e0             	mov    %edx,-0x20(%ebp)
    memmove(name, s, len);
80101fe8:	83 ec 04             	sub    $0x4,%esp
80101feb:	50                   	push   %eax
80101fec:	53                   	push   %ebx
    name[len] = 0;
80101fed:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fef:	ff 75 e4             	push   -0x1c(%ebp)
80101ff2:	e8 19 2a 00 00       	call   80104a10 <memmove>
    name[len] = 0;
80101ff7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	c6 00 00             	movb   $0x0,(%eax)
80102000:	e9 3a ff ff ff       	jmp    80101f3f <namex+0xaf>
80102005:	8d 76 00             	lea    0x0(%esi),%esi
  }
  if(nameiparent){
80102008:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010200b:	85 c0                	test   %eax,%eax
8010200d:	0f 85 99 00 00 00    	jne    801020ac <namex+0x21c>
    iput(ip);
    return 0;
  }
  return ip;
}
80102013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102016:	89 f0                	mov    %esi,%eax
80102018:	5b                   	pop    %ebx
80102019:	5e                   	pop    %esi
8010201a:	5f                   	pop    %edi
8010201b:	5d                   	pop    %ebp
8010201c:	c3                   	ret
8010201d:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102023:	89 df                	mov    %ebx,%edi
80102025:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102028:	31 c0                	xor    %eax,%eax
8010202a:	eb bc                	jmp    80101fe8 <namex+0x158>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010202c:	83 ec 0c             	sub    $0xc,%esp
8010202f:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102032:	53                   	push   %ebx
80102033:	e8 b8 25 00 00       	call   801045f0 <holdingsleep>
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	85 c0                	test   %eax,%eax
8010203d:	74 7d                	je     801020bc <namex+0x22c>
8010203f:	8b 4e 08             	mov    0x8(%esi),%ecx
80102042:	85 c9                	test   %ecx,%ecx
80102044:	7e 76                	jle    801020bc <namex+0x22c>
  releasesleep(&ip->lock);
80102046:	83 ec 0c             	sub    $0xc,%esp
80102049:	53                   	push   %ebx
8010204a:	e8 61 25 00 00       	call   801045b0 <releasesleep>
  iput(ip);
8010204f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102052:	31 f6                	xor    %esi,%esi
  iput(ip);
80102054:	e8 47 f9 ff ff       	call   801019a0 <iput>
      return 0;
80102059:	83 c4 10             	add    $0x10,%esp
}
8010205c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010205f:	89 f0                	mov    %esi,%eax
80102061:	5b                   	pop    %ebx
80102062:	5e                   	pop    %esi
80102063:	5f                   	pop    %edi
80102064:	5d                   	pop    %ebp
80102065:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102066:	ba 01 00 00 00       	mov    $0x1,%edx
8010206b:	b8 01 00 00 00       	mov    $0x1,%eax
80102070:	e8 eb f2 ff ff       	call   80101360 <iget>
80102075:	89 c6                	mov    %eax,%esi
80102077:	e9 67 fe ff ff       	jmp    80101ee3 <namex+0x53>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010207c:	83 ec 0c             	sub    $0xc,%esp
8010207f:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102082:	53                   	push   %ebx
80102083:	e8 68 25 00 00       	call   801045f0 <holdingsleep>
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	74 2d                	je     801020bc <namex+0x22c>
8010208f:	8b 7e 08             	mov    0x8(%esi),%edi
80102092:	85 ff                	test   %edi,%edi
80102094:	7e 26                	jle    801020bc <namex+0x22c>
  releasesleep(&ip->lock);
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	53                   	push   %ebx
8010209a:	e8 11 25 00 00       	call   801045b0 <releasesleep>
}
8010209f:	83 c4 10             	add    $0x10,%esp
}
801020a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a5:	89 f0                	mov    %esi,%eax
801020a7:	5b                   	pop    %ebx
801020a8:	5e                   	pop    %esi
801020a9:	5f                   	pop    %edi
801020aa:	5d                   	pop    %ebp
801020ab:	c3                   	ret
    iput(ip);
801020ac:	83 ec 0c             	sub    $0xc,%esp
801020af:	56                   	push   %esi
      return 0;
801020b0:	31 f6                	xor    %esi,%esi
    iput(ip);
801020b2:	e8 e9 f8 ff ff       	call   801019a0 <iput>
    return 0;
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	eb a0                	jmp    8010205c <namex+0x1cc>
    panic("iunlock");
801020bc:	83 ec 0c             	sub    $0xc,%esp
801020bf:	68 ae 76 10 80       	push   $0x801076ae
801020c4:	e8 d7 e2 ff ff       	call   801003a0 <panic>
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020d0 <dirlink>:
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	57                   	push   %edi
801020d4:	56                   	push   %esi
801020d5:	53                   	push   %ebx
801020d6:	83 ec 20             	sub    $0x20,%esp
801020d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020dc:	6a 00                	push   $0x0
801020de:	ff 75 0c             	push   0xc(%ebp)
801020e1:	53                   	push   %ebx
801020e2:	e8 e9 fc ff ff       	call   80101dd0 <dirlookup>
801020e7:	83 c4 10             	add    $0x10,%esp
801020ea:	85 c0                	test   %eax,%eax
801020ec:	75 67                	jne    80102155 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020ee:	8b 7b 58             	mov    0x58(%ebx),%edi
801020f1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020f4:	85 ff                	test   %edi,%edi
801020f6:	74 29                	je     80102121 <dirlink+0x51>
801020f8:	31 ff                	xor    %edi,%edi
801020fa:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020fd:	eb 09                	jmp    80102108 <dirlink+0x38>
801020ff:	90                   	nop
80102100:	83 c7 10             	add    $0x10,%edi
80102103:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102106:	73 19                	jae    80102121 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102108:	6a 10                	push   $0x10
8010210a:	57                   	push   %edi
8010210b:	56                   	push   %esi
8010210c:	53                   	push   %ebx
8010210d:	e8 7e fa ff ff       	call   80101b90 <readi>
80102112:	83 c4 10             	add    $0x10,%esp
80102115:	83 f8 10             	cmp    $0x10,%eax
80102118:	75 4e                	jne    80102168 <dirlink+0x98>
    if(de.inum == 0)
8010211a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010211f:	75 df                	jne    80102100 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102121:	83 ec 04             	sub    $0x4,%esp
80102124:	8d 45 da             	lea    -0x26(%ebp),%eax
80102127:	6a 0e                	push   $0xe
80102129:	ff 75 0c             	push   0xc(%ebp)
8010212c:	50                   	push   %eax
8010212d:	e8 9e 29 00 00       	call   80104ad0 <strncpy>
  de.inum = inum;
80102132:	8b 45 10             	mov    0x10(%ebp),%eax
80102135:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102139:	6a 10                	push   $0x10
8010213b:	57                   	push   %edi
8010213c:	56                   	push   %esi
8010213d:	53                   	push   %ebx
8010213e:	e8 4d fb ff ff       	call   80101c90 <writei>
80102143:	83 c4 20             	add    $0x20,%esp
80102146:	83 f8 10             	cmp    $0x10,%eax
80102149:	75 2a                	jne    80102175 <dirlink+0xa5>
  return 0;
8010214b:	31 c0                	xor    %eax,%eax
}
8010214d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102150:	5b                   	pop    %ebx
80102151:	5e                   	pop    %esi
80102152:	5f                   	pop    %edi
80102153:	5d                   	pop    %ebp
80102154:	c3                   	ret
    iput(ip);
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	50                   	push   %eax
80102159:	e8 42 f8 ff ff       	call   801019a0 <iput>
    return -1;
8010215e:	83 c4 10             	add    $0x10,%esp
80102161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102166:	eb e5                	jmp    8010214d <dirlink+0x7d>
      panic("dirlink read");
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	68 d7 76 10 80       	push   $0x801076d7
80102170:	e8 2b e2 ff ff       	call   801003a0 <panic>
    panic("dirlink");
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	68 4f 79 10 80       	push   $0x8010794f
8010217d:	e8 1e e2 ff ff       	call   801003a0 <panic>
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010218f:	00 

80102190 <namei>:

struct inode*
namei(char *path)
{
80102190:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102191:	31 d2                	xor    %edx,%edx
{
80102193:	89 e5                	mov    %esp,%ebp
80102195:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102198:	8b 45 08             	mov    0x8(%ebp),%eax
8010219b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010219e:	e8 ed fc ff ff       	call   80101e90 <namex>
}
801021a3:	c9                   	leave
801021a4:	c3                   	ret
801021a5:	8d 76 00             	lea    0x0(%esi),%esi
801021a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021af:	00 

801021b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021b0:	55                   	push   %ebp
  return namex(path, 1, name);
801021b1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021b6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021be:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021bf:	e9 cc fc ff ff       	jmp    80101e90 <namex>
801021c4:	66 90                	xchg   %ax,%ax
801021c6:	66 90                	xchg   %ax,%ax
801021c8:	66 90                	xchg   %ax,%ax
801021ca:	66 90                	xchg   %ax,%ax
801021cc:	66 90                	xchg   %ax,%ax
801021ce:	66 90                	xchg   %ax,%ax

801021d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	57                   	push   %edi
801021d4:	56                   	push   %esi
801021d5:	53                   	push   %ebx
801021d6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021d9:	85 c0                	test   %eax,%eax
801021db:	0f 84 ac 00 00 00    	je     8010228d <idestart+0xbd>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021e1:	8b 70 08             	mov    0x8(%eax),%esi
801021e4:	89 c3                	mov    %eax,%ebx
801021e6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801021ec:	0f 87 8e 00 00 00    	ja     80102280 <idestart+0xb0>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021f7:	90                   	nop
801021f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021ff:	00 
80102200:	89 ca                	mov    %ecx,%edx
80102202:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102203:	83 e0 c0             	and    $0xffffffc0,%eax
80102206:	3c 40                	cmp    $0x40,%al
80102208:	75 f6                	jne    80102200 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010220a:	ba f6 03 00 00       	mov    $0x3f6,%edx
8010220f:	31 c0                	xor    %eax,%eax
80102211:	ee                   	out    %al,(%dx)
80102212:	b8 01 00 00 00       	mov    $0x1,%eax
80102217:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010221c:	ee                   	out    %al,(%dx)
8010221d:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102222:	89 f0                	mov    %esi,%eax
80102224:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102225:	89 f0                	mov    %esi,%eax
80102227:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010222c:	c1 f8 08             	sar    $0x8,%eax
8010222f:	ee                   	out    %al,(%dx)
80102230:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102235:	31 c0                	xor    %eax,%eax
80102237:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102238:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010223c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102241:	c1 e0 04             	shl    $0x4,%eax
80102244:	83 e0 10             	and    $0x10,%eax
80102247:	83 c8 e0             	or     $0xffffffe0,%eax
8010224a:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010224b:	f6 03 04             	testb  $0x4,(%ebx)
8010224e:	75 10                	jne    80102260 <idestart+0x90>
80102250:	b8 20 00 00 00       	mov    $0x20,%eax
80102255:	89 ca                	mov    %ecx,%edx
80102257:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225b:	5b                   	pop    %ebx
8010225c:	5e                   	pop    %esi
8010225d:	5f                   	pop    %edi
8010225e:	5d                   	pop    %ebp
8010225f:	c3                   	ret
80102260:	b8 30 00 00 00       	mov    $0x30,%eax
80102265:	89 ca                	mov    %ecx,%edx
80102267:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102268:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010226d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102270:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102275:	fc                   	cld
80102276:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227b:	5b                   	pop    %ebx
8010227c:	5e                   	pop    %esi
8010227d:	5f                   	pop    %edi
8010227e:	5d                   	pop    %ebp
8010227f:	c3                   	ret
    panic("incorrect blockno");
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	68 ed 76 10 80       	push   $0x801076ed
80102288:	e8 13 e1 ff ff       	call   801003a0 <panic>
    panic("idestart");
8010228d:	83 ec 0c             	sub    $0xc,%esp
80102290:	68 e4 76 10 80       	push   $0x801076e4
80102295:	e8 06 e1 ff ff       	call   801003a0 <panic>
8010229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022a0 <ideinit>:
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022a6:	68 ff 76 10 80       	push   $0x801076ff
801022ab:	68 00 16 11 80       	push   $0x80111600
801022b0:	e8 8b 23 00 00       	call   80104640 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022b5:	58                   	pop    %eax
801022b6:	a1 84 17 11 80       	mov    0x80111784,%eax
801022bb:	5a                   	pop    %edx
801022bc:	83 e8 01             	sub    $0x1,%eax
801022bf:	50                   	push   %eax
801022c0:	6a 0e                	push   $0xe
801022c2:	e8 b9 02 00 00       	call   80102580 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022cf:	90                   	nop
801022d0:	ec                   	in     (%dx),%al
801022d1:	83 e0 c0             	and    $0xffffffc0,%eax
801022d4:	3c 40                	cmp    $0x40,%al
801022d6:	75 f8                	jne    801022d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022e2:	ee                   	out    %al,(%dx)
801022e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ed:	eb 06                	jmp    801022f5 <ideinit+0x55>
801022ef:	90                   	nop
  for(i=0; i<1000; i++){
801022f0:	83 e9 01             	sub    $0x1,%ecx
801022f3:	74 0f                	je     80102304 <ideinit+0x64>
801022f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022f6:	84 c0                	test   %al,%al
801022f8:	74 f6                	je     801022f0 <ideinit+0x50>
      havedisk1 = 1;
801022fa:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102301:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102304:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102309:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010230e:	ee                   	out    %al,(%dx)
}
8010230f:	c9                   	leave
80102310:	c3                   	ret
80102311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010231f:	00 

80102320 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	57                   	push   %edi
80102324:	56                   	push   %esi
80102325:	53                   	push   %ebx
80102326:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102329:	68 00 16 11 80       	push   $0x80111600
8010232e:	e8 2d 25 00 00       	call   80104860 <acquire>

  if((b = idequeue) == 0){
80102333:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 db                	test   %ebx,%ebx
8010233e:	74 63                	je     801023a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102340:	8b 43 58             	mov    0x58(%ebx),%eax
80102343:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102348:	8b 33                	mov    (%ebx),%esi
8010234a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102350:	75 2f                	jne    80102381 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102352:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102357:	90                   	nop
80102358:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010235f:	00 
80102360:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102361:	89 c1                	mov    %eax,%ecx
80102363:	83 e1 c0             	and    $0xffffffc0,%ecx
80102366:	80 f9 40             	cmp    $0x40,%cl
80102369:	75 f5                	jne    80102360 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010236b:	a8 21                	test   $0x21,%al
8010236d:	75 12                	jne    80102381 <ideintr+0x61>
  asm volatile("cld; rep insl" :
8010236f:	b9 80 00 00 00       	mov    $0x80,%ecx
80102374:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102379:	8d 7b 5c             	lea    0x5c(%ebx),%edi
8010237c:	fc                   	cld
8010237d:	f3 6d                	rep insl (%dx),%es:(%edi)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010237f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102381:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102384:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102387:	83 ce 02             	or     $0x2,%esi
8010238a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010238c:	53                   	push   %ebx
8010238d:	e8 be 1f 00 00       	call   80104350 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102392:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102397:	83 c4 10             	add    $0x10,%esp
8010239a:	85 c0                	test   %eax,%eax
8010239c:	74 05                	je     801023a3 <ideintr+0x83>
    idestart(idequeue);
8010239e:	e8 2d fe ff ff       	call   801021d0 <idestart>
    release(&idelock);
801023a3:	83 ec 0c             	sub    $0xc,%esp
801023a6:	68 00 16 11 80       	push   $0x80111600
801023ab:	e8 50 24 00 00       	call   80104800 <release>

  release(&idelock);
}
801023b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023b3:	5b                   	pop    %ebx
801023b4:	5e                   	pop    %esi
801023b5:	5f                   	pop    %edi
801023b6:	5d                   	pop    %ebp
801023b7:	c3                   	ret
801023b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801023bf:	00 

801023c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	53                   	push   %ebx
801023c4:	83 ec 10             	sub    $0x10,%esp
801023c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801023cd:	50                   	push   %eax
801023ce:	e8 1d 22 00 00       	call   801045f0 <holdingsleep>
801023d3:	83 c4 10             	add    $0x10,%esp
801023d6:	85 c0                	test   %eax,%eax
801023d8:	0f 84 c3 00 00 00    	je     801024a1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 e0 06             	and    $0x6,%eax
801023e3:	83 f8 02             	cmp    $0x2,%eax
801023e6:	0f 84 a8 00 00 00    	je     80102494 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023ec:	8b 53 04             	mov    0x4(%ebx),%edx
801023ef:	85 d2                	test   %edx,%edx
801023f1:	74 0d                	je     80102400 <iderw+0x40>
801023f3:	a1 e0 15 11 80       	mov    0x801115e0,%eax
801023f8:	85 c0                	test   %eax,%eax
801023fa:	0f 84 87 00 00 00    	je     80102487 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102400:	83 ec 0c             	sub    $0xc,%esp
80102403:	68 00 16 11 80       	push   $0x80111600
80102408:	e8 53 24 00 00       	call   80104860 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010240d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102412:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102419:	83 c4 10             	add    $0x10,%esp
8010241c:	85 c0                	test   %eax,%eax
8010241e:	74 60                	je     80102480 <iderw+0xc0>
80102420:	89 c2                	mov    %eax,%edx
80102422:	8b 40 58             	mov    0x58(%eax),%eax
80102425:	85 c0                	test   %eax,%eax
80102427:	75 f7                	jne    80102420 <iderw+0x60>
80102429:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010242c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010242e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102434:	74 3a                	je     80102470 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102436:	8b 03                	mov    (%ebx),%eax
80102438:	83 e0 06             	and    $0x6,%eax
8010243b:	83 f8 02             	cmp    $0x2,%eax
8010243e:	74 1b                	je     8010245b <iderw+0x9b>
    sleep(b, &idelock);
80102440:	83 ec 08             	sub    $0x8,%esp
80102443:	68 00 16 11 80       	push   $0x80111600
80102448:	53                   	push   %ebx
80102449:	e8 42 1e 00 00       	call   80104290 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010244e:	8b 03                	mov    (%ebx),%eax
80102450:	83 c4 10             	add    $0x10,%esp
80102453:	83 e0 06             	and    $0x6,%eax
80102456:	83 f8 02             	cmp    $0x2,%eax
80102459:	75 e5                	jne    80102440 <iderw+0x80>
  }


  release(&idelock);
8010245b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102465:	c9                   	leave
  release(&idelock);
80102466:	e9 95 23 00 00       	jmp    80104800 <release>
8010246b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102470:	89 d8                	mov    %ebx,%eax
80102472:	e8 59 fd ff ff       	call   801021d0 <idestart>
80102477:	eb bd                	jmp    80102436 <iderw+0x76>
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102480:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102485:	eb a5                	jmp    8010242c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 2e 77 10 80       	push   $0x8010772e
8010248f:	e8 0c df ff ff       	call   801003a0 <panic>
    panic("iderw: nothing to do");
80102494:	83 ec 0c             	sub    $0xc,%esp
80102497:	68 19 77 10 80       	push   $0x80107719
8010249c:	e8 ff de ff ff       	call   801003a0 <panic>
    panic("iderw: buf not locked");
801024a1:	83 ec 0c             	sub    $0xc,%esp
801024a4:	68 03 77 10 80       	push   $0x80107703
801024a9:	e8 f2 de ff ff       	call   801003a0 <panic>
801024ae:	66 90                	xchg   %ax,%ax
801024b0:	66 90                	xchg   %ax,%ax
801024b2:	66 90                	xchg   %ax,%ax
801024b4:	66 90                	xchg   %ax,%ax
801024b6:	66 90                	xchg   %ax,%ax
801024b8:	66 90                	xchg   %ax,%ax
801024ba:	66 90                	xchg   %ax,%ax
801024bc:	66 90                	xchg   %ax,%ax
801024be:	66 90                	xchg   %ax,%ax

801024c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024c5:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801024cc:	00 c0 fe 
  ioapic->reg = reg;
801024cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024d6:	00 00 00 
  return ioapic->data;
801024d9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801024df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024e8:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024ee:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024f5:	c1 ee 10             	shr    $0x10,%esi
801024f8:	89 f0                	mov    %esi,%eax
801024fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102500:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102503:	39 c2                	cmp    %eax,%edx
80102505:	74 16                	je     8010251d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102507:	83 ec 0c             	sub    $0xc,%esp
8010250a:	68 1c 7b 10 80       	push   $0x80107b1c
8010250f:	e8 bc e1 ff ff       	call   801006d0 <cprintf>
  ioapic->reg = reg;
80102514:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010251a:	83 c4 10             	add    $0x10,%esp
{
8010251d:	ba 10 00 00 00       	mov    $0x10,%edx
80102522:	31 c0                	xor    %eax,%eax
80102524:	eb 1a                	jmp    80102540 <ioapicinit+0x80>
80102526:	66 90                	xchg   %ax,%ax
80102528:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010252f:	00 
80102530:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102537:	00 
80102538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010253f:	00 
  ioapic->reg = reg;
80102540:	89 13                	mov    %edx,(%ebx)
80102542:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
80102545:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010254b:	83 c0 01             	add    $0x1,%eax
8010254e:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
80102554:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
80102557:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
8010255a:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010255d:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
8010255f:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
80102565:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
8010256c:	39 c6                	cmp    %eax,%esi
8010256e:	7d d0                	jge    80102540 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102570:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102573:	5b                   	pop    %ebx
80102574:	5e                   	pop    %esi
80102575:	5d                   	pop    %ebp
80102576:	c3                   	ret
80102577:	90                   	nop
80102578:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010257f:	00 

80102580 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102580:	55                   	push   %ebp
  ioapic->reg = reg;
80102581:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102587:	89 e5                	mov    %esp,%ebp
80102589:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010258c:	8d 50 20             	lea    0x20(%eax),%edx
8010258f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102593:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102595:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010259b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010259e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025a6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret
801025b3:	66 90                	xchg   %ax,%ax
801025b5:	66 90                	xchg   %ax,%ax
801025b7:	66 90                	xchg   %ax,%ax
801025b9:	66 90                	xchg   %ax,%ax
801025bb:	66 90                	xchg   %ax,%ax
801025bd:	66 90                	xchg   %ax,%ax
801025bf:	90                   	nop

801025c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	53                   	push   %ebx
801025c4:	83 ec 04             	sub    $0x4,%esp
801025c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025d0:	75 76                	jne    80102648 <kfree+0x88>
801025d2:	81 fb d0 56 11 80    	cmp    $0x801156d0,%ebx
801025d8:	72 6e                	jb     80102648 <kfree+0x88>
801025da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025e5:	77 61                	ja     80102648 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025e7:	83 ec 04             	sub    $0x4,%esp
801025ea:	68 00 10 00 00       	push   $0x1000
801025ef:	6a 01                	push   $0x1
801025f1:	53                   	push   %ebx
801025f2:	e8 89 23 00 00       	call   80104980 <memset>

  if(kmem.use_lock)
801025f7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	85 d2                	test   %edx,%edx
80102602:	75 1c                	jne    80102620 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102604:	a1 78 16 11 80       	mov    0x80111678,%eax
80102609:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010260b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102610:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102616:	85 c0                	test   %eax,%eax
80102618:	75 1e                	jne    80102638 <kfree+0x78>
    release(&kmem.lock);
}
8010261a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010261d:	c9                   	leave
8010261e:	c3                   	ret
8010261f:	90                   	nop
    acquire(&kmem.lock);
80102620:	83 ec 0c             	sub    $0xc,%esp
80102623:	68 40 16 11 80       	push   $0x80111640
80102628:	e8 33 22 00 00       	call   80104860 <acquire>
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	eb d2                	jmp    80102604 <kfree+0x44>
80102632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102638:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010263f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102642:	c9                   	leave
    release(&kmem.lock);
80102643:	e9 b8 21 00 00       	jmp    80104800 <release>
    panic("kfree");
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	68 4c 77 10 80       	push   $0x8010774c
80102650:	e8 4b dd ff ff       	call   801003a0 <panic>
80102655:	8d 76 00             	lea    0x0(%esi),%esi
80102658:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265f:	00 

80102660 <freerange>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102665:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102668:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010266b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102671:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102677:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267d:	39 de                	cmp    %ebx,%esi
8010267f:	72 2b                	jb     801026ac <freerange+0x4c>
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102688:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268f:	00 
    kfree(p);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102699:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010269f:	50                   	push   %eax
801026a0:	e8 1b ff ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a5:	83 c4 10             	add    $0x10,%esp
801026a8:	39 de                	cmp    %ebx,%esi
801026aa:	73 e4                	jae    80102690 <freerange+0x30>
}
801026ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026af:	5b                   	pop    %ebx
801026b0:	5e                   	pop    %esi
801026b1:	5d                   	pop    %ebp
801026b2:	c3                   	ret
801026b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801026b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026bf:	00 

801026c0 <kinit2>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
801026c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dd:	39 de                	cmp    %ebx,%esi
801026df:	72 2b                	jb     8010270c <kinit2+0x4c>
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ef:	00 
    kfree(p);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026ff:	50                   	push   %eax
80102700:	e8 bb fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102705:	83 c4 10             	add    $0x10,%esp
80102708:	39 de                	cmp    %ebx,%esi
8010270a:	73 e4                	jae    801026f0 <kinit2+0x30>
  kmem.use_lock = 1;
8010270c:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
80102713:	00 00 00 
}
80102716:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102719:	5b                   	pop    %ebx
8010271a:	5e                   	pop    %esi
8010271b:	5d                   	pop    %ebp
8010271c:	c3                   	ret
8010271d:	8d 76 00             	lea    0x0(%esi),%esi

80102720 <kinit1>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
80102725:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 52 77 10 80       	push   $0x80107752
80102730:	68 40 16 11 80       	push   $0x80111640
80102735:	e8 06 1f 00 00       	call   80104640 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102740:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102747:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010274a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102750:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102756:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	72 1c                	jb     8010277c <kinit1+0x5c>
    kfree(p);
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010276f:	50                   	push   %eax
80102770:	e8 4b fe ff ff       	call   801025c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	39 de                	cmp    %ebx,%esi
8010277a:	73 e4                	jae    80102760 <kinit1+0x40>
}
8010277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5d                   	pop    %ebp
80102782:	c3                   	ret
80102783:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010278f:	00 

80102790 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102790:	a1 74 16 11 80       	mov    0x80111674,%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	75 1f                	jne    801027b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102799:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010279e:	85 c0                	test   %eax,%eax
801027a0:	74 0e                	je     801027b0 <kalloc+0x20>
    kmem.freelist = r->next;
801027a2:	8b 10                	mov    (%eax),%edx
801027a4:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801027aa:	c3                   	ret
801027ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
  return (char*)r;
}
801027b0:	c3                   	ret
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027b8:	55                   	push   %ebp
801027b9:	89 e5                	mov    %esp,%ebp
801027bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027be:	68 40 16 11 80       	push   $0x80111640
801027c3:	e8 98 20 00 00       	call   80104860 <acquire>
  r = kmem.freelist;
801027c8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801027cd:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801027d3:	83 c4 10             	add    $0x10,%esp
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 08                	je     801027e2 <kalloc+0x52>
    kmem.freelist = r->next;
801027da:	8b 08                	mov    (%eax),%ecx
801027dc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801027e2:	85 d2                	test   %edx,%edx
801027e4:	74 16                	je     801027fc <kalloc+0x6c>
    release(&kmem.lock);
801027e6:	83 ec 0c             	sub    $0xc,%esp
801027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027ec:	68 40 16 11 80       	push   $0x80111640
801027f1:	e8 0a 20 00 00       	call   80104800 <release>
801027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f9:	83 c4 10             	add    $0x10,%esp
}
801027fc:	c9                   	leave
801027fd:	c3                   	ret
801027fe:	66 90                	xchg   %ax,%ax

80102800 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102800:	ba 64 00 00 00       	mov    $0x64,%edx
80102805:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102806:	a8 01                	test   $0x1,%al
80102808:	0f 84 c2 00 00 00    	je     801028d0 <kbdgetc+0xd0>
{
8010280e:	55                   	push   %ebp
8010280f:	ba 60 00 00 00       	mov    $0x60,%edx
80102814:	89 e5                	mov    %esp,%ebp
80102816:	53                   	push   %ebx
80102817:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102818:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010281e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102821:	3c e0                	cmp    $0xe0,%al
80102823:	74 53                	je     80102878 <kbdgetc+0x78>
    return 0;
  } else if(data & 0x80){
80102825:	84 c0                	test   %al,%al
80102827:	78 67                	js     80102890 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102829:	f6 c3 40             	test   $0x40,%bl
8010282c:	74 09                	je     80102837 <kbdgetc+0x37>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010282e:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102831:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102834:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102837:	0f b6 91 60 7d 10 80 	movzbl -0x7fef82a0(%ecx),%edx
  shift ^= togglecode[data];
8010283e:	0f b6 81 60 7c 10 80 	movzbl -0x7fef83a0(%ecx),%eax
  shift |= shiftcode[data];
80102845:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102847:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102849:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010284b:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102851:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102854:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102857:	8b 04 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%eax
8010285e:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102862:	74 0b                	je     8010286f <kbdgetc+0x6f>
    if('a' <= c && c <= 'z')
80102864:	8d 50 9f             	lea    -0x61(%eax),%edx
80102867:	83 fa 19             	cmp    $0x19,%edx
8010286a:	77 4c                	ja     801028b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010286c:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010286f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102872:	c9                   	leave
80102873:	c3                   	ret
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102878:	83 cb 40             	or     $0x40,%ebx
    return 0;
8010287b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010287d:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
80102883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102886:	c9                   	leave
80102887:	c3                   	ret
80102888:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010288f:	00 
    data = (shift & E0ESC ? data : data & 0x7F);
80102890:	83 e0 7f             	and    $0x7f,%eax
80102893:	f6 c3 40             	test   $0x40,%bl
80102896:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102899:	0f b6 81 60 7d 10 80 	movzbl -0x7fef82a0(%ecx),%eax
801028a0:	83 c8 40             	or     $0x40,%eax
801028a3:	0f b6 c0             	movzbl %al,%eax
801028a6:	f7 d0                	not    %eax
801028a8:	21 d8                	and    %ebx,%eax
801028aa:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801028af:	31 c0                	xor    %eax,%eax
801028b1:	eb d0                	jmp    80102883 <kbdgetc+0x83>
801028b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801028b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801028be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c1:	c9                   	leave
      c += 'a' - 'A';
801028c2:	83 f9 1a             	cmp    $0x1a,%ecx
801028c5:	0f 42 c2             	cmovb  %edx,%eax
}
801028c8:	c3                   	ret
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028d5:	c3                   	ret
801028d6:	66 90                	xchg   %ax,%ax
801028d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028df:	00 

801028e0 <kbdintr>:

void
kbdintr(void)
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
801028e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028e6:	68 00 28 10 80       	push   $0x80102800
801028eb:	e8 e0 df ff ff       	call   801008d0 <consoleintr>
}
801028f0:	83 c4 10             	add    $0x10,%esp
801028f3:	c9                   	leave
801028f4:	c3                   	ret
801028f5:	66 90                	xchg   %ax,%ax
801028f7:	66 90                	xchg   %ax,%ax
801028f9:	66 90                	xchg   %ax,%ax
801028fb:	66 90                	xchg   %ax,%ax
801028fd:	66 90                	xchg   %ax,%ax
801028ff:	90                   	nop

80102900 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102900:	a1 80 16 11 80       	mov    0x80111680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	0f 84 cb 00 00 00    	je     801029d8 <lapicinit+0xd8>
  lapic[index] = value;
8010290d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102914:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102921:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102924:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102927:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010292e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102931:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102934:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010293b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010293e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102941:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102948:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102955:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102958:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010295b:	8b 50 30             	mov    0x30(%eax),%edx
8010295e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102964:	75 7a                	jne    801029e0 <lapicinit+0xe0>
  lapic[index] = value;
80102966:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010296d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102973:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010297a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010297d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102980:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102987:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010298d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102994:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102997:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029a1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029ae:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029bf:	00 
801029c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029c6:	80 e6 10             	and    $0x10,%dh
801029c9:	75 f5                	jne    801029c0 <lapicinit+0xc0>
  lapic[index] = value;
801029cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029d8:	c3                   	ret
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801029ed:	e9 74 ff ff ff       	jmp    80102966 <lapicinit+0x66>
801029f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029ff:	00 

80102a00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a00:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	74 07                	je     80102a10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a09:	8b 40 20             	mov    0x20(%eax),%eax
80102a0c:	c1 e8 18             	shr    $0x18,%eax
80102a0f:	c3                   	ret
80102a10:	31 c0                	xor    %eax,%eax
}
80102a12:	c3                   	ret
80102a13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a1f:	00 

80102a20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a20:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 0d                	je     80102a36 <lapiceoi+0x16>
  lapic[index] = value;
80102a29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a36:	c3                   	ret
80102a37:	90                   	nop
80102a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a3f:	00 

80102a40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a40:	c3                   	ret
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a4f:	00 

80102a50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a56:	ba 70 00 00 00       	mov    $0x70,%edx
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	56                   	push   %esi
80102a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a61:	53                   	push   %ebx
80102a62:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a65:	ee                   	out    %al,(%dx)
80102a66:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a6b:	ba 71 00 00 00       	mov    $0x71,%edx
80102a70:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a71:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102a73:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a76:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a7c:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a7e:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102a81:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a84:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a87:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a8d:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a92:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a98:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9b:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102aa2:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa8:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102aaf:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab2:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ab5:	ba 02 00 00 00       	mov    $0x2,%edx
  lapic[index] = value;
80102aba:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac0:	8b 70 20             	mov    0x20(%eax),%esi
  lapic[index] = value;
80102ac3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac9:	8b 70 20             	mov    0x20(%eax),%esi
  for(i = 0; i < 2; i++){
80102acc:	83 fa 01             	cmp    $0x1,%edx
80102acf:	75 07                	jne    80102ad8 <lapicstartap+0x88>
    microdelay(200);
  }
}
80102ad1:	5b                   	pop    %ebx
80102ad2:	5e                   	pop    %esi
80102ad3:	5d                   	pop    %ebp
80102ad4:	c3                   	ret
80102ad5:	8d 76 00             	lea    0x0(%esi),%esi
80102ad8:	ba 01 00 00 00       	mov    $0x1,%edx
80102add:	eb db                	jmp    80102aba <lapicstartap+0x6a>
80102adf:	90                   	nop

80102ae0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ae0:	55                   	push   %ebp
80102ae1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ae6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	57                   	push   %edi
80102aee:	56                   	push   %esi
80102aef:	53                   	push   %ebx
80102af0:	83 ec 4c             	sub    $0x4c,%esp
80102af3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af4:	ba 71 00 00 00       	mov    $0x71,%edx
80102af9:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afa:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102afd:	8d 76 00             	lea    0x0(%esi),%esi
80102b00:	31 c0                	xor    %eax,%eax
80102b02:	ba 70 00 00 00       	mov    $0x70,%edx
80102b07:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b08:	ba 71 00 00 00       	mov    $0x71,%edx
80102b0d:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0e:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b13:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b16:	b8 02 00 00 00       	mov    $0x2,%eax
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	ba 71 00 00 00       	mov    $0x71,%edx
80102b21:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b22:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b27:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2a:	b8 04 00 00 00       	mov    $0x4,%eax
80102b2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	ba 71 00 00 00       	mov    $0x71,%edx
80102b35:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b36:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3b:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3e:	b8 07 00 00 00       	mov    $0x7,%eax
80102b43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b44:	ba 71 00 00 00       	mov    $0x71,%edx
80102b49:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4a:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4f:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	b8 08 00 00 00       	mov    $0x8,%eax
80102b56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b57:	ba 71 00 00 00       	mov    $0x71,%edx
80102b5c:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5d:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b62:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b64:	b8 09 00 00 00       	mov    $0x9,%eax
80102b69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b6f:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b70:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b75:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b78:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7e:	ba 71 00 00 00       	mov    $0x71,%edx
80102b83:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b84:	84 c0                	test   %al,%al
80102b86:	0f 88 74 ff ff ff    	js     80102b00 <cmostime+0x20>
  return inb(CMOS_RETURN);
80102b8c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b90:	89 fa                	mov    %edi,%edx
80102b92:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102b95:	0f b6 fa             	movzbl %dl,%edi
80102b98:	89 f2                	mov    %esi,%edx
80102b9a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b9d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ba1:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba4:	ba 70 00 00 00       	mov    $0x70,%edx
80102ba9:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80102bac:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102baf:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bb3:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102bb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bb9:	31 c0                	xor    %eax,%eax
80102bbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbc:	ba 71 00 00 00       	mov    $0x71,%edx
80102bc1:	ec                   	in     (%dx),%al
80102bc2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc5:	ba 70 00 00 00       	mov    $0x70,%edx
80102bca:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bcd:	b8 02 00 00 00       	mov    $0x2,%eax
80102bd2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd3:	ba 71 00 00 00       	mov    $0x71,%edx
80102bd8:	ec                   	in     (%dx),%al
80102bd9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bdc:	ba 70 00 00 00       	mov    $0x70,%edx
80102be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102be4:	b8 04 00 00 00       	mov    $0x4,%eax
80102be9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bea:	ba 71 00 00 00       	mov    $0x71,%edx
80102bef:	ec                   	in     (%dx),%al
80102bf0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf3:	ba 70 00 00 00       	mov    $0x70,%edx
80102bf8:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bfb:	b8 07 00 00 00       	mov    $0x7,%eax
80102c00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c01:	ba 71 00 00 00       	mov    $0x71,%edx
80102c06:	ec                   	in     (%dx),%al
80102c07:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c0a:	ba 70 00 00 00       	mov    $0x70,%edx
80102c0f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c12:	b8 08 00 00 00       	mov    $0x8,%eax
80102c17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c18:	ba 71 00 00 00       	mov    $0x71,%edx
80102c1d:	ec                   	in     (%dx),%al
80102c1e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c21:	ba 70 00 00 00       	mov    $0x70,%edx
80102c26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c29:	b8 09 00 00 00       	mov    $0x9,%eax
80102c2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2f:	ba 71 00 00 00       	mov    $0x71,%edx
80102c34:	ec                   	in     (%dx),%al
80102c35:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c38:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c3e:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c41:	6a 18                	push   $0x18
80102c43:	50                   	push   %eax
80102c44:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c47:	50                   	push   %eax
80102c48:	e8 73 1d 00 00       	call   801049c0 <memcmp>
80102c4d:	83 c4 10             	add    $0x10,%esp
80102c50:	85 c0                	test   %eax,%eax
80102c52:	0f 85 a8 fe ff ff    	jne    80102b00 <cmostime+0x20>
      break;
  }

  // convert
  if(bcd) {
80102c58:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c5b:	f6 45 b4 04          	testb  $0x4,-0x4c(%ebp)
80102c5f:	75 78                	jne    80102cd9 <cmostime+0x1f9>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c61:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c64:	89 c2                	mov    %eax,%edx
80102c66:	83 e0 0f             	and    $0xf,%eax
80102c69:	c1 ea 04             	shr    $0x4,%edx
80102c6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c72:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c75:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c78:	89 c2                	mov    %eax,%edx
80102c7a:	83 e0 0f             	and    $0xf,%eax
80102c7d:	c1 ea 04             	shr    $0x4,%edx
80102c80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c86:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c89:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c8c:	89 c2                	mov    %eax,%edx
80102c8e:	83 e0 0f             	and    $0xf,%eax
80102c91:	c1 ea 04             	shr    $0x4,%edx
80102c94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c9a:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c9d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ca0:	89 c2                	mov    %eax,%edx
80102ca2:	83 e0 0f             	and    $0xf,%eax
80102ca5:	c1 ea 04             	shr    $0x4,%edx
80102ca8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cb1:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cb4:	89 c2                	mov    %eax,%edx
80102cb6:	83 e0 0f             	and    $0xf,%eax
80102cb9:	c1 ea 04             	shr    $0x4,%edx
80102cbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cc2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cc8:	89 c2                	mov    %eax,%edx
80102cca:	83 e0 0f             	and    $0xf,%eax
80102ccd:	c1 ea 04             	shr    $0x4,%edx
80102cd0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102cd9:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cdc:	89 03                	mov    %eax,(%ebx)
80102cde:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ce1:	89 43 04             	mov    %eax,0x4(%ebx)
80102ce4:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce7:	89 43 08             	mov    %eax,0x8(%ebx)
80102cea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ced:	89 43 0c             	mov    %eax,0xc(%ebx)
80102cf0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cf3:	89 43 10             	mov    %eax,0x10(%ebx)
80102cf6:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cf9:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102cfc:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d06:	5b                   	pop    %ebx
80102d07:	5e                   	pop    %esi
80102d08:	5f                   	pop    %edi
80102d09:	5d                   	pop    %ebp
80102d0a:	c3                   	ret
80102d0b:	66 90                	xchg   %ax,%ax
80102d0d:	66 90                	xchg   %ax,%ax
80102d0f:	66 90                	xchg   %ax,%ax
80102d11:	66 90                	xchg   %ax,%ax
80102d13:	66 90                	xchg   %ax,%ax
80102d15:	66 90                	xchg   %ax,%ax
80102d17:	66 90                	xchg   %ax,%ax
80102d19:	66 90                	xchg   %ax,%ax
80102d1b:	66 90                	xchg   %ax,%ax
80102d1d:	66 90                	xchg   %ax,%ax
80102d1f:	90                   	nop

80102d20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d20:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102d26:	85 c9                	test   %ecx,%ecx
80102d28:	0f 8e 8a 00 00 00    	jle    80102db8 <install_trans+0x98>
{
80102d2e:	55                   	push   %ebp
80102d2f:	89 e5                	mov    %esp,%ebp
80102d31:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d32:	31 ff                	xor    %edi,%edi
{
80102d34:	56                   	push   %esi
80102d35:	53                   	push   %ebx
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d40:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102d45:	83 ec 08             	sub    $0x8,%esp
80102d48:	8d 44 38 01          	lea    0x1(%eax,%edi,1),%eax
80102d4c:	50                   	push   %eax
80102d4d:	ff 35 e4 16 11 80    	push   0x801116e4
80102d53:	e8 78 d3 ff ff       	call   801000d0 <bread>
80102d58:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d5a:	58                   	pop    %eax
80102d5b:	5a                   	pop    %edx
80102d5c:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102d63:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d69:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d6c:	e8 5f d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d71:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d74:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d76:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d79:	68 00 02 00 00       	push   $0x200
80102d7e:	50                   	push   %eax
80102d7f:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d82:	50                   	push   %eax
80102d83:	e8 88 1c 00 00       	call   80104a10 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d88:	89 1c 24             	mov    %ebx,(%esp)
80102d8b:	e8 30 d4 ff ff       	call   801001c0 <bwrite>
    brelse(lbuf);
80102d90:	89 34 24             	mov    %esi,(%esp)
80102d93:	e8 68 d4 ff ff       	call   80100200 <brelse>
    brelse(dbuf);
80102d98:	89 1c 24             	mov    %ebx,(%esp)
80102d9b:	e8 60 d4 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	83 c4 10             	add    $0x10,%esp
80102da3:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102da9:	7f 95                	jg     80102d40 <install_trans+0x20>
  }
}
80102dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dae:	5b                   	pop    %ebx
80102daf:	5e                   	pop    %esi
80102db0:	5f                   	pop    %edi
80102db1:	5d                   	pop    %ebp
80102db2:	c3                   	ret
80102db3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102db8:	c3                   	ret
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dc7:	ff 35 d4 16 11 80    	push   0x801116d4
80102dcd:	ff 35 e4 16 11 80    	push   0x801116e4
80102dd3:	e8 f8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102dd8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ddb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ddd:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102de2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102de5:	85 c0                	test   %eax,%eax
80102de7:	7e 29                	jle    80102e12 <write_head+0x52>
80102de9:	31 d2                	xor    %edx,%edx
80102deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102df0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102df7:	00 
80102df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dff:	00 
    hb->block[i] = log.lh.block[i];
80102e00:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102e07:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e0b:	83 c2 01             	add    $0x1,%edx
80102e0e:	39 d0                	cmp    %edx,%eax
80102e10:	75 ee                	jne    80102e00 <write_head+0x40>
  }
  bwrite(buf);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	53                   	push   %ebx
80102e16:	e8 a5 d3 ff ff       	call   801001c0 <bwrite>
  brelse(buf);
80102e1b:	89 1c 24             	mov    %ebx,(%esp)
80102e1e:	e8 dd d3 ff ff       	call   80100200 <brelse>
}
80102e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e26:	83 c4 10             	add    $0x10,%esp
80102e29:	c9                   	leave
80102e2a:	c3                   	ret
80102e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102e30 <initlog>:
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	53                   	push   %ebx
80102e34:	83 ec 2c             	sub    $0x2c,%esp
80102e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e3a:	68 57 77 10 80       	push   $0x80107757
80102e3f:	68 a0 16 11 80       	push   $0x801116a0
80102e44:	e8 f7 17 00 00       	call   80104640 <initlock>
  readsb(dev, &sb);
80102e49:	58                   	pop    %eax
80102e4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e4d:	5a                   	pop    %edx
80102e4e:	50                   	push   %eax
80102e4f:	53                   	push   %ebx
80102e50:	e8 ab e7 ff ff       	call   80101600 <readsb>
  log.start = sb.logstart;
80102e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e58:	59                   	pop    %ecx
  log.dev = dev;
80102e59:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102e5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e62:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102e67:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102e6d:	5a                   	pop    %edx
80102e6e:	50                   	push   %eax
80102e6f:	53                   	push   %ebx
80102e70:	e8 5b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e75:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e78:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e7b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102e81:	85 db                	test   %ebx,%ebx
80102e83:	7e 2d                	jle    80102eb2 <initlog+0x82>
80102e85:	31 d2                	xor    %edx,%edx
80102e87:	eb 17                	jmp    80102ea0 <initlog+0x70>
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e90:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e97:	00 
80102e98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e9f:	00 
    log.lh.block[i] = lh->block[i];
80102ea0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102ea4:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102eab:	83 c2 01             	add    $0x1,%edx
80102eae:	39 d3                	cmp    %edx,%ebx
80102eb0:	75 ee                	jne    80102ea0 <initlog+0x70>
  brelse(buf);
80102eb2:	83 ec 0c             	sub    $0xc,%esp
80102eb5:	50                   	push   %eax
80102eb6:	e8 45 d3 ff ff       	call   80100200 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ebb:	e8 60 fe ff ff       	call   80102d20 <install_trans>
  log.lh.n = 0;
80102ec0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102ec7:	00 00 00 
  write_head(); // clear the log
80102eca:	e8 f1 fe ff ff       	call   80102dc0 <write_head>
}
80102ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ed2:	83 c4 10             	add    $0x10,%esp
80102ed5:	c9                   	leave
80102ed6:	c3                   	ret
80102ed7:	90                   	nop
80102ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102edf:	00 

80102ee0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ee6:	68 a0 16 11 80       	push   $0x801116a0
80102eeb:	e8 70 19 00 00       	call   80104860 <acquire>
80102ef0:	83 c4 10             	add    $0x10,%esp
80102ef3:	eb 18                	jmp    80102f0d <begin_op+0x2d>
80102ef5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ef8:	83 ec 08             	sub    $0x8,%esp
80102efb:	68 a0 16 11 80       	push   $0x801116a0
80102f00:	68 a0 16 11 80       	push   $0x801116a0
80102f05:	e8 86 13 00 00       	call   80104290 <sleep>
80102f0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f0d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102f12:	85 c0                	test   %eax,%eax
80102f14:	75 e2                	jne    80102ef8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f16:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f1b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f21:	83 c0 01             	add    $0x1,%eax
80102f24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f2a:	83 fa 1e             	cmp    $0x1e,%edx
80102f2d:	7f c9                	jg     80102ef8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f32:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102f37:	68 a0 16 11 80       	push   $0x801116a0
80102f3c:	e8 bf 18 00 00       	call   80104800 <release>
      break;
    }
  }
}
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	c9                   	leave
80102f45:	c3                   	ret
80102f46:	66 90                	xchg   %ax,%ax
80102f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f4f:	00 

80102f50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	57                   	push   %edi
80102f54:	56                   	push   %esi
80102f55:	53                   	push   %ebx
80102f56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f59:	68 a0 16 11 80       	push   $0x801116a0
80102f5e:	e8 fd 18 00 00       	call   80104860 <acquire>
  log.outstanding -= 1;
80102f63:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102f68:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102f6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f71:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f74:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102f7a:	85 f6                	test   %esi,%esi
80102f7c:	0f 85 22 01 00 00    	jne    801030a4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f82:	85 db                	test   %ebx,%ebx
80102f84:	0f 85 f6 00 00 00    	jne    80103080 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f8a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102f91:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	68 a0 16 11 80       	push   $0x801116a0
80102f9c:	e8 5f 18 00 00       	call   80104800 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fa1:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102fa7:	83 c4 10             	add    $0x10,%esp
80102faa:	85 c9                	test   %ecx,%ecx
80102fac:	7f 42                	jg     80102ff0 <end_op+0xa0>
    acquire(&log.lock);
80102fae:	83 ec 0c             	sub    $0xc,%esp
80102fb1:	68 a0 16 11 80       	push   $0x801116a0
80102fb6:	e8 a5 18 00 00       	call   80104860 <acquire>
    log.committing = 0;
80102fbb:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102fc2:	00 00 00 
    wakeup(&log);
80102fc5:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102fcc:	e8 7f 13 00 00       	call   80104350 <wakeup>
    release(&log.lock);
80102fd1:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102fd8:	e8 23 18 00 00       	call   80104800 <release>
80102fdd:	83 c4 10             	add    $0x10,%esp
}
80102fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fe3:	5b                   	pop    %ebx
80102fe4:	5e                   	pop    %esi
80102fe5:	5f                   	pop    %edi
80102fe6:	5d                   	pop    %ebp
80102fe7:	c3                   	ret
80102fe8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fef:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ff0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102ff5:	83 ec 08             	sub    $0x8,%esp
80102ff8:	8d 44 18 01          	lea    0x1(%eax,%ebx,1),%eax
80102ffc:	50                   	push   %eax
80102ffd:	ff 35 e4 16 11 80    	push   0x801116e4
80103003:	e8 c8 d0 ff ff       	call   801000d0 <bread>
80103008:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010300a:	58                   	pop    %eax
8010300b:	5a                   	pop    %edx
8010300c:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80103013:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80103019:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010301c:	e8 af d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103021:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103024:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103026:	8d 40 5c             	lea    0x5c(%eax),%eax
80103029:	68 00 02 00 00       	push   $0x200
8010302e:	50                   	push   %eax
8010302f:	8d 46 5c             	lea    0x5c(%esi),%eax
80103032:	50                   	push   %eax
80103033:	e8 d8 19 00 00       	call   80104a10 <memmove>
    bwrite(to);  // write the log
80103038:	89 34 24             	mov    %esi,(%esp)
8010303b:	e8 80 d1 ff ff       	call   801001c0 <bwrite>
    brelse(from);
80103040:	89 3c 24             	mov    %edi,(%esp)
80103043:	e8 b8 d1 ff ff       	call   80100200 <brelse>
    brelse(to);
80103048:	89 34 24             	mov    %esi,(%esp)
8010304b:	e8 b0 d1 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103050:	83 c4 10             	add    $0x10,%esp
80103053:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80103059:	7c 95                	jl     80102ff0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010305b:	e8 60 fd ff ff       	call   80102dc0 <write_head>
    install_trans(); // Now install writes to home locations
80103060:	e8 bb fc ff ff       	call   80102d20 <install_trans>
    log.lh.n = 0;
80103065:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010306c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010306f:	e8 4c fd ff ff       	call   80102dc0 <write_head>
80103074:	e9 35 ff ff ff       	jmp    80102fae <end_op+0x5e>
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103080:	83 ec 0c             	sub    $0xc,%esp
80103083:	68 a0 16 11 80       	push   $0x801116a0
80103088:	e8 c3 12 00 00       	call   80104350 <wakeup>
  release(&log.lock);
8010308d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103094:	e8 67 17 00 00       	call   80104800 <release>
80103099:	83 c4 10             	add    $0x10,%esp
}
8010309c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309f:	5b                   	pop    %ebx
801030a0:	5e                   	pop    %esi
801030a1:	5f                   	pop    %edi
801030a2:	5d                   	pop    %ebp
801030a3:	c3                   	ret
    panic("log.committing");
801030a4:	83 ec 0c             	sub    $0xc,%esp
801030a7:	68 5b 77 10 80       	push   $0x8010775b
801030ac:	e8 ef d2 ff ff       	call   801003a0 <panic>
801030b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801030bf:	00 

801030c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	53                   	push   %ebx
801030c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030c7:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
801030cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030d0:	83 fa 1d             	cmp    $0x1d,%edx
801030d3:	7f 7d                	jg     80103152 <log_write+0x92>
801030d5:	a1 d8 16 11 80       	mov    0x801116d8,%eax
801030da:	83 e8 01             	sub    $0x1,%eax
801030dd:	39 c2                	cmp    %eax,%edx
801030df:	7d 71                	jge    80103152 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030e1:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801030e6:	85 c0                	test   %eax,%eax
801030e8:	7e 75                	jle    8010315f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030ea:	83 ec 0c             	sub    $0xc,%esp
801030ed:	68 a0 16 11 80       	push   $0x801116a0
801030f2:	e8 69 17 00 00       	call   80104860 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801030f7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030fa:	83 c4 10             	add    $0x10,%esp
801030fd:	31 c0                	xor    %eax,%eax
801030ff:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80103105:	85 d2                	test   %edx,%edx
80103107:	7f 0e                	jg     80103117 <log_write+0x57>
80103109:	eb 15                	jmp    80103120 <log_write+0x60>
8010310b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103110:	83 c0 01             	add    $0x1,%eax
80103113:	39 d0                	cmp    %edx,%eax
80103115:	74 29                	je     80103140 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103117:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010311e:	75 f0                	jne    80103110 <log_write+0x50>
  log.lh.block[i] = b->blockno;
80103120:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80103127:	39 c2                	cmp    %eax,%edx
80103129:	74 1c                	je     80103147 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010312b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010312e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103131:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103138:	c9                   	leave
  release(&log.lock);
80103139:	e9 c2 16 00 00       	jmp    80104800 <release>
8010313e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103140:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80103147:	83 c2 01             	add    $0x1,%edx
8010314a:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103150:	eb d9                	jmp    8010312b <log_write+0x6b>
    panic("too big a transaction");
80103152:	83 ec 0c             	sub    $0xc,%esp
80103155:	68 6a 77 10 80       	push   $0x8010776a
8010315a:	e8 41 d2 ff ff       	call   801003a0 <panic>
    panic("log_write outside of trans");
8010315f:	83 ec 0c             	sub    $0xc,%esp
80103162:	68 80 77 10 80       	push   $0x80107780
80103167:	e8 34 d2 ff ff       	call   801003a0 <panic>
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	53                   	push   %ebx
80103174:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103177:	e8 a4 09 00 00       	call   80103b20 <cpuid>
8010317c:	89 c3                	mov    %eax,%ebx
8010317e:	e8 9d 09 00 00       	call   80103b20 <cpuid>
80103183:	83 ec 04             	sub    $0x4,%esp
80103186:	53                   	push   %ebx
80103187:	50                   	push   %eax
80103188:	68 9b 77 10 80       	push   $0x8010779b
8010318d:	e8 3e d5 ff ff       	call   801006d0 <cprintf>
  idtinit();       // load idt register
80103192:	e8 99 2a 00 00       	call   80105c30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103197:	e8 04 09 00 00       	call   80103aa0 <mycpu>
8010319c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010319e:	b8 01 00 00 00       	mov    $0x1,%eax
801031a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031aa:	e8 41 0c 00 00       	call   80103df0 <scheduler>
801031af:	90                   	nop

801031b0 <mpenter>:
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031b6:	e8 45 3c 00 00       	call   80106e00 <switchkvm>
  seginit();
801031bb:	e8 b0 3b 00 00       	call   80106d70 <seginit>
  lapicinit();
801031c0:	e8 3b f7 ff ff       	call   80102900 <lapicinit>
  mpmain();
801031c5:	e8 a6 ff ff ff       	call   80103170 <mpmain>
801031ca:	66 90                	xchg   %ax,%ax
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <main>:
{
801031d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031d4:	83 e4 f0             	and    $0xfffffff0,%esp
801031d7:	ff 71 fc             	push   -0x4(%ecx)
801031da:	55                   	push   %ebp
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	53                   	push   %ebx
801031de:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031df:	83 ec 08             	sub    $0x8,%esp
801031e2:	68 00 00 40 80       	push   $0x80400000
801031e7:	68 d0 56 11 80       	push   $0x801156d0
801031ec:	e8 2f f5 ff ff       	call   80102720 <kinit1>
  kvmalloc();      // kernel page table
801031f1:	e8 ca 40 00 00       	call   801072c0 <kvmalloc>
  mpinit();        // detect other processors
801031f6:	e8 85 01 00 00       	call   80103380 <mpinit>
  lapicinit();     // interrupt controller
801031fb:	e8 00 f7 ff ff       	call   80102900 <lapicinit>
  seginit();       // segment descriptors
80103200:	e8 6b 3b 00 00       	call   80106d70 <seginit>
  picinit();       // disable pic
80103205:	e8 56 03 00 00       	call   80103560 <picinit>
  ioapicinit();    // another interrupt controller
8010320a:	e8 b1 f2 ff ff       	call   801024c0 <ioapicinit>
  consoleinit();   // console hardware
8010320f:	e8 ac d8 ff ff       	call   80100ac0 <consoleinit>
  uartinit();      // serial port
80103214:	e8 c7 2d 00 00       	call   80105fe0 <uartinit>
  pinit();         // process table
80103219:	e8 62 08 00 00       	call   80103a80 <pinit>
  tvinit();        // trap vectors
8010321e:	e8 5d 29 00 00       	call   80105b80 <tvinit>
  binit();         // buffer cache
80103223:	e8 18 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103228:	e8 73 dc ff ff       	call   80100ea0 <fileinit>
  ideinit();       // disk 
8010322d:	e8 6e f0 ff ff       	call   801022a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103232:	83 c4 0c             	add    $0xc,%esp
80103235:	68 8a 00 00 00       	push   $0x8a
8010323a:	68 8c a4 10 80       	push   $0x8010a48c
8010323f:	68 00 70 00 80       	push   $0x80007000
80103244:	e8 c7 17 00 00       	call   80104a10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103253:	00 00 00 
80103256:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010325b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103260:	76 7e                	jbe    801032e0 <main+0x110>
80103262:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103267:	eb 20                	jmp    80103289 <main+0xb9>
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103270:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103277:	00 00 00 
8010327a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103280:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103285:	39 c3                	cmp    %eax,%ebx
80103287:	73 57                	jae    801032e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103289:	e8 12 08 00 00       	call   80103aa0 <mycpu>
8010328e:	39 d8                	cmp    %ebx,%eax
80103290:	74 de                	je     80103270 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103292:	e8 f9 f4 ff ff       	call   80102790 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103297:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010329a:	c7 05 f8 6f 00 80 b0 	movl   $0x801031b0,0x80006ff8
801032a1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032a4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801032ab:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ae:	05 00 10 00 00       	add    $0x1000,%eax
801032b3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032b8:	0f b6 03             	movzbl (%ebx),%eax
801032bb:	68 00 70 00 00       	push   $0x7000
801032c0:	50                   	push   %eax
801032c1:	e8 8a f7 ff ff       	call   80102a50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032c6:	83 c4 10             	add    $0x10,%esp
801032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032d6:	85 c0                	test   %eax,%eax
801032d8:	74 f6                	je     801032d0 <main+0x100>
801032da:	eb 94                	jmp    80103270 <main+0xa0>
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032e0:	83 ec 08             	sub    $0x8,%esp
801032e3:	68 00 00 00 8e       	push   $0x8e000000
801032e8:	68 00 00 40 80       	push   $0x80400000
801032ed:	e8 ce f3 ff ff       	call   801026c0 <kinit2>
  userinit();      // first user process
801032f2:	e8 79 08 00 00       	call   80103b70 <userinit>
  mpmain();        // finish this processor's setup
801032f7:	e8 74 fe ff ff       	call   80103170 <mpmain>
801032fc:	66 90                	xchg   %ax,%ax
801032fe:	66 90                	xchg   %ax,%ax

80103300 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103305:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010330b:	53                   	push   %ebx
  e = addr+len;
8010330c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010330f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103312:	39 de                	cmp    %ebx,%esi
80103314:	72 10                	jb     80103326 <mpsearch1+0x26>
80103316:	eb 58                	jmp    80103370 <mpsearch1+0x70>
80103318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010331f:	00 
80103320:	89 fe                	mov    %edi,%esi
80103322:	39 df                	cmp    %ebx,%edi
80103324:	73 4a                	jae    80103370 <mpsearch1+0x70>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103326:	83 ec 04             	sub    $0x4,%esp
80103329:	8d 7e 10             	lea    0x10(%esi),%edi
8010332c:	6a 04                	push   $0x4
8010332e:	68 af 77 10 80       	push   $0x801077af
80103333:	56                   	push   %esi
80103334:	e8 87 16 00 00       	call   801049c0 <memcmp>
80103339:	83 c4 10             	add    $0x10,%esp
8010333c:	85 c0                	test   %eax,%eax
8010333e:	75 e0                	jne    80103320 <mpsearch1+0x20>
80103340:	89 f2                	mov    %esi,%edx
80103342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103348:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010334f:	00 
    sum += addr[i];
80103350:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103353:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103356:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103358:	39 fa                	cmp    %edi,%edx
8010335a:	75 f4                	jne    80103350 <mpsearch1+0x50>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010335c:	84 c0                	test   %al,%al
8010335e:	75 c0                	jne    80103320 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103363:	89 f0                	mov    %esi,%eax
80103365:	5b                   	pop    %ebx
80103366:	5e                   	pop    %esi
80103367:	5f                   	pop    %edi
80103368:	5d                   	pop    %ebp
80103369:	c3                   	ret
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103373:	31 f6                	xor    %esi,%esi
}
80103375:	5b                   	pop    %ebx
80103376:	89 f0                	mov    %esi,%eax
80103378:	5e                   	pop    %esi
80103379:	5f                   	pop    %edi
8010337a:	5d                   	pop    %ebp
8010337b:	c3                   	ret
8010337c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103380 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103389:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103390:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103397:	c1 e0 08             	shl    $0x8,%eax
8010339a:	09 d0                	or     %edx,%eax
8010339c:	c1 e0 04             	shl    $0x4,%eax
8010339f:	75 1b                	jne    801033bc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033a1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033a8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033af:	c1 e0 08             	shl    $0x8,%eax
801033b2:	09 d0                	or     %edx,%eax
801033b4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033b7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033bc:	ba 00 04 00 00       	mov    $0x400,%edx
801033c1:	e8 3a ff ff ff       	call   80103300 <mpsearch1>
801033c6:	89 c3                	mov    %eax,%ebx
801033c8:	85 c0                	test   %eax,%eax
801033ca:	0f 84 38 01 00 00    	je     80103508 <mpinit+0x188>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033d0:	8b 73 04             	mov    0x4(%ebx),%esi
801033d3:	85 f6                	test   %esi,%esi
801033d5:	0f 84 1d 01 00 00    	je     801034f8 <mpinit+0x178>
  if(memcmp(conf, "PCMP", 4) != 0)
801033db:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033de:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801033e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801033e7:	6a 04                	push   $0x4
801033e9:	68 b4 77 10 80       	push   $0x801077b4
801033ee:	50                   	push   %eax
801033ef:	e8 cc 15 00 00       	call   801049c0 <memcmp>
801033f4:	83 c4 10             	add    $0x10,%esp
801033f7:	89 c2                	mov    %eax,%edx
801033f9:	85 c0                	test   %eax,%eax
801033fb:	0f 85 f7 00 00 00    	jne    801034f8 <mpinit+0x178>
  if(conf->version != 1 && conf->version != 4)
80103401:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103408:	3c 01                	cmp    $0x1,%al
8010340a:	74 08                	je     80103414 <mpinit+0x94>
8010340c:	3c 04                	cmp    $0x4,%al
8010340e:	0f 85 e4 00 00 00    	jne    801034f8 <mpinit+0x178>
  if(sum((uchar*)conf, conf->length) != 0)
80103414:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
  for(i=0; i<len; i++)
8010341b:	66 85 c9             	test   %cx,%cx
8010341e:	74 28                	je     80103448 <mpinit+0xc8>
80103420:	89 f0                	mov    %esi,%eax
80103422:	8d 3c 31             	lea    (%ecx,%esi,1),%edi
80103425:	8d 76 00             	lea    0x0(%esi),%esi
80103428:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010342f:	00 
    sum += addr[i];
80103430:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103437:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010343a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010343c:	39 c7                	cmp    %eax,%edi
8010343e:	75 f0                	jne    80103430 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103440:	84 d2                	test   %dl,%dl
80103442:	0f 85 b0 00 00 00    	jne    801034f8 <mpinit+0x178>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103448:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010344e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  lapic = (uint*)conf->lapicaddr;
80103451:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103456:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
8010345d:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103463:	01 f9                	add    %edi,%ecx
80103465:	39 c8                	cmp    %ecx,%eax
80103467:	72 12                	jb     8010347b <mpinit+0xfb>
80103469:	eb 36                	jmp    801034a1 <mpinit+0x121>
8010346b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    switch(*p){
80103470:	84 d2                	test   %dl,%dl
80103472:	74 54                	je     801034c8 <mpinit+0x148>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103474:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103477:	39 c8                	cmp    %ecx,%eax
80103479:	73 26                	jae    801034a1 <mpinit+0x121>
    switch(*p){
8010347b:	0f b6 10             	movzbl (%eax),%edx
8010347e:	80 fa 02             	cmp    $0x2,%dl
80103481:	74 0d                	je     80103490 <mpinit+0x110>
80103483:	76 eb                	jbe    80103470 <mpinit+0xf0>
80103485:	83 ea 03             	sub    $0x3,%edx
80103488:	80 fa 01             	cmp    $0x1,%dl
8010348b:	76 e7                	jbe    80103474 <mpinit+0xf4>
8010348d:	eb fe                	jmp    8010348d <mpinit+0x10d>
8010348f:	90                   	nop
      ioapicid = ioapic->apicno;
80103490:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103494:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103497:	88 15 80 17 11 80    	mov    %dl,0x80111780
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010349d:	39 c8                	cmp    %ecx,%eax
8010349f:	72 da                	jb     8010347b <mpinit+0xfb>
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034a1:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801034a5:	74 15                	je     801034bc <mpinit+0x13c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034a7:	b8 70 00 00 00       	mov    $0x70,%eax
801034ac:	ba 22 00 00 00       	mov    $0x22,%edx
801034b1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034b2:	ba 23 00 00 00       	mov    $0x23,%edx
801034b7:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801034b8:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034bb:	ee                   	out    %al,(%dx)
  }
}
801034bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034bf:	5b                   	pop    %ebx
801034c0:	5e                   	pop    %esi
801034c1:	5f                   	pop    %edi
801034c2:	5d                   	pop    %ebp
801034c3:	c3                   	ret
801034c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801034c8:	8b 35 84 17 11 80    	mov    0x80111784,%esi
801034ce:	83 fe 07             	cmp    $0x7,%esi
801034d1:	7f 19                	jg     801034ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034d3:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
801034d9:	0f b6 50 01          	movzbl 0x1(%eax),%edx
        ncpu++;
801034dd:	83 c6 01             	add    $0x1,%esi
801034e0:	89 35 84 17 11 80    	mov    %esi,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034e6:	88 97 a0 17 11 80    	mov    %dl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
801034ec:	83 c0 14             	add    $0x14,%eax
      continue;
801034ef:	eb 86                	jmp    80103477 <mpinit+0xf7>
801034f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034f8:	83 ec 0c             	sub    $0xc,%esp
801034fb:	68 b9 77 10 80       	push   $0x801077b9
80103500:	e8 9b ce ff ff       	call   801003a0 <panic>
80103505:	8d 76 00             	lea    0x0(%esi),%esi
{
80103508:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010350d:	eb 0b                	jmp    8010351a <mpinit+0x19a>
8010350f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103510:	89 f3                	mov    %esi,%ebx
80103512:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103518:	74 de                	je     801034f8 <mpinit+0x178>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010351a:	83 ec 04             	sub    $0x4,%esp
8010351d:	8d 73 10             	lea    0x10(%ebx),%esi
80103520:	6a 04                	push   $0x4
80103522:	68 af 77 10 80       	push   $0x801077af
80103527:	53                   	push   %ebx
80103528:	e8 93 14 00 00       	call   801049c0 <memcmp>
8010352d:	83 c4 10             	add    $0x10,%esp
80103530:	85 c0                	test   %eax,%eax
80103532:	75 dc                	jne    80103510 <mpinit+0x190>
80103534:	89 da                	mov    %ebx,%edx
80103536:	66 90                	xchg   %ax,%ax
80103538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010353f:	00 
    sum += addr[i];
80103540:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103543:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103546:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103548:	39 d6                	cmp    %edx,%esi
8010354a:	75 f4                	jne    80103540 <mpinit+0x1c0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010354c:	84 c0                	test   %al,%al
8010354e:	75 c0                	jne    80103510 <mpinit+0x190>
80103550:	e9 7b fe ff ff       	jmp    801033d0 <mpinit+0x50>
80103555:	66 90                	xchg   %ax,%ax
80103557:	66 90                	xchg   %ax,%ax
80103559:	66 90                	xchg   %ax,%ax
8010355b:	66 90                	xchg   %ax,%ax
8010355d:	66 90                	xchg   %ax,%ax
8010355f:	90                   	nop

80103560 <picinit>:
80103560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103565:	ba 21 00 00 00       	mov    $0x21,%edx
8010356a:	ee                   	out    %al,(%dx)
8010356b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103570:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103571:	c3                   	ret
80103572:	66 90                	xchg   %ax,%ax
80103574:	66 90                	xchg   %ax,%ax
80103576:	66 90                	xchg   %ax,%ax
80103578:	66 90                	xchg   %ax,%ax
8010357a:	66 90                	xchg   %ax,%ax
8010357c:	66 90                	xchg   %ax,%ax
8010357e:	66 90                	xchg   %ax,%ax

80103580 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	57                   	push   %edi
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 0c             	sub    $0xc,%esp
80103589:	8b 75 08             	mov    0x8(%ebp),%esi
8010358c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010358f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103595:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010359b:	e8 20 d9 ff ff       	call   80100ec0 <filealloc>
801035a0:	89 06                	mov    %eax,(%esi)
801035a2:	85 c0                	test   %eax,%eax
801035a4:	0f 84 a5 00 00 00    	je     8010364f <pipealloc+0xcf>
801035aa:	e8 11 d9 ff ff       	call   80100ec0 <filealloc>
801035af:	89 07                	mov    %eax,(%edi)
801035b1:	85 c0                	test   %eax,%eax
801035b3:	0f 84 84 00 00 00    	je     8010363d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035b9:	e8 d2 f1 ff ff       	call   80102790 <kalloc>
801035be:	89 c3                	mov    %eax,%ebx
801035c0:	85 c0                	test   %eax,%eax
801035c2:	0f 84 a0 00 00 00    	je     80103668 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801035c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035dc:	00 00 00 
  p->nwrite = 0;
801035df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035e6:	00 00 00 
  p->nread = 0;
801035e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035f0:	00 00 00 
  initlock(&p->lock, "pipe");
801035f3:	68 d1 77 10 80       	push   $0x801077d1
801035f8:	50                   	push   %eax
801035f9:	e8 42 10 00 00       	call   80104640 <initlock>
  (*f0)->type = FD_PIPE;
801035fe:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103600:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103603:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103609:	8b 06                	mov    (%esi),%eax
8010360b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010360f:	8b 06                	mov    (%esi),%eax
80103611:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103615:	8b 06                	mov    (%esi),%eax
80103617:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010361a:	8b 07                	mov    (%edi),%eax
8010361c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103622:	8b 07                	mov    (%edi),%eax
80103624:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103628:	8b 07                	mov    (%edi),%eax
8010362a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010362e:	8b 07                	mov    (%edi),%eax
80103630:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103633:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103638:	5b                   	pop    %ebx
80103639:	5e                   	pop    %esi
8010363a:	5f                   	pop    %edi
8010363b:	5d                   	pop    %ebp
8010363c:	c3                   	ret
  if(*f0)
8010363d:	8b 06                	mov    (%esi),%eax
8010363f:	85 c0                	test   %eax,%eax
80103641:	74 1e                	je     80103661 <pipealloc+0xe1>
    fileclose(*f0);
80103643:	83 ec 0c             	sub    $0xc,%esp
80103646:	50                   	push   %eax
80103647:	e8 34 d9 ff ff       	call   80100f80 <fileclose>
8010364c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010364f:	8b 07                	mov    (%edi),%eax
80103651:	85 c0                	test   %eax,%eax
80103653:	74 0c                	je     80103661 <pipealloc+0xe1>
    fileclose(*f1);
80103655:	83 ec 0c             	sub    $0xc,%esp
80103658:	50                   	push   %eax
80103659:	e8 22 d9 ff ff       	call   80100f80 <fileclose>
8010365e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103666:	eb cd                	jmp    80103635 <pipealloc+0xb5>
  if(*f0)
80103668:	8b 06                	mov    (%esi),%eax
8010366a:	85 c0                	test   %eax,%eax
8010366c:	75 d5                	jne    80103643 <pipealloc+0xc3>
8010366e:	eb df                	jmp    8010364f <pipealloc+0xcf>

80103670 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	56                   	push   %esi
80103674:	53                   	push   %ebx
80103675:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103678:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010367b:	83 ec 0c             	sub    $0xc,%esp
8010367e:	53                   	push   %ebx
8010367f:	e8 dc 11 00 00       	call   80104860 <acquire>
  if(writable){
80103684:	83 c4 10             	add    $0x10,%esp
80103687:	85 f6                	test   %esi,%esi
80103689:	74 45                	je     801036d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103694:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010369b:	00 00 00 
    wakeup(&p->nread);
8010369e:	50                   	push   %eax
8010369f:	e8 ac 0c 00 00       	call   80104350 <wakeup>
801036a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036ad:	85 d2                	test   %edx,%edx
801036af:	75 0a                	jne    801036bb <pipeclose+0x4b>
801036b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036b7:	85 c0                	test   %eax,%eax
801036b9:	74 35                	je     801036f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036c1:	5b                   	pop    %ebx
801036c2:	5e                   	pop    %esi
801036c3:	5d                   	pop    %ebp
    release(&p->lock);
801036c4:	e9 37 11 00 00       	jmp    80104800 <release>
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036e0:	00 00 00 
    wakeup(&p->nwrite);
801036e3:	50                   	push   %eax
801036e4:	e8 67 0c 00 00       	call   80104350 <wakeup>
801036e9:	83 c4 10             	add    $0x10,%esp
801036ec:	eb b9                	jmp    801036a7 <pipeclose+0x37>
801036ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	53                   	push   %ebx
801036f4:	e8 07 11 00 00       	call   80104800 <release>
    kfree((char*)p);
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103702:	5b                   	pop    %ebx
80103703:	5e                   	pop    %esi
80103704:	5d                   	pop    %ebp
    kfree((char*)p);
80103705:	e9 b6 ee ff ff       	jmp    801025c0 <kfree>
8010370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103710 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	57                   	push   %edi
80103714:	56                   	push   %esi
80103715:	53                   	push   %ebx
80103716:	83 ec 28             	sub    $0x28,%esp
80103719:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010371c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010371f:	53                   	push   %ebx
80103720:	e8 3b 11 00 00       	call   80104860 <acquire>
  for(i = 0; i < n; i++){
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	85 ff                	test   %edi,%edi
8010372a:	0f 8e cc 00 00 00    	jle    801037fc <pipewrite+0xec>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103730:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103736:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103739:	89 7d 10             	mov    %edi,0x10(%ebp)
8010373c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010373f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103742:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103745:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010374b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103751:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103757:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010375d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103760:	0f 85 b4 00 00 00    	jne    8010381a <pipewrite+0x10a>
80103766:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103769:	eb 3b                	jmp    801037a6 <pipewrite+0x96>
8010376b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103770:	e8 cb 03 00 00       	call   80103b40 <myproc>
80103775:	8b 48 24             	mov    0x24(%eax),%ecx
80103778:	85 c9                	test   %ecx,%ecx
8010377a:	75 34                	jne    801037b0 <pipewrite+0xa0>
      wakeup(&p->nread);
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	56                   	push   %esi
80103780:	e8 cb 0b 00 00       	call   80104350 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103785:	58                   	pop    %eax
80103786:	5a                   	pop    %edx
80103787:	53                   	push   %ebx
80103788:	57                   	push   %edi
80103789:	e8 02 0b 00 00       	call   80104290 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010378e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103794:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010379a:	83 c4 10             	add    $0x10,%esp
8010379d:	05 00 02 00 00       	add    $0x200,%eax
801037a2:	39 c2                	cmp    %eax,%edx
801037a4:	75 2a                	jne    801037d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801037a6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037ac:	85 c0                	test   %eax,%eax
801037ae:	75 c0                	jne    80103770 <pipewrite+0x60>
        release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	53                   	push   %ebx
801037b4:	e8 47 10 00 00       	call   80104800 <release>
        return -1;
801037b9:	83 c4 10             	add    $0x10,%esp
801037bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	5b                   	pop    %ebx
801037c5:	5e                   	pop    %esi
801037c6:	5f                   	pop    %edi
801037c7:	5d                   	pop    %ebp
801037c8:	c3                   	ret
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037d3:	8d 42 01             	lea    0x1(%edx),%eax
801037d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801037dc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037df:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037e8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801037ec:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037f0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801037f3:	0f 85 52 ff ff ff    	jne    8010374b <pipewrite+0x3b>
801037f9:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037fc:	83 ec 0c             	sub    $0xc,%esp
801037ff:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103805:	50                   	push   %eax
80103806:	e8 45 0b 00 00       	call   80104350 <wakeup>
  release(&p->lock);
8010380b:	89 1c 24             	mov    %ebx,(%esp)
8010380e:	e8 ed 0f 00 00       	call   80104800 <release>
  return n;
80103813:	83 c4 10             	add    $0x10,%esp
80103816:	89 f8                	mov    %edi,%eax
80103818:	eb a7                	jmp    801037c1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010381a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010381d:	eb b4                	jmp    801037d3 <pipewrite+0xc3>
8010381f:	90                   	nop

80103820 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	57                   	push   %edi
80103824:	56                   	push   %esi
80103825:	53                   	push   %ebx
80103826:	83 ec 18             	sub    $0x18,%esp
80103829:	8b 75 08             	mov    0x8(%ebp),%esi
8010382c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010382f:	56                   	push   %esi
80103830:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103836:	e8 25 10 00 00       	call   80104860 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010383b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103841:	83 c4 10             	add    $0x10,%esp
80103844:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010384a:	74 2f                	je     8010387b <piperead+0x5b>
8010384c:	eb 37                	jmp    80103885 <piperead+0x65>
8010384e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103850:	e8 eb 02 00 00       	call   80103b40 <myproc>
80103855:	8b 40 24             	mov    0x24(%eax),%eax
80103858:	85 c0                	test   %eax,%eax
8010385a:	0f 85 b0 00 00 00    	jne    80103910 <piperead+0xf0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103860:	83 ec 08             	sub    $0x8,%esp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
80103865:	e8 26 0a 00 00       	call   80104290 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010386a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103870:	83 c4 10             	add    $0x10,%esp
80103873:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103879:	75 0a                	jne    80103885 <piperead+0x65>
8010387b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103881:	85 d2                	test   %edx,%edx
80103883:	75 cb                	jne    80103850 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103885:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103888:	31 db                	xor    %ebx,%ebx
8010388a:	85 c9                	test   %ecx,%ecx
8010388c:	7f 56                	jg     801038e4 <piperead+0xc4>
8010388e:	eb 5c                	jmp    801038ec <piperead+0xcc>
80103890:	eb 2e                	jmp    801038c0 <piperead+0xa0>
80103892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010389f:	00 
801038a0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038a7:	00 
801038a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038af:	00 
801038b0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038b7:	00 
801038b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038bf:	00 
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038c0:	8d 48 01             	lea    0x1(%eax),%ecx
801038c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801038c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801038ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801038d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038d6:	83 c3 01             	add    $0x1,%ebx
801038d9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801038dc:	74 0e                	je     801038ec <piperead+0xcc>
801038de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801038e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038ea:	75 d4                	jne    801038c0 <piperead+0xa0>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038ec:	83 ec 0c             	sub    $0xc,%esp
801038ef:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038f5:	50                   	push   %eax
801038f6:	e8 55 0a 00 00       	call   80104350 <wakeup>
  release(&p->lock);
801038fb:	89 34 24             	mov    %esi,(%esp)
801038fe:	e8 fd 0e 00 00       	call   80104800 <release>
  return i;
80103903:	83 c4 10             	add    $0x10,%esp
}
80103906:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103909:	89 d8                	mov    %ebx,%eax
8010390b:	5b                   	pop    %ebx
8010390c:	5e                   	pop    %esi
8010390d:	5f                   	pop    %edi
8010390e:	5d                   	pop    %ebp
8010390f:	c3                   	ret
      release(&p->lock);
80103910:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103913:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103918:	56                   	push   %esi
80103919:	e8 e2 0e 00 00       	call   80104800 <release>
      return -1;
8010391e:	83 c4 10             	add    $0x10,%esp
}
80103921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103924:	89 d8                	mov    %ebx,%eax
80103926:	5b                   	pop    %ebx
80103927:	5e                   	pop    %esi
80103928:	5f                   	pop    %edi
80103929:	5d                   	pop    %ebp
8010392a:	c3                   	ret
8010392b:	66 90                	xchg   %ax,%ax
8010392d:	66 90                	xchg   %ax,%ax
8010392f:	66 90                	xchg   %ax,%ax
80103931:	66 90                	xchg   %ax,%ax
80103933:	66 90                	xchg   %ax,%ax
80103935:	66 90                	xchg   %ax,%ax
80103937:	66 90                	xchg   %ax,%ax
80103939:	66 90                	xchg   %ax,%ax
8010393b:	66 90                	xchg   %ax,%ax
8010393d:	66 90                	xchg   %ax,%ax
8010393f:	90                   	nop

80103940 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103944:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
80103949:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010394c:	68 20 1d 11 80       	push   $0x80111d20
80103951:	e8 0a 0f 00 00       	call   80104860 <acquire>
80103956:	83 c4 10             	add    $0x10,%esp
80103959:	eb 17                	jmp    80103972 <allocproc+0x32>
8010395b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103960:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103966:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
8010396c:	0f 84 8e 00 00 00    	je     80103a00 <allocproc+0xc0>
    if(p->state == UNUSED)
80103972:	8b 43 0c             	mov    0xc(%ebx),%eax
80103975:	85 c0                	test   %eax,%eax
80103977:	75 e7                	jne    80103960 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103979:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 0;
  p->ticks = 0;

  release(&ptable.lock);
8010397e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103981:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 0;
80103988:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
8010398f:	89 43 10             	mov    %eax,0x10(%ebx)
80103992:	8d 50 01             	lea    0x1(%eax),%edx
  p->ticks = 0;
80103995:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010399c:	00 00 00 
  release(&ptable.lock);
8010399f:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
801039a4:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801039aa:	e8 51 0e 00 00       	call   80104800 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039af:	e8 dc ed ff ff       	call   80102790 <kalloc>
801039b4:	83 c4 10             	add    $0x10,%esp
801039b7:	89 43 08             	mov    %eax,0x8(%ebx)
801039ba:	85 c0                	test   %eax,%eax
801039bc:	74 5b                	je     80103a19 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039be:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039c4:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039c7:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039cc:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801039cf:	c7 40 14 5c 5b 10 80 	movl   $0x80105b5c,0x14(%eax)
  p->context = (struct context*)sp;
801039d6:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039d9:	6a 14                	push   $0x14
801039db:	6a 00                	push   $0x0
801039dd:	50                   	push   %eax
801039de:	e8 9d 0f 00 00       	call   80104980 <memset>
  p->context->eip = (uint)forkret;
801039e3:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039e6:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039e9:	c7 40 10 30 3a 10 80 	movl   $0x80103a30,0x10(%eax)
}
801039f0:	89 d8                	mov    %ebx,%eax
801039f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039f5:	c9                   	leave
801039f6:	c3                   	ret
801039f7:	90                   	nop
801039f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039ff:	00 
  release(&ptable.lock);
80103a00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a03:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a05:	68 20 1d 11 80       	push   $0x80111d20
80103a0a:	e8 f1 0d 00 00       	call   80104800 <release>
  return 0;
80103a0f:	83 c4 10             	add    $0x10,%esp
}
80103a12:	89 d8                	mov    %ebx,%eax
80103a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a17:	c9                   	leave
80103a18:	c3                   	ret
    p->state = UNUSED;
80103a19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103a20:	31 db                	xor    %ebx,%ebx
80103a22:	eb ee                	jmp    80103a12 <allocproc+0xd2>
80103a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a2f:	00 

80103a30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a36:	68 20 1d 11 80       	push   $0x80111d20
80103a3b:	e8 c0 0d 00 00       	call   80104800 <release>

  if (first) {
80103a40:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	85 c0                	test   %eax,%eax
80103a4a:	75 04                	jne    80103a50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a4c:	c9                   	leave
80103a4d:	c3                   	ret
80103a4e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a50:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a57:	00 00 00 
    iinit(ROOTDEV);
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	6a 01                	push   $0x1
80103a5f:	e8 dc db ff ff       	call   80101640 <iinit>
    initlog(ROOTDEV);
80103a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a6b:	e8 c0 f3 ff ff       	call   80102e30 <initlog>
}
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	c9                   	leave
80103a74:	c3                   	ret
80103a75:	8d 76 00             	lea    0x0(%esi),%esi
80103a78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a7f:	00 

80103a80 <pinit>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a86:	68 d6 77 10 80       	push   $0x801077d6
80103a8b:	68 20 1d 11 80       	push   $0x80111d20
80103a90:	e8 ab 0b 00 00       	call   80104640 <initlock>
}
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	c9                   	leave
80103a99:	c3                   	ret
80103a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103aa0 <mycpu>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aa5:	9c                   	pushf
80103aa6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103aa7:	f6 c4 02             	test   $0x2,%ah
80103aaa:	75 65                	jne    80103b11 <mycpu+0x71>
  apicid = lapicid();
80103aac:	e8 4f ef ff ff       	call   80102a00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ab1:	8b 1d 84 17 11 80    	mov    0x80111784,%ebx
  apicid = lapicid();
80103ab7:	89 c6                	mov    %eax,%esi
  for (i = 0; i < ncpu; ++i) {
80103ab9:	85 db                	test   %ebx,%ebx
80103abb:	7e 47                	jle    80103b04 <mycpu+0x64>
80103abd:	31 d2                	xor    %edx,%edx
80103abf:	eb 26                	jmp    80103ae7 <mycpu+0x47>
80103ac1:	eb 1d                	jmp    80103ae0 <mycpu+0x40>
80103ac3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ac8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103acf:	00 
80103ad0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ad7:	00 
80103ad8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103adf:	00 
80103ae0:	83 c2 01             	add    $0x1,%edx
80103ae3:	39 da                	cmp    %ebx,%edx
80103ae5:	74 1d                	je     80103b04 <mycpu+0x64>
    if (cpus[i].apicid == apicid)
80103ae7:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103aed:	0f b6 88 a0 17 11 80 	movzbl -0x7feee860(%eax),%ecx
80103af4:	39 f1                	cmp    %esi,%ecx
80103af6:	75 e8                	jne    80103ae0 <mycpu+0x40>
}
80103af8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103afb:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
80103b00:	5b                   	pop    %ebx
80103b01:	5e                   	pop    %esi
80103b02:	5d                   	pop    %ebp
80103b03:	c3                   	ret
  panic("unknown apicid\n");
80103b04:	83 ec 0c             	sub    $0xc,%esp
80103b07:	68 dd 77 10 80       	push   $0x801077dd
80103b0c:	e8 8f c8 ff ff       	call   801003a0 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b11:	83 ec 0c             	sub    $0xc,%esp
80103b14:	68 50 7b 10 80       	push   $0x80107b50
80103b19:	e8 82 c8 ff ff       	call   801003a0 <panic>
80103b1e:	66 90                	xchg   %ax,%ax

80103b20 <cpuid>:
cpuid() {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b26:	e8 75 ff ff ff       	call   80103aa0 <mycpu>
}
80103b2b:	c9                   	leave
  return mycpu()-cpus;
80103b2c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103b31:	c1 f8 04             	sar    $0x4,%eax
80103b34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b3a:	c3                   	ret
80103b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b40 <myproc>:
myproc(void) {
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b47:	e8 b4 0b 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103b4c:	e8 4f ff ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103b51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b57:	e8 f4 0b 00 00       	call   80104750 <popcli>
}
80103b5c:	89 d8                	mov    %ebx,%eax
80103b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b61:	c9                   	leave
80103b62:	c3                   	ret
80103b63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b6f:	00 

80103b70 <userinit>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	53                   	push   %ebx
80103b74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b77:	e8 c4 fd ff ff       	call   80103940 <allocproc>
80103b7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b7e:	a3 54 3e 11 80       	mov    %eax,0x80113e54
  if((p->pgdir = setupkvm()) == 0)
80103b83:	e8 b8 36 00 00       	call   80107240 <setupkvm>
80103b88:	89 43 04             	mov    %eax,0x4(%ebx)
80103b8b:	85 c0                	test   %eax,%eax
80103b8d:	0f 84 bd 00 00 00    	je     80103c50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b93:	83 ec 04             	sub    $0x4,%esp
80103b96:	68 2c 00 00 00       	push   $0x2c
80103b9b:	68 60 a4 10 80       	push   $0x8010a460
80103ba0:	50                   	push   %eax
80103ba1:	e8 7a 33 00 00       	call   80106f20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ba6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ba9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103baf:	6a 4c                	push   $0x4c
80103bb1:	6a 00                	push   $0x0
80103bb3:	ff 73 18             	push   0x18(%ebx)
80103bb6:	e8 c5 0d 00 00       	call   80104980 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bbe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bc3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bc6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bcf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bdd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103be1:	8b 43 18             	mov    0x18(%ebx),%eax
80103be4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103be8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bec:	8b 43 18             	mov    0x18(%ebx),%eax
80103bef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c00:	8b 43 18             	mov    0x18(%ebx),%eax
80103c03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c0d:	6a 10                	push   $0x10
80103c0f:	68 06 78 10 80       	push   $0x80107806
80103c14:	50                   	push   %eax
80103c15:	e8 16 0f 00 00       	call   80104b30 <safestrcpy>
  p->cwd = namei("/");
80103c1a:	c7 04 24 0f 78 10 80 	movl   $0x8010780f,(%esp)
80103c21:	e8 6a e5 ff ff       	call   80102190 <namei>
80103c26:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c29:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c30:	e8 2b 0c 00 00       	call   80104860 <acquire>
  p->state = RUNNABLE;
80103c35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c3c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c43:	e8 b8 0b 00 00       	call   80104800 <release>
}
80103c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c4b:	83 c4 10             	add    $0x10,%esp
80103c4e:	c9                   	leave
80103c4f:	c3                   	ret
    panic("userinit: out of memory?");
80103c50:	83 ec 0c             	sub    $0xc,%esp
80103c53:	68 ed 77 10 80       	push   $0x801077ed
80103c58:	e8 43 c7 ff ff       	call   801003a0 <panic>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi

80103c60 <growproc>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c67:	e8 94 0a 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103c6c:	e8 2f fe ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103c71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c77:	e8 d4 0a 00 00       	call   80104750 <popcli>
  if(n > 0){
80103c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  sz = curproc->sz;
80103c7f:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c81:	85 d2                	test   %edx,%edx
80103c83:	7f 1b                	jg     80103ca0 <growproc+0x40>
  } else if(n < 0){
80103c85:	75 39                	jne    80103cc0 <growproc+0x60>
  switchuvm(curproc);
80103c87:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c8a:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c8c:	53                   	push   %ebx
80103c8d:	e8 7e 31 00 00       	call   80106e10 <switchuvm>
  return 0;
80103c92:	83 c4 10             	add    $0x10,%esp
80103c95:	31 c0                	xor    %eax,%eax
}
80103c97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c9a:	c9                   	leave
80103c9b:	c3                   	ret
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca0:	8b 55 08             	mov    0x8(%ebp),%edx
80103ca3:	83 ec 04             	sub    $0x4,%esp
80103ca6:	01 c2                	add    %eax,%edx
80103ca8:	52                   	push   %edx
80103ca9:	50                   	push   %eax
80103caa:	ff 73 04             	push   0x4(%ebx)
80103cad:	e8 be 33 00 00       	call   80107070 <allocuvm>
80103cb2:	83 c4 10             	add    $0x10,%esp
80103cb5:	85 c0                	test   %eax,%eax
80103cb7:	75 ce                	jne    80103c87 <growproc+0x27>
      return -1;
80103cb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cbe:	eb d7                	jmp    80103c97 <growproc+0x37>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc0:	8b 55 08             	mov    0x8(%ebp),%edx
80103cc3:	83 ec 04             	sub    $0x4,%esp
80103cc6:	01 c2                	add    %eax,%edx
80103cc8:	52                   	push   %edx
80103cc9:	50                   	push   %eax
80103cca:	ff 73 04             	push   0x4(%ebx)
80103ccd:	e8 be 34 00 00       	call   80107190 <deallocuvm>
80103cd2:	83 c4 10             	add    $0x10,%esp
80103cd5:	85 c0                	test   %eax,%eax
80103cd7:	75 ae                	jne    80103c87 <growproc+0x27>
80103cd9:	eb de                	jmp    80103cb9 <growproc+0x59>
80103cdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ce0 <fork>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
80103ce5:	53                   	push   %ebx
80103ce6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ce9:	e8 12 0a 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103cee:	e8 ad fd ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103cf3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf9:	e8 52 0a 00 00       	call   80104750 <popcli>
  if((np = allocproc()) == 0){
80103cfe:	e8 3d fc ff ff       	call   80103940 <allocproc>
80103d03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d06:	85 c0                	test   %eax,%eax
80103d08:	0f 84 d6 00 00 00    	je     80103de4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d0e:	83 ec 08             	sub    $0x8,%esp
80103d11:	ff 33                	push   (%ebx)
80103d13:	89 c7                	mov    %eax,%edi
80103d15:	ff 73 04             	push   0x4(%ebx)
80103d18:	e8 13 36 00 00       	call   80107330 <copyuvm>
80103d1d:	83 c4 10             	add    $0x10,%esp
80103d20:	89 47 04             	mov    %eax,0x4(%edi)
80103d23:	85 c0                	test   %eax,%eax
80103d25:	0f 84 9a 00 00 00    	je     80103dc5 <fork+0xe5>
  np->sz = curproc->sz;
80103d2b:	8b 03                	mov    (%ebx),%eax
80103d2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d30:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d32:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d35:	89 c8                	mov    %ecx,%eax
80103d37:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d3a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d3f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d46:	8b 40 18             	mov    0x18(%eax),%eax
80103d49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d54:	85 c0                	test   %eax,%eax
80103d56:	74 13                	je     80103d6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	50                   	push   %eax
80103d5c:	e8 cf d1 ff ff       	call   80100f30 <filedup>
80103d61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d6b:	83 c6 01             	add    $0x1,%esi
80103d6e:	83 fe 10             	cmp    $0x10,%esi
80103d71:	75 dd                	jne    80103d50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d73:	83 ec 0c             	sub    $0xc,%esp
80103d76:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d79:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d7c:	e8 bf da ff ff       	call   80101840 <idup>
80103d81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d87:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d8d:	6a 10                	push   $0x10
80103d8f:	53                   	push   %ebx
80103d90:	50                   	push   %eax
80103d91:	e8 9a 0d 00 00       	call   80104b30 <safestrcpy>
  pid = np->pid;
80103d96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d99:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103da0:	e8 bb 0a 00 00       	call   80104860 <acquire>
  np->state = RUNNABLE;
80103da5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dac:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103db3:	e8 48 0a 00 00       	call   80104800 <release>
  return pid;
80103db8:	83 c4 10             	add    $0x10,%esp
}
80103dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dbe:	89 d8                	mov    %ebx,%eax
80103dc0:	5b                   	pop    %ebx
80103dc1:	5e                   	pop    %esi
80103dc2:	5f                   	pop    %edi
80103dc3:	5d                   	pop    %ebp
80103dc4:	c3                   	ret
    kfree(np->kstack);
80103dc5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	ff 73 08             	push   0x8(%ebx)
80103dce:	e8 ed e7 ff ff       	call   801025c0 <kfree>
    np->kstack = 0;
80103dd3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103dda:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ddd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103de4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103de9:	eb d0                	jmp    80103dbb <fork+0xdb>
80103deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103df0 <scheduler>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103df9:	e8 a2 fc ff ff       	call   80103aa0 <mycpu>
  c->proc = 0;
80103dfe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e05:	00 00 00 
  struct cpu *c = mycpu();
80103e08:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e0a:	8d 40 04             	lea    0x4(%eax),%eax
80103e0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103e10:	fb                   	sti
    acquire(&ptable.lock);
80103e11:	83 ec 0c             	sub    $0xc,%esp
    for(q = 0; q < 3; q++){
80103e14:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80103e16:	68 20 1d 11 80       	push   $0x80111d20
80103e1b:	e8 40 0a 00 00       	call   80104860 <acquire>
80103e20:	83 c4 10             	add    $0x10,%esp
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e23:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103e28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e2f:	00 
        if(p->state != RUNNABLE)
80103e30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e34:	75 5a                	jne    80103e90 <scheduler+0xa0>
        if(p->priority != q)
80103e36:	39 7b 7c             	cmp    %edi,0x7c(%ebx)
80103e39:	75 55                	jne    80103e90 <scheduler+0xa0>
        switchuvm(p);
80103e3b:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103e3e:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80103e44:	53                   	push   %ebx
80103e45:	e8 c6 2f 00 00       	call   80106e10 <switchuvm>
        cprintf("pid %d running in queue %d\n", p->pid, p->priority);
80103e4a:	83 c4 0c             	add    $0xc,%esp
80103e4d:	ff 73 7c             	push   0x7c(%ebx)
80103e50:	ff 73 10             	push   0x10(%ebx)
80103e53:	68 11 78 10 80       	push   $0x80107811
        p->state = RUNNING;
80103e58:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        cprintf("pid %d running in queue %d\n", p->pid, p->priority);
80103e5f:	e8 6c c8 ff ff       	call   801006d0 <cprintf>
        swtch(&(c->scheduler), p->context);
80103e64:	58                   	pop    %eax
80103e65:	5a                   	pop    %edx
80103e66:	ff 73 1c             	push   0x1c(%ebx)
80103e69:	ff 75 e4             	push   -0x1c(%ebp)
80103e6c:	e8 2a 0d 00 00       	call   80104b9b <swtch>
        switchkvm();
80103e71:	e8 8a 2f 00 00       	call   80106e00 <switchkvm>
        c->proc = 0;
80103e76:	83 c4 10             	add    $0x10,%esp
80103e79:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e80:	00 00 00 
80103e83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e8f:	00 
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e90:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103e96:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103e9c:	75 92                	jne    80103e30 <scheduler+0x40>
    for(q = 0; q < 3; q++){
80103e9e:	83 c7 01             	add    $0x1,%edi
80103ea1:	83 ff 03             	cmp    $0x3,%edi
80103ea4:	0f 85 79 ff ff ff    	jne    80103e23 <scheduler+0x33>
    release(&ptable.lock);
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 20 1d 11 80       	push   $0x80111d20
80103eb2:	e8 49 09 00 00       	call   80104800 <release>
    sti();
80103eb7:	83 c4 10             	add    $0x10,%esp
80103eba:	e9 51 ff ff ff       	jmp    80103e10 <scheduler+0x20>
80103ebf:	90                   	nop

80103ec0 <sched>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
  pushcli();
80103ec5:	e8 36 08 00 00       	call   80104700 <pushcli>
  c = mycpu();
80103eca:	e8 d1 fb ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103ecf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ed5:	e8 76 08 00 00       	call   80104750 <popcli>
  if(!holding(&ptable.lock))
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 20 1d 11 80       	push   $0x80111d20
80103ee2:	e8 c9 08 00 00       	call   801047b0 <holding>
80103ee7:	83 c4 10             	add    $0x10,%esp
80103eea:	85 c0                	test   %eax,%eax
80103eec:	74 4f                	je     80103f3d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103eee:	e8 ad fb ff ff       	call   80103aa0 <mycpu>
80103ef3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103efa:	75 68                	jne    80103f64 <sched+0xa4>
  if(p->state == RUNNING)
80103efc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f00:	74 55                	je     80103f57 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f02:	9c                   	pushf
80103f03:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f04:	f6 c4 02             	test   $0x2,%ah
80103f07:	75 41                	jne    80103f4a <sched+0x8a>
  intena = mycpu()->intena;
80103f09:	e8 92 fb ff ff       	call   80103aa0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f0e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f17:	e8 84 fb ff ff       	call   80103aa0 <mycpu>
80103f1c:	83 ec 08             	sub    $0x8,%esp
80103f1f:	ff 70 04             	push   0x4(%eax)
80103f22:	53                   	push   %ebx
80103f23:	e8 73 0c 00 00       	call   80104b9b <swtch>
  mycpu()->intena = intena;
80103f28:	e8 73 fb ff ff       	call   80103aa0 <mycpu>
}
80103f2d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f39:	5b                   	pop    %ebx
80103f3a:	5e                   	pop    %esi
80103f3b:	5d                   	pop    %ebp
80103f3c:	c3                   	ret
    panic("sched ptable.lock");
80103f3d:	83 ec 0c             	sub    $0xc,%esp
80103f40:	68 2d 78 10 80       	push   $0x8010782d
80103f45:	e8 56 c4 ff ff       	call   801003a0 <panic>
    panic("sched interruptible");
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 59 78 10 80       	push   $0x80107859
80103f52:	e8 49 c4 ff ff       	call   801003a0 <panic>
    panic("sched running");
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	68 4b 78 10 80       	push   $0x8010784b
80103f5f:	e8 3c c4 ff ff       	call   801003a0 <panic>
    panic("sched locks");
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 3f 78 10 80       	push   $0x8010783f
80103f6c:	e8 2f c4 ff ff       	call   801003a0 <panic>
80103f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f7f:	00 

80103f80 <exit>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	57                   	push   %edi
80103f84:	56                   	push   %esi
80103f85:	53                   	push   %ebx
80103f86:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f89:	e8 b2 fb ff ff       	call   80103b40 <myproc>
  if(curproc == initproc)
80103f8e:	39 05 54 3e 11 80    	cmp    %eax,0x80113e54
80103f94:	0f 84 3f 01 00 00    	je     801040d9 <exit+0x159>
80103f9a:	89 c3                	mov    %eax,%ebx
80103f9c:	8d 70 28             	lea    0x28(%eax),%esi
80103f9f:	8d 78 68             	lea    0x68(%eax),%edi
80103fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103fa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103faf:	00 
    if(curproc->ofile[fd]){
80103fb0:	8b 06                	mov    (%esi),%eax
80103fb2:	85 c0                	test   %eax,%eax
80103fb4:	74 12                	je     80103fc8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fb6:	83 ec 0c             	sub    $0xc,%esp
80103fb9:	50                   	push   %eax
80103fba:	e8 c1 cf ff ff       	call   80100f80 <fileclose>
      curproc->ofile[fd] = 0;
80103fbf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fc5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fc8:	83 c6 04             	add    $0x4,%esi
80103fcb:	39 f7                	cmp    %esi,%edi
80103fcd:	75 e1                	jne    80103fb0 <exit+0x30>
  begin_op();
80103fcf:	e8 0c ef ff ff       	call   80102ee0 <begin_op>
  iput(curproc->cwd);
80103fd4:	83 ec 0c             	sub    $0xc,%esp
80103fd7:	ff 73 68             	push   0x68(%ebx)
80103fda:	e8 c1 d9 ff ff       	call   801019a0 <iput>
  end_op();
80103fdf:	e8 6c ef ff ff       	call   80102f50 <end_op>
  curproc->cwd = 0;
80103fe4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103feb:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ff2:	e8 69 08 00 00       	call   80104860 <acquire>
  wakeup1(curproc->parent);
80103ff7:	8b 53 14             	mov    0x14(%ebx),%edx
80103ffa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ffd:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104002:	eb 28                	jmp    8010402c <exit+0xac>
80104004:	eb 1a                	jmp    80104020 <exit+0xa0>
80104006:	66 90                	xchg   %ax,%ax
80104008:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010400f:	00 
80104010:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104017:	00 
80104018:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010401f:	00 
80104020:	05 84 00 00 00       	add    $0x84,%eax
80104025:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
8010402a:	74 1e                	je     8010404a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
8010402c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104030:	75 ee                	jne    80104020 <exit+0xa0>
80104032:	3b 50 20             	cmp    0x20(%eax),%edx
80104035:	75 e9                	jne    80104020 <exit+0xa0>
      p->state = RUNNABLE;
80104037:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403e:	05 84 00 00 00       	add    $0x84,%eax
80104043:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80104048:	75 e2                	jne    8010402c <exit+0xac>
      p->parent = initproc;
8010404a:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104050:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80104055:	eb 17                	jmp    8010406e <exit+0xee>
80104057:	90                   	nop
80104058:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010405f:	00 
80104060:	81 c2 84 00 00 00    	add    $0x84,%edx
80104066:	81 fa 54 3e 11 80    	cmp    $0x80113e54,%edx
8010406c:	74 52                	je     801040c0 <exit+0x140>
    if(p->parent == curproc){
8010406e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104071:	75 ed                	jne    80104060 <exit+0xe0>
      p->parent = initproc;
80104073:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104076:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
8010407a:	75 e4                	jne    80104060 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407c:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104081:	eb 29                	jmp    801040ac <exit+0x12c>
80104083:	eb 1b                	jmp    801040a0 <exit+0x120>
80104085:	8d 76 00             	lea    0x0(%esi),%esi
80104088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010408f:	00 
80104090:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104097:	00 
80104098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010409f:	00 
801040a0:	05 84 00 00 00       	add    $0x84,%eax
801040a5:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
801040aa:	74 b4                	je     80104060 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
801040ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040b0:	75 ee                	jne    801040a0 <exit+0x120>
801040b2:	3b 48 20             	cmp    0x20(%eax),%ecx
801040b5:	75 e9                	jne    801040a0 <exit+0x120>
      p->state = RUNNABLE;
801040b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040be:	eb e0                	jmp    801040a0 <exit+0x120>
  curproc->state = ZOMBIE;
801040c0:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801040c7:	e8 f4 fd ff ff       	call   80103ec0 <sched>
  panic("zombie exit");
801040cc:	83 ec 0c             	sub    $0xc,%esp
801040cf:	68 7a 78 10 80       	push   $0x8010787a
801040d4:	e8 c7 c2 ff ff       	call   801003a0 <panic>
    panic("init exiting");
801040d9:	83 ec 0c             	sub    $0xc,%esp
801040dc:	68 6d 78 10 80       	push   $0x8010786d
801040e1:	e8 ba c2 ff ff       	call   801003a0 <panic>
801040e6:	66 90                	xchg   %ax,%ax
801040e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040ef:	00 

801040f0 <wait>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
  pushcli();
801040f5:	e8 06 06 00 00       	call   80104700 <pushcli>
  c = mycpu();
801040fa:	e8 a1 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801040ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104105:	e8 46 06 00 00       	call   80104750 <popcli>
  acquire(&ptable.lock);
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 20 1d 11 80       	push   $0x80111d20
80104112:	e8 49 07 00 00       	call   80104860 <acquire>
80104117:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010411a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104121:	eb 2b                	jmp    8010414e <wait+0x5e>
80104123:	eb 1b                	jmp    80104140 <wait+0x50>
80104125:	8d 76 00             	lea    0x0(%esi),%esi
80104128:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010412f:	00 
80104130:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104137:	00 
80104138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010413f:	00 
80104140:	81 c3 84 00 00 00    	add    $0x84,%ebx
80104146:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
8010414c:	74 1e                	je     8010416c <wait+0x7c>
      if(p->parent != curproc)
8010414e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104151:	75 ed                	jne    80104140 <wait+0x50>
      if(p->state == ZOMBIE){
80104153:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104157:	74 67                	je     801041c0 <wait+0xd0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104159:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
8010415f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104164:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
8010416a:	75 e2                	jne    8010414e <wait+0x5e>
    if(!havekids || curproc->killed){
8010416c:	85 c0                	test   %eax,%eax
8010416e:	0f 84 a2 00 00 00    	je     80104216 <wait+0x126>
80104174:	8b 46 24             	mov    0x24(%esi),%eax
80104177:	85 c0                	test   %eax,%eax
80104179:	0f 85 97 00 00 00    	jne    80104216 <wait+0x126>
  pushcli();
8010417f:	e8 7c 05 00 00       	call   80104700 <pushcli>
  c = mycpu();
80104184:	e8 17 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104189:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010418f:	e8 bc 05 00 00       	call   80104750 <popcli>
  if(p == 0)
80104194:	85 db                	test   %ebx,%ebx
80104196:	0f 84 91 00 00 00    	je     8010422d <wait+0x13d>
  p->chan = chan;
8010419c:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
8010419f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041a6:	e8 15 fd ff ff       	call   80103ec0 <sched>
  p->chan = 0;
801041ab:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041b2:	e9 63 ff ff ff       	jmp    8010411a <wait+0x2a>
801041b7:	90                   	nop
801041b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041bf:	00 
        kfree(p->kstack);
801041c0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801041c3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801041c6:	ff 73 08             	push   0x8(%ebx)
801041c9:	e8 f2 e3 ff ff       	call   801025c0 <kfree>
        p->kstack = 0;
801041ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801041d5:	5a                   	pop    %edx
801041d6:	ff 73 04             	push   0x4(%ebx)
801041d9:	e8 e2 2f 00 00       	call   801071c0 <freevm>
        p->pid = 0;
801041de:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801041e5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041ec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041f0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041fe:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104205:	e8 f6 05 00 00       	call   80104800 <release>
        return pid;
8010420a:	83 c4 10             	add    $0x10,%esp
}
8010420d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104210:	89 f0                	mov    %esi,%eax
80104212:	5b                   	pop    %ebx
80104213:	5e                   	pop    %esi
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret
      release(&ptable.lock);
80104216:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104219:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010421e:	68 20 1d 11 80       	push   $0x80111d20
80104223:	e8 d8 05 00 00       	call   80104800 <release>
      return -1;
80104228:	83 c4 10             	add    $0x10,%esp
8010422b:	eb e0                	jmp    8010420d <wait+0x11d>
    panic("sleep");
8010422d:	83 ec 0c             	sub    $0xc,%esp
80104230:	68 86 78 10 80       	push   $0x80107886
80104235:	e8 66 c1 ff ff       	call   801003a0 <panic>
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <yield>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104247:	68 20 1d 11 80       	push   $0x80111d20
8010424c:	e8 0f 06 00 00       	call   80104860 <acquire>
  pushcli();
80104251:	e8 aa 04 00 00       	call   80104700 <pushcli>
  c = mycpu();
80104256:	e8 45 f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010425b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104261:	e8 ea 04 00 00       	call   80104750 <popcli>
  myproc()->state = RUNNABLE;
80104266:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010426d:	e8 4e fc ff ff       	call   80103ec0 <sched>
  release(&ptable.lock);
80104272:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104279:	e8 82 05 00 00       	call   80104800 <release>
}
8010427e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104281:	83 c4 10             	add    $0x10,%esp
80104284:	c9                   	leave
80104285:	c3                   	ret
80104286:	66 90                	xchg   %ax,%ax
80104288:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010428f:	00 

80104290 <sleep>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	83 ec 0c             	sub    $0xc,%esp
80104299:	8b 7d 08             	mov    0x8(%ebp),%edi
8010429c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010429f:	e8 5c 04 00 00       	call   80104700 <pushcli>
  c = mycpu();
801042a4:	e8 f7 f7 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801042a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042af:	e8 9c 04 00 00       	call   80104750 <popcli>
  if(p == 0)
801042b4:	85 db                	test   %ebx,%ebx
801042b6:	0f 84 87 00 00 00    	je     80104343 <sleep+0xb3>
  if(lk == 0)
801042bc:	85 f6                	test   %esi,%esi
801042be:	74 76                	je     80104336 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042c0:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801042c6:	74 50                	je     80104318 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	68 20 1d 11 80       	push   $0x80111d20
801042d0:	e8 8b 05 00 00       	call   80104860 <acquire>
    release(lk);
801042d5:	89 34 24             	mov    %esi,(%esp)
801042d8:	e8 23 05 00 00       	call   80104800 <release>
  p->chan = chan;
801042dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042e7:	e8 d4 fb ff ff       	call   80103ec0 <sched>
  p->chan = 0;
801042ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042f3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801042fa:	e8 01 05 00 00       	call   80104800 <release>
    acquire(lk);
801042ff:	83 c4 10             	add    $0x10,%esp
80104302:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104308:	5b                   	pop    %ebx
80104309:	5e                   	pop    %esi
8010430a:	5f                   	pop    %edi
8010430b:	5d                   	pop    %ebp
    acquire(lk);
8010430c:	e9 4f 05 00 00       	jmp    80104860 <acquire>
80104311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104318:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010431b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104322:	e8 99 fb ff ff       	call   80103ec0 <sched>
  p->chan = 0;
80104327:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010432e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104331:	5b                   	pop    %ebx
80104332:	5e                   	pop    %esi
80104333:	5f                   	pop    %edi
80104334:	5d                   	pop    %ebp
80104335:	c3                   	ret
    panic("sleep without lk");
80104336:	83 ec 0c             	sub    $0xc,%esp
80104339:	68 8c 78 10 80       	push   $0x8010788c
8010433e:	e8 5d c0 ff ff       	call   801003a0 <panic>
    panic("sleep");
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	68 86 78 10 80       	push   $0x80107886
8010434b:	e8 50 c0 ff ff       	call   801003a0 <panic>

80104350 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010435a:	68 20 1d 11 80       	push   $0x80111d20
8010435f:	e8 fc 04 00 00       	call   80104860 <acquire>
80104364:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104367:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010436c:	eb 1e                	jmp    8010438c <wakeup+0x3c>
8010436e:	66 90                	xchg   %ax,%ax
80104370:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104377:	00 
80104378:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010437f:	00 
80104380:	05 84 00 00 00       	add    $0x84,%eax
80104385:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
8010438a:	74 1e                	je     801043aa <wakeup+0x5a>
    if(p->state == SLEEPING && p->chan == chan)
8010438c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104390:	75 ee                	jne    80104380 <wakeup+0x30>
80104392:	3b 58 20             	cmp    0x20(%eax),%ebx
80104395:	75 e9                	jne    80104380 <wakeup+0x30>
      p->state = RUNNABLE;
80104397:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010439e:	05 84 00 00 00       	add    $0x84,%eax
801043a3:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
801043a8:	75 e2                	jne    8010438c <wakeup+0x3c>
  wakeup1(chan);
  release(&ptable.lock);
801043aa:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
801043b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b4:	c9                   	leave
  release(&ptable.lock);
801043b5:	e9 46 04 00 00       	jmp    80104800 <release>
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ca:	68 20 1d 11 80       	push   $0x80111d20
801043cf:	e8 8c 04 00 00       	call   80104860 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801043dc:	eb 0e                	jmp    801043ec <kill+0x2c>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	05 84 00 00 00       	add    $0x84,%eax
801043e5:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
801043ea:	74 34                	je     80104420 <kill+0x60>
    if(p->pid == pid){
801043ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801043ef:	75 ef                	jne    801043e0 <kill+0x20>
      p->killed = 1;
801043f1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043f8:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043fc:	75 07                	jne    80104405 <kill+0x45>
        p->state = RUNNABLE;
801043fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104405:	83 ec 0c             	sub    $0xc,%esp
80104408:	68 20 1d 11 80       	push   $0x80111d20
8010440d:	e8 ee 03 00 00       	call   80104800 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104415:	83 c4 10             	add    $0x10,%esp
80104418:	31 c0                	xor    %eax,%eax
}
8010441a:	c9                   	leave
8010441b:	c3                   	ret
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 20 1d 11 80       	push   $0x80111d20
80104428:	e8 d3 03 00 00       	call   80104800 <release>
}
8010442d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104430:	83 c4 10             	add    $0x10,%esp
80104433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104438:	c9                   	leave
80104439:	c3                   	ret
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104445:	8d 75 c0             	lea    -0x40(%ebp),%esi
{
80104448:	53                   	push   %ebx
80104449:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010444e:	83 ec 3c             	sub    $0x3c,%esp
80104451:	eb 27                	jmp    8010447a <procdump+0x3a>
80104453:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	68 63 7a 10 80       	push   $0x80107a63
80104460:	e8 6b c2 ff ff       	call   801006d0 <cprintf>
80104465:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104468:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010446e:	81 fb c0 3e 11 80    	cmp    $0x80113ec0,%ebx
80104474:	0f 84 86 00 00 00    	je     80104500 <procdump+0xc0>
    if(p->state == UNUSED)
8010447a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010447d:	85 c0                	test   %eax,%eax
8010447f:	74 e7                	je     80104468 <procdump+0x28>
      state = "???";
80104481:	ba 9d 78 10 80       	mov    $0x8010789d,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104486:	83 f8 05             	cmp    $0x5,%eax
80104489:	77 11                	ja     8010449c <procdump+0x5c>
8010448b:	8b 14 85 60 7e 10 80 	mov    -0x7fef81a0(,%eax,4),%edx
      state = "???";
80104492:	b8 9d 78 10 80       	mov    $0x8010789d,%eax
80104497:	85 d2                	test   %edx,%edx
80104499:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010449c:	53                   	push   %ebx
8010449d:	52                   	push   %edx
8010449e:	ff 73 a4             	push   -0x5c(%ebx)
801044a1:	68 a1 78 10 80       	push   $0x801078a1
801044a6:	e8 25 c2 ff ff       	call   801006d0 <cprintf>
    if(p->state == SLEEPING){
801044ab:	83 c4 10             	add    $0x10,%esp
801044ae:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044b2:	75 a4                	jne    80104458 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044b4:	83 ec 08             	sub    $0x8,%esp
801044b7:	89 f7                	mov    %esi,%edi
801044b9:	56                   	push   %esi
801044ba:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044bd:	8b 40 0c             	mov    0xc(%eax),%eax
801044c0:	83 c0 08             	add    $0x8,%eax
801044c3:	50                   	push   %eax
801044c4:	e8 97 01 00 00       	call   80104660 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044c9:	83 c4 10             	add    $0x10,%esp
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d0:	8b 07                	mov    (%edi),%eax
801044d2:	85 c0                	test   %eax,%eax
801044d4:	74 82                	je     80104458 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044dc:	50                   	push   %eax
801044dd:	68 c1 75 10 80       	push   $0x801075c1
801044e2:	e8 e9 c1 ff ff       	call   801006d0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044e7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801044ea:	83 c4 10             	add    $0x10,%esp
801044ed:	39 c7                	cmp    %eax,%edi
801044ef:	75 df                	jne    801044d0 <procdump+0x90>
801044f1:	e9 62 ff ff ff       	jmp    80104458 <procdump+0x18>
801044f6:	66 90                	xchg   %ax,%ax
801044f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044ff:	00 
  }
}
80104500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104503:	5b                   	pop    %ebx
80104504:	5e                   	pop    %esi
80104505:	5f                   	pop    %edi
80104506:	5d                   	pop    %ebp
80104507:	c3                   	ret
80104508:	66 90                	xchg   %ax,%ax
8010450a:	66 90                	xchg   %ax,%ax
8010450c:	66 90                	xchg   %ax,%ax
8010450e:	66 90                	xchg   %ax,%ax

80104510 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	53                   	push   %ebx
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010451a:	68 d4 78 10 80       	push   $0x801078d4
8010451f:	8d 43 04             	lea    0x4(%ebx),%eax
80104522:	50                   	push   %eax
80104523:	e8 18 01 00 00       	call   80104640 <initlock>
  lk->name = name;
80104528:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010452b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104531:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104534:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010453b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010453e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104541:	c9                   	leave
80104542:	c3                   	ret
80104543:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104548:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010454f:	00 

80104550 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104558:	8d 73 04             	lea    0x4(%ebx),%esi
8010455b:	83 ec 0c             	sub    $0xc,%esp
8010455e:	56                   	push   %esi
8010455f:	e8 fc 02 00 00       	call   80104860 <acquire>
  while (lk->locked) {
80104564:	8b 13                	mov    (%ebx),%edx
80104566:	83 c4 10             	add    $0x10,%esp
80104569:	85 d2                	test   %edx,%edx
8010456b:	74 16                	je     80104583 <acquiresleep+0x33>
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104570:	83 ec 08             	sub    $0x8,%esp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	e8 16 fd ff ff       	call   80104290 <sleep>
  while (lk->locked) {
8010457a:	8b 03                	mov    (%ebx),%eax
8010457c:	83 c4 10             	add    $0x10,%esp
8010457f:	85 c0                	test   %eax,%eax
80104581:	75 ed                	jne    80104570 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104583:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104589:	e8 b2 f5 ff ff       	call   80103b40 <myproc>
8010458e:	8b 40 10             	mov    0x10(%eax),%eax
80104591:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104594:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104597:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010459a:	5b                   	pop    %ebx
8010459b:	5e                   	pop    %esi
8010459c:	5d                   	pop    %ebp
  release(&lk->lk);
8010459d:	e9 5e 02 00 00       	jmp    80104800 <release>
801045a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045af:	00 

801045b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045b8:	8d 73 04             	lea    0x4(%ebx),%esi
801045bb:	83 ec 0c             	sub    $0xc,%esp
801045be:	56                   	push   %esi
801045bf:	e8 9c 02 00 00       	call   80104860 <acquire>
  lk->locked = 0;
801045c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045d1:	89 1c 24             	mov    %ebx,(%esp)
801045d4:	e8 77 fd ff ff       	call   80104350 <wakeup>
  release(&lk->lk);
801045d9:	83 c4 10             	add    $0x10,%esp
801045dc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045e2:	5b                   	pop    %ebx
801045e3:	5e                   	pop    %esi
801045e4:	5d                   	pop    %ebp
  release(&lk->lk);
801045e5:	e9 16 02 00 00       	jmp    80104800 <release>
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	31 ff                	xor    %edi,%edi
801045f6:	56                   	push   %esi
801045f7:	53                   	push   %ebx
801045f8:	83 ec 18             	sub    $0x18,%esp
801045fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104601:	56                   	push   %esi
80104602:	e8 59 02 00 00       	call   80104860 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104607:	8b 03                	mov    (%ebx),%eax
80104609:	83 c4 10             	add    $0x10,%esp
8010460c:	85 c0                	test   %eax,%eax
8010460e:	75 18                	jne    80104628 <holdingsleep+0x38>
  release(&lk->lk);
80104610:	83 ec 0c             	sub    $0xc,%esp
80104613:	56                   	push   %esi
80104614:	e8 e7 01 00 00       	call   80104800 <release>
  return r;
}
80104619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010461c:	89 f8                	mov    %edi,%eax
8010461e:	5b                   	pop    %ebx
8010461f:	5e                   	pop    %esi
80104620:	5f                   	pop    %edi
80104621:	5d                   	pop    %ebp
80104622:	c3                   	ret
80104623:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104628:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010462b:	e8 10 f5 ff ff       	call   80103b40 <myproc>
80104630:	39 58 10             	cmp    %ebx,0x10(%eax)
80104633:	0f 94 c0             	sete   %al
80104636:	0f b6 c0             	movzbl %al,%eax
80104639:	89 c7                	mov    %eax,%edi
8010463b:	eb d3                	jmp    80104610 <holdingsleep+0x20>
8010463d:	66 90                	xchg   %ax,%ax
8010463f:	90                   	nop

80104640 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104646:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010464f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104652:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104659:	5d                   	pop    %ebp
8010465a:	c3                   	ret
8010465b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104660 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104660:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104661:	31 d2                	xor    %edx,%edx
{
80104663:	89 e5                	mov    %esp,%ebp
80104665:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104666:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104669:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010466c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010466f:	90                   	nop
80104670:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104677:	00 
80104678:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010467f:	00 
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104680:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104686:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010468c:	77 1a                	ja     801046a8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010468e:	8b 58 04             	mov    0x4(%eax),%ebx
80104691:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104694:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104697:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104699:	83 fa 0a             	cmp    $0xa,%edx
8010469c:	75 e2                	jne    80104680 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010469e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a1:	c9                   	leave
801046a2:	c3                   	ret
801046a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801046a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046ab:	83 c1 28             	add    $0x28,%ecx
801046ae:	89 ca                	mov    %ecx,%edx
801046b0:	29 c2                	sub    %eax,%edx
801046b2:	83 e2 04             	and    $0x4,%edx
801046b5:	74 29                	je     801046e0 <getcallerpcs+0x80>
    pcs[i] = 0;
801046b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046bd:	83 c0 04             	add    $0x4,%eax
801046c0:	39 c8                	cmp    %ecx,%eax
801046c2:	74 da                	je     8010469e <getcallerpcs+0x3e>
801046c4:	eb 1a                	jmp    801046e0 <getcallerpcs+0x80>
801046c6:	66 90                	xchg   %ax,%ax
801046c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046cf:	00 
801046d0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046d7:	00 
801046d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046df:	00 
    pcs[i] = 0;
801046e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046e6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801046e9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801046f0:	39 c8                	cmp    %ecx,%eax
801046f2:	75 ec                	jne    801046e0 <getcallerpcs+0x80>
801046f4:	eb a8                	jmp    8010469e <getcallerpcs+0x3e>
801046f6:	66 90                	xchg   %ax,%ax
801046f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046ff:	00 

80104700 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 04             	sub    $0x4,%esp
80104707:	9c                   	pushf
80104708:	5b                   	pop    %ebx
  asm volatile("cli");
80104709:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010470a:	e8 91 f3 ff ff       	call   80103aa0 <mycpu>
8010470f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104715:	85 c0                	test   %eax,%eax
80104717:	74 17                	je     80104730 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104719:	e8 82 f3 ff ff       	call   80103aa0 <mycpu>
8010471e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104728:	c9                   	leave
80104729:	c3                   	ret
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104730:	e8 6b f3 ff ff       	call   80103aa0 <mycpu>
80104735:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010473b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104741:	eb d6                	jmp    80104719 <pushcli+0x19>
80104743:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010474f:	00 

80104750 <popcli>:

void
popcli(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104756:	9c                   	pushf
80104757:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104758:	f6 c4 02             	test   $0x2,%ah
8010475b:	75 35                	jne    80104792 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010475d:	e8 3e f3 ff ff       	call   80103aa0 <mycpu>
80104762:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104769:	78 34                	js     8010479f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010476b:	e8 30 f3 ff ff       	call   80103aa0 <mycpu>
80104770:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104776:	85 d2                	test   %edx,%edx
80104778:	74 06                	je     80104780 <popcli+0x30>
    sti();
}
8010477a:	c9                   	leave
8010477b:	c3                   	ret
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104780:	e8 1b f3 ff ff       	call   80103aa0 <mycpu>
80104785:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010478b:	85 c0                	test   %eax,%eax
8010478d:	74 eb                	je     8010477a <popcli+0x2a>
  asm volatile("sti");
8010478f:	fb                   	sti
}
80104790:	c9                   	leave
80104791:	c3                   	ret
    panic("popcli - interruptible");
80104792:	83 ec 0c             	sub    $0xc,%esp
80104795:	68 df 78 10 80       	push   $0x801078df
8010479a:	e8 01 bc ff ff       	call   801003a0 <panic>
    panic("popcli");
8010479f:	83 ec 0c             	sub    $0xc,%esp
801047a2:	68 f6 78 10 80       	push   $0x801078f6
801047a7:	e8 f4 bb ff ff       	call   801003a0 <panic>
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <holding>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	53                   	push   %ebx
801047b4:	31 db                	xor    %ebx,%ebx
801047b6:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801047b9:	e8 42 ff ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047be:	8b 45 08             	mov    0x8(%ebp),%eax
801047c1:	8b 10                	mov    (%eax),%edx
801047c3:	85 d2                	test   %edx,%edx
801047c5:	75 11                	jne    801047d8 <holding+0x28>
  popcli();
801047c7:	e8 84 ff ff ff       	call   80104750 <popcli>
}
801047cc:	89 d8                	mov    %ebx,%eax
801047ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d1:	c9                   	leave
801047d2:	c3                   	ret
801047d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801047d8:	8b 58 08             	mov    0x8(%eax),%ebx
801047db:	e8 c0 f2 ff ff       	call   80103aa0 <mycpu>
801047e0:	39 c3                	cmp    %eax,%ebx
801047e2:	0f 94 c3             	sete   %bl
  popcli();
801047e5:	e8 66 ff ff ff       	call   80104750 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801047ea:	0f b6 db             	movzbl %bl,%ebx
}
801047ed:	89 d8                	mov    %ebx,%eax
801047ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f2:	c9                   	leave
801047f3:	c3                   	ret
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047ff:	00 

80104800 <release>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104808:	e8 f3 fe ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010480d:	8b 03                	mov    (%ebx),%eax
8010480f:	85 c0                	test   %eax,%eax
80104811:	75 15                	jne    80104828 <release+0x28>
  popcli();
80104813:	e8 38 ff ff ff       	call   80104750 <popcli>
    panic("release");
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 fd 78 10 80       	push   $0x801078fd
80104820:	e8 7b bb ff ff       	call   801003a0 <panic>
80104825:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104828:	8b 73 08             	mov    0x8(%ebx),%esi
8010482b:	e8 70 f2 ff ff       	call   80103aa0 <mycpu>
80104830:	39 c6                	cmp    %eax,%esi
80104832:	75 df                	jne    80104813 <release+0x13>
  popcli();
80104834:	e8 17 ff ff ff       	call   80104750 <popcli>
  lk->pcs[0] = 0;
80104839:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104840:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104847:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010484c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104852:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104855:	5b                   	pop    %ebx
80104856:	5e                   	pop    %esi
80104857:	5d                   	pop    %ebp
  popcli();
80104858:	e9 f3 fe ff ff       	jmp    80104750 <popcli>
8010485d:	8d 76 00             	lea    0x0(%esi),%esi

80104860 <acquire>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104865:	e8 96 fe ff ff       	call   80104700 <pushcli>
  if(holding(lk))
8010486a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010486d:	e8 8e fe ff ff       	call   80104700 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104872:	8b 03                	mov    (%ebx),%eax
80104874:	85 c0                	test   %eax,%eax
80104876:	0f 85 c4 00 00 00    	jne    80104940 <acquire+0xe0>
  popcli();
8010487c:	e8 cf fe ff ff       	call   80104750 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104881:	b8 01 00 00 00       	mov    $0x1,%eax
80104886:	f0 87 03             	lock xchg %eax,(%ebx)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104889:	8b 55 08             	mov    0x8(%ebp),%edx
  while(xchg(&lk->locked, 1) != 0)
8010488c:	85 c0                	test   %eax,%eax
8010488e:	74 0c                	je     8010489c <acquire+0x3c>
  asm volatile("lock; xchgl %0, %1" :
80104890:	b8 01 00 00 00       	mov    $0x1,%eax
80104895:	f0 87 02             	lock xchg %eax,(%edx)
80104898:	85 c0                	test   %eax,%eax
8010489a:	75 f4                	jne    80104890 <acquire+0x30>
  __sync_synchronize();
8010489c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048a4:	e8 f7 f1 ff ff       	call   80103aa0 <mycpu>
  ebp = (uint*)v - 2;
801048a9:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801048ab:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801048ae:	31 c0                	xor    %eax,%eax
801048b0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048b7:	00 
801048b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048bf:	00 
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048c0:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
801048c6:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801048cc:	77 22                	ja     801048f0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801048ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801048d1:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
801048d5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048d8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048da:	83 f8 0a             	cmp    $0xa,%eax
801048dd:	75 e1                	jne    801048c0 <acquire+0x60>
}
801048df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e2:	5b                   	pop    %ebx
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret
801048e6:	66 90                	xchg   %ax,%ax
801048e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ef:	00 
  for(; i < 10; i++)
801048f0:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
801048f4:	83 c3 34             	add    $0x34,%ebx
801048f7:	89 da                	mov    %ebx,%edx
801048f9:	29 c2                	sub    %eax,%edx
801048fb:	83 e2 04             	and    $0x4,%edx
801048fe:	74 20                	je     80104920 <acquire+0xc0>
    pcs[i] = 0;
80104900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104906:	83 c0 04             	add    $0x4,%eax
80104909:	39 d8                	cmp    %ebx,%eax
8010490b:	74 d2                	je     801048df <acquire+0x7f>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
80104910:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104917:	00 
80104918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010491f:	00 
    pcs[i] = 0;
80104920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104926:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104929:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104930:	39 d8                	cmp    %ebx,%eax
80104932:	75 ec                	jne    80104920 <acquire+0xc0>
80104934:	eb a9                	jmp    801048df <acquire+0x7f>
80104936:	66 90                	xchg   %ax,%ax
80104938:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010493f:	00 
  r = lock->locked && lock->cpu == mycpu();
80104940:	8b 73 08             	mov    0x8(%ebx),%esi
80104943:	e8 58 f1 ff ff       	call   80103aa0 <mycpu>
80104948:	39 c6                	cmp    %eax,%esi
8010494a:	0f 85 2c ff ff ff    	jne    8010487c <acquire+0x1c>
  popcli();
80104950:	e8 fb fd ff ff       	call   80104750 <popcli>
    panic("acquire");
80104955:	83 ec 0c             	sub    $0xc,%esp
80104958:	68 05 79 10 80       	push   $0x80107905
8010495d:	e8 3e ba ff ff       	call   801003a0 <panic>
80104962:	66 90                	xchg   %ax,%ax
80104964:	66 90                	xchg   %ax,%ax
80104966:	66 90                	xchg   %ax,%ax
80104968:	66 90                	xchg   %ax,%ax
8010496a:	66 90                	xchg   %ax,%ax
8010496c:	66 90                	xchg   %ax,%ax
8010496e:	66 90                	xchg   %ax,%ax
80104970:	66 90                	xchg   %ax,%ax
80104972:	66 90                	xchg   %ax,%ax
80104974:	66 90                	xchg   %ax,%ax
80104976:	66 90                	xchg   %ax,%ax
80104978:	66 90                	xchg   %ax,%ax
8010497a:	66 90                	xchg   %ax,%ax
8010497c:	66 90                	xchg   %ax,%ax
8010497e:	66 90                	xchg   %ax,%ax

80104980 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	8b 55 08             	mov    0x8(%ebp),%edx
80104987:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010498a:	89 d0                	mov    %edx,%eax
8010498c:	09 c8                	or     %ecx,%eax
8010498e:	a8 03                	test   $0x3,%al
80104990:	75 1e                	jne    801049b0 <memset+0x30>
    c &= 0xFF;
80104992:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104996:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104999:	89 d7                	mov    %edx,%edi
8010499b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801049a1:	fc                   	cld
801049a2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801049a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801049a7:	89 d0                	mov    %edx,%eax
801049a9:	c9                   	leave
801049aa:	c3                   	ret
801049ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801049b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801049b3:	89 d7                	mov    %edx,%edi
801049b5:	fc                   	cld
801049b6:	f3 aa                	rep stos %al,%es:(%edi)
801049b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801049bb:	89 d0                	mov    %edx,%eax
801049bd:	c9                   	leave
801049be:	c3                   	ret
801049bf:	90                   	nop

801049c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	8b 75 10             	mov    0x10(%ebp),%esi
801049c7:	8b 45 08             	mov    0x8(%ebp),%eax
801049ca:	53                   	push   %ebx
801049cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049ce:	85 f6                	test   %esi,%esi
801049d0:	74 2e                	je     80104a00 <memcmp+0x40>
801049d2:	01 c6                	add    %eax,%esi
801049d4:	eb 14                	jmp    801049ea <memcmp+0x2a>
801049d6:	66 90                	xchg   %ax,%ax
801049d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049df:	00 
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049e0:	83 c0 01             	add    $0x1,%eax
801049e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049e6:	39 f0                	cmp    %esi,%eax
801049e8:	74 16                	je     80104a00 <memcmp+0x40>
    if(*s1 != *s2)
801049ea:	0f b6 08             	movzbl (%eax),%ecx
801049ed:	0f b6 1a             	movzbl (%edx),%ebx
801049f0:	38 d9                	cmp    %bl,%cl
801049f2:	74 ec                	je     801049e0 <memcmp+0x20>
      return *s1 - *s2;
801049f4:	0f b6 c1             	movzbl %cl,%eax
801049f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049f9:	5b                   	pop    %ebx
801049fa:	5e                   	pop    %esi
801049fb:	5d                   	pop    %ebp
801049fc:	c3                   	ret
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
80104a00:	5b                   	pop    %ebx
  return 0;
80104a01:	31 c0                	xor    %eax,%eax
}
80104a03:	5e                   	pop    %esi
80104a04:	5d                   	pop    %ebp
80104a05:	c3                   	ret
80104a06:	66 90                	xchg   %ax,%ax
80104a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a0f:	00 

80104a10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	8b 55 08             	mov    0x8(%ebp),%edx
80104a17:	8b 45 10             	mov    0x10(%ebp),%eax
80104a1a:	56                   	push   %esi
80104a1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a1e:	39 d6                	cmp    %edx,%esi
80104a20:	73 26                	jae    80104a48 <memmove+0x38>
80104a22:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104a25:	39 ca                	cmp    %ecx,%edx
80104a27:	73 1f                	jae    80104a48 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a29:	85 c0                	test   %eax,%eax
80104a2b:	74 0f                	je     80104a3c <memmove+0x2c>
80104a2d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104a30:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a34:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a37:	83 e8 01             	sub    $0x1,%eax
80104a3a:	73 f4                	jae    80104a30 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a3c:	5e                   	pop    %esi
80104a3d:	89 d0                	mov    %edx,%eax
80104a3f:	5f                   	pop    %edi
80104a40:	5d                   	pop    %ebp
80104a41:	c3                   	ret
80104a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a48:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104a4b:	89 d7                	mov    %edx,%edi
80104a4d:	85 c0                	test   %eax,%eax
80104a4f:	74 eb                	je     80104a3c <memmove+0x2c>
80104a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a5f:	00 
      *d++ = *s++;
80104a60:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a61:	39 f1                	cmp    %esi,%ecx
80104a63:	75 fb                	jne    80104a60 <memmove+0x50>
}
80104a65:	5e                   	pop    %esi
80104a66:	89 d0                	mov    %edx,%eax
80104a68:	5f                   	pop    %edi
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret
80104a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a70:	eb 9e                	jmp    80104a10 <memmove>
80104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a7f:	00 

80104a80 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	8b 55 10             	mov    0x10(%ebp),%edx
80104a87:	8b 45 08             	mov    0x8(%ebp),%eax
80104a8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104a8d:	85 d2                	test   %edx,%edx
80104a8f:	75 16                	jne    80104aa7 <strncmp+0x27>
80104a91:	eb 2d                	jmp    80104ac0 <strncmp+0x40>
80104a93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a98:	3a 19                	cmp    (%ecx),%bl
80104a9a:	75 12                	jne    80104aae <strncmp+0x2e>
    n--, p++, q++;
80104a9c:	83 c0 01             	add    $0x1,%eax
80104a9f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104aa2:	83 ea 01             	sub    $0x1,%edx
80104aa5:	74 19                	je     80104ac0 <strncmp+0x40>
80104aa7:	0f b6 18             	movzbl (%eax),%ebx
80104aaa:	84 db                	test   %bl,%bl
80104aac:	75 ea                	jne    80104a98 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104aae:	0f b6 00             	movzbl (%eax),%eax
80104ab1:	0f b6 11             	movzbl (%ecx),%edx
}
80104ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104ab8:	29 d0                	sub    %edx,%eax
}
80104aba:	c3                   	ret
80104abb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104ac3:	31 c0                	xor    %eax,%eax
}
80104ac5:	c9                   	leave
80104ac6:	c3                   	ret
80104ac7:	90                   	nop
80104ac8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104acf:	00 

80104ad0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ad7:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ada:	8b 45 08             	mov    0x8(%ebp),%eax
80104add:	eb 14                	jmp    80104af3 <strncpy+0x23>
80104adf:	90                   	nop
80104ae0:	0f b6 19             	movzbl (%ecx),%ebx
80104ae3:	83 c1 01             	add    $0x1,%ecx
80104ae6:	83 c0 01             	add    $0x1,%eax
80104ae9:	88 58 ff             	mov    %bl,-0x1(%eax)
80104aec:	84 db                	test   %bl,%bl
80104aee:	74 10                	je     80104b00 <strncpy+0x30>
80104af0:	83 ea 01             	sub    $0x1,%edx
80104af3:	85 d2                	test   %edx,%edx
80104af5:	7f e9                	jg     80104ae0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104af7:	8b 45 08             	mov    0x8(%ebp),%eax
80104afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104afd:	c9                   	leave
80104afe:	c3                   	ret
80104aff:	90                   	nop
  while(n-- > 0)
80104b00:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
80104b04:	83 ea 01             	sub    $0x1,%edx
80104b07:	74 ee                	je     80104af7 <strncpy+0x27>
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b10:	83 c0 01             	add    $0x1,%eax
80104b13:	89 ca                	mov    %ecx,%edx
80104b15:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104b19:	29 c2                	sub    %eax,%edx
80104b1b:	85 d2                	test   %edx,%edx
80104b1d:	7f f1                	jg     80104b10 <strncpy+0x40>
}
80104b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104b22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b25:	c9                   	leave
80104b26:	c3                   	ret
80104b27:	90                   	nop
80104b28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b2f:	00 

80104b30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	8b 55 10             	mov    0x10(%ebp),%edx
80104b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b3a:	85 d2                	test   %edx,%edx
80104b3c:	7e 39                	jle    80104b77 <safestrcpy+0x47>
80104b3e:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b42:	8b 55 08             	mov    0x8(%ebp),%edx
80104b45:	eb 29                	jmp    80104b70 <safestrcpy+0x40>
80104b47:	eb 17                	jmp    80104b60 <safestrcpy+0x30>
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b50:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b57:	00 
80104b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b5f:	00 
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b60:	0f b6 08             	movzbl (%eax),%ecx
80104b63:	83 c0 01             	add    $0x1,%eax
80104b66:	83 c2 01             	add    $0x1,%edx
80104b69:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b6c:	84 c9                	test   %cl,%cl
80104b6e:	74 04                	je     80104b74 <safestrcpy+0x44>
80104b70:	39 d8                	cmp    %ebx,%eax
80104b72:	75 ec                	jne    80104b60 <safestrcpy+0x30>
    ;
  *s = 0;
80104b74:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b77:	8b 45 08             	mov    0x8(%ebp),%eax
80104b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b7d:	c9                   	leave
80104b7e:	c3                   	ret
80104b7f:	90                   	nop

80104b80 <strlen>:

int
strlen(const char *s)
{
80104b80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b81:	31 c0                	xor    %eax,%eax
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b88:	80 3a 00             	cmpb   $0x0,(%edx)
80104b8b:	74 0c                	je     80104b99 <strlen+0x19>
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
80104b90:	83 c0 01             	add    $0x1,%eax
80104b93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b97:	75 f7                	jne    80104b90 <strlen+0x10>
    ;
  return n;
}
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret

80104b9b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ba3:	55                   	push   %ebp
  pushl %ebx
80104ba4:	53                   	push   %ebx
  pushl %esi
80104ba5:	56                   	push   %esi
  pushl %edi
80104ba6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ba7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ba9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bab:	5f                   	pop    %edi
  popl %esi
80104bac:	5e                   	pop    %esi
  popl %ebx
80104bad:	5b                   	pop    %ebx
  popl %ebp
80104bae:	5d                   	pop    %ebp
  ret
80104baf:	c3                   	ret

80104bb0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bba:	e8 81 ef ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bbf:	8b 00                	mov    (%eax),%eax
80104bc1:	39 c3                	cmp    %eax,%ebx
80104bc3:	73 1b                	jae    80104be0 <fetchint+0x30>
80104bc5:	8d 53 04             	lea    0x4(%ebx),%edx
80104bc8:	39 d0                	cmp    %edx,%eax
80104bca:	72 14                	jb     80104be0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bcf:	8b 13                	mov    (%ebx),%edx
80104bd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd8:	c9                   	leave
80104bd9:	c3                   	ret
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104be5:	eb ee                	jmp    80104bd5 <fetchint+0x25>
80104be7:	90                   	nop
80104be8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bef:	00 

80104bf0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
80104bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bfa:	e8 41 ef ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz)
80104bff:	3b 18                	cmp    (%eax),%ebx
80104c01:	73 35                	jae    80104c38 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104c03:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c06:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c08:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c0a:	39 d3                	cmp    %edx,%ebx
80104c0c:	73 2a                	jae    80104c38 <fetchstr+0x48>
80104c0e:	89 d8                	mov    %ebx,%eax
80104c10:	eb 15                	jmp    80104c27 <fetchstr+0x37>
80104c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c1f:	00 
80104c20:	83 c0 01             	add    $0x1,%eax
80104c23:	39 d0                	cmp    %edx,%eax
80104c25:	73 11                	jae    80104c38 <fetchstr+0x48>
    if(*s == 0)
80104c27:	80 38 00             	cmpb   $0x0,(%eax)
80104c2a:	75 f4                	jne    80104c20 <fetchstr+0x30>
      return s - *pp;
80104c2c:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c31:	c9                   	leave
80104c32:	c3                   	ret
80104c33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c40:	c9                   	leave
80104c41:	c3                   	ret
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c4f:	00 

80104c50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c55:	e8 e6 ee ff ff       	call   80103b40 <myproc>
80104c5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c5d:	8b 40 18             	mov    0x18(%eax),%eax
80104c60:	8b 40 44             	mov    0x44(%eax),%eax
80104c63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c66:	e8 d5 ee ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c6e:	8b 00                	mov    (%eax),%eax
80104c70:	39 c6                	cmp    %eax,%esi
80104c72:	73 1c                	jae    80104c90 <argint+0x40>
80104c74:	8d 53 08             	lea    0x8(%ebx),%edx
80104c77:	39 d0                	cmp    %edx,%eax
80104c79:	72 15                	jb     80104c90 <argint+0x40>
  *ip = *(int*)(addr);
80104c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c81:	89 10                	mov    %edx,(%eax)
  return 0;
80104c83:	31 c0                	xor    %eax,%eax
}
80104c85:	5b                   	pop    %ebx
80104c86:	5e                   	pop    %esi
80104c87:	5d                   	pop    %ebp
80104c88:	c3                   	ret
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c95:	eb ee                	jmp    80104c85 <argint+0x35>
80104c97:	90                   	nop
80104c98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c9f:	00 

80104ca0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	56                   	push   %esi
80104ca5:	53                   	push   %ebx
80104ca6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ca9:	e8 92 ee ff ff       	call   80103b40 <myproc>
80104cae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cb0:	e8 8b ee ff ff       	call   80103b40 <myproc>
80104cb5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cb8:	8b 40 18             	mov    0x18(%eax),%eax
80104cbb:	8b 40 44             	mov    0x44(%eax),%eax
80104cbe:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  struct proc *curproc = myproc();
80104cc1:	e8 7a ee ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cc6:	8d 5f 04             	lea    0x4(%edi),%ebx
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cc9:	8b 00                	mov    (%eax),%eax
80104ccb:	39 c3                	cmp    %eax,%ebx
80104ccd:	73 31                	jae    80104d00 <argptr+0x60>
80104ccf:	8d 57 08             	lea    0x8(%edi),%edx
80104cd2:	39 d0                	cmp    %edx,%eax
80104cd4:	72 2a                	jb     80104d00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cd6:	8b 45 10             	mov    0x10(%ebp),%eax
80104cd9:	85 c0                	test   %eax,%eax
80104cdb:	78 23                	js     80104d00 <argptr+0x60>
  *ip = *(int*)(addr);
80104cdd:	8b 57 04             	mov    0x4(%edi),%edx
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ce0:	8b 0e                	mov    (%esi),%ecx
80104ce2:	39 ca                	cmp    %ecx,%edx
80104ce4:	73 1a                	jae    80104d00 <argptr+0x60>
80104ce6:	8b 45 10             	mov    0x10(%ebp),%eax
80104ce9:	01 d0                	add    %edx,%eax
80104ceb:	39 c1                	cmp    %eax,%ecx
80104ced:	72 11                	jb     80104d00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104cef:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cf2:	89 10                	mov    %edx,(%eax)
  return 0;
80104cf4:	31 c0                	xor    %eax,%eax
}
80104cf6:	83 c4 0c             	add    $0xc,%esp
80104cf9:	5b                   	pop    %ebx
80104cfa:	5e                   	pop    %esi
80104cfb:	5f                   	pop    %edi
80104cfc:	5d                   	pop    %ebp
80104cfd:	c3                   	ret
80104cfe:	66 90                	xchg   %ax,%ax
    return -1;
80104d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d05:	eb ef                	jmp    80104cf6 <argptr+0x56>
80104d07:	90                   	nop
80104d08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d0f:	00 

80104d10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d15:	e8 26 ee ff ff       	call   80103b40 <myproc>
80104d1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d1d:	8b 40 18             	mov    0x18(%eax),%eax
80104d20:	8b 40 44             	mov    0x44(%eax),%eax
80104d23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d26:	e8 15 ee ff ff       	call   80103b40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d2e:	8b 00                	mov    (%eax),%eax
80104d30:	39 c6                	cmp    %eax,%esi
80104d32:	73 44                	jae    80104d78 <argstr+0x68>
80104d34:	8d 53 08             	lea    0x8(%ebx),%edx
80104d37:	39 d0                	cmp    %edx,%eax
80104d39:	72 3d                	jb     80104d78 <argstr+0x68>
  *ip = *(int*)(addr);
80104d3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d3e:	e8 fd ed ff ff       	call   80103b40 <myproc>
  if(addr >= curproc->sz)
80104d43:	3b 18                	cmp    (%eax),%ebx
80104d45:	73 31                	jae    80104d78 <argstr+0x68>
  *pp = (char*)addr;
80104d47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d4e:	39 d3                	cmp    %edx,%ebx
80104d50:	73 26                	jae    80104d78 <argstr+0x68>
80104d52:	89 d8                	mov    %ebx,%eax
80104d54:	eb 11                	jmp    80104d67 <argstr+0x57>
80104d56:	66 90                	xchg   %ax,%ax
80104d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d5f:	00 
80104d60:	83 c0 01             	add    $0x1,%eax
80104d63:	39 d0                	cmp    %edx,%eax
80104d65:	73 11                	jae    80104d78 <argstr+0x68>
    if(*s == 0)
80104d67:	80 38 00             	cmpb   $0x0,(%eax)
80104d6a:	75 f4                	jne    80104d60 <argstr+0x50>
      return s - *pp;
80104d6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d6e:	5b                   	pop    %ebx
80104d6f:	5e                   	pop    %esi
80104d70:	5d                   	pop    %ebp
80104d71:	c3                   	ret
80104d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d78:	5b                   	pop    %ebx
    return -1;
80104d79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d7e:	5e                   	pop    %esi
80104d7f:	5d                   	pop    %ebp
80104d80:	c3                   	ret
80104d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d8f:	00 

80104d90 <syscall>:
[SYS_hello] sys_hello,
};

void
syscall(void)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d97:	e8 a4 ed ff ff       	call   80103b40 <myproc>
80104d9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d9e:	8b 40 18             	mov    0x18(%eax),%eax
80104da1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104da4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104da7:	83 fa 15             	cmp    $0x15,%edx
80104daa:	77 24                	ja     80104dd0 <syscall+0x40>
80104dac:	8b 14 85 80 7e 10 80 	mov    -0x7fef8180(,%eax,4),%edx
80104db3:	85 d2                	test   %edx,%edx
80104db5:	74 19                	je     80104dd0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104db7:	ff d2                	call   *%edx
80104db9:	89 c2                	mov    %eax,%edx
80104dbb:	8b 43 18             	mov    0x18(%ebx),%eax
80104dbe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104dc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc4:	c9                   	leave
80104dc5:	c3                   	ret
80104dc6:	66 90                	xchg   %ax,%ax
80104dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dcf:	00 
    cprintf("%d %s: unknown sys call %d\n",
80104dd0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104dd1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104dd4:	50                   	push   %eax
80104dd5:	ff 73 10             	push   0x10(%ebx)
80104dd8:	68 0d 79 10 80       	push   $0x8010790d
80104ddd:	e8 ee b8 ff ff       	call   801006d0 <cprintf>
    curproc->tf->eax = -1;
80104de2:	8b 43 18             	mov    0x18(%ebx),%eax
80104de5:	83 c4 10             	add    $0x10,%esp
80104de8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104def:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df2:	c9                   	leave
80104df3:	c3                   	ret
80104df4:	66 90                	xchg   %ax,%ax
80104df6:	66 90                	xchg   %ax,%ax
80104df8:	66 90                	xchg   %ax,%ax
80104dfa:	66 90                	xchg   %ax,%ax
80104dfc:	66 90                	xchg   %ax,%ax
80104dfe:	66 90                	xchg   %ax,%ax

80104e00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
80104e05:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e06:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104e09:	83 ec 34             	sub    $0x34,%esp
80104e0c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80104e0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e12:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e15:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e18:	53                   	push   %ebx
80104e19:	50                   	push   %eax
80104e1a:	e8 91 d3 ff ff       	call   801021b0 <nameiparent>
80104e1f:	83 c4 10             	add    $0x10,%esp
80104e22:	85 c0                	test   %eax,%eax
80104e24:	74 5e                	je     80104e84 <create+0x84>
    return 0;
  ilock(dp);
80104e26:	83 ec 0c             	sub    $0xc,%esp
80104e29:	89 c6                	mov    %eax,%esi
80104e2b:	50                   	push   %eax
80104e2c:	e8 3f ca ff ff       	call   80101870 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e31:	83 c4 0c             	add    $0xc,%esp
80104e34:	6a 00                	push   $0x0
80104e36:	53                   	push   %ebx
80104e37:	56                   	push   %esi
80104e38:	e8 93 cf ff ff       	call   80101dd0 <dirlookup>
80104e3d:	83 c4 10             	add    $0x10,%esp
80104e40:	89 c7                	mov    %eax,%edi
80104e42:	85 c0                	test   %eax,%eax
80104e44:	74 4a                	je     80104e90 <create+0x90>
    iunlockput(dp);
80104e46:	83 ec 0c             	sub    $0xc,%esp
80104e49:	56                   	push   %esi
80104e4a:	e8 c1 cc ff ff       	call   80101b10 <iunlockput>
    ilock(ip);
80104e4f:	89 3c 24             	mov    %edi,(%esp)
80104e52:	e8 19 ca ff ff       	call   80101870 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e57:	83 c4 10             	add    $0x10,%esp
80104e5a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e5f:	75 17                	jne    80104e78 <create+0x78>
80104e61:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104e66:	75 10                	jne    80104e78 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e6b:	89 f8                	mov    %edi,%eax
80104e6d:	5b                   	pop    %ebx
80104e6e:	5e                   	pop    %esi
80104e6f:	5f                   	pop    %edi
80104e70:	5d                   	pop    %ebp
80104e71:	c3                   	ret
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e78:	83 ec 0c             	sub    $0xc,%esp
80104e7b:	57                   	push   %edi
80104e7c:	e8 8f cc ff ff       	call   80101b10 <iunlockput>
    return 0;
80104e81:	83 c4 10             	add    $0x10,%esp
}
80104e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e87:	31 ff                	xor    %edi,%edi
}
80104e89:	5b                   	pop    %ebx
80104e8a:	89 f8                	mov    %edi,%eax
80104e8c:	5e                   	pop    %esi
80104e8d:	5f                   	pop    %edi
80104e8e:	5d                   	pop    %ebp
80104e8f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104e90:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e94:	83 ec 08             	sub    $0x8,%esp
80104e97:	50                   	push   %eax
80104e98:	ff 36                	push   (%esi)
80104e9a:	e8 51 c8 ff ff       	call   801016f0 <ialloc>
80104e9f:	83 c4 10             	add    $0x10,%esp
80104ea2:	89 c7                	mov    %eax,%edi
80104ea4:	85 c0                	test   %eax,%eax
80104ea6:	0f 84 af 00 00 00    	je     80104f5b <create+0x15b>
  ilock(ip);
80104eac:	83 ec 0c             	sub    $0xc,%esp
80104eaf:	50                   	push   %eax
80104eb0:	e8 bb c9 ff ff       	call   80101870 <ilock>
  ip->major = major;
80104eb5:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104eb9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104ebd:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ec1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ec5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eca:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104ece:	89 3c 24             	mov    %edi,(%esp)
80104ed1:	e8 da c8 ff ff       	call   801017b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ed6:	83 c4 10             	add    $0x10,%esp
80104ed9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104ede:	74 30                	je     80104f10 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104ee0:	83 ec 04             	sub    $0x4,%esp
80104ee3:	ff 77 04             	push   0x4(%edi)
80104ee6:	53                   	push   %ebx
80104ee7:	56                   	push   %esi
80104ee8:	e8 e3 d1 ff ff       	call   801020d0 <dirlink>
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	78 74                	js     80104f68 <create+0x168>
  iunlockput(dp);
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	56                   	push   %esi
80104ef8:	e8 13 cc ff ff       	call   80101b10 <iunlockput>
  return ip;
80104efd:	83 c4 10             	add    $0x10,%esp
}
80104f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f03:	89 f8                	mov    %edi,%eax
80104f05:	5b                   	pop    %ebx
80104f06:	5e                   	pop    %esi
80104f07:	5f                   	pop    %edi
80104f08:	5d                   	pop    %ebp
80104f09:	c3                   	ret
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f13:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104f18:	56                   	push   %esi
80104f19:	e8 92 c8 ff ff       	call   801017b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f1e:	83 c4 0c             	add    $0xc,%esp
80104f21:	ff 77 04             	push   0x4(%edi)
80104f24:	68 45 79 10 80       	push   $0x80107945
80104f29:	57                   	push   %edi
80104f2a:	e8 a1 d1 ff ff       	call   801020d0 <dirlink>
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	85 c0                	test   %eax,%eax
80104f34:	78 18                	js     80104f4e <create+0x14e>
80104f36:	83 ec 04             	sub    $0x4,%esp
80104f39:	ff 76 04             	push   0x4(%esi)
80104f3c:	68 44 79 10 80       	push   $0x80107944
80104f41:	57                   	push   %edi
80104f42:	e8 89 d1 ff ff       	call   801020d0 <dirlink>
80104f47:	83 c4 10             	add    $0x10,%esp
80104f4a:	85 c0                	test   %eax,%eax
80104f4c:	79 92                	jns    80104ee0 <create+0xe0>
      panic("create dots");
80104f4e:	83 ec 0c             	sub    $0xc,%esp
80104f51:	68 38 79 10 80       	push   $0x80107938
80104f56:	e8 45 b4 ff ff       	call   801003a0 <panic>
    panic("create: ialloc");
80104f5b:	83 ec 0c             	sub    $0xc,%esp
80104f5e:	68 29 79 10 80       	push   $0x80107929
80104f63:	e8 38 b4 ff ff       	call   801003a0 <panic>
    panic("create: dirlink");
80104f68:	83 ec 0c             	sub    $0xc,%esp
80104f6b:	68 47 79 10 80       	push   $0x80107947
80104f70:	e8 2b b4 ff ff       	call   801003a0 <panic>
80104f75:	8d 76 00             	lea    0x0(%esi),%esi
80104f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f7f:	00 

80104f80 <sys_dup>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f8b:	50                   	push   %eax
80104f8c:	6a 00                	push   $0x0
80104f8e:	e8 bd fc ff ff       	call   80104c50 <argint>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	78 36                	js     80104fd0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f9e:	77 30                	ja     80104fd0 <sys_dup+0x50>
80104fa0:	e8 9b eb ff ff       	call   80103b40 <myproc>
80104fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fa8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fac:	85 f6                	test   %esi,%esi
80104fae:	74 20                	je     80104fd0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104fb0:	e8 8b eb ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104fb5:	31 db                	xor    %ebx,%ebx
80104fb7:	90                   	nop
80104fb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fbf:	00 
    if(curproc->ofile[fd] == 0){
80104fc0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fc4:	85 d2                	test   %edx,%edx
80104fc6:	74 18                	je     80104fe0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104fc8:	83 c3 01             	add    $0x1,%ebx
80104fcb:	83 fb 10             	cmp    $0x10,%ebx
80104fce:	75 f0                	jne    80104fc0 <sys_dup+0x40>
    return -1;
80104fd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104fd5:	eb 19                	jmp    80104ff0 <sys_dup+0x70>
80104fd7:	90                   	nop
80104fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fdf:	00 
  filedup(f);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104fe3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fe7:	56                   	push   %esi
80104fe8:	e8 43 bf ff ff       	call   80100f30 <filedup>
  return fd;
80104fed:	83 c4 10             	add    $0x10,%esp
}
80104ff0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff3:	89 d8                	mov    %ebx,%eax
80104ff5:	5b                   	pop    %ebx
80104ff6:	5e                   	pop    %esi
80104ff7:	5d                   	pop    %ebp
80104ff8:	c3                   	ret
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105000 <sys_read>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105005:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105008:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010500b:	53                   	push   %ebx
8010500c:	6a 00                	push   $0x0
8010500e:	e8 3d fc ff ff       	call   80104c50 <argint>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	78 5e                	js     80105078 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010501a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010501e:	77 58                	ja     80105078 <sys_read+0x78>
80105020:	e8 1b eb ff ff       	call   80103b40 <myproc>
80105025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105028:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010502c:	85 f6                	test   %esi,%esi
8010502e:	74 48                	je     80105078 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105030:	83 ec 08             	sub    $0x8,%esp
80105033:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105036:	50                   	push   %eax
80105037:	6a 02                	push   $0x2
80105039:	e8 12 fc ff ff       	call   80104c50 <argint>
8010503e:	83 c4 10             	add    $0x10,%esp
80105041:	85 c0                	test   %eax,%eax
80105043:	78 33                	js     80105078 <sys_read+0x78>
80105045:	83 ec 04             	sub    $0x4,%esp
80105048:	ff 75 f0             	push   -0x10(%ebp)
8010504b:	53                   	push   %ebx
8010504c:	6a 01                	push   $0x1
8010504e:	e8 4d fc ff ff       	call   80104ca0 <argptr>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	78 1e                	js     80105078 <sys_read+0x78>
  return fileread(f, p, n);
8010505a:	83 ec 04             	sub    $0x4,%esp
8010505d:	ff 75 f0             	push   -0x10(%ebp)
80105060:	ff 75 f4             	push   -0xc(%ebp)
80105063:	56                   	push   %esi
80105064:	e8 47 c0 ff ff       	call   801010b0 <fileread>
80105069:	83 c4 10             	add    $0x10,%esp
}
8010506c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010506f:	5b                   	pop    %ebx
80105070:	5e                   	pop    %esi
80105071:	5d                   	pop    %ebp
80105072:	c3                   	ret
80105073:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507d:	eb ed                	jmp    8010506c <sys_read+0x6c>
8010507f:	90                   	nop

80105080 <sys_write>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105085:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105088:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010508b:	53                   	push   %ebx
8010508c:	6a 00                	push   $0x0
8010508e:	e8 bd fb ff ff       	call   80104c50 <argint>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	78 5e                	js     801050f8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010509a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010509e:	77 58                	ja     801050f8 <sys_write+0x78>
801050a0:	e8 9b ea ff ff       	call   80103b40 <myproc>
801050a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050ac:	85 f6                	test   %esi,%esi
801050ae:	74 48                	je     801050f8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050b0:	83 ec 08             	sub    $0x8,%esp
801050b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b6:	50                   	push   %eax
801050b7:	6a 02                	push   $0x2
801050b9:	e8 92 fb ff ff       	call   80104c50 <argint>
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	85 c0                	test   %eax,%eax
801050c3:	78 33                	js     801050f8 <sys_write+0x78>
801050c5:	83 ec 04             	sub    $0x4,%esp
801050c8:	ff 75 f0             	push   -0x10(%ebp)
801050cb:	53                   	push   %ebx
801050cc:	6a 01                	push   $0x1
801050ce:	e8 cd fb ff ff       	call   80104ca0 <argptr>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	78 1e                	js     801050f8 <sys_write+0x78>
  return filewrite(f, p, n);
801050da:	83 ec 04             	sub    $0x4,%esp
801050dd:	ff 75 f0             	push   -0x10(%ebp)
801050e0:	ff 75 f4             	push   -0xc(%ebp)
801050e3:	56                   	push   %esi
801050e4:	e8 57 c0 ff ff       	call   80101140 <filewrite>
801050e9:	83 c4 10             	add    $0x10,%esp
}
801050ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ef:	5b                   	pop    %ebx
801050f0:	5e                   	pop    %esi
801050f1:	5d                   	pop    %ebp
801050f2:	c3                   	ret
801050f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fd:	eb ed                	jmp    801050ec <sys_write+0x6c>
801050ff:	90                   	nop

80105100 <sys_close>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105105:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105108:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010510b:	50                   	push   %eax
8010510c:	6a 00                	push   $0x0
8010510e:	e8 3d fb ff ff       	call   80104c50 <argint>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 3e                	js     80105158 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010511a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010511e:	77 38                	ja     80105158 <sys_close+0x58>
80105120:	e8 1b ea ff ff       	call   80103b40 <myproc>
80105125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105128:	8d 5a 08             	lea    0x8(%edx),%ebx
8010512b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010512f:	85 f6                	test   %esi,%esi
80105131:	74 25                	je     80105158 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105133:	e8 08 ea ff ff       	call   80103b40 <myproc>
  fileclose(f);
80105138:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010513b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105142:	00 
  fileclose(f);
80105143:	56                   	push   %esi
80105144:	e8 37 be ff ff       	call   80100f80 <fileclose>
  return 0;
80105149:	83 c4 10             	add    $0x10,%esp
8010514c:	31 c0                	xor    %eax,%eax
}
8010514e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105151:	5b                   	pop    %ebx
80105152:	5e                   	pop    %esi
80105153:	5d                   	pop    %ebp
80105154:	c3                   	ret
80105155:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515d:	eb ef                	jmp    8010514e <sys_close+0x4e>
8010515f:	90                   	nop

80105160 <sys_fstat>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105165:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105168:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010516b:	53                   	push   %ebx
8010516c:	6a 00                	push   $0x0
8010516e:	e8 dd fa ff ff       	call   80104c50 <argint>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	78 46                	js     801051c0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010517a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010517e:	77 40                	ja     801051c0 <sys_fstat+0x60>
80105180:	e8 bb e9 ff ff       	call   80103b40 <myproc>
80105185:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105188:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010518c:	85 f6                	test   %esi,%esi
8010518e:	74 30                	je     801051c0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105190:	83 ec 04             	sub    $0x4,%esp
80105193:	6a 14                	push   $0x14
80105195:	53                   	push   %ebx
80105196:	6a 01                	push   $0x1
80105198:	e8 03 fb ff ff       	call   80104ca0 <argptr>
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	85 c0                	test   %eax,%eax
801051a2:	78 1c                	js     801051c0 <sys_fstat+0x60>
  return filestat(f, st);
801051a4:	83 ec 08             	sub    $0x8,%esp
801051a7:	ff 75 f4             	push   -0xc(%ebp)
801051aa:	56                   	push   %esi
801051ab:	e8 b0 be ff ff       	call   80101060 <filestat>
801051b0:	83 c4 10             	add    $0x10,%esp
}
801051b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051b6:	5b                   	pop    %ebx
801051b7:	5e                   	pop    %esi
801051b8:	5d                   	pop    %ebp
801051b9:	c3                   	ret
801051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c5:	eb ec                	jmp    801051b3 <sys_fstat+0x53>
801051c7:	90                   	nop
801051c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051cf:	00 

801051d0 <sys_link>:
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051d5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051d8:	53                   	push   %ebx
801051d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051dc:	50                   	push   %eax
801051dd:	6a 00                	push   $0x0
801051df:	e8 2c fb ff ff       	call   80104d10 <argstr>
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	85 c0                	test   %eax,%eax
801051e9:	0f 88 fb 00 00 00    	js     801052ea <sys_link+0x11a>
801051ef:	83 ec 08             	sub    $0x8,%esp
801051f2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051f5:	50                   	push   %eax
801051f6:	6a 01                	push   $0x1
801051f8:	e8 13 fb ff ff       	call   80104d10 <argstr>
801051fd:	83 c4 10             	add    $0x10,%esp
80105200:	85 c0                	test   %eax,%eax
80105202:	0f 88 e2 00 00 00    	js     801052ea <sys_link+0x11a>
  begin_op();
80105208:	e8 d3 dc ff ff       	call   80102ee0 <begin_op>
  if((ip = namei(old)) == 0){
8010520d:	83 ec 0c             	sub    $0xc,%esp
80105210:	ff 75 d4             	push   -0x2c(%ebp)
80105213:	e8 78 cf ff ff       	call   80102190 <namei>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	89 c3                	mov    %eax,%ebx
8010521d:	85 c0                	test   %eax,%eax
8010521f:	0f 84 df 00 00 00    	je     80105304 <sys_link+0x134>
  ilock(ip);
80105225:	83 ec 0c             	sub    $0xc,%esp
80105228:	50                   	push   %eax
80105229:	e8 42 c6 ff ff       	call   80101870 <ilock>
  if(ip->type == T_DIR){
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105236:	0f 84 b5 00 00 00    	je     801052f1 <sys_link+0x121>
  iupdate(ip);
8010523c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010523f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105244:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105247:	53                   	push   %ebx
80105248:	e8 63 c5 ff ff       	call   801017b0 <iupdate>
  iunlock(ip);
8010524d:	89 1c 24             	mov    %ebx,(%esp)
80105250:	e8 fb c6 ff ff       	call   80101950 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105255:	58                   	pop    %eax
80105256:	5a                   	pop    %edx
80105257:	57                   	push   %edi
80105258:	ff 75 d0             	push   -0x30(%ebp)
8010525b:	e8 50 cf ff ff       	call   801021b0 <nameiparent>
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	89 c6                	mov    %eax,%esi
80105265:	85 c0                	test   %eax,%eax
80105267:	74 5b                	je     801052c4 <sys_link+0xf4>
  ilock(dp);
80105269:	83 ec 0c             	sub    $0xc,%esp
8010526c:	50                   	push   %eax
8010526d:	e8 fe c5 ff ff       	call   80101870 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105272:	8b 03                	mov    (%ebx),%eax
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	39 06                	cmp    %eax,(%esi)
80105279:	75 3d                	jne    801052b8 <sys_link+0xe8>
8010527b:	83 ec 04             	sub    $0x4,%esp
8010527e:	ff 73 04             	push   0x4(%ebx)
80105281:	57                   	push   %edi
80105282:	56                   	push   %esi
80105283:	e8 48 ce ff ff       	call   801020d0 <dirlink>
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	85 c0                	test   %eax,%eax
8010528d:	78 29                	js     801052b8 <sys_link+0xe8>
  iunlockput(dp);
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	56                   	push   %esi
80105293:	e8 78 c8 ff ff       	call   80101b10 <iunlockput>
  iput(ip);
80105298:	89 1c 24             	mov    %ebx,(%esp)
8010529b:	e8 00 c7 ff ff       	call   801019a0 <iput>
  end_op();
801052a0:	e8 ab dc ff ff       	call   80102f50 <end_op>
  return 0;
801052a5:	83 c4 10             	add    $0x10,%esp
801052a8:	31 c0                	xor    %eax,%eax
}
801052aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ad:	5b                   	pop    %ebx
801052ae:	5e                   	pop    %esi
801052af:	5f                   	pop    %edi
801052b0:	5d                   	pop    %ebp
801052b1:	c3                   	ret
801052b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052b8:	83 ec 0c             	sub    $0xc,%esp
801052bb:	56                   	push   %esi
801052bc:	e8 4f c8 ff ff       	call   80101b10 <iunlockput>
    goto bad;
801052c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052c4:	83 ec 0c             	sub    $0xc,%esp
801052c7:	53                   	push   %ebx
801052c8:	e8 a3 c5 ff ff       	call   80101870 <ilock>
  ip->nlink--;
801052cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052d2:	89 1c 24             	mov    %ebx,(%esp)
801052d5:	e8 d6 c4 ff ff       	call   801017b0 <iupdate>
  iunlockput(ip);
801052da:	89 1c 24             	mov    %ebx,(%esp)
801052dd:	e8 2e c8 ff ff       	call   80101b10 <iunlockput>
  end_op();
801052e2:	e8 69 dc ff ff       	call   80102f50 <end_op>
  return -1;
801052e7:	83 c4 10             	add    $0x10,%esp
    return -1;
801052ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ef:	eb b9                	jmp    801052aa <sys_link+0xda>
    iunlockput(ip);
801052f1:	83 ec 0c             	sub    $0xc,%esp
801052f4:	53                   	push   %ebx
801052f5:	e8 16 c8 ff ff       	call   80101b10 <iunlockput>
    end_op();
801052fa:	e8 51 dc ff ff       	call   80102f50 <end_op>
    return -1;
801052ff:	83 c4 10             	add    $0x10,%esp
80105302:	eb e6                	jmp    801052ea <sys_link+0x11a>
    end_op();
80105304:	e8 47 dc ff ff       	call   80102f50 <end_op>
    return -1;
80105309:	eb df                	jmp    801052ea <sys_link+0x11a>
8010530b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105310 <sys_unlink>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105315:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105318:	53                   	push   %ebx
80105319:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010531c:	50                   	push   %eax
8010531d:	6a 00                	push   $0x0
8010531f:	e8 ec f9 ff ff       	call   80104d10 <argstr>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	0f 88 54 01 00 00    	js     80105483 <sys_unlink+0x173>
  begin_op();
8010532f:	e8 ac db ff ff       	call   80102ee0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105334:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105337:	83 ec 08             	sub    $0x8,%esp
8010533a:	53                   	push   %ebx
8010533b:	ff 75 c0             	push   -0x40(%ebp)
8010533e:	e8 6d ce ff ff       	call   801021b0 <nameiparent>
80105343:	83 c4 10             	add    $0x10,%esp
80105346:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105349:	85 c0                	test   %eax,%eax
8010534b:	0f 84 58 01 00 00    	je     801054a9 <sys_unlink+0x199>
  ilock(dp);
80105351:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	57                   	push   %edi
80105358:	e8 13 c5 ff ff       	call   80101870 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010535d:	58                   	pop    %eax
8010535e:	5a                   	pop    %edx
8010535f:	68 45 79 10 80       	push   $0x80107945
80105364:	53                   	push   %ebx
80105365:	e8 46 ca ff ff       	call   80101db0 <namecmp>
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	85 c0                	test   %eax,%eax
8010536f:	0f 84 fb 00 00 00    	je     80105470 <sys_unlink+0x160>
80105375:	83 ec 08             	sub    $0x8,%esp
80105378:	68 44 79 10 80       	push   $0x80107944
8010537d:	53                   	push   %ebx
8010537e:	e8 2d ca ff ff       	call   80101db0 <namecmp>
80105383:	83 c4 10             	add    $0x10,%esp
80105386:	85 c0                	test   %eax,%eax
80105388:	0f 84 e2 00 00 00    	je     80105470 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010538e:	83 ec 04             	sub    $0x4,%esp
80105391:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105394:	50                   	push   %eax
80105395:	53                   	push   %ebx
80105396:	57                   	push   %edi
80105397:	e8 34 ca ff ff       	call   80101dd0 <dirlookup>
8010539c:	83 c4 10             	add    $0x10,%esp
8010539f:	89 c3                	mov    %eax,%ebx
801053a1:	85 c0                	test   %eax,%eax
801053a3:	0f 84 c7 00 00 00    	je     80105470 <sys_unlink+0x160>
  ilock(ip);
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	50                   	push   %eax
801053ad:	e8 be c4 ff ff       	call   80101870 <ilock>
  if(ip->nlink < 1)
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053ba:	0f 8e fd 00 00 00    	jle    801054bd <sys_unlink+0x1ad>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053c0:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053c3:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053c8:	74 66                	je     80105430 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053ca:	83 ec 04             	sub    $0x4,%esp
801053cd:	6a 10                	push   $0x10
801053cf:	6a 00                	push   $0x0
801053d1:	57                   	push   %edi
801053d2:	e8 a9 f5 ff ff       	call   80104980 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053d7:	6a 10                	push   $0x10
801053d9:	ff 75 c4             	push   -0x3c(%ebp)
801053dc:	57                   	push   %edi
801053dd:	ff 75 b4             	push   -0x4c(%ebp)
801053e0:	e8 ab c8 ff ff       	call   80101c90 <writei>
801053e5:	83 c4 20             	add    $0x20,%esp
801053e8:	83 f8 10             	cmp    $0x10,%eax
801053eb:	0f 85 d9 00 00 00    	jne    801054ca <sys_unlink+0x1ba>
  if(ip->type == T_DIR){
801053f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053f6:	0f 84 94 00 00 00    	je     80105490 <sys_unlink+0x180>
  iunlockput(dp);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	ff 75 b4             	push   -0x4c(%ebp)
80105402:	e8 09 c7 ff ff       	call   80101b10 <iunlockput>
  ip->nlink--;
80105407:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010540c:	89 1c 24             	mov    %ebx,(%esp)
8010540f:	e8 9c c3 ff ff       	call   801017b0 <iupdate>
  iunlockput(ip);
80105414:	89 1c 24             	mov    %ebx,(%esp)
80105417:	e8 f4 c6 ff ff       	call   80101b10 <iunlockput>
  end_op();
8010541c:	e8 2f db ff ff       	call   80102f50 <end_op>
  return 0;
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	31 c0                	xor    %eax,%eax
}
80105426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105429:	5b                   	pop    %ebx
8010542a:	5e                   	pop    %esi
8010542b:	5f                   	pop    %edi
8010542c:	5d                   	pop    %ebp
8010542d:	c3                   	ret
8010542e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105430:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105434:	76 94                	jbe    801053ca <sys_unlink+0xba>
80105436:	be 20 00 00 00       	mov    $0x20,%esi
8010543b:	eb 0b                	jmp    80105448 <sys_unlink+0x138>
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
80105440:	83 c6 10             	add    $0x10,%esi
80105443:	3b 73 58             	cmp    0x58(%ebx),%esi
80105446:	73 82                	jae    801053ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105448:	6a 10                	push   $0x10
8010544a:	56                   	push   %esi
8010544b:	57                   	push   %edi
8010544c:	53                   	push   %ebx
8010544d:	e8 3e c7 ff ff       	call   80101b90 <readi>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	83 f8 10             	cmp    $0x10,%eax
80105458:	75 56                	jne    801054b0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010545a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010545f:	74 df                	je     80105440 <sys_unlink+0x130>
    iunlockput(ip);
80105461:	83 ec 0c             	sub    $0xc,%esp
80105464:	53                   	push   %ebx
80105465:	e8 a6 c6 ff ff       	call   80101b10 <iunlockput>
    goto bad;
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	ff 75 b4             	push   -0x4c(%ebp)
80105476:	e8 95 c6 ff ff       	call   80101b10 <iunlockput>
  end_op();
8010547b:	e8 d0 da ff ff       	call   80102f50 <end_op>
  return -1;
80105480:	83 c4 10             	add    $0x10,%esp
    return -1;
80105483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105488:	eb 9c                	jmp    80105426 <sys_unlink+0x116>
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105490:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105493:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105496:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010549b:	50                   	push   %eax
8010549c:	e8 0f c3 ff ff       	call   801017b0 <iupdate>
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	e9 53 ff ff ff       	jmp    801053fc <sys_unlink+0xec>
    end_op();
801054a9:	e8 a2 da ff ff       	call   80102f50 <end_op>
    return -1;
801054ae:	eb d3                	jmp    80105483 <sys_unlink+0x173>
      panic("isdirempty: readi");
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	68 69 79 10 80       	push   $0x80107969
801054b8:	e8 e3 ae ff ff       	call   801003a0 <panic>
    panic("unlink: nlink < 1");
801054bd:	83 ec 0c             	sub    $0xc,%esp
801054c0:	68 57 79 10 80       	push   $0x80107957
801054c5:	e8 d6 ae ff ff       	call   801003a0 <panic>
    panic("unlink: writei");
801054ca:	83 ec 0c             	sub    $0xc,%esp
801054cd:	68 7b 79 10 80       	push   $0x8010797b
801054d2:	e8 c9 ae ff ff       	call   801003a0 <panic>
801054d7:	90                   	nop
801054d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054df:	00 

801054e0 <sys_open>:

int
sys_open(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054e8:	53                   	push   %ebx
801054e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ec:	50                   	push   %eax
801054ed:	6a 00                	push   $0x0
801054ef:	e8 1c f8 ff ff       	call   80104d10 <argstr>
801054f4:	83 c4 10             	add    $0x10,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	0f 88 8e 00 00 00    	js     8010558d <sys_open+0xad>
801054ff:	83 ec 08             	sub    $0x8,%esp
80105502:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105505:	50                   	push   %eax
80105506:	6a 01                	push   $0x1
80105508:	e8 43 f7 ff ff       	call   80104c50 <argint>
8010550d:	83 c4 10             	add    $0x10,%esp
80105510:	85 c0                	test   %eax,%eax
80105512:	78 79                	js     8010558d <sys_open+0xad>
    return -1;

  begin_op();
80105514:	e8 c7 d9 ff ff       	call   80102ee0 <begin_op>

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(omode & O_CREATE){
8010551c:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105520:	75 76                	jne    80105598 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105522:	83 ec 0c             	sub    $0xc,%esp
80105525:	50                   	push   %eax
80105526:	e8 65 cc ff ff       	call   80102190 <namei>
8010552b:	83 c4 10             	add    $0x10,%esp
8010552e:	89 c7                	mov    %eax,%edi
80105530:	85 c0                	test   %eax,%eax
80105532:	74 7e                	je     801055b2 <sys_open+0xd2>
      end_op();
      return -1;
    }
    ilock(ip);
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	50                   	push   %eax
80105538:	e8 33 c3 ff ff       	call   80101870 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80105545:	0f 84 bd 00 00 00    	je     80105608 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010554b:	e8 70 b9 ff ff       	call   80100ec0 <filealloc>
80105550:	89 c6                	mov    %eax,%esi
80105552:	85 c0                	test   %eax,%eax
80105554:	74 26                	je     8010557c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105556:	e8 e5 e5 ff ff       	call   80103b40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010555b:	31 db                	xor    %ebx,%ebx
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105560:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105564:	85 d2                	test   %edx,%edx
80105566:	74 58                	je     801055c0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105568:	83 c3 01             	add    $0x1,%ebx
8010556b:	83 fb 10             	cmp    $0x10,%ebx
8010556e:	75 f0                	jne    80105560 <sys_open+0x80>
    if(f)
      fileclose(f);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	56                   	push   %esi
80105574:	e8 07 ba ff ff       	call   80100f80 <fileclose>
80105579:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	57                   	push   %edi
80105580:	e8 8b c5 ff ff       	call   80101b10 <iunlockput>
    end_op();
80105585:	e8 c6 d9 ff ff       	call   80102f50 <end_op>
    return -1;
8010558a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010558d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105592:	eb 65                	jmp    801055f9 <sys_open+0x119>
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105598:	83 ec 0c             	sub    $0xc,%esp
8010559b:	31 c9                	xor    %ecx,%ecx
8010559d:	ba 02 00 00 00       	mov    $0x2,%edx
801055a2:	6a 00                	push   $0x0
801055a4:	e8 57 f8 ff ff       	call   80104e00 <create>
    if(ip == 0){
801055a9:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055ac:	89 c7                	mov    %eax,%edi
    if(ip == 0){
801055ae:	85 c0                	test   %eax,%eax
801055b0:	75 99                	jne    8010554b <sys_open+0x6b>
      end_op();
801055b2:	e8 99 d9 ff ff       	call   80102f50 <end_op>
      return -1;
801055b7:	eb d4                	jmp    8010558d <sys_open+0xad>
801055b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055c3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055c7:	57                   	push   %edi
801055c8:	e8 83 c3 ff ff       	call   80101950 <iunlock>
  end_op();
801055cd:	e8 7e d9 ff ff       	call   80102f50 <end_op>

  f->type = FD_INODE;
801055d2:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055db:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055de:	89 7e 10             	mov    %edi,0x10(%esi)
  f->readable = !(omode & O_WRONLY);
801055e1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055e3:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
801055ea:	f7 d0                	not    %eax
801055ec:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055ef:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055f2:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055f5:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
801055f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055fc:	89 d8                	mov    %ebx,%eax
801055fe:	5b                   	pop    %ebx
801055ff:	5e                   	pop    %esi
80105600:	5f                   	pop    %edi
80105601:	5d                   	pop    %ebp
80105602:	c3                   	ret
80105603:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105608:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010560b:	85 c9                	test   %ecx,%ecx
8010560d:	0f 84 38 ff ff ff    	je     8010554b <sys_open+0x6b>
80105613:	e9 64 ff ff ff       	jmp    8010557c <sys_open+0x9c>
80105618:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010561f:	00 

80105620 <sys_mkdir>:

int
sys_mkdir(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105626:	e8 b5 d8 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010562b:	83 ec 08             	sub    $0x8,%esp
8010562e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105631:	50                   	push   %eax
80105632:	6a 00                	push   $0x0
80105634:	e8 d7 f6 ff ff       	call   80104d10 <argstr>
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	85 c0                	test   %eax,%eax
8010563e:	78 30                	js     80105670 <sys_mkdir+0x50>
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105646:	31 c9                	xor    %ecx,%ecx
80105648:	ba 01 00 00 00       	mov    $0x1,%edx
8010564d:	6a 00                	push   $0x0
8010564f:	e8 ac f7 ff ff       	call   80104e00 <create>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	74 15                	je     80105670 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010565b:	83 ec 0c             	sub    $0xc,%esp
8010565e:	50                   	push   %eax
8010565f:	e8 ac c4 ff ff       	call   80101b10 <iunlockput>
  end_op();
80105664:	e8 e7 d8 ff ff       	call   80102f50 <end_op>
  return 0;
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	31 c0                	xor    %eax,%eax
}
8010566e:	c9                   	leave
8010566f:	c3                   	ret
    end_op();
80105670:	e8 db d8 ff ff       	call   80102f50 <end_op>
    return -1;
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010567a:	c9                   	leave
8010567b:	c3                   	ret
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_mknod>:

int
sys_mknod(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105686:	e8 55 d8 ff ff       	call   80102ee0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010568b:	83 ec 08             	sub    $0x8,%esp
8010568e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105691:	50                   	push   %eax
80105692:	6a 00                	push   $0x0
80105694:	e8 77 f6 ff ff       	call   80104d10 <argstr>
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	85 c0                	test   %eax,%eax
8010569e:	78 60                	js     80105700 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056a6:	50                   	push   %eax
801056a7:	6a 01                	push   $0x1
801056a9:	e8 a2 f5 ff ff       	call   80104c50 <argint>
  if((argstr(0, &path)) < 0 ||
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	85 c0                	test   %eax,%eax
801056b3:	78 4b                	js     80105700 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056b5:	83 ec 08             	sub    $0x8,%esp
801056b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056bb:	50                   	push   %eax
801056bc:	6a 02                	push   $0x2
801056be:	e8 8d f5 ff ff       	call   80104c50 <argint>
     argint(1, &major) < 0 ||
801056c3:	83 c4 10             	add    $0x10,%esp
801056c6:	85 c0                	test   %eax,%eax
801056c8:	78 36                	js     80105700 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801056ce:	83 ec 0c             	sub    $0xc,%esp
801056d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056d5:	ba 03 00 00 00       	mov    $0x3,%edx
801056da:	50                   	push   %eax
801056db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056de:	e8 1d f7 ff ff       	call   80104e00 <create>
     argint(2, &minor) < 0 ||
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	74 16                	je     80105700 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ea:	83 ec 0c             	sub    $0xc,%esp
801056ed:	50                   	push   %eax
801056ee:	e8 1d c4 ff ff       	call   80101b10 <iunlockput>
  end_op();
801056f3:	e8 58 d8 ff ff       	call   80102f50 <end_op>
  return 0;
801056f8:	83 c4 10             	add    $0x10,%esp
801056fb:	31 c0                	xor    %eax,%eax
}
801056fd:	c9                   	leave
801056fe:	c3                   	ret
801056ff:	90                   	nop
    end_op();
80105700:	e8 4b d8 ff ff       	call   80102f50 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010570a:	c9                   	leave
8010570b:	c3                   	ret
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_chdir>:

int
sys_chdir(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	56                   	push   %esi
80105714:	53                   	push   %ebx
80105715:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105718:	e8 23 e4 ff ff       	call   80103b40 <myproc>
8010571d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010571f:	e8 bc d7 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105724:	83 ec 08             	sub    $0x8,%esp
80105727:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010572a:	50                   	push   %eax
8010572b:	6a 00                	push   $0x0
8010572d:	e8 de f5 ff ff       	call   80104d10 <argstr>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	78 77                	js     801057b0 <sys_chdir+0xa0>
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	ff 75 f4             	push   -0xc(%ebp)
8010573f:	e8 4c ca ff ff       	call   80102190 <namei>
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	89 c3                	mov    %eax,%ebx
80105749:	85 c0                	test   %eax,%eax
8010574b:	74 63                	je     801057b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010574d:	83 ec 0c             	sub    $0xc,%esp
80105750:	50                   	push   %eax
80105751:	e8 1a c1 ff ff       	call   80101870 <ilock>
  if(ip->type != T_DIR){
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010575e:	75 30                	jne    80105790 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 e7 c1 ff ff       	call   80101950 <iunlock>
  iput(curproc->cwd);
80105769:	58                   	pop    %eax
8010576a:	ff 76 68             	push   0x68(%esi)
8010576d:	e8 2e c2 ff ff       	call   801019a0 <iput>
  end_op();
80105772:	e8 d9 d7 ff ff       	call   80102f50 <end_op>
  curproc->cwd = ip;
80105777:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	31 c0                	xor    %eax,%eax
}
8010577f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105782:	5b                   	pop    %ebx
80105783:	5e                   	pop    %esi
80105784:	5d                   	pop    %ebp
80105785:	c3                   	ret
80105786:	66 90                	xchg   %ax,%ax
80105788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010578f:	00 
    iunlockput(ip);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	53                   	push   %ebx
80105794:	e8 77 c3 ff ff       	call   80101b10 <iunlockput>
    end_op();
80105799:	e8 b2 d7 ff ff       	call   80102f50 <end_op>
    return -1;
8010579e:	83 c4 10             	add    $0x10,%esp
    return -1;
801057a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a6:	eb d7                	jmp    8010577f <sys_chdir+0x6f>
801057a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057af:	00 
    end_op();
801057b0:	e8 9b d7 ff ff       	call   80102f50 <end_op>
    return -1;
801057b5:	eb ea                	jmp    801057a1 <sys_chdir+0x91>
801057b7:	90                   	nop
801057b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057bf:	00 

801057c0 <sys_exec>:

int
sys_exec(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057cb:	53                   	push   %ebx
801057cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057d2:	50                   	push   %eax
801057d3:	6a 00                	push   $0x0
801057d5:	e8 36 f5 ff ff       	call   80104d10 <argstr>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	0f 88 85 00 00 00    	js     8010586a <sys_exec+0xaa>
801057e5:	83 ec 08             	sub    $0x8,%esp
801057e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057ee:	50                   	push   %eax
801057ef:	6a 01                	push   $0x1
801057f1:	e8 5a f4 ff ff       	call   80104c50 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	78 6d                	js     8010586a <sys_exec+0xaa>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057fd:	83 ec 04             	sub    $0x4,%esp
80105800:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105806:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105808:	68 80 00 00 00       	push   $0x80
8010580d:	6a 00                	push   $0x0
8010580f:	56                   	push   %esi
80105810:	e8 6b f1 ff ff       	call   80104980 <memset>
80105815:	83 c4 10             	add    $0x10,%esp
80105818:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010581f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105829:	50                   	push   %eax
8010582a:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
80105831:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
80105837:	50                   	push   %eax
80105838:	e8 73 f3 ff ff       	call   80104bb0 <fetchint>
8010583d:	83 c4 10             	add    $0x10,%esp
80105840:	85 c0                	test   %eax,%eax
80105842:	78 26                	js     8010586a <sys_exec+0xaa>
      return -1;
    if(uarg == 0){
80105844:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010584a:	85 c0                	test   %eax,%eax
8010584c:	74 32                	je     80105880 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010584e:	83 ec 08             	sub    $0x8,%esp
80105851:	8d 14 9e             	lea    (%esi,%ebx,4),%edx
80105854:	52                   	push   %edx
80105855:	50                   	push   %eax
80105856:	e8 95 f3 ff ff       	call   80104bf0 <fetchstr>
8010585b:	83 c4 10             	add    $0x10,%esp
8010585e:	85 c0                	test   %eax,%eax
80105860:	78 08                	js     8010586a <sys_exec+0xaa>
  for(i=0;; i++){
80105862:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105865:	83 fb 20             	cmp    $0x20,%ebx
80105868:	75 b6                	jne    80105820 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010586a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010586d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105872:	5b                   	pop    %ebx
80105873:	5e                   	pop    %esi
80105874:	5f                   	pop    %edi
80105875:	5d                   	pop    %ebp
80105876:	c3                   	ret
80105877:	90                   	nop
80105878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010587f:	00 
      argv[i] = 0;
80105880:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105887:	00 00 00 00 
  return exec(path, argv);
8010588b:	83 ec 08             	sub    $0x8,%esp
8010588e:	56                   	push   %esi
8010588f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105895:	e8 76 b2 ff ff       	call   80100b10 <exec>
8010589a:	83 c4 10             	add    $0x10,%esp
}
8010589d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058a0:	5b                   	pop    %ebx
801058a1:	5e                   	pop    %esi
801058a2:	5f                   	pop    %edi
801058a3:	5d                   	pop    %ebp
801058a4:	c3                   	ret
801058a5:	8d 76 00             	lea    0x0(%esi),%esi
801058a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058af:	00 

801058b0 <sys_pipe>:

int
sys_pipe(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058b8:	53                   	push   %ebx
801058b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058bc:	6a 08                	push   $0x8
801058be:	50                   	push   %eax
801058bf:	6a 00                	push   $0x0
801058c1:	e8 da f3 ff ff       	call   80104ca0 <argptr>
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	85 c0                	test   %eax,%eax
801058cb:	0f 88 93 00 00 00    	js     80105964 <sys_pipe+0xb4>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058d1:	83 ec 08             	sub    $0x8,%esp
801058d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058d7:	50                   	push   %eax
801058d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058db:	50                   	push   %eax
801058dc:	e8 9f dc ff ff       	call   80103580 <pipealloc>
801058e1:	83 c4 10             	add    $0x10,%esp
801058e4:	85 c0                	test   %eax,%eax
801058e6:	78 7c                	js     80105964 <sys_pipe+0xb4>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058eb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058ed:	e8 4e e2 ff ff       	call   80103b40 <myproc>
    if(curproc->ofile[fd] == 0){
801058f2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058f6:	85 f6                	test   %esi,%esi
801058f8:	74 16                	je     80105910 <sys_pipe+0x60>
801058fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105900:	83 c3 01             	add    $0x1,%ebx
80105903:	83 fb 10             	cmp    $0x10,%ebx
80105906:	74 45                	je     8010594d <sys_pipe+0x9d>
    if(curproc->ofile[fd] == 0){
80105908:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010590c:	85 f6                	test   %esi,%esi
8010590e:	75 f0                	jne    80105900 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105910:	8d 73 08             	lea    0x8(%ebx),%esi
80105913:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105917:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010591a:	e8 21 e2 ff ff       	call   80103b40 <myproc>
8010591f:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
80105921:	31 c0                	xor    %eax,%eax
80105923:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105928:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010592f:	00 
    if(curproc->ofile[fd] == 0){
80105930:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80105934:	85 c9                	test   %ecx,%ecx
80105936:	74 38                	je     80105970 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105938:	83 c0 01             	add    $0x1,%eax
8010593b:	83 f8 10             	cmp    $0x10,%eax
8010593e:	75 f0                	jne    80105930 <sys_pipe+0x80>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105940:	e8 fb e1 ff ff       	call   80103b40 <myproc>
80105945:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010594c:	00 
    fileclose(rf);
8010594d:	83 ec 0c             	sub    $0xc,%esp
80105950:	ff 75 e0             	push   -0x20(%ebp)
80105953:	e8 28 b6 ff ff       	call   80100f80 <fileclose>
    fileclose(wf);
80105958:	58                   	pop    %eax
80105959:	ff 75 e4             	push   -0x1c(%ebp)
8010595c:	e8 1f b6 ff ff       	call   80100f80 <fileclose>
    return -1;
80105961:	83 c4 10             	add    $0x10,%esp
    return -1;
80105964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105969:	eb 16                	jmp    80105981 <sys_pipe+0xd1>
8010596b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105970:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
80105974:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105977:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105979:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010597c:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
8010597f:	31 c0                	xor    %eax,%eax
}
80105981:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105984:	5b                   	pop    %ebx
80105985:	5e                   	pop    %esi
80105986:	5f                   	pop    %edi
80105987:	5d                   	pop    %ebp
80105988:	c3                   	ret
80105989:	66 90                	xchg   %ax,%ax
8010598b:	66 90                	xchg   %ax,%ax
8010598d:	66 90                	xchg   %ax,%ax
8010598f:	90                   	nop

80105990 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105990:	e9 4b e3 ff ff       	jmp    80103ce0 <fork>
80105995:	8d 76 00             	lea    0x0(%esi),%esi
80105998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599f:	00 

801059a0 <sys_exit>:
}

int
sys_exit(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059a6:	e8 d5 e5 ff ff       	call   80103f80 <exit>
  return 0;  // not reached
}
801059ab:	31 c0                	xor    %eax,%eax
801059ad:	c9                   	leave
801059ae:	c3                   	ret
801059af:	90                   	nop

801059b0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801059b0:	e9 3b e7 ff ff       	jmp    801040f0 <wait>
801059b5:	8d 76 00             	lea    0x0(%esi),%esi
801059b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059bf:	00 

801059c0 <sys_kill>:
}

int
sys_kill(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059c9:	50                   	push   %eax
801059ca:	6a 00                	push   $0x0
801059cc:	e8 7f f2 ff ff       	call   80104c50 <argint>
801059d1:	83 c4 10             	add    $0x10,%esp
801059d4:	85 c0                	test   %eax,%eax
801059d6:	78 18                	js     801059f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059d8:	83 ec 0c             	sub    $0xc,%esp
801059db:	ff 75 f4             	push   -0xc(%ebp)
801059de:	e8 dd e9 ff ff       	call   801043c0 <kill>
801059e3:	83 c4 10             	add    $0x10,%esp
}
801059e6:	c9                   	leave
801059e7:	c3                   	ret
801059e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ef:	00 
801059f0:	c9                   	leave
    return -1;
801059f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f6:	c3                   	ret
801059f7:	90                   	nop
801059f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ff:	00 

80105a00 <sys_getpid>:

int
sys_getpid(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a06:	e8 35 e1 ff ff       	call   80103b40 <myproc>
80105a0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a0e:	c9                   	leave
80105a0f:	c3                   	ret

80105a10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a1a:	50                   	push   %eax
80105a1b:	6a 00                	push   $0x0
80105a1d:	e8 2e f2 ff ff       	call   80104c50 <argint>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	78 27                	js     80105a50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a29:	e8 12 e1 ff ff       	call   80103b40 <myproc>
  if(growproc(n) < 0)
80105a2e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a31:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a33:	ff 75 f4             	push   -0xc(%ebp)
80105a36:	e8 25 e2 ff ff       	call   80103c60 <growproc>
80105a3b:	83 c4 10             	add    $0x10,%esp
80105a3e:	85 c0                	test   %eax,%eax
80105a40:	78 0e                	js     80105a50 <sys_sbrk+0x40>
  addr = myproc()->sz;
80105a42:	89 d8                	mov    %ebx,%eax
    return -1;
  return addr;
}
80105a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a47:	c9                   	leave
80105a48:	c3                   	ret
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a55:	eb ed                	jmp    80105a44 <sys_sbrk+0x34>
80105a57:	90                   	nop
80105a58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a5f:	00 

80105a60 <sys_sleep>:

int
sys_sleep(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a6a:	50                   	push   %eax
80105a6b:	6a 00                	push   $0x0
80105a6d:	e8 de f1 ff ff       	call   80104c50 <argint>
80105a72:	83 c4 10             	add    $0x10,%esp
80105a75:	85 c0                	test   %eax,%eax
80105a77:	78 64                	js     80105add <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	68 80 3e 11 80       	push   $0x80113e80
80105a81:	e8 da ed ff ff       	call   80104860 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a89:	83 c4 10             	add    $0x10,%esp
80105a8c:	85 d2                	test   %edx,%edx
80105a8e:	74 58                	je     80105ae8 <sys_sleep+0x88>
  ticks0 = ticks;
80105a90:	8b 1d 60 3e 11 80    	mov    0x80113e60,%ebx
80105a96:	eb 29                	jmp    80105ac1 <sys_sleep+0x61>
80105a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a9f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105aa0:	83 ec 08             	sub    $0x8,%esp
80105aa3:	68 80 3e 11 80       	push   $0x80113e80
80105aa8:	68 60 3e 11 80       	push   $0x80113e60
80105aad:	e8 de e7 ff ff       	call   80104290 <sleep>
  while(ticks - ticks0 < n){
80105ab2:	a1 60 3e 11 80       	mov    0x80113e60,%eax
80105ab7:	83 c4 10             	add    $0x10,%esp
80105aba:	29 d8                	sub    %ebx,%eax
80105abc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105abf:	73 27                	jae    80105ae8 <sys_sleep+0x88>
    if(myproc()->killed){
80105ac1:	e8 7a e0 ff ff       	call   80103b40 <myproc>
80105ac6:	8b 40 24             	mov    0x24(%eax),%eax
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	74 d3                	je     80105aa0 <sys_sleep+0x40>
      release(&tickslock);
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	68 80 3e 11 80       	push   $0x80113e80
80105ad5:	e8 26 ed ff ff       	call   80104800 <release>
      return -1;
80105ada:	83 c4 10             	add    $0x10,%esp
    return -1;
80105add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae2:	eb 16                	jmp    80105afa <sys_sleep+0x9a>
80105ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&tickslock);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	68 80 3e 11 80       	push   $0x80113e80
80105af0:	e8 0b ed ff ff       	call   80104800 <release>
  return 0;
80105af5:	83 c4 10             	add    $0x10,%esp
80105af8:	31 c0                	xor    %eax,%eax
}
80105afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105afd:	c9                   	leave
80105afe:	c3                   	ret
80105aff:	90                   	nop

80105b00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	53                   	push   %ebx
80105b04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b07:	68 80 3e 11 80       	push   $0x80113e80
80105b0c:	e8 4f ed ff ff       	call   80104860 <acquire>
  xticks = ticks;
80105b11:	8b 1d 60 3e 11 80    	mov    0x80113e60,%ebx
  release(&tickslock);
80105b17:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
80105b1e:	e8 dd ec ff ff       	call   80104800 <release>
  return xticks;
}
80105b23:	89 d8                	mov    %ebx,%eax
80105b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b28:	c9                   	leave
80105b29:	c3                   	ret
80105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b30 <sys_hello>:
int
sys_hello(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 14             	sub    $0x14,%esp
  cprintf("Hello from xv6 syscall\n");
80105b36:	68 8a 79 10 80       	push   $0x8010798a
80105b3b:	e8 90 ab ff ff       	call   801006d0 <cprintf>
  return 0;
}
80105b40:	31 c0                	xor    %eax,%eax
80105b42:	c9                   	leave
80105b43:	c3                   	ret

80105b44 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b44:	1e                   	push   %ds
  pushl %es
80105b45:	06                   	push   %es
  pushl %fs
80105b46:	0f a0                	push   %fs
  pushl %gs
80105b48:	0f a8                	push   %gs
  pushal
80105b4a:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b4b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b4f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b51:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b53:	54                   	push   %esp
  call trap
80105b54:	e8 07 01 00 00       	call   80105c60 <trap>
  addl $4, %esp
80105b59:	83 c4 04             	add    $0x4,%esp

80105b5c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b5c:	61                   	popa
  popl %gs
80105b5d:	0f a9                	pop    %gs
  popl %fs
80105b5f:	0f a1                	pop    %fs
  popl %es
80105b61:	07                   	pop    %es
  popl %ds
80105b62:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b63:	83 c4 08             	add    $0x8,%esp
  iret
80105b66:	cf                   	iret
80105b67:	66 90                	xchg   %ax,%ax
80105b69:	66 90                	xchg   %ax,%ax
80105b6b:	66 90                	xchg   %ax,%ax
80105b6d:	66 90                	xchg   %ax,%ax
80105b6f:	66 90                	xchg   %ax,%ax
80105b71:	66 90                	xchg   %ax,%ax
80105b73:	66 90                	xchg   %ax,%ax
80105b75:	66 90                	xchg   %ax,%ax
80105b77:	66 90                	xchg   %ax,%ax
80105b79:	66 90                	xchg   %ax,%ax
80105b7b:	66 90                	xchg   %ax,%ax
80105b7d:	66 90                	xchg   %ax,%ax
80105b7f:	90                   	nop

80105b80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b81:	31 c0                	xor    %eax,%eax
{
80105b83:	89 e5                	mov    %esp,%ebp
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	eb 36                	jmp    80105bc0 <tvinit+0x40>
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b90:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b97:	00 
80105b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b9f:	00 
80105ba0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ba7:	00 
80105ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105baf:	00 
80105bb0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bb7:	00 
80105bb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bbf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bc0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105bc7:	c7 04 c5 c2 3e 11 80 	movl   $0x8e000008,-0x7feec13e(,%eax,8)
80105bce:	08 00 00 8e 
80105bd2:	66 89 14 c5 c0 3e 11 	mov    %dx,-0x7feec140(,%eax,8)
80105bd9:	80 
80105bda:	c1 ea 10             	shr    $0x10,%edx
80105bdd:	66 89 14 c5 c6 3e 11 	mov    %dx,-0x7feec13a(,%eax,8)
80105be4:	80 
  for(i = 0; i < 256; i++)
80105be5:	83 c0 01             	add    $0x1,%eax
80105be8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bed:	75 d1                	jne    80105bc0 <tvinit+0x40>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105bef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bf2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105bf7:	c7 05 c2 40 11 80 08 	movl   $0xef000008,0x801140c2
80105bfe:	00 00 ef 
  initlock(&tickslock, "time");
80105c01:	68 a2 79 10 80       	push   $0x801079a2
80105c06:	68 80 3e 11 80       	push   $0x80113e80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c0b:	66 a3 c0 40 11 80    	mov    %ax,0x801140c0
80105c11:	c1 e8 10             	shr    $0x10,%eax
80105c14:	66 a3 c6 40 11 80    	mov    %ax,0x801140c6
  initlock(&tickslock, "time");
80105c1a:	e8 21 ea ff ff       	call   80104640 <initlock>
}
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	c9                   	leave
80105c23:	c3                   	ret
80105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c2f:	00 

80105c30 <idtinit>:

void
idtinit(void)
{
80105c30:	55                   	push   %ebp
  pd[0] = size-1;
80105c31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c36:	89 e5                	mov    %esp,%ebp
80105c38:	83 ec 10             	sub    $0x10,%esp
80105c3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c3f:	b8 c0 3e 11 80       	mov    $0x80113ec0,%eax
80105c44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c48:	c1 e8 10             	shr    $0x10,%eax
80105c4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c55:	c9                   	leave
80105c56:	c3                   	ret
80105c57:	90                   	nop
80105c58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c5f:	00 

80105c60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
80105c66:	83 ec 1c             	sub    $0x1c,%esp
80105c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c6f:	83 f8 40             	cmp    $0x40,%eax
80105c72:	0f 84 c8 01 00 00    	je     80105e40 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c78:	83 e8 20             	sub    $0x20,%eax
80105c7b:	83 f8 1f             	cmp    $0x1f,%eax
80105c7e:	0f 87 7c 00 00 00    	ja     80105d00 <trap+0xa0>
80105c84:	ff 24 85 dc 7e 10 80 	jmp    *-0x7fef8124(,%eax,4)
80105c8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c90:	e8 8b c6 ff ff       	call   80102320 <ideintr>
    lapiceoi();
80105c95:	e8 86 cd ff ff       	call   80102a20 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c9a:	e8 a1 de ff ff       	call   80103b40 <myproc>
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	74 1a                	je     80105cbd <trap+0x5d>
80105ca3:	e8 98 de ff ff       	call   80103b40 <myproc>
80105ca8:	8b 70 24             	mov    0x24(%eax),%esi
80105cab:	85 f6                	test   %esi,%esi
80105cad:	74 0e                	je     80105cbd <trap+0x5d>
80105caf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cb3:	f7 d0                	not    %eax
80105cb5:	a8 03                	test   $0x3,%al
80105cb7:	0f 84 4b 02 00 00    	je     80105f08 <trap+0x2a8>
    exit();

  // Force process to give up CPU on clock tick.
// If interrupts were on while locks held, would need to check nlock.
if(myproc() && myproc()->state == RUNNING &&
80105cbd:	e8 7e de ff ff       	call   80103b40 <myproc>
80105cc2:	85 c0                	test   %eax,%eax
80105cc4:	74 0f                	je     80105cd5 <trap+0x75>
80105cc6:	e8 75 de ff ff       	call   80103b40 <myproc>
80105ccb:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ccf:	0f 84 ab 00 00 00    	je     80105d80 <trap+0x120>
    yield();
  }
}

// Check if the process has been killed since we yielded
if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cd5:	e8 66 de ff ff       	call   80103b40 <myproc>
80105cda:	85 c0                	test   %eax,%eax
80105cdc:	74 1a                	je     80105cf8 <trap+0x98>
80105cde:	e8 5d de ff ff       	call   80103b40 <myproc>
80105ce3:	8b 40 24             	mov    0x24(%eax),%eax
80105ce6:	85 c0                	test   %eax,%eax
80105ce8:	74 0e                	je     80105cf8 <trap+0x98>
80105cea:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cee:	f7 d0                	not    %eax
80105cf0:	a8 03                	test   $0x3,%al
80105cf2:	0f 84 75 01 00 00    	je     80105e6d <trap+0x20d>
  exit();
}
80105cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cfb:	5b                   	pop    %ebx
80105cfc:	5e                   	pop    %esi
80105cfd:	5f                   	pop    %edi
80105cfe:	5d                   	pop    %ebp
80105cff:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d00:	e8 3b de ff ff       	call   80103b40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d05:	8b 73 38             	mov    0x38(%ebx),%esi
80105d08:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d0b:	85 c0                	test   %eax,%eax
80105d0d:	0f 84 6b 02 00 00    	je     80105f7e <trap+0x31e>
80105d13:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d17:	0f 84 61 02 00 00    	je     80105f7e <trap+0x31e>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d1d:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d20:	e8 fb dd ff ff       	call   80103b20 <cpuid>
80105d25:	8b 4b 30             	mov    0x30(%ebx),%ecx
80105d28:	89 45 d8             	mov    %eax,-0x28(%ebp)
80105d2b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d2e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80105d31:	89 45 e0             	mov    %eax,-0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d34:	e8 07 de ff ff       	call   80103b40 <myproc>
80105d39:	8d 70 6c             	lea    0x6c(%eax),%esi
80105d3c:	e8 ff dd ff ff       	call   80103b40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d41:	57                   	push   %edi
80105d42:	ff 75 e4             	push   -0x1c(%ebp)
80105d45:	8b 55 d8             	mov    -0x28(%ebp),%edx
80105d48:	52                   	push   %edx
80105d49:	ff 75 e0             	push   -0x20(%ebp)
80105d4c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105d4f:	51                   	push   %ecx
80105d50:	56                   	push   %esi
80105d51:	ff 70 10             	push   0x10(%eax)
80105d54:	68 d0 7b 10 80       	push   $0x80107bd0
80105d59:	e8 72 a9 ff ff       	call   801006d0 <cprintf>
    myproc()->killed = 1;
80105d5e:	83 c4 20             	add    $0x20,%esp
80105d61:	e8 da dd ff ff       	call   80103b40 <myproc>
80105d66:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d6d:	e8 ce dd ff ff       	call   80103b40 <myproc>
80105d72:	85 c0                	test   %eax,%eax
80105d74:	0f 85 29 ff ff ff    	jne    80105ca3 <trap+0x43>
80105d7a:	e9 3e ff ff ff       	jmp    80105cbd <trap+0x5d>
80105d7f:	90                   	nop
if(myproc() && myproc()->state == RUNNING &&
80105d80:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d84:	0f 85 4b ff ff ff    	jne    80105cd5 <trap+0x75>
  myproc()->ticks++;
80105d8a:	e8 b1 dd ff ff       	call   80103b40 <myproc>
80105d8f:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
  if(myproc()->priority == 0 && myproc()->ticks >= 1){
80105d96:	e8 a5 dd ff ff       	call   80103b40 <myproc>
80105d9b:	8b 48 7c             	mov    0x7c(%eax),%ecx
80105d9e:	85 c9                	test   %ecx,%ecx
80105da0:	75 13                	jne    80105db5 <trap+0x155>
80105da2:	e8 99 dd ff ff       	call   80103b40 <myproc>
80105da7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105dad:	85 d2                	test   %edx,%edx
80105daf:	0f 8f a4 01 00 00    	jg     80105f59 <trap+0x2f9>
  } else if(myproc()->priority == 1 && myproc()->ticks >= 2){
80105db5:	e8 86 dd ff ff       	call   80103b40 <myproc>
80105dba:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80105dbe:	0f 84 5e 01 00 00    	je     80105f22 <trap+0x2c2>
  } else if(myproc()->priority == 2 && myproc()->ticks >= 8){
80105dc4:	e8 77 dd ff ff       	call   80103b40 <myproc>
80105dc9:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
80105dcd:	0f 85 02 ff ff ff    	jne    80105cd5 <trap+0x75>
80105dd3:	e8 68 dd ff ff       	call   80103b40 <myproc>
80105dd8:	83 b8 80 00 00 00 07 	cmpl   $0x7,0x80(%eax)
80105ddf:	0f 8e f0 fe ff ff    	jle    80105cd5 <trap+0x75>
    myproc()->ticks = 0;
80105de5:	e8 56 dd ff ff       	call   80103b40 <myproc>
80105dea:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105df1:	00 00 00 
    yield();
80105df4:	e8 47 e4 ff ff       	call   80104240 <yield>
80105df9:	e9 d7 fe ff ff       	jmp    80105cd5 <trap+0x75>
80105dfe:	66 90                	xchg   %ax,%ax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e00:	8b 4b 38             	mov    0x38(%ebx),%ecx
80105e03:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105e07:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80105e0a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105e0d:	e8 0e dd ff ff       	call   80103b20 <cpuid>
80105e12:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105e15:	51                   	push   %ecx
80105e16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105e19:	52                   	push   %edx
80105e1a:	50                   	push   %eax
80105e1b:	68 78 7b 10 80       	push   $0x80107b78
80105e20:	e8 ab a8 ff ff       	call   801006d0 <cprintf>
    lapiceoi();
80105e25:	e8 f6 cb ff ff       	call   80102a20 <lapiceoi>
    break;
80105e2a:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e2d:	e8 0e dd ff ff       	call   80103b40 <myproc>
80105e32:	85 c0                	test   %eax,%eax
80105e34:	0f 85 69 fe ff ff    	jne    80105ca3 <trap+0x43>
80105e3a:	e9 7e fe ff ff       	jmp    80105cbd <trap+0x5d>
80105e3f:	90                   	nop
    if(myproc()->killed)
80105e40:	e8 fb dc ff ff       	call   80103b40 <myproc>
80105e45:	8b 40 24             	mov    0x24(%eax),%eax
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	0f 85 c8 00 00 00    	jne    80105f18 <trap+0x2b8>
    myproc()->tf = tf;
80105e50:	e8 eb dc ff ff       	call   80103b40 <myproc>
80105e55:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e58:	e8 33 ef ff ff       	call   80104d90 <syscall>
    if(myproc()->killed)
80105e5d:	e8 de dc ff ff       	call   80103b40 <myproc>
80105e62:	8b 78 24             	mov    0x24(%eax),%edi
80105e65:	85 ff                	test   %edi,%edi
80105e67:	0f 84 8b fe ff ff    	je     80105cf8 <trap+0x98>
}
80105e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e70:	5b                   	pop    %ebx
80105e71:	5e                   	pop    %esi
80105e72:	5f                   	pop    %edi
80105e73:	5d                   	pop    %ebp
      exit();
80105e74:	e9 07 e1 ff ff       	jmp    80103f80 <exit>
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e80:	e8 9b 02 00 00       	call   80106120 <uartintr>
    lapiceoi();
80105e85:	e8 96 cb ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e8a:	e8 b1 dc ff ff       	call   80103b40 <myproc>
80105e8f:	85 c0                	test   %eax,%eax
80105e91:	0f 85 0c fe ff ff    	jne    80105ca3 <trap+0x43>
80105e97:	e9 21 fe ff ff       	jmp    80105cbd <trap+0x5d>
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ea0:	e8 3b ca ff ff       	call   801028e0 <kbdintr>
    lapiceoi();
80105ea5:	e8 76 cb ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eaa:	e8 91 dc ff ff       	call   80103b40 <myproc>
80105eaf:	85 c0                	test   %eax,%eax
80105eb1:	0f 85 ec fd ff ff    	jne    80105ca3 <trap+0x43>
80105eb7:	e9 01 fe ff ff       	jmp    80105cbd <trap+0x5d>
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ec0:	e8 5b dc ff ff       	call   80103b20 <cpuid>
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	0f 85 c8 fd ff ff    	jne    80105c95 <trap+0x35>
      acquire(&tickslock);
80105ecd:	83 ec 0c             	sub    $0xc,%esp
80105ed0:	68 80 3e 11 80       	push   $0x80113e80
80105ed5:	e8 86 e9 ff ff       	call   80104860 <acquire>
      ticks++;
80105eda:	83 05 60 3e 11 80 01 	addl   $0x1,0x80113e60
      wakeup(&ticks);
80105ee1:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80105ee8:	e8 63 e4 ff ff       	call   80104350 <wakeup>
      release(&tickslock);
80105eed:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
80105ef4:	e8 07 e9 ff ff       	call   80104800 <release>
80105ef9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105efc:	e9 94 fd ff ff       	jmp    80105c95 <trap+0x35>
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f08:	e8 73 e0 ff ff       	call   80103f80 <exit>
80105f0d:	e9 ab fd ff ff       	jmp    80105cbd <trap+0x5d>
80105f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f18:	e8 63 e0 ff ff       	call   80103f80 <exit>
80105f1d:	e9 2e ff ff ff       	jmp    80105e50 <trap+0x1f0>
  } else if(myproc()->priority == 1 && myproc()->ticks >= 2){
80105f22:	e8 19 dc ff ff       	call   80103b40 <myproc>
80105f27:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
80105f2e:	0f 8e 90 fe ff ff    	jle    80105dc4 <trap+0x164>
    myproc()->priority = 2;
80105f34:	e8 07 dc ff ff       	call   80103b40 <myproc>
80105f39:	c7 40 7c 02 00 00 00 	movl   $0x2,0x7c(%eax)
    myproc()->ticks = 0;
80105f40:	e8 fb db ff ff       	call   80103b40 <myproc>
80105f45:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105f4c:	00 00 00 
    yield();
80105f4f:	e8 ec e2 ff ff       	call   80104240 <yield>
80105f54:	e9 7c fd ff ff       	jmp    80105cd5 <trap+0x75>
    myproc()->priority = 1;
80105f59:	e8 e2 db ff ff       	call   80103b40 <myproc>
80105f5e:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
    myproc()->ticks = 0;
80105f65:	e8 d6 db ff ff       	call   80103b40 <myproc>
80105f6a:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105f71:	00 00 00 
    yield();
80105f74:	e8 c7 e2 ff ff       	call   80104240 <yield>
80105f79:	e9 57 fd ff ff       	jmp    80105cd5 <trap+0x75>
80105f7e:	0f 20 d2             	mov    %cr2,%edx
80105f81:	89 55 e0             	mov    %edx,-0x20(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f84:	e8 97 db ff ff       	call   80103b20 <cpuid>
80105f89:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105f8c:	83 ec 0c             	sub    $0xc,%esp
80105f8f:	52                   	push   %edx
80105f90:	ff 75 e4             	push   -0x1c(%ebp)
80105f93:	50                   	push   %eax
80105f94:	ff 73 30             	push   0x30(%ebx)
80105f97:	68 9c 7b 10 80       	push   $0x80107b9c
80105f9c:	e8 2f a7 ff ff       	call   801006d0 <cprintf>
      panic("trap");
80105fa1:	83 c4 14             	add    $0x14,%esp
80105fa4:	68 a7 79 10 80       	push   $0x801079a7
80105fa9:	e8 f2 a3 ff ff       	call   801003a0 <panic>
80105fae:	66 90                	xchg   %ax,%ax

80105fb0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fb0:	a1 c0 46 11 80       	mov    0x801146c0,%eax
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	74 17                	je     80105fd0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fb9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fbe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fbf:	a8 01                	test   $0x1,%al
80105fc1:	74 0d                	je     80105fd0 <uartgetc+0x20>
80105fc3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fc8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fc9:	0f b6 c0             	movzbl %al,%eax
80105fcc:	c3                   	ret
80105fcd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd5:	c3                   	ret
80105fd6:	66 90                	xchg   %ax,%ax
80105fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fdf:	00 

80105fe0 <uartinit>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fe0:	31 c0                	xor    %eax,%eax
80105fe2:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105fe7:	ee                   	out    %al,(%dx)
80105fe8:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105fed:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105ff2:	ee                   	out    %al,(%dx)
80105ff3:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ff8:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffd:	ee                   	out    %al,(%dx)
80105ffe:	31 c0                	xor    %eax,%eax
80106000:	ba f9 03 00 00       	mov    $0x3f9,%edx
80106005:	ee                   	out    %al,(%dx)
80106006:	b8 03 00 00 00       	mov    $0x3,%eax
8010600b:	ba fb 03 00 00       	mov    $0x3fb,%edx
80106010:	ee                   	out    %al,(%dx)
80106011:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106016:	31 c0                	xor    %eax,%eax
80106018:	ee                   	out    %al,(%dx)
80106019:	b8 01 00 00 00       	mov    $0x1,%eax
8010601e:	ba f9 03 00 00       	mov    $0x3f9,%edx
80106023:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106024:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106029:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010602a:	3c ff                	cmp    $0xff,%al
8010602c:	0f 84 8e 00 00 00    	je     801060c0 <uartinit+0xe0>
{
80106032:	55                   	push   %ebp
80106033:	ba fa 03 00 00       	mov    $0x3fa,%edx
80106038:	89 e5                	mov    %esp,%ebp
8010603a:	57                   	push   %edi
8010603b:	56                   	push   %esi
8010603c:	53                   	push   %ebx
8010603d:	83 ec 24             	sub    $0x24,%esp
  uart = 1;
80106040:	c7 05 c0 46 11 80 01 	movl   $0x1,0x801146c0
80106047:	00 00 00 
8010604a:	ec                   	in     (%dx),%al
8010604b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106050:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106051:	6a 00                	push   $0x0
  for(p="xv6...\n"; *p; p++)
80106053:	bf ac 79 10 80       	mov    $0x801079ac,%edi
  ioapicenable(IRQ_COM1, 0);
80106058:	6a 04                	push   $0x4
8010605a:	e8 21 c5 ff ff       	call   80102580 <ioapicenable>
8010605f:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106062:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80106066:	66 90                	xchg   %ax,%ax
80106068:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010606f:	00 
  if(!uart)
80106070:	a1 c0 46 11 80       	mov    0x801146c0,%eax
80106075:	bb 80 00 00 00       	mov    $0x80,%ebx
8010607a:	85 c0                	test   %eax,%eax
8010607c:	75 14                	jne    80106092 <uartinit+0xb2>
8010607e:	eb 26                	jmp    801060a6 <uartinit+0xc6>
    microdelay(10);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	6a 0a                	push   $0xa
80106085:	e8 b6 c9 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	83 eb 01             	sub    $0x1,%ebx
80106090:	74 0a                	je     8010609c <uartinit+0xbc>
80106092:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106097:	ec                   	in     (%dx),%al
80106098:	a8 20                	test   $0x20,%al
8010609a:	74 e4                	je     80106080 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010609c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801060a0:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060a5:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801060a6:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801060aa:	83 c7 01             	add    $0x1,%edi
801060ad:	88 45 e7             	mov    %al,-0x19(%ebp)
801060b0:	81 ff b3 79 10 80    	cmp    $0x801079b3,%edi
801060b6:	75 b8                	jne    80106070 <uartinit+0x90>
}
801060b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060bb:	5b                   	pop    %ebx
801060bc:	5e                   	pop    %esi
801060bd:	5f                   	pop    %edi
801060be:	5d                   	pop    %ebp
801060bf:	c3                   	ret
801060c0:	c3                   	ret
801060c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801060cf:	00 

801060d0 <uartputc>:
  if(!uart)
801060d0:	a1 c0 46 11 80       	mov    0x801146c0,%eax
801060d5:	85 c0                	test   %eax,%eax
801060d7:	74 3f                	je     80106118 <uartputc+0x48>
{
801060d9:	55                   	push   %ebp
801060da:	89 e5                	mov    %esp,%ebp
801060dc:	56                   	push   %esi
801060dd:	53                   	push   %ebx
801060de:	bb 80 00 00 00       	mov    $0x80,%ebx
801060e3:	eb 15                	jmp    801060fa <uartputc+0x2a>
801060e5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801060e8:	83 ec 0c             	sub    $0xc,%esp
801060eb:	6a 0a                	push   $0xa
801060ed:	e8 4e c9 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060f2:	83 c4 10             	add    $0x10,%esp
801060f5:	83 eb 01             	sub    $0x1,%ebx
801060f8:	74 0a                	je     80106104 <uartputc+0x34>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060fa:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060ff:	ec                   	in     (%dx),%al
80106100:	a8 20                	test   $0x20,%al
80106102:	74 e4                	je     801060e8 <uartputc+0x18>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106104:	8b 45 08             	mov    0x8(%ebp),%eax
80106107:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010610c:	ee                   	out    %al,(%dx)
}
8010610d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106110:	5b                   	pop    %ebx
80106111:	5e                   	pop    %esi
80106112:	5d                   	pop    %ebp
80106113:	c3                   	ret
80106114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106118:	c3                   	ret
80106119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106120 <uartintr>:

void
uartintr(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106126:	68 b0 5f 10 80       	push   $0x80105fb0
8010612b:	e8 a0 a7 ff ff       	call   801008d0 <consoleintr>
}
80106130:	83 c4 10             	add    $0x10,%esp
80106133:	c9                   	leave
80106134:	c3                   	ret

80106135 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $0
80106137:	6a 00                	push   $0x0
  jmp alltraps
80106139:	e9 06 fa ff ff       	jmp    80105b44 <alltraps>

8010613e <vector1>:
.globl vector1
vector1:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $1
80106140:	6a 01                	push   $0x1
  jmp alltraps
80106142:	e9 fd f9 ff ff       	jmp    80105b44 <alltraps>

80106147 <vector2>:
.globl vector2
vector2:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $2
80106149:	6a 02                	push   $0x2
  jmp alltraps
8010614b:	e9 f4 f9 ff ff       	jmp    80105b44 <alltraps>

80106150 <vector3>:
.globl vector3
vector3:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $3
80106152:	6a 03                	push   $0x3
  jmp alltraps
80106154:	e9 eb f9 ff ff       	jmp    80105b44 <alltraps>

80106159 <vector4>:
.globl vector4
vector4:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $4
8010615b:	6a 04                	push   $0x4
  jmp alltraps
8010615d:	e9 e2 f9 ff ff       	jmp    80105b44 <alltraps>

80106162 <vector5>:
.globl vector5
vector5:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $5
80106164:	6a 05                	push   $0x5
  jmp alltraps
80106166:	e9 d9 f9 ff ff       	jmp    80105b44 <alltraps>

8010616b <vector6>:
.globl vector6
vector6:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $6
8010616d:	6a 06                	push   $0x6
  jmp alltraps
8010616f:	e9 d0 f9 ff ff       	jmp    80105b44 <alltraps>

80106174 <vector7>:
.globl vector7
vector7:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $7
80106176:	6a 07                	push   $0x7
  jmp alltraps
80106178:	e9 c7 f9 ff ff       	jmp    80105b44 <alltraps>

8010617d <vector8>:
.globl vector8
vector8:
  pushl $8
8010617d:	6a 08                	push   $0x8
  jmp alltraps
8010617f:	e9 c0 f9 ff ff       	jmp    80105b44 <alltraps>

80106184 <vector9>:
.globl vector9
vector9:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $9
80106186:	6a 09                	push   $0x9
  jmp alltraps
80106188:	e9 b7 f9 ff ff       	jmp    80105b44 <alltraps>

8010618d <vector10>:
.globl vector10
vector10:
  pushl $10
8010618d:	6a 0a                	push   $0xa
  jmp alltraps
8010618f:	e9 b0 f9 ff ff       	jmp    80105b44 <alltraps>

80106194 <vector11>:
.globl vector11
vector11:
  pushl $11
80106194:	6a 0b                	push   $0xb
  jmp alltraps
80106196:	e9 a9 f9 ff ff       	jmp    80105b44 <alltraps>

8010619b <vector12>:
.globl vector12
vector12:
  pushl $12
8010619b:	6a 0c                	push   $0xc
  jmp alltraps
8010619d:	e9 a2 f9 ff ff       	jmp    80105b44 <alltraps>

801061a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061a2:	6a 0d                	push   $0xd
  jmp alltraps
801061a4:	e9 9b f9 ff ff       	jmp    80105b44 <alltraps>

801061a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061a9:	6a 0e                	push   $0xe
  jmp alltraps
801061ab:	e9 94 f9 ff ff       	jmp    80105b44 <alltraps>

801061b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061b0:	6a 00                	push   $0x0
  pushl $15
801061b2:	6a 0f                	push   $0xf
  jmp alltraps
801061b4:	e9 8b f9 ff ff       	jmp    80105b44 <alltraps>

801061b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061b9:	6a 00                	push   $0x0
  pushl $16
801061bb:	6a 10                	push   $0x10
  jmp alltraps
801061bd:	e9 82 f9 ff ff       	jmp    80105b44 <alltraps>

801061c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061c2:	6a 11                	push   $0x11
  jmp alltraps
801061c4:	e9 7b f9 ff ff       	jmp    80105b44 <alltraps>

801061c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $18
801061cb:	6a 12                	push   $0x12
  jmp alltraps
801061cd:	e9 72 f9 ff ff       	jmp    80105b44 <alltraps>

801061d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $19
801061d4:	6a 13                	push   $0x13
  jmp alltraps
801061d6:	e9 69 f9 ff ff       	jmp    80105b44 <alltraps>

801061db <vector20>:
.globl vector20
vector20:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $20
801061dd:	6a 14                	push   $0x14
  jmp alltraps
801061df:	e9 60 f9 ff ff       	jmp    80105b44 <alltraps>

801061e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $21
801061e6:	6a 15                	push   $0x15
  jmp alltraps
801061e8:	e9 57 f9 ff ff       	jmp    80105b44 <alltraps>

801061ed <vector22>:
.globl vector22
vector22:
  pushl $0
801061ed:	6a 00                	push   $0x0
  pushl $22
801061ef:	6a 16                	push   $0x16
  jmp alltraps
801061f1:	e9 4e f9 ff ff       	jmp    80105b44 <alltraps>

801061f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $23
801061f8:	6a 17                	push   $0x17
  jmp alltraps
801061fa:	e9 45 f9 ff ff       	jmp    80105b44 <alltraps>

801061ff <vector24>:
.globl vector24
vector24:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $24
80106201:	6a 18                	push   $0x18
  jmp alltraps
80106203:	e9 3c f9 ff ff       	jmp    80105b44 <alltraps>

80106208 <vector25>:
.globl vector25
vector25:
  pushl $0
80106208:	6a 00                	push   $0x0
  pushl $25
8010620a:	6a 19                	push   $0x19
  jmp alltraps
8010620c:	e9 33 f9 ff ff       	jmp    80105b44 <alltraps>

80106211 <vector26>:
.globl vector26
vector26:
  pushl $0
80106211:	6a 00                	push   $0x0
  pushl $26
80106213:	6a 1a                	push   $0x1a
  jmp alltraps
80106215:	e9 2a f9 ff ff       	jmp    80105b44 <alltraps>

8010621a <vector27>:
.globl vector27
vector27:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $27
8010621c:	6a 1b                	push   $0x1b
  jmp alltraps
8010621e:	e9 21 f9 ff ff       	jmp    80105b44 <alltraps>

80106223 <vector28>:
.globl vector28
vector28:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $28
80106225:	6a 1c                	push   $0x1c
  jmp alltraps
80106227:	e9 18 f9 ff ff       	jmp    80105b44 <alltraps>

8010622c <vector29>:
.globl vector29
vector29:
  pushl $0
8010622c:	6a 00                	push   $0x0
  pushl $29
8010622e:	6a 1d                	push   $0x1d
  jmp alltraps
80106230:	e9 0f f9 ff ff       	jmp    80105b44 <alltraps>

80106235 <vector30>:
.globl vector30
vector30:
  pushl $0
80106235:	6a 00                	push   $0x0
  pushl $30
80106237:	6a 1e                	push   $0x1e
  jmp alltraps
80106239:	e9 06 f9 ff ff       	jmp    80105b44 <alltraps>

8010623e <vector31>:
.globl vector31
vector31:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $31
80106240:	6a 1f                	push   $0x1f
  jmp alltraps
80106242:	e9 fd f8 ff ff       	jmp    80105b44 <alltraps>

80106247 <vector32>:
.globl vector32
vector32:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $32
80106249:	6a 20                	push   $0x20
  jmp alltraps
8010624b:	e9 f4 f8 ff ff       	jmp    80105b44 <alltraps>

80106250 <vector33>:
.globl vector33
vector33:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $33
80106252:	6a 21                	push   $0x21
  jmp alltraps
80106254:	e9 eb f8 ff ff       	jmp    80105b44 <alltraps>

80106259 <vector34>:
.globl vector34
vector34:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $34
8010625b:	6a 22                	push   $0x22
  jmp alltraps
8010625d:	e9 e2 f8 ff ff       	jmp    80105b44 <alltraps>

80106262 <vector35>:
.globl vector35
vector35:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $35
80106264:	6a 23                	push   $0x23
  jmp alltraps
80106266:	e9 d9 f8 ff ff       	jmp    80105b44 <alltraps>

8010626b <vector36>:
.globl vector36
vector36:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $36
8010626d:	6a 24                	push   $0x24
  jmp alltraps
8010626f:	e9 d0 f8 ff ff       	jmp    80105b44 <alltraps>

80106274 <vector37>:
.globl vector37
vector37:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $37
80106276:	6a 25                	push   $0x25
  jmp alltraps
80106278:	e9 c7 f8 ff ff       	jmp    80105b44 <alltraps>

8010627d <vector38>:
.globl vector38
vector38:
  pushl $0
8010627d:	6a 00                	push   $0x0
  pushl $38
8010627f:	6a 26                	push   $0x26
  jmp alltraps
80106281:	e9 be f8 ff ff       	jmp    80105b44 <alltraps>

80106286 <vector39>:
.globl vector39
vector39:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $39
80106288:	6a 27                	push   $0x27
  jmp alltraps
8010628a:	e9 b5 f8 ff ff       	jmp    80105b44 <alltraps>

8010628f <vector40>:
.globl vector40
vector40:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $40
80106291:	6a 28                	push   $0x28
  jmp alltraps
80106293:	e9 ac f8 ff ff       	jmp    80105b44 <alltraps>

80106298 <vector41>:
.globl vector41
vector41:
  pushl $0
80106298:	6a 00                	push   $0x0
  pushl $41
8010629a:	6a 29                	push   $0x29
  jmp alltraps
8010629c:	e9 a3 f8 ff ff       	jmp    80105b44 <alltraps>

801062a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062a1:	6a 00                	push   $0x0
  pushl $42
801062a3:	6a 2a                	push   $0x2a
  jmp alltraps
801062a5:	e9 9a f8 ff ff       	jmp    80105b44 <alltraps>

801062aa <vector43>:
.globl vector43
vector43:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $43
801062ac:	6a 2b                	push   $0x2b
  jmp alltraps
801062ae:	e9 91 f8 ff ff       	jmp    80105b44 <alltraps>

801062b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $44
801062b5:	6a 2c                	push   $0x2c
  jmp alltraps
801062b7:	e9 88 f8 ff ff       	jmp    80105b44 <alltraps>

801062bc <vector45>:
.globl vector45
vector45:
  pushl $0
801062bc:	6a 00                	push   $0x0
  pushl $45
801062be:	6a 2d                	push   $0x2d
  jmp alltraps
801062c0:	e9 7f f8 ff ff       	jmp    80105b44 <alltraps>

801062c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062c5:	6a 00                	push   $0x0
  pushl $46
801062c7:	6a 2e                	push   $0x2e
  jmp alltraps
801062c9:	e9 76 f8 ff ff       	jmp    80105b44 <alltraps>

801062ce <vector47>:
.globl vector47
vector47:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $47
801062d0:	6a 2f                	push   $0x2f
  jmp alltraps
801062d2:	e9 6d f8 ff ff       	jmp    80105b44 <alltraps>

801062d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $48
801062d9:	6a 30                	push   $0x30
  jmp alltraps
801062db:	e9 64 f8 ff ff       	jmp    80105b44 <alltraps>

801062e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $49
801062e2:	6a 31                	push   $0x31
  jmp alltraps
801062e4:	e9 5b f8 ff ff       	jmp    80105b44 <alltraps>

801062e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $50
801062eb:	6a 32                	push   $0x32
  jmp alltraps
801062ed:	e9 52 f8 ff ff       	jmp    80105b44 <alltraps>

801062f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $51
801062f4:	6a 33                	push   $0x33
  jmp alltraps
801062f6:	e9 49 f8 ff ff       	jmp    80105b44 <alltraps>

801062fb <vector52>:
.globl vector52
vector52:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $52
801062fd:	6a 34                	push   $0x34
  jmp alltraps
801062ff:	e9 40 f8 ff ff       	jmp    80105b44 <alltraps>

80106304 <vector53>:
.globl vector53
vector53:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $53
80106306:	6a 35                	push   $0x35
  jmp alltraps
80106308:	e9 37 f8 ff ff       	jmp    80105b44 <alltraps>

8010630d <vector54>:
.globl vector54
vector54:
  pushl $0
8010630d:	6a 00                	push   $0x0
  pushl $54
8010630f:	6a 36                	push   $0x36
  jmp alltraps
80106311:	e9 2e f8 ff ff       	jmp    80105b44 <alltraps>

80106316 <vector55>:
.globl vector55
vector55:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $55
80106318:	6a 37                	push   $0x37
  jmp alltraps
8010631a:	e9 25 f8 ff ff       	jmp    80105b44 <alltraps>

8010631f <vector56>:
.globl vector56
vector56:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $56
80106321:	6a 38                	push   $0x38
  jmp alltraps
80106323:	e9 1c f8 ff ff       	jmp    80105b44 <alltraps>

80106328 <vector57>:
.globl vector57
vector57:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $57
8010632a:	6a 39                	push   $0x39
  jmp alltraps
8010632c:	e9 13 f8 ff ff       	jmp    80105b44 <alltraps>

80106331 <vector58>:
.globl vector58
vector58:
  pushl $0
80106331:	6a 00                	push   $0x0
  pushl $58
80106333:	6a 3a                	push   $0x3a
  jmp alltraps
80106335:	e9 0a f8 ff ff       	jmp    80105b44 <alltraps>

8010633a <vector59>:
.globl vector59
vector59:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $59
8010633c:	6a 3b                	push   $0x3b
  jmp alltraps
8010633e:	e9 01 f8 ff ff       	jmp    80105b44 <alltraps>

80106343 <vector60>:
.globl vector60
vector60:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $60
80106345:	6a 3c                	push   $0x3c
  jmp alltraps
80106347:	e9 f8 f7 ff ff       	jmp    80105b44 <alltraps>

8010634c <vector61>:
.globl vector61
vector61:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $61
8010634e:	6a 3d                	push   $0x3d
  jmp alltraps
80106350:	e9 ef f7 ff ff       	jmp    80105b44 <alltraps>

80106355 <vector62>:
.globl vector62
vector62:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $62
80106357:	6a 3e                	push   $0x3e
  jmp alltraps
80106359:	e9 e6 f7 ff ff       	jmp    80105b44 <alltraps>

8010635e <vector63>:
.globl vector63
vector63:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $63
80106360:	6a 3f                	push   $0x3f
  jmp alltraps
80106362:	e9 dd f7 ff ff       	jmp    80105b44 <alltraps>

80106367 <vector64>:
.globl vector64
vector64:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $64
80106369:	6a 40                	push   $0x40
  jmp alltraps
8010636b:	e9 d4 f7 ff ff       	jmp    80105b44 <alltraps>

80106370 <vector65>:
.globl vector65
vector65:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $65
80106372:	6a 41                	push   $0x41
  jmp alltraps
80106374:	e9 cb f7 ff ff       	jmp    80105b44 <alltraps>

80106379 <vector66>:
.globl vector66
vector66:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $66
8010637b:	6a 42                	push   $0x42
  jmp alltraps
8010637d:	e9 c2 f7 ff ff       	jmp    80105b44 <alltraps>

80106382 <vector67>:
.globl vector67
vector67:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $67
80106384:	6a 43                	push   $0x43
  jmp alltraps
80106386:	e9 b9 f7 ff ff       	jmp    80105b44 <alltraps>

8010638b <vector68>:
.globl vector68
vector68:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $68
8010638d:	6a 44                	push   $0x44
  jmp alltraps
8010638f:	e9 b0 f7 ff ff       	jmp    80105b44 <alltraps>

80106394 <vector69>:
.globl vector69
vector69:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $69
80106396:	6a 45                	push   $0x45
  jmp alltraps
80106398:	e9 a7 f7 ff ff       	jmp    80105b44 <alltraps>

8010639d <vector70>:
.globl vector70
vector70:
  pushl $0
8010639d:	6a 00                	push   $0x0
  pushl $70
8010639f:	6a 46                	push   $0x46
  jmp alltraps
801063a1:	e9 9e f7 ff ff       	jmp    80105b44 <alltraps>

801063a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $71
801063a8:	6a 47                	push   $0x47
  jmp alltraps
801063aa:	e9 95 f7 ff ff       	jmp    80105b44 <alltraps>

801063af <vector72>:
.globl vector72
vector72:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $72
801063b1:	6a 48                	push   $0x48
  jmp alltraps
801063b3:	e9 8c f7 ff ff       	jmp    80105b44 <alltraps>

801063b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $73
801063ba:	6a 49                	push   $0x49
  jmp alltraps
801063bc:	e9 83 f7 ff ff       	jmp    80105b44 <alltraps>

801063c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063c1:	6a 00                	push   $0x0
  pushl $74
801063c3:	6a 4a                	push   $0x4a
  jmp alltraps
801063c5:	e9 7a f7 ff ff       	jmp    80105b44 <alltraps>

801063ca <vector75>:
.globl vector75
vector75:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $75
801063cc:	6a 4b                	push   $0x4b
  jmp alltraps
801063ce:	e9 71 f7 ff ff       	jmp    80105b44 <alltraps>

801063d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $76
801063d5:	6a 4c                	push   $0x4c
  jmp alltraps
801063d7:	e9 68 f7 ff ff       	jmp    80105b44 <alltraps>

801063dc <vector77>:
.globl vector77
vector77:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $77
801063de:	6a 4d                	push   $0x4d
  jmp alltraps
801063e0:	e9 5f f7 ff ff       	jmp    80105b44 <alltraps>

801063e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $78
801063e7:	6a 4e                	push   $0x4e
  jmp alltraps
801063e9:	e9 56 f7 ff ff       	jmp    80105b44 <alltraps>

801063ee <vector79>:
.globl vector79
vector79:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $79
801063f0:	6a 4f                	push   $0x4f
  jmp alltraps
801063f2:	e9 4d f7 ff ff       	jmp    80105b44 <alltraps>

801063f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $80
801063f9:	6a 50                	push   $0x50
  jmp alltraps
801063fb:	e9 44 f7 ff ff       	jmp    80105b44 <alltraps>

80106400 <vector81>:
.globl vector81
vector81:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $81
80106402:	6a 51                	push   $0x51
  jmp alltraps
80106404:	e9 3b f7 ff ff       	jmp    80105b44 <alltraps>

80106409 <vector82>:
.globl vector82
vector82:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $82
8010640b:	6a 52                	push   $0x52
  jmp alltraps
8010640d:	e9 32 f7 ff ff       	jmp    80105b44 <alltraps>

80106412 <vector83>:
.globl vector83
vector83:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $83
80106414:	6a 53                	push   $0x53
  jmp alltraps
80106416:	e9 29 f7 ff ff       	jmp    80105b44 <alltraps>

8010641b <vector84>:
.globl vector84
vector84:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $84
8010641d:	6a 54                	push   $0x54
  jmp alltraps
8010641f:	e9 20 f7 ff ff       	jmp    80105b44 <alltraps>

80106424 <vector85>:
.globl vector85
vector85:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $85
80106426:	6a 55                	push   $0x55
  jmp alltraps
80106428:	e9 17 f7 ff ff       	jmp    80105b44 <alltraps>

8010642d <vector86>:
.globl vector86
vector86:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $86
8010642f:	6a 56                	push   $0x56
  jmp alltraps
80106431:	e9 0e f7 ff ff       	jmp    80105b44 <alltraps>

80106436 <vector87>:
.globl vector87
vector87:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $87
80106438:	6a 57                	push   $0x57
  jmp alltraps
8010643a:	e9 05 f7 ff ff       	jmp    80105b44 <alltraps>

8010643f <vector88>:
.globl vector88
vector88:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $88
80106441:	6a 58                	push   $0x58
  jmp alltraps
80106443:	e9 fc f6 ff ff       	jmp    80105b44 <alltraps>

80106448 <vector89>:
.globl vector89
vector89:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $89
8010644a:	6a 59                	push   $0x59
  jmp alltraps
8010644c:	e9 f3 f6 ff ff       	jmp    80105b44 <alltraps>

80106451 <vector90>:
.globl vector90
vector90:
  pushl $0
80106451:	6a 00                	push   $0x0
  pushl $90
80106453:	6a 5a                	push   $0x5a
  jmp alltraps
80106455:	e9 ea f6 ff ff       	jmp    80105b44 <alltraps>

8010645a <vector91>:
.globl vector91
vector91:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $91
8010645c:	6a 5b                	push   $0x5b
  jmp alltraps
8010645e:	e9 e1 f6 ff ff       	jmp    80105b44 <alltraps>

80106463 <vector92>:
.globl vector92
vector92:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $92
80106465:	6a 5c                	push   $0x5c
  jmp alltraps
80106467:	e9 d8 f6 ff ff       	jmp    80105b44 <alltraps>

8010646c <vector93>:
.globl vector93
vector93:
  pushl $0
8010646c:	6a 00                	push   $0x0
  pushl $93
8010646e:	6a 5d                	push   $0x5d
  jmp alltraps
80106470:	e9 cf f6 ff ff       	jmp    80105b44 <alltraps>

80106475 <vector94>:
.globl vector94
vector94:
  pushl $0
80106475:	6a 00                	push   $0x0
  pushl $94
80106477:	6a 5e                	push   $0x5e
  jmp alltraps
80106479:	e9 c6 f6 ff ff       	jmp    80105b44 <alltraps>

8010647e <vector95>:
.globl vector95
vector95:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $95
80106480:	6a 5f                	push   $0x5f
  jmp alltraps
80106482:	e9 bd f6 ff ff       	jmp    80105b44 <alltraps>

80106487 <vector96>:
.globl vector96
vector96:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $96
80106489:	6a 60                	push   $0x60
  jmp alltraps
8010648b:	e9 b4 f6 ff ff       	jmp    80105b44 <alltraps>

80106490 <vector97>:
.globl vector97
vector97:
  pushl $0
80106490:	6a 00                	push   $0x0
  pushl $97
80106492:	6a 61                	push   $0x61
  jmp alltraps
80106494:	e9 ab f6 ff ff       	jmp    80105b44 <alltraps>

80106499 <vector98>:
.globl vector98
vector98:
  pushl $0
80106499:	6a 00                	push   $0x0
  pushl $98
8010649b:	6a 62                	push   $0x62
  jmp alltraps
8010649d:	e9 a2 f6 ff ff       	jmp    80105b44 <alltraps>

801064a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $99
801064a4:	6a 63                	push   $0x63
  jmp alltraps
801064a6:	e9 99 f6 ff ff       	jmp    80105b44 <alltraps>

801064ab <vector100>:
.globl vector100
vector100:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $100
801064ad:	6a 64                	push   $0x64
  jmp alltraps
801064af:	e9 90 f6 ff ff       	jmp    80105b44 <alltraps>

801064b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064b4:	6a 00                	push   $0x0
  pushl $101
801064b6:	6a 65                	push   $0x65
  jmp alltraps
801064b8:	e9 87 f6 ff ff       	jmp    80105b44 <alltraps>

801064bd <vector102>:
.globl vector102
vector102:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $102
801064bf:	6a 66                	push   $0x66
  jmp alltraps
801064c1:	e9 7e f6 ff ff       	jmp    80105b44 <alltraps>

801064c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $103
801064c8:	6a 67                	push   $0x67
  jmp alltraps
801064ca:	e9 75 f6 ff ff       	jmp    80105b44 <alltraps>

801064cf <vector104>:
.globl vector104
vector104:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $104
801064d1:	6a 68                	push   $0x68
  jmp alltraps
801064d3:	e9 6c f6 ff ff       	jmp    80105b44 <alltraps>

801064d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $105
801064da:	6a 69                	push   $0x69
  jmp alltraps
801064dc:	e9 63 f6 ff ff       	jmp    80105b44 <alltraps>

801064e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $106
801064e3:	6a 6a                	push   $0x6a
  jmp alltraps
801064e5:	e9 5a f6 ff ff       	jmp    80105b44 <alltraps>

801064ea <vector107>:
.globl vector107
vector107:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $107
801064ec:	6a 6b                	push   $0x6b
  jmp alltraps
801064ee:	e9 51 f6 ff ff       	jmp    80105b44 <alltraps>

801064f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $108
801064f5:	6a 6c                	push   $0x6c
  jmp alltraps
801064f7:	e9 48 f6 ff ff       	jmp    80105b44 <alltraps>

801064fc <vector109>:
.globl vector109
vector109:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $109
801064fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106500:	e9 3f f6 ff ff       	jmp    80105b44 <alltraps>

80106505 <vector110>:
.globl vector110
vector110:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $110
80106507:	6a 6e                	push   $0x6e
  jmp alltraps
80106509:	e9 36 f6 ff ff       	jmp    80105b44 <alltraps>

8010650e <vector111>:
.globl vector111
vector111:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $111
80106510:	6a 6f                	push   $0x6f
  jmp alltraps
80106512:	e9 2d f6 ff ff       	jmp    80105b44 <alltraps>

80106517 <vector112>:
.globl vector112
vector112:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $112
80106519:	6a 70                	push   $0x70
  jmp alltraps
8010651b:	e9 24 f6 ff ff       	jmp    80105b44 <alltraps>

80106520 <vector113>:
.globl vector113
vector113:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $113
80106522:	6a 71                	push   $0x71
  jmp alltraps
80106524:	e9 1b f6 ff ff       	jmp    80105b44 <alltraps>

80106529 <vector114>:
.globl vector114
vector114:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $114
8010652b:	6a 72                	push   $0x72
  jmp alltraps
8010652d:	e9 12 f6 ff ff       	jmp    80105b44 <alltraps>

80106532 <vector115>:
.globl vector115
vector115:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $115
80106534:	6a 73                	push   $0x73
  jmp alltraps
80106536:	e9 09 f6 ff ff       	jmp    80105b44 <alltraps>

8010653b <vector116>:
.globl vector116
vector116:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $116
8010653d:	6a 74                	push   $0x74
  jmp alltraps
8010653f:	e9 00 f6 ff ff       	jmp    80105b44 <alltraps>

80106544 <vector117>:
.globl vector117
vector117:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $117
80106546:	6a 75                	push   $0x75
  jmp alltraps
80106548:	e9 f7 f5 ff ff       	jmp    80105b44 <alltraps>

8010654d <vector118>:
.globl vector118
vector118:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $118
8010654f:	6a 76                	push   $0x76
  jmp alltraps
80106551:	e9 ee f5 ff ff       	jmp    80105b44 <alltraps>

80106556 <vector119>:
.globl vector119
vector119:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $119
80106558:	6a 77                	push   $0x77
  jmp alltraps
8010655a:	e9 e5 f5 ff ff       	jmp    80105b44 <alltraps>

8010655f <vector120>:
.globl vector120
vector120:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $120
80106561:	6a 78                	push   $0x78
  jmp alltraps
80106563:	e9 dc f5 ff ff       	jmp    80105b44 <alltraps>

80106568 <vector121>:
.globl vector121
vector121:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $121
8010656a:	6a 79                	push   $0x79
  jmp alltraps
8010656c:	e9 d3 f5 ff ff       	jmp    80105b44 <alltraps>

80106571 <vector122>:
.globl vector122
vector122:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $122
80106573:	6a 7a                	push   $0x7a
  jmp alltraps
80106575:	e9 ca f5 ff ff       	jmp    80105b44 <alltraps>

8010657a <vector123>:
.globl vector123
vector123:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $123
8010657c:	6a 7b                	push   $0x7b
  jmp alltraps
8010657e:	e9 c1 f5 ff ff       	jmp    80105b44 <alltraps>

80106583 <vector124>:
.globl vector124
vector124:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $124
80106585:	6a 7c                	push   $0x7c
  jmp alltraps
80106587:	e9 b8 f5 ff ff       	jmp    80105b44 <alltraps>

8010658c <vector125>:
.globl vector125
vector125:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $125
8010658e:	6a 7d                	push   $0x7d
  jmp alltraps
80106590:	e9 af f5 ff ff       	jmp    80105b44 <alltraps>

80106595 <vector126>:
.globl vector126
vector126:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $126
80106597:	6a 7e                	push   $0x7e
  jmp alltraps
80106599:	e9 a6 f5 ff ff       	jmp    80105b44 <alltraps>

8010659e <vector127>:
.globl vector127
vector127:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $127
801065a0:	6a 7f                	push   $0x7f
  jmp alltraps
801065a2:	e9 9d f5 ff ff       	jmp    80105b44 <alltraps>

801065a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $128
801065a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065ae:	e9 91 f5 ff ff       	jmp    80105b44 <alltraps>

801065b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $129
801065b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065ba:	e9 85 f5 ff ff       	jmp    80105b44 <alltraps>

801065bf <vector130>:
.globl vector130
vector130:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $130
801065c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065c6:	e9 79 f5 ff ff       	jmp    80105b44 <alltraps>

801065cb <vector131>:
.globl vector131
vector131:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $131
801065cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065d2:	e9 6d f5 ff ff       	jmp    80105b44 <alltraps>

801065d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $132
801065d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065de:	e9 61 f5 ff ff       	jmp    80105b44 <alltraps>

801065e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $133
801065e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065ea:	e9 55 f5 ff ff       	jmp    80105b44 <alltraps>

801065ef <vector134>:
.globl vector134
vector134:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $134
801065f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065f6:	e9 49 f5 ff ff       	jmp    80105b44 <alltraps>

801065fb <vector135>:
.globl vector135
vector135:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $135
801065fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106602:	e9 3d f5 ff ff       	jmp    80105b44 <alltraps>

80106607 <vector136>:
.globl vector136
vector136:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $136
80106609:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010660e:	e9 31 f5 ff ff       	jmp    80105b44 <alltraps>

80106613 <vector137>:
.globl vector137
vector137:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $137
80106615:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010661a:	e9 25 f5 ff ff       	jmp    80105b44 <alltraps>

8010661f <vector138>:
.globl vector138
vector138:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $138
80106621:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106626:	e9 19 f5 ff ff       	jmp    80105b44 <alltraps>

8010662b <vector139>:
.globl vector139
vector139:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $139
8010662d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106632:	e9 0d f5 ff ff       	jmp    80105b44 <alltraps>

80106637 <vector140>:
.globl vector140
vector140:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $140
80106639:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010663e:	e9 01 f5 ff ff       	jmp    80105b44 <alltraps>

80106643 <vector141>:
.globl vector141
vector141:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $141
80106645:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010664a:	e9 f5 f4 ff ff       	jmp    80105b44 <alltraps>

8010664f <vector142>:
.globl vector142
vector142:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $142
80106651:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106656:	e9 e9 f4 ff ff       	jmp    80105b44 <alltraps>

8010665b <vector143>:
.globl vector143
vector143:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $143
8010665d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106662:	e9 dd f4 ff ff       	jmp    80105b44 <alltraps>

80106667 <vector144>:
.globl vector144
vector144:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $144
80106669:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010666e:	e9 d1 f4 ff ff       	jmp    80105b44 <alltraps>

80106673 <vector145>:
.globl vector145
vector145:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $145
80106675:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010667a:	e9 c5 f4 ff ff       	jmp    80105b44 <alltraps>

8010667f <vector146>:
.globl vector146
vector146:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $146
80106681:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106686:	e9 b9 f4 ff ff       	jmp    80105b44 <alltraps>

8010668b <vector147>:
.globl vector147
vector147:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $147
8010668d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106692:	e9 ad f4 ff ff       	jmp    80105b44 <alltraps>

80106697 <vector148>:
.globl vector148
vector148:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $148
80106699:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010669e:	e9 a1 f4 ff ff       	jmp    80105b44 <alltraps>

801066a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $149
801066a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066aa:	e9 95 f4 ff ff       	jmp    80105b44 <alltraps>

801066af <vector150>:
.globl vector150
vector150:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $150
801066b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066b6:	e9 89 f4 ff ff       	jmp    80105b44 <alltraps>

801066bb <vector151>:
.globl vector151
vector151:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $151
801066bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066c2:	e9 7d f4 ff ff       	jmp    80105b44 <alltraps>

801066c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $152
801066c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066ce:	e9 71 f4 ff ff       	jmp    80105b44 <alltraps>

801066d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $153
801066d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066da:	e9 65 f4 ff ff       	jmp    80105b44 <alltraps>

801066df <vector154>:
.globl vector154
vector154:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $154
801066e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066e6:	e9 59 f4 ff ff       	jmp    80105b44 <alltraps>

801066eb <vector155>:
.globl vector155
vector155:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $155
801066ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066f2:	e9 4d f4 ff ff       	jmp    80105b44 <alltraps>

801066f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $156
801066f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066fe:	e9 41 f4 ff ff       	jmp    80105b44 <alltraps>

80106703 <vector157>:
.globl vector157
vector157:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $157
80106705:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010670a:	e9 35 f4 ff ff       	jmp    80105b44 <alltraps>

8010670f <vector158>:
.globl vector158
vector158:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $158
80106711:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106716:	e9 29 f4 ff ff       	jmp    80105b44 <alltraps>

8010671b <vector159>:
.globl vector159
vector159:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $159
8010671d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106722:	e9 1d f4 ff ff       	jmp    80105b44 <alltraps>

80106727 <vector160>:
.globl vector160
vector160:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $160
80106729:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010672e:	e9 11 f4 ff ff       	jmp    80105b44 <alltraps>

80106733 <vector161>:
.globl vector161
vector161:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $161
80106735:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010673a:	e9 05 f4 ff ff       	jmp    80105b44 <alltraps>

8010673f <vector162>:
.globl vector162
vector162:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $162
80106741:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106746:	e9 f9 f3 ff ff       	jmp    80105b44 <alltraps>

8010674b <vector163>:
.globl vector163
vector163:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $163
8010674d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106752:	e9 ed f3 ff ff       	jmp    80105b44 <alltraps>

80106757 <vector164>:
.globl vector164
vector164:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $164
80106759:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010675e:	e9 e1 f3 ff ff       	jmp    80105b44 <alltraps>

80106763 <vector165>:
.globl vector165
vector165:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $165
80106765:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010676a:	e9 d5 f3 ff ff       	jmp    80105b44 <alltraps>

8010676f <vector166>:
.globl vector166
vector166:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $166
80106771:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106776:	e9 c9 f3 ff ff       	jmp    80105b44 <alltraps>

8010677b <vector167>:
.globl vector167
vector167:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $167
8010677d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106782:	e9 bd f3 ff ff       	jmp    80105b44 <alltraps>

80106787 <vector168>:
.globl vector168
vector168:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $168
80106789:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010678e:	e9 b1 f3 ff ff       	jmp    80105b44 <alltraps>

80106793 <vector169>:
.globl vector169
vector169:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $169
80106795:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010679a:	e9 a5 f3 ff ff       	jmp    80105b44 <alltraps>

8010679f <vector170>:
.globl vector170
vector170:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $170
801067a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067a6:	e9 99 f3 ff ff       	jmp    80105b44 <alltraps>

801067ab <vector171>:
.globl vector171
vector171:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $171
801067ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067b2:	e9 8d f3 ff ff       	jmp    80105b44 <alltraps>

801067b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $172
801067b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067be:	e9 81 f3 ff ff       	jmp    80105b44 <alltraps>

801067c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $173
801067c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067ca:	e9 75 f3 ff ff       	jmp    80105b44 <alltraps>

801067cf <vector174>:
.globl vector174
vector174:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $174
801067d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067d6:	e9 69 f3 ff ff       	jmp    80105b44 <alltraps>

801067db <vector175>:
.globl vector175
vector175:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $175
801067dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067e2:	e9 5d f3 ff ff       	jmp    80105b44 <alltraps>

801067e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $176
801067e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067ee:	e9 51 f3 ff ff       	jmp    80105b44 <alltraps>

801067f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $177
801067f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067fa:	e9 45 f3 ff ff       	jmp    80105b44 <alltraps>

801067ff <vector178>:
.globl vector178
vector178:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $178
80106801:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106806:	e9 39 f3 ff ff       	jmp    80105b44 <alltraps>

8010680b <vector179>:
.globl vector179
vector179:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $179
8010680d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106812:	e9 2d f3 ff ff       	jmp    80105b44 <alltraps>

80106817 <vector180>:
.globl vector180
vector180:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $180
80106819:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010681e:	e9 21 f3 ff ff       	jmp    80105b44 <alltraps>

80106823 <vector181>:
.globl vector181
vector181:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $181
80106825:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010682a:	e9 15 f3 ff ff       	jmp    80105b44 <alltraps>

8010682f <vector182>:
.globl vector182
vector182:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $182
80106831:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106836:	e9 09 f3 ff ff       	jmp    80105b44 <alltraps>

8010683b <vector183>:
.globl vector183
vector183:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $183
8010683d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106842:	e9 fd f2 ff ff       	jmp    80105b44 <alltraps>

80106847 <vector184>:
.globl vector184
vector184:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $184
80106849:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010684e:	e9 f1 f2 ff ff       	jmp    80105b44 <alltraps>

80106853 <vector185>:
.globl vector185
vector185:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $185
80106855:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010685a:	e9 e5 f2 ff ff       	jmp    80105b44 <alltraps>

8010685f <vector186>:
.globl vector186
vector186:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $186
80106861:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106866:	e9 d9 f2 ff ff       	jmp    80105b44 <alltraps>

8010686b <vector187>:
.globl vector187
vector187:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $187
8010686d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106872:	e9 cd f2 ff ff       	jmp    80105b44 <alltraps>

80106877 <vector188>:
.globl vector188
vector188:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $188
80106879:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010687e:	e9 c1 f2 ff ff       	jmp    80105b44 <alltraps>

80106883 <vector189>:
.globl vector189
vector189:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $189
80106885:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010688a:	e9 b5 f2 ff ff       	jmp    80105b44 <alltraps>

8010688f <vector190>:
.globl vector190
vector190:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $190
80106891:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106896:	e9 a9 f2 ff ff       	jmp    80105b44 <alltraps>

8010689b <vector191>:
.globl vector191
vector191:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $191
8010689d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068a2:	e9 9d f2 ff ff       	jmp    80105b44 <alltraps>

801068a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $192
801068a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068ae:	e9 91 f2 ff ff       	jmp    80105b44 <alltraps>

801068b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $193
801068b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068ba:	e9 85 f2 ff ff       	jmp    80105b44 <alltraps>

801068bf <vector194>:
.globl vector194
vector194:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $194
801068c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068c6:	e9 79 f2 ff ff       	jmp    80105b44 <alltraps>

801068cb <vector195>:
.globl vector195
vector195:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $195
801068cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068d2:	e9 6d f2 ff ff       	jmp    80105b44 <alltraps>

801068d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $196
801068d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068de:	e9 61 f2 ff ff       	jmp    80105b44 <alltraps>

801068e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $197
801068e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068ea:	e9 55 f2 ff ff       	jmp    80105b44 <alltraps>

801068ef <vector198>:
.globl vector198
vector198:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $198
801068f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068f6:	e9 49 f2 ff ff       	jmp    80105b44 <alltraps>

801068fb <vector199>:
.globl vector199
vector199:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $199
801068fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106902:	e9 3d f2 ff ff       	jmp    80105b44 <alltraps>

80106907 <vector200>:
.globl vector200
vector200:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $200
80106909:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010690e:	e9 31 f2 ff ff       	jmp    80105b44 <alltraps>

80106913 <vector201>:
.globl vector201
vector201:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $201
80106915:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010691a:	e9 25 f2 ff ff       	jmp    80105b44 <alltraps>

8010691f <vector202>:
.globl vector202
vector202:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $202
80106921:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106926:	e9 19 f2 ff ff       	jmp    80105b44 <alltraps>

8010692b <vector203>:
.globl vector203
vector203:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $203
8010692d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106932:	e9 0d f2 ff ff       	jmp    80105b44 <alltraps>

80106937 <vector204>:
.globl vector204
vector204:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $204
80106939:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010693e:	e9 01 f2 ff ff       	jmp    80105b44 <alltraps>

80106943 <vector205>:
.globl vector205
vector205:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $205
80106945:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010694a:	e9 f5 f1 ff ff       	jmp    80105b44 <alltraps>

8010694f <vector206>:
.globl vector206
vector206:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $206
80106951:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106956:	e9 e9 f1 ff ff       	jmp    80105b44 <alltraps>

8010695b <vector207>:
.globl vector207
vector207:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $207
8010695d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106962:	e9 dd f1 ff ff       	jmp    80105b44 <alltraps>

80106967 <vector208>:
.globl vector208
vector208:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $208
80106969:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010696e:	e9 d1 f1 ff ff       	jmp    80105b44 <alltraps>

80106973 <vector209>:
.globl vector209
vector209:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $209
80106975:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010697a:	e9 c5 f1 ff ff       	jmp    80105b44 <alltraps>

8010697f <vector210>:
.globl vector210
vector210:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $210
80106981:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106986:	e9 b9 f1 ff ff       	jmp    80105b44 <alltraps>

8010698b <vector211>:
.globl vector211
vector211:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $211
8010698d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106992:	e9 ad f1 ff ff       	jmp    80105b44 <alltraps>

80106997 <vector212>:
.globl vector212
vector212:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $212
80106999:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010699e:	e9 a1 f1 ff ff       	jmp    80105b44 <alltraps>

801069a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $213
801069a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069aa:	e9 95 f1 ff ff       	jmp    80105b44 <alltraps>

801069af <vector214>:
.globl vector214
vector214:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $214
801069b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069b6:	e9 89 f1 ff ff       	jmp    80105b44 <alltraps>

801069bb <vector215>:
.globl vector215
vector215:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $215
801069bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069c2:	e9 7d f1 ff ff       	jmp    80105b44 <alltraps>

801069c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $216
801069c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069ce:	e9 71 f1 ff ff       	jmp    80105b44 <alltraps>

801069d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $217
801069d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069da:	e9 65 f1 ff ff       	jmp    80105b44 <alltraps>

801069df <vector218>:
.globl vector218
vector218:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $218
801069e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069e6:	e9 59 f1 ff ff       	jmp    80105b44 <alltraps>

801069eb <vector219>:
.globl vector219
vector219:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $219
801069ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069f2:	e9 4d f1 ff ff       	jmp    80105b44 <alltraps>

801069f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $220
801069f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069fe:	e9 41 f1 ff ff       	jmp    80105b44 <alltraps>

80106a03 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $221
80106a05:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a0a:	e9 35 f1 ff ff       	jmp    80105b44 <alltraps>

80106a0f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $222
80106a11:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a16:	e9 29 f1 ff ff       	jmp    80105b44 <alltraps>

80106a1b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $223
80106a1d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a22:	e9 1d f1 ff ff       	jmp    80105b44 <alltraps>

80106a27 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $224
80106a29:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a2e:	e9 11 f1 ff ff       	jmp    80105b44 <alltraps>

80106a33 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $225
80106a35:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a3a:	e9 05 f1 ff ff       	jmp    80105b44 <alltraps>

80106a3f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $226
80106a41:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a46:	e9 f9 f0 ff ff       	jmp    80105b44 <alltraps>

80106a4b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $227
80106a4d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a52:	e9 ed f0 ff ff       	jmp    80105b44 <alltraps>

80106a57 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $228
80106a59:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a5e:	e9 e1 f0 ff ff       	jmp    80105b44 <alltraps>

80106a63 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $229
80106a65:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a6a:	e9 d5 f0 ff ff       	jmp    80105b44 <alltraps>

80106a6f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $230
80106a71:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a76:	e9 c9 f0 ff ff       	jmp    80105b44 <alltraps>

80106a7b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $231
80106a7d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a82:	e9 bd f0 ff ff       	jmp    80105b44 <alltraps>

80106a87 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $232
80106a89:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a8e:	e9 b1 f0 ff ff       	jmp    80105b44 <alltraps>

80106a93 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $233
80106a95:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a9a:	e9 a5 f0 ff ff       	jmp    80105b44 <alltraps>

80106a9f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $234
80106aa1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106aa6:	e9 99 f0 ff ff       	jmp    80105b44 <alltraps>

80106aab <vector235>:
.globl vector235
vector235:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $235
80106aad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ab2:	e9 8d f0 ff ff       	jmp    80105b44 <alltraps>

80106ab7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $236
80106ab9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106abe:	e9 81 f0 ff ff       	jmp    80105b44 <alltraps>

80106ac3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $237
80106ac5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106aca:	e9 75 f0 ff ff       	jmp    80105b44 <alltraps>

80106acf <vector238>:
.globl vector238
vector238:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $238
80106ad1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ad6:	e9 69 f0 ff ff       	jmp    80105b44 <alltraps>

80106adb <vector239>:
.globl vector239
vector239:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $239
80106add:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ae2:	e9 5d f0 ff ff       	jmp    80105b44 <alltraps>

80106ae7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $240
80106ae9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106aee:	e9 51 f0 ff ff       	jmp    80105b44 <alltraps>

80106af3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $241
80106af5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106afa:	e9 45 f0 ff ff       	jmp    80105b44 <alltraps>

80106aff <vector242>:
.globl vector242
vector242:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $242
80106b01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b06:	e9 39 f0 ff ff       	jmp    80105b44 <alltraps>

80106b0b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $243
80106b0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b12:	e9 2d f0 ff ff       	jmp    80105b44 <alltraps>

80106b17 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $244
80106b19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b1e:	e9 21 f0 ff ff       	jmp    80105b44 <alltraps>

80106b23 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $245
80106b25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b2a:	e9 15 f0 ff ff       	jmp    80105b44 <alltraps>

80106b2f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $246
80106b31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b36:	e9 09 f0 ff ff       	jmp    80105b44 <alltraps>

80106b3b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $247
80106b3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b42:	e9 fd ef ff ff       	jmp    80105b44 <alltraps>

80106b47 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $248
80106b49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b4e:	e9 f1 ef ff ff       	jmp    80105b44 <alltraps>

80106b53 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $249
80106b55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b5a:	e9 e5 ef ff ff       	jmp    80105b44 <alltraps>

80106b5f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $250
80106b61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b66:	e9 d9 ef ff ff       	jmp    80105b44 <alltraps>

80106b6b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $251
80106b6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b72:	e9 cd ef ff ff       	jmp    80105b44 <alltraps>

80106b77 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $252
80106b79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b7e:	e9 c1 ef ff ff       	jmp    80105b44 <alltraps>

80106b83 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $253
80106b85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b8a:	e9 b5 ef ff ff       	jmp    80105b44 <alltraps>

80106b8f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $254
80106b91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b96:	e9 a9 ef ff ff       	jmp    80105b44 <alltraps>

80106b9b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $255
80106b9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ba2:	e9 9d ef ff ff       	jmp    80105b44 <alltraps>
80106ba7:	66 90                	xchg   %ax,%ax
80106ba9:	66 90                	xchg   %ax,%ax
80106bab:	66 90                	xchg   %ax,%ax
80106bad:	66 90                	xchg   %ax,%ax
80106baf:	66 90                	xchg   %ax,%ax
80106bb1:	66 90                	xchg   %ax,%ax
80106bb3:	66 90                	xchg   %ax,%ax
80106bb5:	66 90                	xchg   %ax,%ax
80106bb7:	66 90                	xchg   %ax,%ax
80106bb9:	66 90                	xchg   %ax,%ax
80106bbb:	66 90                	xchg   %ax,%ax
80106bbd:	66 90                	xchg   %ax,%ax
80106bbf:	90                   	nop

80106bc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bc6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106bcc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106bd5:	39 d3                	cmp    %edx,%ebx
80106bd7:	73 6c                	jae    80106c45 <deallocuvm.part.0+0x85>
80106bd9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106bdc:	89 c6                	mov    %eax,%esi
80106bde:	89 d7                	mov    %edx,%edi
80106be0:	eb 28                	jmp    80106c0a <deallocuvm.part.0+0x4a>
80106be2:	eb 1c                	jmp    80106c00 <deallocuvm.part.0+0x40>
80106be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106be8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bef:	00 
80106bf0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bf7:	00 
80106bf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bff:	00 
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c00:	8d 5a 01             	lea    0x1(%edx),%ebx
80106c03:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c06:	39 fb                	cmp    %edi,%ebx
80106c08:	73 38                	jae    80106c42 <deallocuvm.part.0+0x82>
  pde = &pgdir[PDX(va)];
80106c0a:	89 da                	mov    %ebx,%edx
80106c0c:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c0f:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106c12:	a8 01                	test   $0x1,%al
80106c14:	74 ea                	je     80106c00 <deallocuvm.part.0+0x40>
  return &pgtab[PTX(va)];
80106c16:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c1d:	c1 e9 0a             	shr    $0xa,%ecx
80106c20:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106c26:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106c2d:	85 c0                	test   %eax,%eax
80106c2f:	74 cf                	je     80106c00 <deallocuvm.part.0+0x40>
    else if((*pte & PTE_P) != 0){
80106c31:	8b 10                	mov    (%eax),%edx
80106c33:	f6 c2 01             	test   $0x1,%dl
80106c36:	75 18                	jne    80106c50 <deallocuvm.part.0+0x90>
  for(; a  < oldsz; a += PGSIZE){
80106c38:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c3e:	39 fb                	cmp    %edi,%ebx
80106c40:	72 c8                	jb     80106c0a <deallocuvm.part.0+0x4a>
80106c42:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c48:	89 c8                	mov    %ecx,%eax
80106c4a:	5b                   	pop    %ebx
80106c4b:	5e                   	pop    %esi
80106c4c:	5f                   	pop    %edi
80106c4d:	5d                   	pop    %ebp
80106c4e:	c3                   	ret
80106c4f:	90                   	nop
      if(pa == 0)
80106c50:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c56:	74 26                	je     80106c7e <deallocuvm.part.0+0xbe>
      kfree(v);
80106c58:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c5b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c64:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106c6a:	52                   	push   %edx
80106c6b:	e8 50 b9 ff ff       	call   801025c0 <kfree>
      *pte = 0;
80106c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106c73:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106c76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106c7c:	eb 88                	jmp    80106c06 <deallocuvm.part.0+0x46>
        panic("kfree");
80106c7e:	83 ec 0c             	sub    $0xc,%esp
80106c81:	68 4c 77 10 80       	push   $0x8010774c
80106c86:	e8 15 97 ff ff       	call   801003a0 <panic>
80106c8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106c90 <mappages>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c94:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
{
80106c98:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c99:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80106c9f:	89 c6                	mov    %eax,%esi
{
80106ca1:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ca2:	89 d3                	mov    %edx,%ebx
80106ca4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106caa:	83 ec 1c             	sub    $0x1c,%esp
80106cad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cb0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106cb3:	29 d9                	sub    %ebx,%ecx
80106cb5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106cb8:	eb 42                	jmp    80106cfc <mappages+0x6c>
80106cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106cc0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cc7:	c1 ea 0a             	shr    $0xa,%edx
80106cca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106cd0:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106cd7:	85 d2                	test   %edx,%edx
80106cd9:	74 6d                	je     80106d48 <mappages+0xb8>
    if(*pte & PTE_P)
80106cdb:	f6 02 01             	testb  $0x1,(%edx)
80106cde:	0f 85 7e 00 00 00    	jne    80106d62 <mappages+0xd2>
    *pte = pa | perm | PTE_P;
80106ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ce7:	01 d8                	add    %ebx,%eax
80106ce9:	0b 45 0c             	or     0xc(%ebp),%eax
80106cec:	83 c8 01             	or     $0x1,%eax
80106cef:	89 02                	mov    %eax,(%edx)
    if(a == last)
80106cf1:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80106cf4:	74 62                	je     80106d58 <mappages+0xc8>
    a += PGSIZE;
80106cf6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pde = &pgdir[PDX(va)];
80106cfc:	89 d8                	mov    %ebx,%eax
80106cfe:	c1 e8 16             	shr    $0x16,%eax
80106d01:	8d 3c 86             	lea    (%esi,%eax,4),%edi
  if(*pde & PTE_P){
80106d04:	8b 07                	mov    (%edi),%eax
80106d06:	a8 01                	test   $0x1,%al
80106d08:	75 b6                	jne    80106cc0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d0a:	e8 81 ba ff ff       	call   80102790 <kalloc>
80106d0f:	85 c0                	test   %eax,%eax
80106d11:	74 35                	je     80106d48 <mappages+0xb8>
    memset(pgtab, 0, PGSIZE);
80106d13:	83 ec 04             	sub    $0x4,%esp
80106d16:	68 00 10 00 00       	push   $0x1000
80106d1b:	6a 00                	push   $0x0
80106d1d:	50                   	push   %eax
80106d1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d21:	e8 5a dc ff ff       	call   80104980 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
80106d29:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d2c:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d32:	83 c8 07             	or     $0x7,%eax
80106d35:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d37:	89 d8                	mov    %ebx,%eax
80106d39:	c1 e8 0a             	shr    $0xa,%eax
80106d3c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d41:	01 c2                	add    %eax,%edx
80106d43:	eb 96                	jmp    80106cdb <mappages+0x4b>
80106d45:	8d 76 00             	lea    0x0(%esi),%esi
}
80106d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d50:	5b                   	pop    %ebx
80106d51:	5e                   	pop    %esi
80106d52:	5f                   	pop    %edi
80106d53:	5d                   	pop    %ebp
80106d54:	c3                   	ret
80106d55:	8d 76 00             	lea    0x0(%esi),%esi
80106d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d5b:	31 c0                	xor    %eax,%eax
}
80106d5d:	5b                   	pop    %ebx
80106d5e:	5e                   	pop    %esi
80106d5f:	5f                   	pop    %edi
80106d60:	5d                   	pop    %ebp
80106d61:	c3                   	ret
      panic("remap");
80106d62:	83 ec 0c             	sub    $0xc,%esp
80106d65:	68 b4 79 10 80       	push   $0x801079b4
80106d6a:	e8 31 96 ff ff       	call   801003a0 <panic>
80106d6f:	90                   	nop

80106d70 <seginit>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d76:	e8 a5 cd ff ff       	call   80103b20 <cpuid>
  pd[0] = size-1;
80106d7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d86:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106d8d:	ff 00 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d90:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106d97:	ff 00 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d9a:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106da1:	ff 00 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106da4:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106dab:	ff 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106dae:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106db5:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106db8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106dbf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106dc2:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106dc9:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dcc:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106dd3:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dd6:	05 10 18 11 80       	add    $0x80111810,%eax
80106ddb:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106ddf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106de3:	c1 e8 10             	shr    $0x10,%eax
80106de6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ded:	0f 01 10             	lgdtl  (%eax)
}
80106df0:	c9                   	leave
80106df1:	c3                   	ret
80106df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dff:	00 

80106e00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e00:	a1 c4 46 11 80       	mov    0x801146c4,%eax
80106e05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e0a:	0f 22 d8             	mov    %eax,%cr3
}
80106e0d:	c3                   	ret
80106e0e:	66 90                	xchg   %ax,%ax

80106e10 <switchuvm>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 1c             	sub    $0x1c,%esp
80106e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106e1c:	85 db                	test   %ebx,%ebx
80106e1e:	0f 84 c9 00 00 00    	je     80106eed <switchuvm+0xdd>
  if(p->kstack == 0)
80106e24:	8b 43 08             	mov    0x8(%ebx),%eax
80106e27:	85 c0                	test   %eax,%eax
80106e29:	0f 84 d8 00 00 00    	je     80106f07 <switchuvm+0xf7>
  if(p->pgdir == 0)
80106e2f:	8b 43 04             	mov    0x4(%ebx),%eax
80106e32:	85 c0                	test   %eax,%eax
80106e34:	0f 84 c0 00 00 00    	je     80106efa <switchuvm+0xea>
  pushcli();
80106e3a:	e8 c1 d8 ff ff       	call   80104700 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e3f:	e8 5c cc ff ff       	call   80103aa0 <mycpu>
80106e44:	89 c6                	mov    %eax,%esi
80106e46:	e8 55 cc ff ff       	call   80103aa0 <mycpu>
80106e4b:	8d 78 08             	lea    0x8(%eax),%edi
80106e4e:	e8 4d cc ff ff       	call   80103aa0 <mycpu>
80106e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e56:	e8 45 cc ff ff       	call   80103aa0 <mycpu>
80106e5b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e5e:	ba 67 00 00 00       	mov    $0x67,%edx
80106e63:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e6a:	83 c0 08             	add    $0x8,%eax
80106e6d:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e74:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e79:	83 c1 08             	add    $0x8,%ecx
80106e7c:	c1 e8 18             	shr    $0x18,%eax
80106e7f:	c1 e9 10             	shr    $0x10,%ecx
80106e82:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106e88:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106e8e:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e93:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e9a:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e9f:	e8 fc cb ff ff       	call   80103aa0 <mycpu>
80106ea4:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106eab:	e8 f0 cb ff ff       	call   80103aa0 <mycpu>
80106eb0:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106eb4:	8b 73 08             	mov    0x8(%ebx),%esi
80106eb7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ebd:	e8 de cb ff ff       	call   80103aa0 <mycpu>
80106ec2:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ec5:	e8 d6 cb ff ff       	call   80103aa0 <mycpu>
80106eca:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ece:	b8 28 00 00 00       	mov    $0x28,%eax
80106ed3:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ed6:	8b 43 04             	mov    0x4(%ebx),%eax
80106ed9:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ede:	0f 22 d8             	mov    %eax,%cr3
}
80106ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ee4:	5b                   	pop    %ebx
80106ee5:	5e                   	pop    %esi
80106ee6:	5f                   	pop    %edi
80106ee7:	5d                   	pop    %ebp
  popcli();
80106ee8:	e9 63 d8 ff ff       	jmp    80104750 <popcli>
    panic("switchuvm: no process");
80106eed:	83 ec 0c             	sub    $0xc,%esp
80106ef0:	68 ba 79 10 80       	push   $0x801079ba
80106ef5:	e8 a6 94 ff ff       	call   801003a0 <panic>
    panic("switchuvm: no pgdir");
80106efa:	83 ec 0c             	sub    $0xc,%esp
80106efd:	68 e5 79 10 80       	push   $0x801079e5
80106f02:	e8 99 94 ff ff       	call   801003a0 <panic>
    panic("switchuvm: no kstack");
80106f07:	83 ec 0c             	sub    $0xc,%esp
80106f0a:	68 d0 79 10 80       	push   $0x801079d0
80106f0f:	e8 8c 94 ff ff       	call   801003a0 <panic>
80106f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f1f:	00 

80106f20 <inituvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106f2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f3b:	77 49                	ja     80106f86 <inituvm+0x66>
  mem = kalloc();
80106f3d:	e8 4e b8 ff ff       	call   80102790 <kalloc>
  memset(mem, 0, PGSIZE);
80106f42:	83 ec 04             	sub    $0x4,%esp
80106f45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106f4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f4c:	6a 00                	push   $0x0
80106f4e:	50                   	push   %eax
80106f4f:	e8 2c da ff ff       	call   80104980 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f54:	58                   	pop    %eax
80106f55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f5b:	5a                   	pop    %edx
80106f5c:	6a 06                	push   $0x6
80106f5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f63:	31 d2                	xor    %edx,%edx
80106f65:	50                   	push   %eax
80106f66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f69:	e8 22 fd ff ff       	call   80106c90 <mappages>
  memmove(mem, init, sz);
80106f6e:	83 c4 10             	add    $0x10,%esp
80106f71:	89 75 10             	mov    %esi,0x10(%ebp)
80106f74:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f7d:	5b                   	pop    %ebx
80106f7e:	5e                   	pop    %esi
80106f7f:	5f                   	pop    %edi
80106f80:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f81:	e9 8a da ff ff       	jmp    80104a10 <memmove>
    panic("inituvm: more than a page");
80106f86:	83 ec 0c             	sub    $0xc,%esp
80106f89:	68 f9 79 10 80       	push   $0x801079f9
80106f8e:	e8 0d 94 ff ff       	call   801003a0 <panic>
80106f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f9f:	00 

80106fa0 <loaduvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106fa9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106fac:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106faf:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106fb5:	0f 85 a2 00 00 00    	jne    8010705d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106fbb:	85 ff                	test   %edi,%edi
80106fbd:	74 7d                	je     8010703c <loaduvm+0x9c>
80106fbf:	90                   	nop
  pde = &pgdir[PDX(va)];
80106fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106fc3:	8b 55 08             	mov    0x8(%ebp),%edx
80106fc6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106fc8:	89 c1                	mov    %eax,%ecx
80106fca:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106fcd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106fd0:	f6 c1 01             	test   $0x1,%cl
80106fd3:	75 13                	jne    80106fe8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106fd5:	83 ec 0c             	sub    $0xc,%esp
80106fd8:	68 13 7a 10 80       	push   $0x80107a13
80106fdd:	e8 be 93 ff ff       	call   801003a0 <panic>
80106fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fe8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106feb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106ff1:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ff6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ffd:	85 c9                	test   %ecx,%ecx
80106fff:	74 d4                	je     80106fd5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107001:	89 fb                	mov    %edi,%ebx
80107003:	b8 00 10 00 00       	mov    $0x1000,%eax
80107008:	29 f3                	sub    %esi,%ebx
8010700a:	39 c3                	cmp    %eax,%ebx
8010700c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010700f:	53                   	push   %ebx
80107010:	8b 45 14             	mov    0x14(%ebp),%eax
80107013:	01 f0                	add    %esi,%eax
80107015:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107016:	8b 01                	mov    (%ecx),%eax
80107018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010701d:	05 00 00 00 80       	add    $0x80000000,%eax
80107022:	50                   	push   %eax
80107023:	ff 75 10             	push   0x10(%ebp)
80107026:	e8 65 ab ff ff       	call   80101b90 <readi>
8010702b:	83 c4 10             	add    $0x10,%esp
8010702e:	39 d8                	cmp    %ebx,%eax
80107030:	75 1e                	jne    80107050 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107032:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107038:	39 fe                	cmp    %edi,%esi
8010703a:	72 84                	jb     80106fc0 <loaduvm+0x20>
}
8010703c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010703f:	31 c0                	xor    %eax,%eax
}
80107041:	5b                   	pop    %ebx
80107042:	5e                   	pop    %esi
80107043:	5f                   	pop    %edi
80107044:	5d                   	pop    %ebp
80107045:	c3                   	ret
80107046:	66 90                	xchg   %ax,%ax
80107048:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010704f:	00 
80107050:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107053:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107058:	5b                   	pop    %ebx
80107059:	5e                   	pop    %esi
8010705a:	5f                   	pop    %edi
8010705b:	5d                   	pop    %ebp
8010705c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010705d:	83 ec 0c             	sub    $0xc,%esp
80107060:	68 14 7c 10 80       	push   $0x80107c14
80107065:	e8 36 93 ff ff       	call   801003a0 <panic>
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107070 <allocuvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 1c             	sub    $0x1c,%esp
80107079:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010707c:	85 f6                	test   %esi,%esi
8010707e:	0f 88 99 00 00 00    	js     8010711d <allocuvm+0xad>
80107084:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107086:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107089:	0f 82 a1 00 00 00    	jb     80107130 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010708f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107092:	05 ff 0f 00 00       	add    $0xfff,%eax
80107097:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010709c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010709e:	39 f0                	cmp    %esi,%eax
801070a0:	0f 83 8d 00 00 00    	jae    80107133 <allocuvm+0xc3>
801070a6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801070a9:	eb 45                	jmp    801070f0 <allocuvm+0x80>
801070ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801070b0:	83 ec 04             	sub    $0x4,%esp
801070b3:	68 00 10 00 00       	push   $0x1000
801070b8:	6a 00                	push   $0x0
801070ba:	50                   	push   %eax
801070bb:	e8 c0 d8 ff ff       	call   80104980 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070c0:	58                   	pop    %eax
801070c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070c7:	5a                   	pop    %edx
801070c8:	6a 06                	push   $0x6
801070ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070cf:	89 fa                	mov    %edi,%edx
801070d1:	50                   	push   %eax
801070d2:	8b 45 08             	mov    0x8(%ebp),%eax
801070d5:	e8 b6 fb ff ff       	call   80106c90 <mappages>
801070da:	83 c4 10             	add    $0x10,%esp
801070dd:	83 f8 ff             	cmp    $0xffffffff,%eax
801070e0:	74 5e                	je     80107140 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801070e2:	81 c7 00 10 00 00    	add    $0x1000,%edi
801070e8:	39 f7                	cmp    %esi,%edi
801070ea:	0f 83 88 00 00 00    	jae    80107178 <allocuvm+0x108>
    mem = kalloc();
801070f0:	e8 9b b6 ff ff       	call   80102790 <kalloc>
801070f5:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801070f7:	85 c0                	test   %eax,%eax
801070f9:	75 b5                	jne    801070b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070fb:	83 ec 0c             	sub    $0xc,%esp
801070fe:	68 31 7a 10 80       	push   $0x80107a31
80107103:	e8 c8 95 ff ff       	call   801006d0 <cprintf>
  if(newsz >= oldsz)
80107108:	83 c4 10             	add    $0x10,%esp
8010710b:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010710e:	74 0d                	je     8010711d <allocuvm+0xad>
80107110:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107113:	8b 45 08             	mov    0x8(%ebp),%eax
80107116:	89 f2                	mov    %esi,%edx
80107118:	e8 a3 fa ff ff       	call   80106bc0 <deallocuvm.part.0>
    return 0;
8010711d:	31 d2                	xor    %edx,%edx
}
8010711f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107122:	89 d0                	mov    %edx,%eax
80107124:	5b                   	pop    %ebx
80107125:	5e                   	pop    %esi
80107126:	5f                   	pop    %edi
80107127:	5d                   	pop    %ebp
80107128:	c3                   	ret
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107130:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107136:	89 d0                	mov    %edx,%eax
80107138:	5b                   	pop    %ebx
80107139:	5e                   	pop    %esi
8010713a:	5f                   	pop    %edi
8010713b:	5d                   	pop    %ebp
8010713c:	c3                   	ret
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107140:	83 ec 0c             	sub    $0xc,%esp
80107143:	68 49 7a 10 80       	push   $0x80107a49
80107148:	e8 83 95 ff ff       	call   801006d0 <cprintf>
  if(newsz >= oldsz)
8010714d:	83 c4 10             	add    $0x10,%esp
80107150:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107153:	74 0d                	je     80107162 <allocuvm+0xf2>
80107155:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107158:	8b 45 08             	mov    0x8(%ebp),%eax
8010715b:	89 f2                	mov    %esi,%edx
8010715d:	e8 5e fa ff ff       	call   80106bc0 <deallocuvm.part.0>
      kfree(mem);
80107162:	83 ec 0c             	sub    $0xc,%esp
80107165:	53                   	push   %ebx
80107166:	e8 55 b4 ff ff       	call   801025c0 <kfree>
      return 0;
8010716b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010716e:	31 d2                	xor    %edx,%edx
80107170:	eb ad                	jmp    8010711f <allocuvm+0xaf>
80107172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107178:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010717b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010717e:	5b                   	pop    %ebx
8010717f:	5e                   	pop    %esi
80107180:	89 d0                	mov    %edx,%eax
80107182:	5f                   	pop    %edi
80107183:	5d                   	pop    %ebp
80107184:	c3                   	ret
80107185:	8d 76 00             	lea    0x0(%esi),%esi
80107188:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010718f:	00 

80107190 <deallocuvm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	8b 55 0c             	mov    0xc(%ebp),%edx
80107196:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107199:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010719c:	39 d1                	cmp    %edx,%ecx
8010719e:	73 10                	jae    801071b0 <deallocuvm+0x20>
}
801071a0:	5d                   	pop    %ebp
801071a1:	e9 1a fa ff ff       	jmp    80106bc0 <deallocuvm.part.0>
801071a6:	66 90                	xchg   %ax,%ax
801071a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071af:	00 
801071b0:	89 d0                	mov    %edx,%eax
801071b2:	5d                   	pop    %ebp
801071b3:	c3                   	ret
801071b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071bf:	00 

801071c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 0c             	sub    $0xc,%esp
801071c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071cc:	85 f6                	test   %esi,%esi
801071ce:	74 59                	je     80107229 <freevm+0x69>
  if(newsz >= oldsz)
801071d0:	31 c9                	xor    %ecx,%ecx
801071d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071d7:	89 f0                	mov    %esi,%eax
801071d9:	89 f3                	mov    %esi,%ebx
801071db:	e8 e0 f9 ff ff       	call   80106bc0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071e6:	eb 0f                	jmp    801071f7 <freevm+0x37>
801071e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ef:	00 
801071f0:	83 c3 04             	add    $0x4,%ebx
801071f3:	39 fb                	cmp    %edi,%ebx
801071f5:	74 23                	je     8010721a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071f7:	8b 03                	mov    (%ebx),%eax
801071f9:	a8 01                	test   $0x1,%al
801071fb:	74 f3                	je     801071f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107202:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107205:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107208:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010720d:	50                   	push   %eax
8010720e:	e8 ad b3 ff ff       	call   801025c0 <kfree>
80107213:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107216:	39 fb                	cmp    %edi,%ebx
80107218:	75 dd                	jne    801071f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010721a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010721d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107220:	5b                   	pop    %ebx
80107221:	5e                   	pop    %esi
80107222:	5f                   	pop    %edi
80107223:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107224:	e9 97 b3 ff ff       	jmp    801025c0 <kfree>
    panic("freevm: no pgdir");
80107229:	83 ec 0c             	sub    $0xc,%esp
8010722c:	68 65 7a 10 80       	push   $0x80107a65
80107231:	e8 6a 91 ff ff       	call   801003a0 <panic>
80107236:	66 90                	xchg   %ax,%ax
80107238:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010723f:	00 

80107240 <setupkvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	56                   	push   %esi
80107244:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107245:	e8 46 b5 ff ff       	call   80102790 <kalloc>
8010724a:	85 c0                	test   %eax,%eax
8010724c:	74 5e                	je     801072ac <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010724e:	83 ec 04             	sub    $0x4,%esp
80107251:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107253:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107258:	68 00 10 00 00       	push   $0x1000
8010725d:	6a 00                	push   $0x0
8010725f:	50                   	push   %eax
80107260:	e8 1b d7 ff ff       	call   80104980 <memset>
80107265:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107268:	8b 43 04             	mov    0x4(%ebx),%eax
8010726b:	83 ec 08             	sub    $0x8,%esp
8010726e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107271:	8b 13                	mov    (%ebx),%edx
80107273:	ff 73 0c             	push   0xc(%ebx)
80107276:	50                   	push   %eax
80107277:	29 c1                	sub    %eax,%ecx
80107279:	89 f0                	mov    %esi,%eax
8010727b:	e8 10 fa ff ff       	call   80106c90 <mappages>
80107280:	83 c4 10             	add    $0x10,%esp
80107283:	83 f8 ff             	cmp    $0xffffffff,%eax
80107286:	74 18                	je     801072a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107288:	83 c3 10             	add    $0x10,%ebx
8010728b:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107291:	75 d5                	jne    80107268 <setupkvm+0x28>
}
80107293:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107296:	89 f0                	mov    %esi,%eax
80107298:	5b                   	pop    %ebx
80107299:	5e                   	pop    %esi
8010729a:	5d                   	pop    %ebp
8010729b:	c3                   	ret
8010729c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801072a0:	83 ec 0c             	sub    $0xc,%esp
801072a3:	56                   	push   %esi
801072a4:	e8 17 ff ff ff       	call   801071c0 <freevm>
      return 0;
801072a9:	83 c4 10             	add    $0x10,%esp
}
801072ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801072af:	31 f6                	xor    %esi,%esi
}
801072b1:	89 f0                	mov    %esi,%eax
801072b3:	5b                   	pop    %ebx
801072b4:	5e                   	pop    %esi
801072b5:	5d                   	pop    %ebp
801072b6:	c3                   	ret
801072b7:	90                   	nop
801072b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072bf:	00 

801072c0 <kvmalloc>:
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072c6:	e8 75 ff ff ff       	call   80107240 <setupkvm>
801072cb:	a3 c4 46 11 80       	mov    %eax,0x801146c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072d0:	05 00 00 00 80       	add    $0x80000000,%eax
801072d5:	0f 22 d8             	mov    %eax,%cr3
}
801072d8:	c9                   	leave
801072d9:	c3                   	ret
801072da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	83 ec 08             	sub    $0x8,%esp
801072e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072e9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072ec:	89 c1                	mov    %eax,%ecx
801072ee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072f4:	f6 c2 01             	test   $0x1,%dl
801072f7:	75 17                	jne    80107310 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801072f9:	83 ec 0c             	sub    $0xc,%esp
801072fc:	68 76 7a 10 80       	push   $0x80107a76
80107301:	e8 9a 90 ff ff       	call   801003a0 <panic>
80107306:	66 90                	xchg   %ax,%ax
80107308:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010730f:	00 
  return &pgtab[PTX(va)];
80107310:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107313:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107319:	25 fc 0f 00 00       	and    $0xffc,%eax
8010731e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107325:	85 c0                	test   %eax,%eax
80107327:	74 d0                	je     801072f9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107329:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010732c:	c9                   	leave
8010732d:	c3                   	ret
8010732e:	66 90                	xchg   %ax,%ax

80107330 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107339:	e8 02 ff ff ff       	call   80107240 <setupkvm>
8010733e:	85 c0                	test   %eax,%eax
80107340:	0f 84 e1 00 00 00    	je     80107427 <copyuvm+0xf7>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107346:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107349:	89 c2                	mov    %eax,%edx
8010734b:	85 c9                	test   %ecx,%ecx
8010734d:	0f 84 b5 00 00 00    	je     80107408 <copyuvm+0xd8>
80107353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107356:	31 ff                	xor    %edi,%edi
80107358:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010735f:	00 
  if(*pde & PTE_P){
80107360:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107363:	89 f8                	mov    %edi,%eax
80107365:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107368:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010736b:	a8 01                	test   $0x1,%al
8010736d:	75 11                	jne    80107380 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010736f:	83 ec 0c             	sub    $0xc,%esp
80107372:	68 80 7a 10 80       	push   $0x80107a80
80107377:	e8 24 90 ff ff       	call   801003a0 <panic>
8010737c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107380:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107387:	c1 ea 0a             	shr    $0xa,%edx
8010738a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107390:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107397:	85 c0                	test   %eax,%eax
80107399:	74 d4                	je     8010736f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010739b:	8b 30                	mov    (%eax),%esi
8010739d:	f7 c6 01 00 00 00    	test   $0x1,%esi
801073a3:	0f 84 98 00 00 00    	je     80107441 <copyuvm+0x111>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801073a9:	e8 e2 b3 ff ff       	call   80102790 <kalloc>
801073ae:	89 c3                	mov    %eax,%ebx
801073b0:	85 c0                	test   %eax,%eax
801073b2:	74 64                	je     80107418 <copyuvm+0xe8>
    pa = PTE_ADDR(*pte);
801073b4:	89 f0                	mov    %esi,%eax
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801073b6:	83 ec 04             	sub    $0x4,%esp
    flags = PTE_FLAGS(*pte);
801073b9:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
    pa = PTE_ADDR(*pte);
801073bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    memmove(mem, (char*)P2V(pa), PGSIZE);
801073c4:	68 00 10 00 00       	push   $0x1000
801073c9:	05 00 00 00 80       	add    $0x80000000,%eax
801073ce:	50                   	push   %eax
801073cf:	53                   	push   %ebx
801073d0:	e8 3b d6 ff ff       	call   80104a10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801073d5:	58                   	pop    %eax
801073d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073dc:	5a                   	pop    %edx
801073dd:	56                   	push   %esi
801073de:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073e3:	89 fa                	mov    %edi,%edx
801073e5:	50                   	push   %eax
801073e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073e9:	e8 a2 f8 ff ff       	call   80106c90 <mappages>
801073ee:	83 c4 10             	add    $0x10,%esp
801073f1:	83 f8 ff             	cmp    $0xffffffff,%eax
801073f4:	74 3a                	je     80107430 <copyuvm+0x100>
  for(i = 0; i < sz; i += PGSIZE){
801073f6:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073fc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801073ff:	0f 82 5b ff ff ff    	jb     80107360 <copyuvm+0x30>
80107405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  return d;

bad:
  freevm(d);
  return 0;
}
80107408:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010740b:	89 d0                	mov    %edx,%eax
8010740d:	5b                   	pop    %ebx
8010740e:	5e                   	pop    %esi
8010740f:	5f                   	pop    %edi
80107410:	5d                   	pop    %ebp
80107411:	c3                   	ret
80107412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107418:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  freevm(d);
8010741b:	83 ec 0c             	sub    $0xc,%esp
8010741e:	52                   	push   %edx
8010741f:	e8 9c fd ff ff       	call   801071c0 <freevm>
  return 0;
80107424:	83 c4 10             	add    $0x10,%esp
    return 0;
80107427:	31 d2                	xor    %edx,%edx
80107429:	eb dd                	jmp    80107408 <copyuvm+0xd8>
8010742b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107430:	83 ec 0c             	sub    $0xc,%esp
80107433:	53                   	push   %ebx
80107434:	e8 87 b1 ff ff       	call   801025c0 <kfree>
      goto bad;
80107439:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010743c:	83 c4 10             	add    $0x10,%esp
8010743f:	eb da                	jmp    8010741b <copyuvm+0xeb>
      panic("copyuvm: page not present");
80107441:	83 ec 0c             	sub    $0xc,%esp
80107444:	68 9a 7a 10 80       	push   $0x80107a9a
80107449:	e8 52 8f ff ff       	call   801003a0 <panic>
8010744e:	66 90                	xchg   %ax,%ax

80107450 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107456:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107459:	89 c1                	mov    %eax,%ecx
8010745b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010745e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107461:	f6 c2 01             	test   $0x1,%dl
80107464:	0f 84 f0 00 00 00    	je     8010755a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010746a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010746d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107473:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107474:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107479:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107480:	89 d0                	mov    %edx,%eax
80107482:	f7 d2                	not    %edx
80107484:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107489:	05 00 00 00 80       	add    $0x80000000,%eax
8010748e:	83 e2 05             	and    $0x5,%edx
80107491:	ba 00 00 00 00       	mov    $0x0,%edx
80107496:	0f 45 c2             	cmovne %edx,%eax
}
80107499:	c3                   	ret
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	53                   	push   %ebx
801074a6:	83 ec 0c             	sub    $0xc,%esp
801074a9:	8b 75 14             	mov    0x14(%ebp),%esi
801074ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074af:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801074b2:	85 f6                	test   %esi,%esi
801074b4:	75 49                	jne    801074ff <copyout+0x5f>
801074b6:	e9 95 00 00 00       	jmp    80107550 <copyout+0xb0>
801074bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801074c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801074c5:	05 00 00 00 80       	add    $0x80000000,%eax
801074ca:	74 6e                	je     8010753a <copyout+0x9a>
      return -1;
    n = PGSIZE - (va - va0);
801074cc:	89 fb                	mov    %edi,%ebx
801074ce:	29 cb                	sub    %ecx,%ebx
801074d0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801074d6:	39 f3                	cmp    %esi,%ebx
801074d8:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074db:	29 f9                	sub    %edi,%ecx
801074dd:	83 ec 04             	sub    $0x4,%esp
801074e0:	01 c8                	add    %ecx,%eax
801074e2:	53                   	push   %ebx
801074e3:	52                   	push   %edx
801074e4:	89 55 10             	mov    %edx,0x10(%ebp)
801074e7:	50                   	push   %eax
801074e8:	e8 23 d5 ff ff       	call   80104a10 <memmove>
    len -= n;
    buf += n;
801074ed:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801074f0:	8d 8f 00 10 00 00    	lea    0x1000(%edi),%ecx
  while(len > 0){
801074f6:	83 c4 10             	add    $0x10,%esp
    buf += n;
801074f9:	01 da                	add    %ebx,%edx
  while(len > 0){
801074fb:	29 de                	sub    %ebx,%esi
801074fd:	74 51                	je     80107550 <copyout+0xb0>
  if(*pde & PTE_P){
801074ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107502:	89 c8                	mov    %ecx,%eax
    va0 = (uint)PGROUNDDOWN(va);
80107504:	89 cf                	mov    %ecx,%edi
  pde = &pgdir[PDX(va)];
80107506:	c1 e8 16             	shr    $0x16,%eax
    va0 = (uint)PGROUNDDOWN(va);
80107509:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
8010750f:	8b 04 83             	mov    (%ebx,%eax,4),%eax
80107512:	a8 01                	test   $0x1,%al
80107514:	0f 84 47 00 00 00    	je     80107561 <copyout.cold>
  return &pgtab[PTX(va)];
8010751a:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010751c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107521:	c1 eb 0c             	shr    $0xc,%ebx
80107524:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
8010752a:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
  if((*pte & PTE_U) == 0)
80107531:	89 c3                	mov    %eax,%ebx
80107533:	f7 d3                	not    %ebx
80107535:	83 e3 05             	and    $0x5,%ebx
80107538:	74 86                	je     801074c0 <copyout+0x20>
  }
  return 0;
}
8010753a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010753d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107542:	5b                   	pop    %ebx
80107543:	5e                   	pop    %esi
80107544:	5f                   	pop    %edi
80107545:	5d                   	pop    %ebp
80107546:	c3                   	ret
80107547:	90                   	nop
80107548:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010754f:	00 
80107550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107553:	31 c0                	xor    %eax,%eax
}
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret

8010755a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010755a:	a1 00 00 00 00       	mov    0x0,%eax
8010755f:	0f 0b                	ud2

80107561 <copyout.cold>:
80107561:	a1 00 00 00 00       	mov    0x0,%eax
80107566:	0f 0b                	ud2
