#define T_DIR  1   // Directory
#define T_FILE 2   // File
#define T_DEV  3   // Device

struct stat {
  short type;  // Type of file
  int dev;     // File system's disk device
  uint ino;    // Inode number
  short nlink; // Number of links to file
  uint size;   // Size of file in bytes
};
#define FDINFO_NONE  0
#define FDINFO_PIPE  1
#define FDINFO_INODE 2

struct fdinfo {
  int fd;
  int filetype;
  short type;
  int dev;
  uint ino;
  short nlink;
  uint size;
  uint off;
  char readable;
  char writable;
};
