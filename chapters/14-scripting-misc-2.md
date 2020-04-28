## Reset your terminal
Sometimes after reading a binary file, your console or Bash might get devasted.
Some characters will be missing, others will be printed in an unpredictable
manner, etc. To get your session back on tracks, use a simple `reset`. According
to The Internet "it's not a miracle solution", but it never failed me. The
funny thing is that `reset` is a symbolic link to the `tset` program. But invoking
`tset` without any argument won't reset terminal. So, logical conclusion is
that tset must check if it's started/invoked as a `reset` command.


After checking sources of ncurses 5.9 (used in Enterprise Linux 7), there is
this part of code in file `/progs/tset.c`.

```c
// flag
static bool isreset = FALSE;    /* invoked as reset */
// More code
// in int main you can find following
    if (same_program(_nc_progname, PROG_RESET)) {
    isreset = TRUE;
    reset_mode();
    }
```

## Resolve symbolic links
Sometimes you might want to get the real (physical) path that you are currently
on. Unfortunately there is no option that will enable automatic symbolic links
resolving in the Bash shell. As symbolic links are convenient, sometimes, they
might be misleading, for example, a symbolic link that leads from one
filesystem to another.  It's also possible to make a symbolic link loop, that
makes the current working directory unnecessarily long, it also trivial to make
the "loop" of symbolic links. Look at the following self-contain example.

```
[Alex@Normandy tmp]$ mkdir -p d1/d2/d3
[Alex@Normandy tmp]$ cd d1
[Alex@Normandy d1]$ ln -s d2/d3 l3
[Alex@Normandy d1]$ cd d2/d3
[Alex@Normandy d3]$ ln -s .. l2
[Alex@Normandy d3]$ cd ../.
[Alex@Normandy d1]$ cd l3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/
[Alex@Normandy l2]$ pwd
/home/Alex/Documents/BashBushido/tmp/d1/l3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2
[Alex@Normandy l2]$ pwd -P
/home/Alex/Documents/BashBushido/tmp/d1/d2
```


In this example, there is a trivial loop "l2->d3->l2->d3...". Going back to the
**d1** directory requires "unwarping" the loop. To make Bash resolve the symbolic
links, the `PROMPT_COMMAND` introduced in [## Executing the chosen commands before the prompt](Executing the chosen commands before the prompt.) might be used.

```
export PROMPT_COMMAND='[ "$(pwd)" == "$(pwd -P)" ] || cd "$(pwd -P)"'.
```

This short code checks if the output of `pwd` and "-p"hysical `pwd` is the
same, and if not ('||' - Bash OR operator) changes the directory to the physical
one. Note that the command is put in `'` so it won't expand when exporting
the PROMPT_COMMAND variable.

After exporting, cd into the same loop will result in:

```
[Alex@Normandy d1]$ cd l3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/
[Alex@Normandy d2]$ pwd
/home/Alex/Documents/BashBushido/tmp/d1/d2
```


There is also the second **easier** solution! You can alias the `cd` to `cd
-P`. The `-P` option lets you "use the physical directory structure without
following symbolic links".

```
[Alex@Normandy d2]$ export PROMPT_COMMAND=''
[Alex@Normandy d1]$ cd -P l3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/
[Alex@Normandy d2]$ pwd
/home/Alex/Documents/BashBushido/tmp/d1/d2
[Alex@Normandy d2]$ cd ..
[Alex@Normandy d1]$ cd  l3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/
[Alex@Normandy l2]$ pwd
/home/Alex/Documents/BashBushido/tmp/d1/l3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2
[Alex@Normandy d1]$ alias cd='cd -P'
[Alex@Normandy d1]$ cd l3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/d3/l2/
[Alex@Normandy d2]$ 
```


Unfortunately there is no such option for `pushd`.

## batch

Batch is a little program similar to the previously introduced `at`. Batch
executes a command when the system load is below a specific value. This
value is set at the compilation, and in the most system, it's **0.8**. To
change this value, you have to set the default value at which atd (AT Daemon)
starts. In Enterprise Linux Distributions the `/etc/sysconfig/atd`  is read by
`atd` daemon. With proper options set in the `OPTS` variable, you can get the
desired effect. For example `OPTS="-l 3.2"` that sets the load average for the
`batch` to 3.2.

Batch is used in a similar way as at, of course the time is skipped.
```
[root@Normandy ~]# uptime
 00:59:39 up 4 days, 10:03, 11 users,  load average: 0.80, 0.87, 0.82
[root@Normandy ~]# batch 
at> date >> /etc/created_by_batch
at> uptime >> /etc/created_by_batch
at> <EOT>
job 9 at Fri Jun 21 00:59:00 2019
[root@Normandy ~]# atq
9  Fri Jun 21 00:59:00 2019 b root
[root@Normandy ~]# cat /etc/created_by_batch
cat: /etc/created_by_batch: No such file or directory
```

After some time, when the load average drops below 0.8, the script was executed.
```
[root@Normandy ~]# cat /etc/created_by_batch 
Fri Jun 21 01:02:01 CEST 2019
 01:02:01 up 4 days, 10:05, 11 users,  load average: 0.40, 0.81, 0.81
```

Some user might discover that atd has 1 minute time graduality and executes
jobs at the beginning of the new minute.

## Why some Linux/UNIX programs have strange names?

I know that in this chapter you won't find exciting new command or any useful
trick :). But... -  Have you ever asked yourself why some basic Linux
command/programs like `passwd` or `umount` have strange names? `umount` is the
best example because there is an actual word - unmount! What is the reason for
these peculiar names, that sometimes save only a single character?

Well, it came from version 1 of UNIX. This UNIX was written in assembly and
supported B (the predecessor of C) programming language. It also had a rather
primitive filesystem that supports only 8-character file names, so it have to
support `umount` as the command but also its sources - `umount.s` ('.s' and '.S'
are file extension for assembly language). Other lead is that the old linkers
support identifiers up to 6 characters only.

\pagebreak

