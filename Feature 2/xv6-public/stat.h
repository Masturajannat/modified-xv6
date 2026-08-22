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

#define FD_TYPE_NONE  0
#define FD_TYPE_PIPE  1
#define FD_TYPE_INODE 2

struct fdinfo {
  int type;          // FD_TYPE_NONE, FD_TYPE_PIPE, FD_TYPE_INODE
  int dev;           // Device number (if inode)
  uint inum;         // Inode number (if inode)
  short nlink;       // Number of links (if inode)
  uint size;         // Size of file in bytes (if inode)
  uint off;          // Current file offset
  char readable;     // 1 if readable, 0 otherwise
  char writable;     // 1 if writable, 0 otherwise
};

