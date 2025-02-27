# 🚀 **LINUX COMMANDS**

## **1. Navigating Files & Directories**

These commands help you move around the file system.

| Command | Description                          | Useful Flags                                                                |
| ------- | ------------------------------------ | --------------------------------------------------------------------------- |
| `ls`    | Lists files and directories          | `-l` (detailed list), `-a` (show hidden files), `-h` (human-readable sizes) |
| `cd`    | Changes directory                    | `cd ..` (move up one level), `cd -` (switch to the previous directory)      |
| `pwd`   | Prints the current working directory | _(No flags needed)_                                                         |

**Examples:**

```sh
ls -la      # List all files including hidden ones with details
cd /home    # Move to the /home directory
pwd         # Show current directory path
```

---

## **2. Manipulating Files & Directories**

These commands allow you to create, move, copy, and delete files.

| Command | Description                  | Useful Flags                                               |
| ------- | ---------------------------- | ---------------------------------------------------------- |
| `touch` | Creates an empty file        | _(No flags needed)_                                        |
| `mkdir` | Creates a new directory      | `-p` (create parent directories if they don't exist)       |
| `rm`    | Deletes files or directories | `-r` (remove directories recursively), `-f` (force delete) |
| `cp`    | Copies files or directories  | `-r` (copy directories recursively), `-v` (verbose output) |
| `mv`    | Moves or renames files       | `-i` (prompt before overwriting), `-v` (verbose output)    |

**Examples:**

```sh
touch file.txt        # Create an empty file
mkdir -p dir/subdir   # Create directories, including parent ones
rm -rf myfolder       # Force delete 'myfolder' and its contents
cp -rv source/ dest/  # Copy 'source' directory to 'dest' with verbose output
mv file.txt newfile.txt  # Rename file
```

---

### **3. Searching Files & Text**

Find files and search inside them.

| Command  | Description                    | Useful Flags                                                                   |
| -------- | ------------------------------ | ------------------------------------------------------------------------------ |
| `find`   | Searches for files             | `-name` (search by name), `-type f` (only files), `-type d` (only directories) |
| `grep`   | Searches for text inside files | `-i` (case-insensitive), `-r` (recursive search), `-n` (show line numbers)     |
| `locate` | Finds files using a database   | `-i` (case-insensitive), `-c` (count matches)                                  |

**Examples:**

```sh
find /home -name "*.txt"    # Find all .txt files in /home
grep -rn "error" /var/log/  # Search for 'error' in log files recursively
locate -i document.pdf      # Find 'document.pdf' (case-insensitive)
```

---

### **4. File Permissions & Ownership**

Manage access control for files and directories.

| Command | Description              | Useful Flags            |
| ------- | ------------------------ | ----------------------- |
| `chmod` | Changes file permissions | `-R` (recursive change) |
| `chown` | Changes file ownership   | `-R` (recursive change) |

**Examples:**

```sh
chmod 755 script.sh    # Set read/write/execute permissions
chmod -R 644 folder/   # Set permissions recursively
chown user:group file  # Change owner to 'user' and group to 'group'
```

#### **1. Understanding File Permissions**

Each file and directory in Linux has **three types of permissions**:

| Permission | Symbol  | Meaning                                                                |
| ---------- | ------- | ---------------------------------------------------------------------- |
| Read       | `r` (4) | Allows viewing file contents or listing directory contents             |
| Write      | `w` (2) | Allows modifying file contents or adding/removing files in a directory |
| Execute    | `x` (1) | Allows running a file as a program or entering a directory             |

Permissions are assigned to **three types of users**:

1. **Owner** (`u`) → The user who created the file
2. **Group** (`g`) → A group of users who share access
3. **Others** (`o`) → Everyone else

---

#### **2. Viewing File Permissions**

Use the `ls -l` command to check permissions:

```sh
ls -l file.txt
```

**Example Output:**

```
-rw-r--r-- 1 user group 1234 Feb 14 12:34 file.txt
```

**Breakdown of `-rw-r--r--`**:
| Symbol | Meaning |
|--------|---------|
| `-` | Regular file (`d` means directory) |
| `rw-` | Owner has read (`r`) and write (`w`) permissions, but not execute (`-`) |
| `r--` | Group members have read-only access (`r--`) |
| `r--` | Others also have read-only access (`r--`) |

---

#### **3. Changing File Permissions with `chmod`**

The `chmod` command is used to modify file permissions.

##### **A. Using Numeric Mode (Octal)**

Each permission is assigned a number:

- `r = 4`
- `w = 2`
- `x = 1`

To set permissions, add up the values:

| Permission | Numeric Value |
| ---------- | ------------- |
| `rwx`      | 7 (`4+2+1`)   |
| `rw-`      | 6 (`4+2`)     |
| `r--`      | 4 (`4`)       |
| `---`      | 0             |

**Example Commands:**

```sh
chmod 755 script.sh   # Owner: rwx (7), Group: r-x (5), Others: r-x (5)
chmod 644 file.txt    # Owner: rw- (6), Group: r-- (4), Others: r-- (4)
chmod 700 secret.txt  # Owner: rwx (7), Group: --- (0), Others: --- (0)
```

#### **B. Using Symbolic Mode**

Symbolic mode allows you to modify permissions without setting them completely.

| Symbol | Meaning                   |
| ------ | ------------------------- |
| `u`    | Owner (user)              |
| `g`    | Group                     |
| `o`    | Others                    |
| `a`    | All (user, group, others) |
| `+`    | Add permission            |
| `-`    | Remove permission         |
| `=`    | Set exact permission      |

**Example Commands:**

```sh
chmod u+x script.sh   # Add execute permission for the owner
chmod g-w file.txt    # Remove write permission from the group
chmod o=r public.txt  # Set others to read-only
chmod a+rw shared.txt # Allow everyone to read and write
```

---

### **4. Changing File Ownership with `chown`**

The `chown` command changes the **owner** and **group** of a file.

**Syntax:**

```sh
chown [new_owner]:[new_group] file
```

**Example Commands:**

```sh
chown alice file.txt       # Change owner to 'alice'
chown alice:staff file.txt # Change owner to 'alice' and group to 'staff'
chown :developers file.txt # Change only the group to 'developers'
chown -R alice folder/     # Change ownership of all files inside 'folder/'
```

---

### **5. Changing Group Ownership with `chgrp`**

If you only want to change the group of a file without modifying the owner, use `chgrp`.

**Example:**

```sh
chgrp developers file.txt  # Change group to 'developers'
chgrp -R staff folder/     # Change group of all files inside 'folder/'
```

---

### **6. Special Permissions: SUID, SGID, and Sticky Bit**

These are advanced permissions used in specific scenarios.

| Permission              | Symbol                        | Meaning                                                                      |
| ----------------------- | ----------------------------- | ---------------------------------------------------------------------------- |
| **Set User ID (SUID)**  | `s` in owner execute (`rws`)  | Allows a file to run as the owner, useful for system utilities like `passwd` |
| **Set Group ID (SGID)** | `s` in group execute (`rws`)  | Allows files created in a directory to inherit the group                     |
| **Sticky Bit**          | `t` in others execute (`rwt`) | Prevents others from deleting files in a directory except the owner          |

**Example Commands:**

```sh
chmod u+s script.sh   # Enable SUID (run as owner)
chmod g+s shared_dir  # Enable SGID (group inheritance)
chmod +t /tmp         # Enable sticky bit (common in /tmp)
```

**Checking Special Permissions:**

```sh
ls -l
```

**Example Output:**

```
-rwsr-xr-x 1 root root 12345 Feb 14 12:34 /usr/bin/passwd
drwxrwsr-x 2 user staff 4096 Feb 14 12:34 shared_folder
drwxrwxrwt 2 root root 4096 Feb 14 12:34 /tmp
```

- **SUID (`s` in owner execute):** `/usr/bin/passwd`
- **SGID (`s` in group execute):** `shared_folder`
- **Sticky Bit (`t` in others execute):** `/tmp`

---

### **7. Recap of Important Commands**

| Command                 | Description                             |
| ----------------------- | --------------------------------------- |
| `ls -l`                 | View file permissions                   |
| `chmod 755 file`        | Set file permissions using numeric mode |
| `chmod u+x file`        | Modify permissions using symbolic mode  |
| `chown user file`       | Change file owner                       |
| `chown user:group file` | Change file owner and group             |
| `chgrp group file`      | Change file group                       |
| `chmod u+s file`        | Enable SUID (Set User ID)               |
| `chmod g+s dir`         | Enable SGID (Set Group ID)              |
| `chmod +t dir`          | Enable Sticky Bit                       |

---

## **5. Managing Processes**

Monitor and control running programs.

| Command | Description                    | Useful Flags                                      |
| ------- | ------------------------------ | ------------------------------------------------- |
| `ps`    | Shows active processes         | `-aux` (detailed list of all processes)           |
| `kill`  | Stops a process by ID          | `-9` (force kill)                                 |
| `top`   | Displays system resource usage | _(No flags needed)_                               |
| `htop`  | Interactive process viewer     | _(No flags needed, but may require installation)_ |

**Examples:**

```sh
ps aux              # Show all running processes
kill -9 1234        # Force kill process with PID 1234
top                 # Show real-time system usage
htop                # Interactive process viewer
```

---

## **6. Networking Commands**

Useful for checking connectivity and network status.

| Command   | Description                           | Useful Flags                                |
| --------- | ------------------------------------- | ------------------------------------------- |
| `ping`    | Checks connectivity to a host         | `-c` (set number of packets)                |
| `curl`    | Fetches data from a URL               | `-I` (fetch headers only), `-O` (save file) |
| `wget`    | Downloads files from the internet     | `-c` (resume download)                      |
| `netstat` | Displays network connections          | `-tulnp` (show listening ports)             |
| `ss`      | More modern replacement for `netstat` | `-tulnp` (show listening ports)             |

**Examples:**

```sh
ping -c 4 google.com    # Ping Google with 4 packets
curl -I example.com     # Get HTTP headers from a website
wget -c file.zip        # Resume an interrupted download
netstat -tulnp          # Show all active network connections
ss -tulnp               # Show active connections (alternative to netstat)
```

---

#### **Bonus: Other Useful Commands**

- **Disk Usage & Storage**
  ```sh
  df -h      # Show disk space usage in human-readable format
  du -sh *   # Show size of all files and directories
  ```
- **System Info**
  ```sh
  uname -a   # Show OS and kernel details
  uptime     # Show system uptime
  ```
- **User Management**
  ```sh
  whoami     # Show current username
  sudo su    # Switch to root user
  ```

---

This should give you a solid foundation in Linux commands! Let me know if you want more details or examples. 🚀
