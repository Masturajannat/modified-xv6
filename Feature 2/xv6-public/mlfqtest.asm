
_mlfqtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid = fork();
   f:	e8 17 03 00 00       	call   32b <fork>

  if(pid < 0){
  14:	85 c0                	test   %eax,%eax
  16:	78 79                	js     91 <main+0x91>
    printf(1, "fork failed\n");
    exit();
  }

  if(pid == 0){
  18:	75 33                	jne    4d <main+0x4d>
    int i, j;
    printf(1, "CPU-bound child started\n");
  1a:	52                   	push   %edx
  1b:	89 c3                	mov    %eax,%ebx
  1d:	52                   	push   %edx
  1e:	68 15 08 00 00       	push   $0x815
  23:	6a 01                	push   $0x1
  25:	e8 76 04 00 00       	call   4a0 <printf>
  2a:	83 c4 10             	add    $0x10,%esp
  2d:	8d 76 00             	lea    0x0(%esi),%esi

    for(i = 0; i < 20; i++){
      for(j = 0; j < 10000000; j++){
      }
      printf(1, "CPU child loop %d\n", i);
  30:	83 ec 04             	sub    $0x4,%esp
  33:	53                   	push   %ebx
    for(i = 0; i < 20; i++){
  34:	83 c3 01             	add    $0x1,%ebx
      printf(1, "CPU child loop %d\n", i);
  37:	68 2e 08 00 00       	push   $0x82e
  3c:	6a 01                	push   $0x1
  3e:	e8 5d 04 00 00       	call   4a0 <printf>
    for(i = 0; i < 20; i++){
  43:	83 c4 10             	add    $0x10,%esp
  46:	83 fb 14             	cmp    $0x14,%ebx
  49:	75 e5                	jne    30 <main+0x30>
  4b:	eb 3f                	jmp    8c <main+0x8c>
    }

    exit();
  } else {
    int i;
    printf(1, "I/O-bound parent started\n");
  4d:	50                   	push   %eax

    for(i = 0; i < 20; i++){
  4e:	31 db                	xor    %ebx,%ebx
    printf(1, "I/O-bound parent started\n");
  50:	50                   	push   %eax
  51:	68 41 08 00 00       	push   $0x841
  56:	6a 01                	push   $0x1
  58:	e8 43 04 00 00       	call   4a0 <printf>
  5d:	83 c4 10             	add    $0x10,%esp
      printf(1, "Parent sleep loop %d\n", i);
  60:	83 ec 04             	sub    $0x4,%esp
  63:	53                   	push   %ebx
    for(i = 0; i < 20; i++){
  64:	83 c3 01             	add    $0x1,%ebx
      printf(1, "Parent sleep loop %d\n", i);
  67:	68 5b 08 00 00       	push   $0x85b
  6c:	6a 01                	push   $0x1
  6e:	e8 2d 04 00 00       	call   4a0 <printf>
      sleep(10);
  73:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  7a:	e8 44 03 00 00       	call   3c3 <sleep>
    for(i = 0; i < 20; i++){
  7f:	83 c4 10             	add    $0x10,%esp
  82:	83 fb 14             	cmp    $0x14,%ebx
  85:	75 d9                	jne    60 <main+0x60>
    }

    wait();
  87:	e8 af 02 00 00       	call   33b <wait>
    exit();
  8c:	e8 a2 02 00 00       	call   333 <exit>
    printf(1, "fork failed\n");
  91:	51                   	push   %ecx
  92:	51                   	push   %ecx
  93:	68 08 08 00 00       	push   $0x808
  98:	6a 01                	push   $0x1
  9a:	e8 01 04 00 00       	call   4a0 <printf>
    exit();
  9f:	e8 8f 02 00 00       	call   333 <exit>
  a4:	66 90                	xchg   %ax,%ax
  a6:	66 90                	xchg   %ax,%ax
  a8:	66 90                	xchg   %ax,%ax
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax
  b0:	66 90                	xchg   %ax,%ax
  b2:	66 90                	xchg   %ax,%ax
  b4:	66 90                	xchg   %ax,%ax
  b6:	66 90                	xchg   %ax,%ax
  b8:	66 90                	xchg   %ax,%ax
  ba:	66 90                	xchg   %ax,%ax
  bc:	66 90                	xchg   %ax,%ax
  be:	66 90                	xchg   %ax,%ax

000000c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c1:	31 c0                	xor    %eax,%eax
{
  c3:	89 e5                	mov    %esp,%ebp
  c5:	53                   	push   %ebx
  c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  d7:	83 c0 01             	add    $0x1,%eax
  da:	84 d2                	test   %dl,%dl
  dc:	75 f2                	jne    d0 <strcpy+0x10>
    ;
  return os;
}
  de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  e1:	89 c8                	mov    %ecx,%eax
  e3:	c9                   	leave
  e4:	c3                   	ret
  e5:	8d 76 00             	lea    0x0(%esi),%esi
  e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ef:	00 

000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
  f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  fa:	0f b6 02             	movzbl (%edx),%eax
  fd:	84 c0                	test   %al,%al
  ff:	75 2d                	jne    12e <strcmp+0x3e>
 101:	eb 4a                	jmp    14d <strcmp+0x5d>
 103:	eb 1b                	jmp    120 <strcmp+0x30>
 105:	8d 76 00             	lea    0x0(%esi),%esi
 108:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 10f:	00 
 110:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 117:	00 
 118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 11f:	00 
 120:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 124:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 127:	84 c0                	test   %al,%al
 129:	74 15                	je     140 <strcmp+0x50>
 12b:	83 c1 01             	add    $0x1,%ecx
 12e:	0f b6 19             	movzbl (%ecx),%ebx
 131:	38 c3                	cmp    %al,%bl
 133:	74 eb                	je     120 <strcmp+0x30>
  return (uchar)*p - (uchar)*q;
 135:	29 d8                	sub    %ebx,%eax
}
 137:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 13a:	c9                   	leave
 13b:	c3                   	ret
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return (uchar)*p - (uchar)*q;
 140:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 144:	31 c0                	xor    %eax,%eax
 146:	29 d8                	sub    %ebx,%eax
}
 148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 14b:	c9                   	leave
 14c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 14d:	0f b6 19             	movzbl (%ecx),%ebx
 150:	31 c0                	xor    %eax,%eax
 152:	eb e1                	jmp    135 <strcmp+0x45>
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 158:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 15f:	00 

00000160 <strlen>:

uint
strlen(const char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 3a 00             	cmpb   $0x0,(%edx)
 169:	74 15                	je     180 <strlen+0x20>
 16b:	31 c0                	xor    %eax,%eax
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	83 c0 01             	add    $0x1,%eax
 173:	89 c1                	mov    %eax,%ecx
 175:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	89 c8                	mov    %ecx,%eax
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret
 17f:	90                   	nop
  for(n = 0; s[n]; n++)
 180:	31 c9                	xor    %ecx,%ecx
}
 182:	5d                   	pop    %ebp
 183:	89 c8                	mov    %ecx,%eax
 185:	c3                   	ret
 186:	66 90                	xchg   %ax,%ax
 188:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 18f:	00 

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 194:	8b 4d 10             	mov    0x10(%ebp),%ecx
 197:	8b 45 0c             	mov    0xc(%ebp),%eax
 19a:	8b 7d 08             	mov    0x8(%ebp),%edi
 19d:	fc                   	cld
 19e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1a6:	c9                   	leave
 1a7:	c3                   	ret
 1a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1af:	00 

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	84 d2                	test   %dl,%dl
 1bf:	75 1a                	jne    1db <strchr+0x2b>
 1c1:	eb 25                	jmp    1e8 <strchr+0x38>
 1c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1cf:	00 
 1d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1d4:	83 c0 01             	add    $0x1,%eax
 1d7:	84 d2                	test   %dl,%dl
 1d9:	74 0d                	je     1e8 <strchr+0x38>
    if(*s == c)
 1db:	38 d1                	cmp    %dl,%cl
 1dd:	75 f1                	jne    1d0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret
 1e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1e8:	31 c0                	xor    %eax,%eax
}
 1ea:	5d                   	pop    %ebp
 1eb:	c3                   	ret
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1f5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1f9:	31 db                	xor    %ebx,%ebx
{
 1fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1fe:	eb 27                	jmp    227 <gets+0x37>
    cc = read(0, &c, 1);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	6a 01                	push   $0x1
 205:	57                   	push   %edi
 206:	6a 00                	push   $0x0
 208:	e8 3e 01 00 00       	call   34b <read>
    if(cc < 1)
 20d:	83 c4 10             	add    $0x10,%esp
 210:	85 c0                	test   %eax,%eax
 212:	7e 1d                	jle    231 <gets+0x41>
      break;
    buf[i++] = c;
 214:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 218:	8b 55 08             	mov    0x8(%ebp),%edx
 21b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 21f:	3c 0a                	cmp    $0xa,%al
 221:	74 1d                	je     240 <gets+0x50>
 223:	3c 0d                	cmp    $0xd,%al
 225:	74 19                	je     240 <gets+0x50>
  for(i=0; i+1 < max; ){
 227:	89 de                	mov    %ebx,%esi
 229:	83 c3 01             	add    $0x1,%ebx
 22c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 22f:	7c cf                	jl     200 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 238:	8d 65 f4             	lea    -0xc(%ebp),%esp
 23b:	5b                   	pop    %ebx
 23c:	5e                   	pop    %esi
 23d:	5f                   	pop    %edi
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret
  buf[i] = '\0';
 240:	8b 45 08             	mov    0x8(%ebp),%eax
    buf[i++] = c;
 243:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 245:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 249:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret
 251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 258:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 25f:	00 

00000260 <stat>:

int
stat(const char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	ff 75 08             	push   0x8(%ebp)
 26d:	e8 01 01 00 00       	call   373 <open>
  if(fd < 0)
 272:	83 c4 10             	add    $0x10,%esp
 275:	85 c0                	test   %eax,%eax
 277:	78 27                	js     2a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	ff 75 0c             	push   0xc(%ebp)
 27f:	89 c3                	mov    %eax,%ebx
 281:	50                   	push   %eax
 282:	e8 04 01 00 00       	call   38b <fstat>
  close(fd);
 287:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 28a:	89 c6                	mov    %eax,%esi
  close(fd);
 28c:	e8 ca 00 00 00       	call   35b <close>
  return r;
 291:	83 c4 10             	add    $0x10,%esp
}
 294:	8d 65 f8             	lea    -0x8(%ebp),%esp
 297:	89 f0                	mov    %esi,%eax
 299:	5b                   	pop    %ebx
 29a:	5e                   	pop    %esi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2a5:	eb ed                	jmp    294 <stat+0x34>
 2a7:	90                   	nop
 2a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2af:	00 

000002b0 <atoi>:

int
atoi(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b7:	0f be 02             	movsbl (%edx),%eax
 2ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2c5:	77 2e                	ja     2f5 <atoi+0x45>
 2c7:	eb 17                	jmp    2e0 <atoi+0x30>
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2d0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2d7:	00 
 2d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2df:	00 
    n = n*10 + *s++ - '0';
 2e0:	83 c2 01             	add    $0x1,%edx
 2e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2ea:	0f be 02             	movsbl (%edx),%eax
 2ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2f0:	80 fb 09             	cmp    $0x9,%bl
 2f3:	76 eb                	jbe    2e0 <atoi+0x30>
  return n;
}
 2f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2f8:	89 c8                	mov    %ecx,%eax
 2fa:	c9                   	leave
 2fb:	c3                   	ret
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	8b 45 10             	mov    0x10(%ebp),%eax
 307:	8b 55 08             	mov    0x8(%ebp),%edx
 30a:	56                   	push   %esi
 30b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 30e:	85 c0                	test   %eax,%eax
 310:	7e 13                	jle    325 <memmove+0x25>
 312:	01 d0                	add    %edx,%eax
  dst = vdst;
 314:	89 d7                	mov    %edx,%edi
 316:	66 90                	xchg   %ax,%ax
 318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 31f:	00 
    *dst++ = *src++;
 320:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 321:	39 f8                	cmp    %edi,%eax
 323:	75 fb                	jne    320 <memmove+0x20>
  return vdst;
}
 325:	5e                   	pop    %esi
 326:	89 d0                	mov    %edx,%eax
 328:	5f                   	pop    %edi
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret

0000032b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32b:	b8 01 00 00 00       	mov    $0x1,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <exit>:
SYSCALL(exit)
 333:	b8 02 00 00 00       	mov    $0x2,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <wait>:
SYSCALL(wait)
 33b:	b8 03 00 00 00       	mov    $0x3,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <pipe>:
SYSCALL(pipe)
 343:	b8 04 00 00 00       	mov    $0x4,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <read>:
SYSCALL(read)
 34b:	b8 05 00 00 00       	mov    $0x5,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <write>:
SYSCALL(write)
 353:	b8 10 00 00 00       	mov    $0x10,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <close>:
SYSCALL(close)
 35b:	b8 15 00 00 00       	mov    $0x15,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <kill>:
SYSCALL(kill)
 363:	b8 06 00 00 00       	mov    $0x6,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <exec>:
SYSCALL(exec)
 36b:	b8 07 00 00 00       	mov    $0x7,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <open>:
SYSCALL(open)
 373:	b8 0f 00 00 00       	mov    $0xf,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <mknod>:
SYSCALL(mknod)
 37b:	b8 11 00 00 00       	mov    $0x11,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <unlink>:
SYSCALL(unlink)
 383:	b8 12 00 00 00       	mov    $0x12,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <fstat>:
SYSCALL(fstat)
 38b:	b8 08 00 00 00       	mov    $0x8,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <link>:
SYSCALL(link)
 393:	b8 13 00 00 00       	mov    $0x13,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <mkdir>:
SYSCALL(mkdir)
 39b:	b8 14 00 00 00       	mov    $0x14,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <chdir>:
SYSCALL(chdir)
 3a3:	b8 09 00 00 00       	mov    $0x9,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <dup>:
SYSCALL(dup)
 3ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <getpid>:
SYSCALL(getpid)
 3b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <sbrk>:
SYSCALL(sbrk)
 3bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <sleep>:
SYSCALL(sleep)
 3c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <uptime>:
SYSCALL(uptime)
 3cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <hello>:
SYSCALL(hello)
 3d3:	b8 16 00 00 00       	mov    $0x16,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret
 3db:	66 90                	xchg   %ax,%ax
 3dd:	66 90                	xchg   %ax,%ax
 3df:	90                   	nop

000003e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	89 cb                	mov    %ecx,%ebx
 3e8:	83 ec 3c             	sub    $0x3c,%esp
 3eb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ee:	85 d2                	test   %edx,%edx
 3f0:	0f 89 9a 00 00 00    	jns    490 <printint+0xb0>
 3f6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3fa:	0f 84 90 00 00 00    	je     490 <printint+0xb0>
    neg = 1;
    x = -xx;
 400:	f7 da                	neg    %edx
    neg = 1;
 402:	b8 01 00 00 00       	mov    $0x1,%eax
 407:	89 45 c0             	mov    %eax,-0x40(%ebp)
 40a:	89 d1                	mov    %edx,%ecx
  } else {
    x = xx;
  }

  i = 0;
 40c:	31 f6                	xor    %esi,%esi
 40e:	66 90                	xchg   %ax,%ax
 410:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 417:	00 
 418:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 41f:	00 
  do{
    buf[i++] = digits[x % base];
 420:	89 c8                	mov    %ecx,%eax
 422:	31 d2                	xor    %edx,%edx
 424:	89 f7                	mov    %esi,%edi
 426:	f7 f3                	div    %ebx
 428:	8d 76 01             	lea    0x1(%esi),%esi
  }while((x /= base) != 0);
 42b:	39 d9                	cmp    %ebx,%ecx
    buf[i++] = digits[x % base];
 42d:	0f b6 92 d0 08 00 00 	movzbl 0x8d0(%edx),%edx
  }while((x /= base) != 0);
 434:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
 436:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 43a:	73 e4                	jae    420 <printint+0x40>
  if(neg)
 43c:	8b 45 c0             	mov    -0x40(%ebp),%eax
 43f:	85 c0                	test   %eax,%eax
 441:	74 07                	je     44a <printint+0x6a>
    buf[i++] = '-';
 443:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 448:	89 f7                	mov    %esi,%edi

  while(--i >= 0)
 44a:	8d 74 3d d8          	lea    -0x28(%ebp,%edi,1),%esi
 44e:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 451:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 458:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 45f:	00 
    putc(fd, buf[i]);
 460:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 463:	83 ec 04             	sub    $0x4,%esp
  while(--i >= 0)
 466:	83 ee 01             	sub    $0x1,%esi
 469:	88 45 d7             	mov    %al,-0x29(%ebp)
  write(fd, &c, 1);
 46c:	8d 45 d7             	lea    -0x29(%ebp),%eax
 46f:	6a 01                	push   $0x1
 471:	50                   	push   %eax
 472:	57                   	push   %edi
 473:	e8 db fe ff ff       	call   353 <write>
  while(--i >= 0)
 478:	83 c4 10             	add    $0x10,%esp
 47b:	39 f3                	cmp    %esi,%ebx
 47d:	75 e1                	jne    460 <printint+0x80>
}
 47f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 482:	5b                   	pop    %ebx
 483:	5e                   	pop    %esi
 484:	5f                   	pop    %edi
 485:	5d                   	pop    %ebp
 486:	c3                   	ret
 487:	90                   	nop
 488:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 48f:	00 
  neg = 0;
 490:	31 c0                	xor    %eax,%eax
 492:	e9 70 ff ff ff       	jmp    407 <printint+0x27>
 497:	90                   	nop
 498:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 49f:	00 

000004a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4ac:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4af:	0f b6 13             	movzbl (%ebx),%edx
 4b2:	83 c3 01             	add    $0x1,%ebx
 4b5:	84 d2                	test   %dl,%dl
 4b7:	0f 84 a0 00 00 00    	je     55d <printf+0xbd>
 4bd:	8d 45 10             	lea    0x10(%ebp),%eax
 4c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 4c3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4c6:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 4c9:	eb 28                	jmp    4f3 <printf+0x53>
 4cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4d6:	88 55 e7             	mov    %dl,-0x19(%ebp)
  for(i = 0; fmt[i]; i++){
 4d9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4dc:	6a 01                	push   $0x1
 4de:	50                   	push   %eax
 4df:	56                   	push   %esi
 4e0:	e8 6e fe ff ff       	call   353 <write>
  for(i = 0; fmt[i]; i++){
 4e5:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4e9:	83 c4 10             	add    $0x10,%esp
 4ec:	84 d2                	test   %dl,%dl
 4ee:	74 6d                	je     55d <printf+0xbd>
    c = fmt[i] & 0xff;
 4f0:	0f b6 c2             	movzbl %dl,%eax
      if(c == '%'){
 4f3:	83 f8 25             	cmp    $0x25,%eax
 4f6:	75 d8                	jne    4d0 <printf+0x30>
  for(i = 0; fmt[i]; i++){
 4f8:	0f b6 13             	movzbl (%ebx),%edx
 4fb:	84 d2                	test   %dl,%dl
 4fd:	74 5e                	je     55d <printf+0xbd>
    c = fmt[i] & 0xff;
 4ff:	0f b6 c2             	movzbl %dl,%eax
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
 502:	80 fa 25             	cmp    $0x25,%dl
 505:	0f 84 25 01 00 00    	je     630 <printf+0x190>
 50b:	83 e8 63             	sub    $0x63,%eax
 50e:	83 f8 15             	cmp    $0x15,%eax
 511:	77 0d                	ja     520 <printf+0x80>
 513:	ff 24 85 78 08 00 00 	jmp    *0x878(,%eax,4)
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 520:	83 ec 04             	sub    $0x4,%esp
 523:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 526:	88 55 d0             	mov    %dl,-0x30(%ebp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 529:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 52d:	6a 01                	push   $0x1
 52f:	51                   	push   %ecx
 530:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 533:	56                   	push   %esi
 534:	e8 1a fe ff ff       	call   353 <write>
        putc(fd, c);
 539:	0f b6 55 d0          	movzbl -0x30(%ebp),%edx
  write(fd, &c, 1);
 53d:	83 c4 0c             	add    $0xc,%esp
 540:	88 55 e7             	mov    %dl,-0x19(%ebp)
 543:	6a 01                	push   $0x1
 545:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 548:	51                   	push   %ecx
  for(i = 0; fmt[i]; i++){
 549:	83 c3 02             	add    $0x2,%ebx
  write(fd, &c, 1);
 54c:	56                   	push   %esi
 54d:	e8 01 fe ff ff       	call   353 <write>
  for(i = 0; fmt[i]; i++){
 552:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 556:	83 c4 10             	add    $0x10,%esp
 559:	84 d2                	test   %dl,%dl
 55b:	75 93                	jne    4f0 <printf+0x50>
      }
      state = 0;
    }
  }
}
 55d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 560:	5b                   	pop    %ebx
 561:	5e                   	pop    %esi
 562:	5f                   	pop    %edi
 563:	5d                   	pop    %ebp
 564:	c3                   	ret
 565:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 568:	83 ec 0c             	sub    $0xc,%esp
 56b:	8b 17                	mov    (%edi),%edx
 56d:	b9 10 00 00 00       	mov    $0x10,%ecx
 572:	89 f0                	mov    %esi,%eax
 574:	6a 00                	push   $0x0
 576:	e8 65 fe ff ff       	call   3e0 <printint>
  for(i = 0; fmt[i]; i++){
 57b:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 57f:	83 c3 02             	add    $0x2,%ebx
 582:	83 c4 10             	add    $0x10,%esp
 585:	84 d2                	test   %dl,%dl
 587:	74 d4                	je     55d <printf+0xbd>
        ap++;
 589:	83 c7 04             	add    $0x4,%edi
 58c:	e9 5f ff ff ff       	jmp    4f0 <printf+0x50>
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 598:	8b 07                	mov    (%edi),%eax
        ap++;
 59a:	83 c7 04             	add    $0x4,%edi
        if(s == 0)
 59d:	85 c0                	test   %eax,%eax
 59f:	0f 84 9b 00 00 00    	je     640 <printf+0x1a0>
        while(*s != 0){
 5a5:	0f b6 10             	movzbl (%eax),%edx
 5a8:	84 d2                	test   %dl,%dl
 5aa:	0f 84 a2 00 00 00    	je     652 <printf+0x1b2>
 5b0:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5b3:	89 c7                	mov    %eax,%edi
 5b5:	89 d0                	mov    %edx,%eax
 5b7:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5ba:	89 fb                	mov    %edi,%ebx
 5bc:	8d 7d e7             	lea    -0x19(%ebp),%edi
 5bf:	90                   	nop
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 5c6:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 5c9:	6a 01                	push   $0x1
 5cb:	57                   	push   %edi
 5cc:	56                   	push   %esi
 5cd:	e8 81 fd ff ff       	call   353 <write>
        while(*s != 0){
 5d2:	0f b6 03             	movzbl (%ebx),%eax
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	84 c0                	test   %al,%al
 5da:	75 e4                	jne    5c0 <printf+0x120>
 5dc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 5df:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 5e3:	83 c3 02             	add    $0x2,%ebx
 5e6:	84 d2                	test   %dl,%dl
 5e8:	0f 85 d5 fe ff ff    	jne    4c3 <printf+0x23>
 5ee:	e9 6a ff ff ff       	jmp    55d <printf+0xbd>
 5f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 5f8:	83 ec 0c             	sub    $0xc,%esp
 5fb:	8b 17                	mov    (%edi),%edx
 5fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 602:	89 f0                	mov    %esi,%eax
 604:	6a 01                	push   $0x1
 606:	e8 d5 fd ff ff       	call   3e0 <printint>
  for(i = 0; fmt[i]; i++){
 60b:	e9 6b ff ff ff       	jmp    57b <printf+0xdb>
        putc(fd, *ap);
 610:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 612:	83 ec 04             	sub    $0x4,%esp
 615:	8d 4d e7             	lea    -0x19(%ebp),%ecx
        putc(fd, *ap);
 618:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 61b:	6a 01                	push   $0x1
 61d:	51                   	push   %ecx
 61e:	56                   	push   %esi
 61f:	e8 2f fd ff ff       	call   353 <write>
 624:	e9 52 ff ff ff       	jmp    57b <printf+0xdb>
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 630:	83 ec 04             	sub    $0x4,%esp
 633:	88 55 e7             	mov    %dl,-0x19(%ebp)
 636:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 639:	6a 01                	push   $0x1
 63b:	e9 08 ff ff ff       	jmp    548 <printf+0xa8>
          s = "(null)";
 640:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 643:	b8 28 00 00 00       	mov    $0x28,%eax
 648:	bf 71 08 00 00       	mov    $0x871,%edi
 64d:	e9 65 ff ff ff       	jmp    5b7 <printf+0x117>
  for(i = 0; fmt[i]; i++){
 652:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 656:	83 c3 02             	add    $0x2,%ebx
 659:	84 d2                	test   %dl,%dl
 65b:	0f 85 8f fe ff ff    	jne    4f0 <printf+0x50>
 661:	e9 f7 fe ff ff       	jmp    55d <printf+0xbd>
 666:	66 90                	xchg   %ax,%ax
 668:	66 90                	xchg   %ax,%ax
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax
 670:	66 90                	xchg   %ax,%ax
 672:	66 90                	xchg   %ax,%ax
 674:	66 90                	xchg   %ax,%ax
 676:	66 90                	xchg   %ax,%ax
 678:	66 90                	xchg   %ax,%ax
 67a:	66 90                	xchg   %ax,%ax
 67c:	66 90                	xchg   %ax,%ax
 67e:	66 90                	xchg   %ax,%ax

00000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	a1 7c 0b 00 00       	mov    0xb7c,%eax
{
 686:	89 e5                	mov    %esp,%ebp
 688:	57                   	push   %edi
 689:	56                   	push   %esi
 68a:	53                   	push   %ebx
 68b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 68e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 698:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 69f:	00 
 6a0:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a2:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a4:	39 ca                	cmp    %ecx,%edx
 6a6:	73 30                	jae    6d8 <free+0x58>
 6a8:	39 c1                	cmp    %eax,%ecx
 6aa:	72 04                	jb     6b0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ac:	39 c2                	cmp    %eax,%edx
 6ae:	72 f0                	jb     6a0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6b3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6b6:	39 f8                	cmp    %edi,%eax
 6b8:	74 36                	je     6f0 <free+0x70>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6ba:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6bd:	8b 42 04             	mov    0x4(%edx),%eax
 6c0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6c3:	39 f1                	cmp    %esi,%ecx
 6c5:	74 40                	je     707 <free+0x87>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6c7:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6c9:	5b                   	pop    %ebx
  freep = p;
 6ca:	89 15 7c 0b 00 00    	mov    %edx,0xb7c
}
 6d0:	5e                   	pop    %esi
 6d1:	5f                   	pop    %edi
 6d2:	5d                   	pop    %ebp
 6d3:	c3                   	ret
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d8:	39 c2                	cmp    %eax,%edx
 6da:	72 c4                	jb     6a0 <free+0x20>
 6dc:	39 c1                	cmp    %eax,%ecx
 6de:	73 c0                	jae    6a0 <free+0x20>
  if(bp + bp->s.size == p->s.ptr){
 6e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6e3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6e6:	39 f8                	cmp    %edi,%eax
 6e8:	75 d0                	jne    6ba <free+0x3a>
 6ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 6f0:	03 70 04             	add    0x4(%eax),%esi
 6f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	8b 02                	mov    (%edx),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6fd:	8b 42 04             	mov    0x4(%edx),%eax
 700:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 703:	39 f1                	cmp    %esi,%ecx
 705:	75 c0                	jne    6c7 <free+0x47>
    p->s.size += bp->s.size;
 707:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 70a:	89 15 7c 0b 00 00    	mov    %edx,0xb7c
    p->s.size += bp->s.size;
 710:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 713:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 716:	89 0a                	mov    %ecx,(%edx)
}
 718:	5b                   	pop    %ebx
 719:	5e                   	pop    %esi
 71a:	5f                   	pop    %edi
 71b:	5d                   	pop    %ebp
 71c:	c3                   	ret
 71d:	8d 76 00             	lea    0x0(%esi),%esi

00000720 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 72c:	8b 15 7c 0b 00 00    	mov    0xb7c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 732:	8d 78 07             	lea    0x7(%eax),%edi
 735:	c1 ef 03             	shr    $0x3,%edi
 738:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 73b:	85 d2                	test   %edx,%edx
 73d:	0f 84 8d 00 00 00    	je     7d0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 743:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 745:	8b 48 04             	mov    0x4(%eax),%ecx
 748:	39 f9                	cmp    %edi,%ecx
 74a:	73 64                	jae    7b0 <malloc+0x90>
  if(nu < 4096)
 74c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 751:	39 df                	cmp    %ebx,%edi
 753:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 756:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 75d:	eb 0a                	jmp    769 <malloc+0x49>
 75f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 760:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 762:	8b 48 04             	mov    0x4(%eax),%ecx
 765:	39 f9                	cmp    %edi,%ecx
 767:	73 47                	jae    7b0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 769:	89 c2                	mov    %eax,%edx
 76b:	39 05 7c 0b 00 00    	cmp    %eax,0xb7c
 771:	75 ed                	jne    760 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 773:	83 ec 0c             	sub    $0xc,%esp
 776:	56                   	push   %esi
 777:	e8 3f fc ff ff       	call   3bb <sbrk>
  if(p == (char*)-1)
 77c:	83 c4 10             	add    $0x10,%esp
 77f:	83 f8 ff             	cmp    $0xffffffff,%eax
 782:	74 1c                	je     7a0 <malloc+0x80>
  hp->s.size = nu;
 784:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 787:	83 ec 0c             	sub    $0xc,%esp
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	50                   	push   %eax
 78e:	e8 ed fe ff ff       	call   680 <free>
  return freep;
 793:	8b 15 7c 0b 00 00    	mov    0xb7c,%edx
      if((p = morecore(nunits)) == 0)
 799:	83 c4 10             	add    $0x10,%esp
 79c:	85 d2                	test   %edx,%edx
 79e:	75 c0                	jne    760 <malloc+0x40>
        return 0;
  }
}
 7a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7a3:	31 c0                	xor    %eax,%eax
}
 7a5:	5b                   	pop    %ebx
 7a6:	5e                   	pop    %esi
 7a7:	5f                   	pop    %edi
 7a8:	5d                   	pop    %ebp
 7a9:	c3                   	ret
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7b0:	39 cf                	cmp    %ecx,%edi
 7b2:	74 4c                	je     800 <malloc+0xe0>
        p->s.size -= nunits;
 7b4:	29 f9                	sub    %edi,%ecx
 7b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7bc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7bf:	89 15 7c 0b 00 00    	mov    %edx,0xb7c
}
 7c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7c8:	83 c0 08             	add    $0x8,%eax
}
 7cb:	5b                   	pop    %ebx
 7cc:	5e                   	pop    %esi
 7cd:	5f                   	pop    %edi
 7ce:	5d                   	pop    %ebp
 7cf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 7d0:	c7 05 7c 0b 00 00 80 	movl   $0xb80,0xb7c
 7d7:	0b 00 00 
    base.s.size = 0;
 7da:	b8 80 0b 00 00       	mov    $0xb80,%eax
    base.s.ptr = freep = prevp = &base;
 7df:	c7 05 80 0b 00 00 80 	movl   $0xb80,0xb80
 7e6:	0b 00 00 
    base.s.size = 0;
 7e9:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 7f0:	00 00 00 
    if(p->s.size >= nunits){
 7f3:	e9 54 ff ff ff       	jmp    74c <malloc+0x2c>
 7f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7ff:	00 
        prevp->s.ptr = p->s.ptr;
 800:	8b 08                	mov    (%eax),%ecx
 802:	89 0a                	mov    %ecx,(%edx)
 804:	eb b9                	jmp    7bf <malloc+0x9f>
