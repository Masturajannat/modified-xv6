
_hellotest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  hello();
   6:	e8 28 03 00 00       	call   333 <hello>
  exit();
   b:	e8 83 02 00 00       	call   293 <exit>
  10:	66 90                	xchg   %ax,%ax
  12:	66 90                	xchg   %ax,%ax
  14:	66 90                	xchg   %ax,%ax
  16:	66 90                	xchg   %ax,%ax
  18:	66 90                	xchg   %ax,%ax
  1a:	66 90                	xchg   %ax,%ax
  1c:	66 90                	xchg   %ax,%ax
  1e:	66 90                	xchg   %ax,%ax

00000020 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  20:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  21:	31 c0                	xor    %eax,%eax
{
  23:	89 e5                	mov    %esp,%ebp
  25:	53                   	push   %ebx
  26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  30:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  34:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  37:	83 c0 01             	add    $0x1,%eax
  3a:	84 d2                	test   %dl,%dl
  3c:	75 f2                	jne    30 <strcpy+0x10>
    ;
  return os;
}
  3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  41:	89 c8                	mov    %ecx,%eax
  43:	c9                   	leave
  44:	c3                   	ret
  45:	8d 76 00             	lea    0x0(%esi),%esi
  48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  4f:	00 

00000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	53                   	push   %ebx
  54:	8b 55 08             	mov    0x8(%ebp),%edx
  57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  5a:	0f b6 02             	movzbl (%edx),%eax
  5d:	84 c0                	test   %al,%al
  5f:	75 2d                	jne    8e <strcmp+0x3e>
  61:	eb 4a                	jmp    ad <strcmp+0x5d>
  63:	eb 1b                	jmp    80 <strcmp+0x30>
  65:	8d 76 00             	lea    0x0(%esi),%esi
  68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  6f:	00 
  70:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  77:	00 
  78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  7f:	00 
  80:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  84:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  87:	84 c0                	test   %al,%al
  89:	74 15                	je     a0 <strcmp+0x50>
  8b:	83 c1 01             	add    $0x1,%ecx
  8e:	0f b6 19             	movzbl (%ecx),%ebx
  91:	38 c3                	cmp    %al,%bl
  93:	74 eb                	je     80 <strcmp+0x30>
  return (uchar)*p - (uchar)*q;
  95:	29 d8                	sub    %ebx,%eax
}
  97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  9a:	c9                   	leave
  9b:	c3                   	ret
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return (uchar)*p - (uchar)*q;
  a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  a4:	31 c0                	xor    %eax,%eax
  a6:	29 d8                	sub    %ebx,%eax
}
  a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ab:	c9                   	leave
  ac:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  ad:	0f b6 19             	movzbl (%ecx),%ebx
  b0:	31 c0                	xor    %eax,%eax
  b2:	eb e1                	jmp    95 <strcmp+0x45>
  b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  bf:	00 

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 3a 00             	cmpb   $0x0,(%edx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 c0                	xor    %eax,%eax
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	83 c0 01             	add    $0x1,%eax
  d3:	89 c1                	mov    %eax,%ecx
  d5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d9:	75 f5                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  db:	89 c8                	mov    %ecx,%eax
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret
  df:	90                   	nop
  for(n = 0; s[n]; n++)
  e0:	31 c9                	xor    %ecx,%ecx
}
  e2:	5d                   	pop    %ebp
  e3:	89 c8                	mov    %ecx,%eax
  e5:	c3                   	ret
  e6:	66 90                	xchg   %ax,%ax
  e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ef:	00 

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  fd:	fc                   	cld
  fe:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	8b 7d fc             	mov    -0x4(%ebp),%edi
 106:	c9                   	leave
 107:	c3                   	ret
 108:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 10f:	00 

00000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	75 1a                	jne    13b <strchr+0x2b>
 121:	eb 25                	jmp    148 <strchr+0x38>
 123:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 128:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 12f:	00 
 130:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 134:	83 c0 01             	add    $0x1,%eax
 137:	84 d2                	test   %dl,%dl
 139:	74 0d                	je     148 <strchr+0x38>
    if(*s == c)
 13b:	38 d1                	cmp    %dl,%cl
 13d:	75 f1                	jne    130 <strchr+0x20>
      return (char*)s;
  return 0;
}
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret
 141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 148:	31 c0                	xor    %eax,%eax
}
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 155:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 158:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 159:	31 db                	xor    %ebx,%ebx
{
 15b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 15e:	eb 27                	jmp    187 <gets+0x37>
    cc = read(0, &c, 1);
 160:	83 ec 04             	sub    $0x4,%esp
 163:	6a 01                	push   $0x1
 165:	57                   	push   %edi
 166:	6a 00                	push   $0x0
 168:	e8 3e 01 00 00       	call   2ab <read>
    if(cc < 1)
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	7e 1d                	jle    191 <gets+0x41>
      break;
    buf[i++] = c;
 174:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 178:	8b 55 08             	mov    0x8(%ebp),%edx
 17b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 17f:	3c 0a                	cmp    $0xa,%al
 181:	74 1d                	je     1a0 <gets+0x50>
 183:	3c 0d                	cmp    $0xd,%al
 185:	74 19                	je     1a0 <gets+0x50>
  for(i=0; i+1 < max; ){
 187:	89 de                	mov    %ebx,%esi
 189:	83 c3 01             	add    $0x1,%ebx
 18c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 18f:	7c cf                	jl     160 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 198:	8d 65 f4             	lea    -0xc(%ebp),%esp
 19b:	5b                   	pop    %ebx
 19c:	5e                   	pop    %esi
 19d:	5f                   	pop    %edi
 19e:	5d                   	pop    %ebp
 19f:	c3                   	ret
  buf[i] = '\0';
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
    buf[i++] = c;
 1a3:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 1a5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ac:	5b                   	pop    %ebx
 1ad:	5e                   	pop    %esi
 1ae:	5f                   	pop    %edi
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret
 1b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1bf:	00 

000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	6a 00                	push   $0x0
 1ca:	ff 75 08             	push   0x8(%ebp)
 1cd:	e8 01 01 00 00       	call   2d3 <open>
  if(fd < 0)
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	85 c0                	test   %eax,%eax
 1d7:	78 27                	js     200 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	ff 75 0c             	push   0xc(%ebp)
 1df:	89 c3                	mov    %eax,%ebx
 1e1:	50                   	push   %eax
 1e2:	e8 04 01 00 00       	call   2eb <fstat>
  close(fd);
 1e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ea:	89 c6                	mov    %eax,%esi
  close(fd);
 1ec:	e8 ca 00 00 00       	call   2bb <close>
  return r;
 1f1:	83 c4 10             	add    $0x10,%esp
}
 1f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1f7:	89 f0                	mov    %esi,%eax
 1f9:	5b                   	pop    %ebx
 1fa:	5e                   	pop    %esi
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 200:	be ff ff ff ff       	mov    $0xffffffff,%esi
 205:	eb ed                	jmp    1f4 <stat+0x34>
 207:	90                   	nop
 208:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20f:	00 

00000210 <atoi>:

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	0f be 02             	movsbl (%edx),%eax
 21a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 21d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 220:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 225:	77 2e                	ja     255 <atoi+0x45>
 227:	eb 17                	jmp    240 <atoi+0x30>
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 230:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 237:	00 
 238:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 23f:	00 
    n = n*10 + *s++ - '0';
 240:	83 c2 01             	add    $0x1,%edx
 243:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 246:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 24a:	0f be 02             	movsbl (%edx),%eax
 24d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 250:	80 fb 09             	cmp    $0x9,%bl
 253:	76 eb                	jbe    240 <atoi+0x30>
  return n;
}
 255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 258:	89 c8                	mov    %ecx,%eax
 25a:	c9                   	leave
 25b:	c3                   	ret
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000260 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	8b 45 10             	mov    0x10(%ebp),%eax
 267:	8b 55 08             	mov    0x8(%ebp),%edx
 26a:	56                   	push   %esi
 26b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26e:	85 c0                	test   %eax,%eax
 270:	7e 13                	jle    285 <memmove+0x25>
 272:	01 d0                	add    %edx,%eax
  dst = vdst;
 274:	89 d7                	mov    %edx,%edi
 276:	66 90                	xchg   %ax,%ax
 278:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27f:	00 
    *dst++ = *src++;
 280:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 281:	39 f8                	cmp    %edi,%eax
 283:	75 fb                	jne    280 <memmove+0x20>
  return vdst;
}
 285:	5e                   	pop    %esi
 286:	89 d0                	mov    %edx,%eax
 288:	5f                   	pop    %edi
 289:	5d                   	pop    %ebp
 28a:	c3                   	ret

0000028b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28b:	b8 01 00 00 00       	mov    $0x1,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <exit>:
SYSCALL(exit)
 293:	b8 02 00 00 00       	mov    $0x2,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <wait>:
SYSCALL(wait)
 29b:	b8 03 00 00 00       	mov    $0x3,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <pipe>:
SYSCALL(pipe)
 2a3:	b8 04 00 00 00       	mov    $0x4,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <read>:
SYSCALL(read)
 2ab:	b8 05 00 00 00       	mov    $0x5,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <write>:
SYSCALL(write)
 2b3:	b8 10 00 00 00       	mov    $0x10,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <close>:
SYSCALL(close)
 2bb:	b8 15 00 00 00       	mov    $0x15,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <kill>:
SYSCALL(kill)
 2c3:	b8 06 00 00 00       	mov    $0x6,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <exec>:
SYSCALL(exec)
 2cb:	b8 07 00 00 00       	mov    $0x7,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <open>:
SYSCALL(open)
 2d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <mknod>:
SYSCALL(mknod)
 2db:	b8 11 00 00 00       	mov    $0x11,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <unlink>:
SYSCALL(unlink)
 2e3:	b8 12 00 00 00       	mov    $0x12,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <fstat>:
SYSCALL(fstat)
 2eb:	b8 08 00 00 00       	mov    $0x8,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <link>:
SYSCALL(link)
 2f3:	b8 13 00 00 00       	mov    $0x13,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <mkdir>:
SYSCALL(mkdir)
 2fb:	b8 14 00 00 00       	mov    $0x14,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <chdir>:
SYSCALL(chdir)
 303:	b8 09 00 00 00       	mov    $0x9,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <dup>:
SYSCALL(dup)
 30b:	b8 0a 00 00 00       	mov    $0xa,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <getpid>:
SYSCALL(getpid)
 313:	b8 0b 00 00 00       	mov    $0xb,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <sbrk>:
SYSCALL(sbrk)
 31b:	b8 0c 00 00 00       	mov    $0xc,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <sleep>:
SYSCALL(sleep)
 323:	b8 0d 00 00 00       	mov    $0xd,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <uptime>:
SYSCALL(uptime)
 32b:	b8 0e 00 00 00       	mov    $0xe,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <hello>:
SYSCALL(hello)
 333:	b8 16 00 00 00       	mov    $0x16,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret
 33b:	66 90                	xchg   %ax,%ax
 33d:	66 90                	xchg   %ax,%ax
 33f:	90                   	nop

00000340 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
 345:	53                   	push   %ebx
 346:	89 cb                	mov    %ecx,%ebx
 348:	83 ec 3c             	sub    $0x3c,%esp
 34b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 34e:	85 d2                	test   %edx,%edx
 350:	0f 89 9a 00 00 00    	jns    3f0 <printint+0xb0>
 356:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 35a:	0f 84 90 00 00 00    	je     3f0 <printint+0xb0>
    neg = 1;
    x = -xx;
 360:	f7 da                	neg    %edx
    neg = 1;
 362:	b8 01 00 00 00       	mov    $0x1,%eax
 367:	89 45 c0             	mov    %eax,-0x40(%ebp)
 36a:	89 d1                	mov    %edx,%ecx
  } else {
    x = xx;
  }

  i = 0;
 36c:	31 f6                	xor    %esi,%esi
 36e:	66 90                	xchg   %ax,%ax
 370:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 377:	00 
 378:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37f:	00 
  do{
    buf[i++] = digits[x % base];
 380:	89 c8                	mov    %ecx,%eax
 382:	31 d2                	xor    %edx,%edx
 384:	89 f7                	mov    %esi,%edi
 386:	f7 f3                	div    %ebx
 388:	8d 76 01             	lea    0x1(%esi),%esi
  }while((x /= base) != 0);
 38b:	39 d9                	cmp    %ebx,%ecx
    buf[i++] = digits[x % base];
 38d:	0f b6 92 c8 07 00 00 	movzbl 0x7c8(%edx),%edx
  }while((x /= base) != 0);
 394:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
 396:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 39a:	73 e4                	jae    380 <printint+0x40>
  if(neg)
 39c:	8b 45 c0             	mov    -0x40(%ebp),%eax
 39f:	85 c0                	test   %eax,%eax
 3a1:	74 07                	je     3aa <printint+0x6a>
    buf[i++] = '-';
 3a3:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 3a8:	89 f7                	mov    %esi,%edi

  while(--i >= 0)
 3aa:	8d 74 3d d8          	lea    -0x28(%ebp,%edi,1),%esi
 3ae:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 3b1:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3bf:	00 
    putc(fd, buf[i]);
 3c0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 3c3:	83 ec 04             	sub    $0x4,%esp
  while(--i >= 0)
 3c6:	83 ee 01             	sub    $0x1,%esi
 3c9:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 3cc:	8d 45 d7             	lea    -0x29(%ebp),%eax
 3cf:	6a 01                	push   $0x1
 3d1:	50                   	push   %eax
 3d2:	57                   	push   %edi
 3d3:	e8 db fe ff ff       	call   2b3 <write>
  while(--i >= 0)
 3d8:	83 c4 10             	add    $0x10,%esp
 3db:	39 f3                	cmp    %esi,%ebx
 3dd:	75 e1                	jne    3c0 <printint+0x80>
}
 3df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e2:	5b                   	pop    %ebx
 3e3:	5e                   	pop    %esi
 3e4:	5f                   	pop    %edi
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret
 3e7:	90                   	nop
 3e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ef:	00 
  neg = 0;
 3f0:	31 c0                	xor    %eax,%eax
 3f2:	e9 70 ff ff ff       	jmp    367 <printint+0x27>
 3f7:	90                   	nop
 3f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ff:	00 

00000400 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 409:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 40c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 40f:	0f b6 13             	movzbl (%ebx),%edx
 412:	83 c3 01             	add    $0x1,%ebx
 415:	84 d2                	test   %dl,%dl
 417:	0f 84 a0 00 00 00    	je     4bd <printf+0xbd>
 41d:	8d 45 10             	lea    0x10(%ebp),%eax
 420:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 423:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 426:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 429:	eb 28                	jmp    453 <printf+0x53>
 42b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 430:	83 ec 04             	sub    $0x4,%esp
 433:	8d 45 e7             	lea    -0x19(%ebp),%eax
 436:	88 55 e7             	mov    %dl,-0x19(%ebp)
  for(i = 0; fmt[i]; i++){
 439:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 43c:	6a 01                	push   $0x1
 43e:	50                   	push   %eax
 43f:	56                   	push   %esi
 440:	e8 6e fe ff ff       	call   2b3 <write>
  for(i = 0; fmt[i]; i++){
 445:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 449:	83 c4 10             	add    $0x10,%esp
 44c:	84 d2                	test   %dl,%dl
 44e:	74 6d                	je     4bd <printf+0xbd>
    c = fmt[i] & 0xff;
 450:	0f b6 c2             	movzbl %dl,%eax
      if(c == '%'){
 453:	83 f8 25             	cmp    $0x25,%eax
 456:	75 d8                	jne    430 <printf+0x30>
  for(i = 0; fmt[i]; i++){
 458:	0f b6 13             	movzbl (%ebx),%edx
 45b:	84 d2                	test   %dl,%dl
 45d:	74 5e                	je     4bd <printf+0xbd>
    c = fmt[i] & 0xff;
 45f:	0f b6 c2             	movzbl %dl,%eax
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
 462:	80 fa 25             	cmp    $0x25,%dl
 465:	0f 84 25 01 00 00    	je     590 <printf+0x190>
 46b:	83 e8 63             	sub    $0x63,%eax
 46e:	83 f8 15             	cmp    $0x15,%eax
 471:	77 0d                	ja     480 <printf+0x80>
 473:	ff 24 85 70 07 00 00 	jmp    *0x770(,%eax,4)
 47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 480:	83 ec 04             	sub    $0x4,%esp
 483:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 486:	88 55 d0             	mov    %dl,-0x30(%ebp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 489:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 48d:	6a 01                	push   $0x1
 48f:	51                   	push   %ecx
 490:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 493:	56                   	push   %esi
 494:	e8 1a fe ff ff       	call   2b3 <write>
        putc(fd, c);
 499:	0f b6 55 d0          	movzbl -0x30(%ebp),%edx
  write(fd, &c, 1);
 49d:	83 c4 0c             	add    $0xc,%esp
 4a0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4a3:	6a 01                	push   $0x1
 4a5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4a8:	51                   	push   %ecx
  for(i = 0; fmt[i]; i++){
 4a9:	83 c3 02             	add    $0x2,%ebx
  write(fd, &c, 1);
 4ac:	56                   	push   %esi
 4ad:	e8 01 fe ff ff       	call   2b3 <write>
  for(i = 0; fmt[i]; i++){
 4b2:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4b6:	83 c4 10             	add    $0x10,%esp
 4b9:	84 d2                	test   %dl,%dl
 4bb:	75 93                	jne    450 <printf+0x50>
      }
      state = 0;
    }
  }
}
 4bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c0:	5b                   	pop    %ebx
 4c1:	5e                   	pop    %esi
 4c2:	5f                   	pop    %edi
 4c3:	5d                   	pop    %ebp
 4c4:	c3                   	ret
 4c5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 4c8:	83 ec 0c             	sub    $0xc,%esp
 4cb:	8b 17                	mov    (%edi),%edx
 4cd:	b9 10 00 00 00       	mov    $0x10,%ecx
 4d2:	89 f0                	mov    %esi,%eax
 4d4:	6a 00                	push   $0x0
 4d6:	e8 65 fe ff ff       	call   340 <printint>
  for(i = 0; fmt[i]; i++){
 4db:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 4df:	83 c3 02             	add    $0x2,%ebx
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	84 d2                	test   %dl,%dl
 4e7:	74 d4                	je     4bd <printf+0xbd>
        ap++;
 4e9:	83 c7 04             	add    $0x4,%edi
 4ec:	e9 5f ff ff ff       	jmp    450 <printf+0x50>
 4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 4f8:	8b 07                	mov    (%edi),%eax
        ap++;
 4fa:	83 c7 04             	add    $0x4,%edi
        if(s == 0)
 4fd:	85 c0                	test   %eax,%eax
 4ff:	0f 84 9b 00 00 00    	je     5a0 <printf+0x1a0>
        while(*s != 0){
 505:	0f b6 10             	movzbl (%eax),%edx
 508:	84 d2                	test   %dl,%dl
 50a:	0f 84 a2 00 00 00    	je     5b2 <printf+0x1b2>
 510:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 513:	89 c7                	mov    %eax,%edi
 515:	89 d0                	mov    %edx,%eax
 517:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 51a:	89 fb                	mov    %edi,%ebx
 51c:	8d 7d e7             	lea    -0x19(%ebp),%edi
 51f:	90                   	nop
  write(fd, &c, 1);
 520:	83 ec 04             	sub    $0x4,%esp
 523:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 526:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 529:	6a 01                	push   $0x1
 52b:	57                   	push   %edi
 52c:	56                   	push   %esi
 52d:	e8 81 fd ff ff       	call   2b3 <write>
        while(*s != 0){
 532:	0f b6 03             	movzbl (%ebx),%eax
 535:	83 c4 10             	add    $0x10,%esp
 538:	84 c0                	test   %al,%al
 53a:	75 e4                	jne    520 <printf+0x120>
 53c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 53f:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 543:	83 c3 02             	add    $0x2,%ebx
 546:	84 d2                	test   %dl,%dl
 548:	0f 85 d5 fe ff ff    	jne    423 <printf+0x23>
 54e:	e9 6a ff ff ff       	jmp    4bd <printf+0xbd>
 553:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 558:	83 ec 0c             	sub    $0xc,%esp
 55b:	8b 17                	mov    (%edi),%edx
 55d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 562:	89 f0                	mov    %esi,%eax
 564:	6a 01                	push   $0x1
 566:	e8 d5 fd ff ff       	call   340 <printint>
  for(i = 0; fmt[i]; i++){
 56b:	e9 6b ff ff ff       	jmp    4db <printf+0xdb>
        putc(fd, *ap);
 570:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 572:	83 ec 04             	sub    $0x4,%esp
 575:	8d 4d e7             	lea    -0x19(%ebp),%ecx
        putc(fd, *ap);
 578:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 57b:	6a 01                	push   $0x1
 57d:	51                   	push   %ecx
 57e:	56                   	push   %esi
 57f:	e8 2f fd ff ff       	call   2b3 <write>
 584:	e9 52 ff ff ff       	jmp    4db <printf+0xdb>
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 590:	83 ec 04             	sub    $0x4,%esp
 593:	88 55 e7             	mov    %dl,-0x19(%ebp)
 596:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 599:	6a 01                	push   $0x1
 59b:	e9 08 ff ff ff       	jmp    4a8 <printf+0xa8>
          s = "(null)";
 5a0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5a3:	b8 28 00 00 00       	mov    $0x28,%eax
 5a8:	bf 68 07 00 00       	mov    $0x768,%edi
 5ad:	e9 65 ff ff ff       	jmp    517 <printf+0x117>
  for(i = 0; fmt[i]; i++){
 5b2:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 5b6:	83 c3 02             	add    $0x2,%ebx
 5b9:	84 d2                	test   %dl,%dl
 5bb:	0f 85 8f fe ff ff    	jne    450 <printf+0x50>
 5c1:	e9 f7 fe ff ff       	jmp    4bd <printf+0xbd>
 5c6:	66 90                	xchg   %ax,%ax
 5c8:	66 90                	xchg   %ax,%ax
 5ca:	66 90                	xchg   %ax,%ax
 5cc:	66 90                	xchg   %ax,%ax
 5ce:	66 90                	xchg   %ax,%ax
 5d0:	66 90                	xchg   %ax,%ax
 5d2:	66 90                	xchg   %ax,%ax
 5d4:	66 90                	xchg   %ax,%ax
 5d6:	66 90                	xchg   %ax,%ax
 5d8:	66 90                	xchg   %ax,%ax
 5da:	66 90                	xchg   %ax,%ax
 5dc:	66 90                	xchg   %ax,%ax
 5de:	66 90                	xchg   %ax,%ax

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 68 0a 00 00       	mov    0xa68,%eax
{
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5ff:	00 
 600:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 604:	39 ca                	cmp    %ecx,%edx
 606:	73 30                	jae    638 <free+0x58>
 608:	39 c1                	cmp    %eax,%ecx
 60a:	72 04                	jb     610 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60c:	39 c2                	cmp    %eax,%edx
 60e:	72 f0                	jb     600 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 610:	8b 73 fc             	mov    -0x4(%ebx),%esi
 613:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 616:	39 f8                	cmp    %edi,%eax
 618:	74 36                	je     650 <free+0x70>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 61a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 61d:	8b 42 04             	mov    0x4(%edx),%eax
 620:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 623:	39 f1                	cmp    %esi,%ecx
 625:	74 40                	je     667 <free+0x87>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 627:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 629:	5b                   	pop    %ebx
  freep = p;
 62a:	89 15 68 0a 00 00    	mov    %edx,0xa68
}
 630:	5e                   	pop    %esi
 631:	5f                   	pop    %edi
 632:	5d                   	pop    %ebp
 633:	c3                   	ret
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 638:	39 c2                	cmp    %eax,%edx
 63a:	72 c4                	jb     600 <free+0x20>
 63c:	39 c1                	cmp    %eax,%ecx
 63e:	73 c0                	jae    600 <free+0x20>
  if(bp + bp->s.size == p->s.ptr){
 640:	8b 73 fc             	mov    -0x4(%ebx),%esi
 643:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 646:	39 f8                	cmp    %edi,%eax
 648:	75 d0                	jne    61a <free+0x3a>
 64a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 650:	03 70 04             	add    0x4(%eax),%esi
 653:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 656:	8b 02                	mov    (%edx),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 65d:	8b 42 04             	mov    0x4(%edx),%eax
 660:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 663:	39 f1                	cmp    %esi,%ecx
 665:	75 c0                	jne    627 <free+0x47>
    p->s.size += bp->s.size;
 667:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 66a:	89 15 68 0a 00 00    	mov    %edx,0xa68
    p->s.size += bp->s.size;
 670:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 673:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 676:	89 0a                	mov    %ecx,(%edx)
}
 678:	5b                   	pop    %ebx
 679:	5e                   	pop    %esi
 67a:	5f                   	pop    %edi
 67b:	5d                   	pop    %ebp
 67c:	c3                   	ret
 67d:	8d 76 00             	lea    0x0(%esi),%esi

00000680 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 689:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 68c:	8b 15 68 0a 00 00    	mov    0xa68,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 692:	8d 78 07             	lea    0x7(%eax),%edi
 695:	c1 ef 03             	shr    $0x3,%edi
 698:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 69b:	85 d2                	test   %edx,%edx
 69d:	0f 84 8d 00 00 00    	je     730 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6a5:	8b 48 04             	mov    0x4(%eax),%ecx
 6a8:	39 f9                	cmp    %edi,%ecx
 6aa:	73 64                	jae    710 <malloc+0x90>
  if(nu < 4096)
 6ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6b1:	39 df                	cmp    %ebx,%edi
 6b3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6b6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6bd:	eb 0a                	jmp    6c9 <malloc+0x49>
 6bf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6c2:	8b 48 04             	mov    0x4(%eax),%ecx
 6c5:	39 f9                	cmp    %edi,%ecx
 6c7:	73 47                	jae    710 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6c9:	89 c2                	mov    %eax,%edx
 6cb:	39 05 68 0a 00 00    	cmp    %eax,0xa68
 6d1:	75 ed                	jne    6c0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6d3:	83 ec 0c             	sub    $0xc,%esp
 6d6:	56                   	push   %esi
 6d7:	e8 3f fc ff ff       	call   31b <sbrk>
  if(p == (char*)-1)
 6dc:	83 c4 10             	add    $0x10,%esp
 6df:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e2:	74 1c                	je     700 <malloc+0x80>
  hp->s.size = nu;
 6e4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	83 c0 08             	add    $0x8,%eax
 6ed:	50                   	push   %eax
 6ee:	e8 ed fe ff ff       	call   5e0 <free>
  return freep;
 6f3:	8b 15 68 0a 00 00    	mov    0xa68,%edx
      if((p = morecore(nunits)) == 0)
 6f9:	83 c4 10             	add    $0x10,%esp
 6fc:	85 d2                	test   %edx,%edx
 6fe:	75 c0                	jne    6c0 <malloc+0x40>
        return 0;
  }
}
 700:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 703:	31 c0                	xor    %eax,%eax
}
 705:	5b                   	pop    %ebx
 706:	5e                   	pop    %esi
 707:	5f                   	pop    %edi
 708:	5d                   	pop    %ebp
 709:	c3                   	ret
 70a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 710:	39 cf                	cmp    %ecx,%edi
 712:	74 4c                	je     760 <malloc+0xe0>
        p->s.size -= nunits;
 714:	29 f9                	sub    %edi,%ecx
 716:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 719:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 71c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 71f:	89 15 68 0a 00 00    	mov    %edx,0xa68
}
 725:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 728:	83 c0 08             	add    $0x8,%eax
}
 72b:	5b                   	pop    %ebx
 72c:	5e                   	pop    %esi
 72d:	5f                   	pop    %edi
 72e:	5d                   	pop    %ebp
 72f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 730:	c7 05 68 0a 00 00 6c 	movl   $0xa6c,0xa68
 737:	0a 00 00 
    base.s.size = 0;
 73a:	b8 6c 0a 00 00       	mov    $0xa6c,%eax
    base.s.ptr = freep = prevp = &base;
 73f:	c7 05 6c 0a 00 00 6c 	movl   $0xa6c,0xa6c
 746:	0a 00 00 
    base.s.size = 0;
 749:	c7 05 70 0a 00 00 00 	movl   $0x0,0xa70
 750:	00 00 00 
    if(p->s.size >= nunits){
 753:	e9 54 ff ff ff       	jmp    6ac <malloc+0x2c>
 758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 75f:	00 
        prevp->s.ptr = p->s.ptr;
 760:	8b 08                	mov    (%eax),%ecx
 762:	89 0a                	mov    %ecx,(%edx)
 764:	eb b9                	jmp    71f <malloc+0x9f>
