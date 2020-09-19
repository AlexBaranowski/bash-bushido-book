# Top and HTOP
In this chapter, I will introduce the top-rated tools for viewing and
monitoring Linux processes. There are many tools that help gather different
statistics about the system, processes, hardware, software, etc. However, I
decided to present `top` and `htop` process viewers/monitors because they
combine most of the useful ones in one place.  If you are interested in getting
more into the processes, how to monitor system with basics tools. I
recommend reading more about `procps-ng` and programs maintained by this
project (the top is one of them).

## top  - top tier serious process monitor

As said before, the `top` is one of the most well-known Unix (and Linux)
programs.  Most Linux distributions use the rewritten and much-improved version
of the old Unix top, the project that rewrote these tools with Linux in mind is
`procps-ng`. 


It's quite popular in the free software world to give `-ng` suffix to the
newer (in most cases rewritten or written from scratch) version of well-known
and established software.


Even if the old Unix style top is similar, most of the tricks presented in the
next chapters won't work! Below is the image of the top invoked in the FreeBSD
system.


![Original top\label{Original top}](images/10-top-htop/bsd_top.png)


The top itself presents a set of useful statistics about the current system
load/health/behaviour and processes running inside of it. However, output and
usage of the `top` program might be a little overwhelming, so I decided that we
can together get through it :) one step at the time.


Because `procps-ng` package (or `procps` in SUSE family) is part of the `core`
(or `minimal`) package group, in most (definitely in any reasonable modern
distro) cases, it is installed by default. Therefore, the `top` doesn't require
any extra steps to install.

## Top output step by step
To invoke the `top` just type its name, additional arguments are not required.


```
top
```

After invoking the top, you should get something like:


![top process viewer \label{top}](images/10-top-htop/top1.png)

As said earlier, the top might be overwhelming, let me decompose its output:

![top summary - uptime .\label{Top summary - uptime}](images/10-top-htop/top_summary_1.png)

On the first line, we have the name with which the top was invoked (you can have
multiple top configurations with different top name), then, the current time and
uptime (how long the system has been running) are shown.


The following information is the number of "users". Note that it counts users
the same way as other procps-ng commands, so it counts open user sessions
(terminals).
 
Then there is **extremely important statistic** - **load average**. Load
average says under what load our system was in the last 1, 5 and 15 minutes. By
rule of thumb, the number of load average should be less than CPU (threads)
count. Load average says how many processes wait to be run, so its possible
values range from 0 to infinity.


There is also an older statistic that is not present in the top,and  it's the
CPU utilization. The problem with the CPU utilization is that it's value
is from 0 to CPU or Threads Count. So, it is a bounded function.


Let's imagine that we have CPU that has 8 cores and disabled HyperThreading or
similar technologies. The CPU utilization equal to 8 and the load average
corresponding to 8 will result in a system that is still quite responsive,
fully loaded but not overloaded. The CPU Utilization equal to 8 and load
average equal to 123 will mean that the system is severely overloaded, and it's
hard to make even the simplest administrative operations on it.


The last thing that I would like to note is that the first top line is
identical to other procps-ng programs like `w` and `uptime`.

![Top summary task/threads.\label{Top summary - tasks/threads}](images/10-top-htop/top_summary_2.png)

The next part considers task or threads (depending on mode) that are managed
by the Linux Kernel, and their states. It's quite easy to see that the top doesn't
report all states because of the "total." the number is not equal to the sum of
all others. The reason for it is that not all states that process can be in are
listed, for example, the idle process state is not present.

To get all process states that are present in our system, one can use this simple one-liner.
```
ps ax -o state | sort | uniq
# OR with count
ps ax -o state | sort | uniq -c 
```


One of the most interesting columns here is the one counting **zombie**
processes. To simplify - zombies are processes that have finished their run,
and they are waiting for `wait()` from the parent process.
It's uncommon to see them because most programs can adequately deal with their
children and in the case of an orphaned process (one whose parent has finished
execution before its children), the init system (like systemd) automatically will
call wait when adopting them. To sum this up, the multiple conditions must be
met for the zombie process to occur.

![Top summary - states .\label{Top summary - states}](images/10-top-htop/top_summary_3.png)

The next line has info about the CPU States - there are following states:

- us(er): time running un-niced user processes (most processes)
- sy(stem): time running kernel processes
- ni(ce): time running niced processes
- id(le): time running idle (kernel idle handler)
- wa(it for IO): time waiting for I/O 
- hi[Hardware Interrups]  time spent servicing hardware interrupts
- si[Software Interrups]: time spent servicing software interrupts
- st(olen): time stolen from this VM by the hypervisor


In an alternative mode where the CPU report percentage of usage in a graph from. The graph has the following format:
```
[us+ni]/[sy] [sum of all excluding idle][Graph]
```

![Top summary - memory.\label{Top summary - memory}](images/10-top-htop/top_summary_4.png)

After Task/Threads statistics, comes the memory usage section. The **free**
section says how much memory wasn't used by the kernel, the **used** says how
much memory is really used, the **buff/cache** is responsible for counting
memory used by caching mechanism that makes a system faster by miles. The most
important statistic is presented in the next line.  **avail Mem** shows memory
that can be allocated by the kernel (in most cases with reducing buff/cache). 

This value doesn't count the swap space! There is a little **.** before
**avail Mem** that tries to separate the information about the swap and
continued physical memory statistics. Unfortunately, this might be
counterintuitive. Example without any swappable memory in the system that has
correctly counted/displayed available memory:

![Top summary - memory.\label{Top summary - memory}](images/10-top-htop/top_summary_4_2.png)

The swappable (sometimes called extended) memory statistics are self-explanatory.


The last part of top `top` is a called "task area". 

![Top summary - memory.\label{Top summary - memory}](images/10-top-htop/top_summary_5.png)

By default, there are the following columns (fields) in the task area:

- PID  - Process ID
- User - The user that owns process.
- PR - Priority. There are two types of priorities: Normal (number) and RT
  (Real Time). If you see RT, it means that the process is in the real-time
  mode.
- NI - Nice Value. Note that in the most cases priority = 20 + NICE. If you are
  unfamiliar with process niceness, please read `man 1 nice` and `man 2 nice`.
- VIRT - Virtual Image size. This is the calculated size of memory mapped by
  the process, memory used by the process, the files that are mapped into
  itself (shared libs) and memory shared with other processes. The VIRT in many
  cases is **the most misleading** and therefore useless value.
- RES - Resident Memory - the non-swapped physical memory a task is using.
- SHR - Shared Memory - the amount of memory that could be potentially shared
  with other processes
- S - process status (Running, Sleeping, Zombie, etc.).
- %CPU - The percentage of CPU time that the processes have used. If the process
  "ate" two cores (threads) of CPU, the 200% will be reported.
- %MEM - Used share of the **physical** memory.
- TIME+ - CPU Time - total CPU time the task has used since it started. `+`
  Means that it's presented in hundredths of seconds.
- COMMAND - Executed command.

## Customizing the TOP
Before making the customization, I strongly recommend making the top symlink
and then invoking `top` by it.
```
$ sudo ln -s /usr/bin/top /usr/bin/my_top
$ my_top
```
Now, the first line of the top will start with `my_top - `. This is a feature
based on the fact that the top, as any program invoked in the Linux, knows its
name. The top uses this information to give you the ability to make and maintain
multiple configurations.

The first practical thing that I recommend is to change the memory units. The
`top` in opposite to htop doesn't have intelligent unit scaling, it's static
and uses KiB that are too small to get clean information on most systems. Two
keys are responsible for memory scaling - `e` and `E`.  First, use `E` to
scale what unit is used to display memory in summary area. Then use `e` to change
how the memory is shown in the task area. I personally scale to megabytes or
gigabytes (I have never managed a server that had more than 1024 GB of RAM [and
I'm not ashamed of it!]).

Now we can commit our first changes. To save the current top settings, use `W` key.
Depending on procps-ng version the top rcfile will be placed in
`${HOME}/.${NAME}rc` or `${HOME}/.config/procps/.${NAME}rc` in the newer version.
In the newer version the legacy path (`~/.toprc`) is read first, then the one
from `XDG_CONFIG_HOME` variable (by default set to `~/.config`, XDG\_\* variables are
one defined by X Desktop Group) is used.

The next important setting that I change updates the update interval (time between refreshing
the statistics). The default value is 3 seconds. Delay value can be set
with `d` like **d**elay or `s` like **s**econds to the requested amount. The
value that I personally prefer is 5 seconds. But there is a possibility to use
absurd values from nearly zero like `0.00001` (the real-time between refreshing
will depend on the host performance; the top will consume 100% [one] CPU) to
more than 31536000 (exactly one year). The highest value that I can get is
2147483520.0 (when you add a small number to it the top will still use
2147483520.0, and in case of using more than 2147483583 the `top` will report
**Unacceptable floating point**.). But I believe that it depends on the
version, architecture and so on :). BTW 2147483520.0 is over 68 years, so
probably more than I will live :).

In the field management interactive menu, that is bound to the `f` key,
you can choose which fields are displayed. Choose a field with up/down arrow,
enable them with `space`, and move them with the right arrow, then up/down and
left to put in the desired place with the left arrow.  To choose the default
sort field use the `s` key. BTW: The default sort field doesn't have to be enabled!
In field management mode, you can also set the other windows that are
available in  `Alt-display` (alternative display mode, with four different
windows). To change the currently edited window use the `w` key. The window
that is used in the default mode is named `1:Def` like DEFault :).

In my case, I enabled the `nTH` field and `USED` field then disabled the `VIRT`
field. After it, I sorted the fields in the following manner  `PID`, `USER`,
`COMMAND`, `S`, `%CPU`, `nTH`, `USED`, `RES`, `SHR`, `%MEM`, `TIME+`, `NI`,
`PR`.

With fields the setup we can exit editing **SINGLE** `q` (double will exit the
top, without saving the configuration!), then use already known `W` to make
the configuration persistent.

When it comes to the fields, I highly recommend not to trust the `SWAP` field.
As said, before the `VIRT` in many cases might be a ~~little~~ misleading metric.
Because the top emulates the `SWAP` field with a simple formula `SWAP=VIRT-RES` in
most cases, it is plain wrong. You can observe the `SWAP` field having value greater
than  0 on systems that don't have any swap memory enabled. 

The last configuration adjustment that I made is the color change. I know that many
IT people (with a noble exception of UI/UX department) is not able to list 
more than 3 colors, but even if you are one (I'm saying this to myself) that
hates to set colors - Don't Panic! - the top allows using a whole stunning palette of
8 colors! So with little trial and error method you can get satisfying results.
Before editing colors, you must enable them with the `z` key that is a typical
toggle. 

To invoke color change mode use the `Z` key. With `S`,`M`, `H`, `T`, choose the
target (part of the top), and then with numbers between 0-7 select the colors.
After this operation, use `Enter` to save current the settings and
then `W` to make them persistent.

In my case, I used `S2 M1 H4 T7` that in my opinion look acceptable.

![Top summary - memory.\label{Top summary - memory}](images/10-top-htop/my_top_final.png)

### Sorting processes
One of the most essential functionality in the top is the ability to sort
the processes by a given filter or measurement. 


Two most popular are:

- `M` - sorts by memory usage - `M`emory.
- `P` - sorts by processor usage (%CPU) - `P`rocessor.

The other filters/sorts include:

- `u` - Filter on the username - `u`ser.
- `T` - Sort by TIME+ (consumed CPU time) - `T`ime.
- `N` - Sort by PID - `N`umber.

In order to flip the order of sorting (DESC/ASC) use `R` like `R`everse :).


The field on which the top will sort can also be chosen in the interactive
field management (`f` or `F`).

## Practical `top` usage

I will take the first and most important advice straight from the `top` manual
```
When  operating  top,  the  two most important keys are a help (’h’ or ’?’) and quit (’q’) key.
```
So, if anything is unclear, just use the built-in help or read the `man 1 top`.

Because the top is potent and robust, there is no need/way to memorize all keys
and settings.  As said before, when in doubt, use the help or the manual.
Netherless I'm going to present the most important ones.

### Sorting and filters

- `P` - sort processes by CPU usage - `P`rocessor.
- `M` - sort processes by memory usage - `M`emory.
- `n` - sort by PID - `n`umber.
- `<` and `>` - change the sort field.
- `u` - filter by `u`sername.
- `R` - `R`everse sort order.

### Useful top commands

- `k` - send a signal to a process, in most cases to `k`ill the process. The
  default signal is *15 SIGTERM*, in an act of desperation you can use *9 SIGKILL*
  that is more powerful than the default `SIGTERM`. SIGKILL is signal that cannot
  be ignored and is practically always fatal. Any valid Linux signal can be used.
- `r` - `r`enice process.

### Alternate-display mode

- `A` - enter/exit alternate-display mode.
- `w` or `a` - change currently managed window. 

Note that in alternate-display mode each has its own field and color
configuration.


### Summary area 

- `1`,`2`,`3` - change the way that CPU/S are showed. Note that first and
  seconds have two submodes.
- `t` - change the way the CPU load is showed.
- `m` - change the way that memory is showed
- `l` - enable/disable the first line.
- `H` - toggle between threads and tasks.

### Other useful commands

- `c` - enable/disable the absolute command path.
- `g` - change the the current window (task area) to another (the naming is not
  that clear, onc time we talk about windows, other times, it is called a field group and
  a task areas).
- `V` - enable the forest mode. In this mode, the top shows the output in
  a tree format quite similar to `pstree` command but within fields of
  the task area.

I highly recommend trying each of the presented keys, modes, and
configurations. Then try to find the setting that suits you the most.

## htop - top on steroids

The name `htop` came from `Hisham top` - the first letter is from the name of
the program author, but I personally remember it with the HyperTOP mnemonic.
`htop` is a better, easier-to-use, cleaner and more powerful, version of the `top`.
It's a self-desscriptive and easy-to-discover program. The only drawback of htop is
that it is not a part of the proc-ng so:

-  It's not a part of the minimal installation.
-  Not all vendors have it in their repositories. So, if you install a third-party
   package containing the `htop`, some vendors **might mark your system as
   unsupportable**, that is well ... stupid as f\*\*\*.

To install `htop` on Enterprise Linux distributions, you need the EPEL repository. 
```
sudo yum install -y epel-release; 
```
The epel-release is a package that sets up EPEL, so it contains repository info,
GPG keys and a preset that is used by the systemd. After installing EPEL, the `htop`
can easily be installed with yum.

```
sudo yum install -y htop
```

### Compiling the htop

If your vendor is not sane, you can compile the `htop` and place it into a not
standard path, that won't be gathered by the sosreport or any other system state
gathering utility.

Compiling the `htop` is extremely easy.
```
# Install build dependencies
sudo yum install -y @development git libncursesw ncurses-devel
# Compilation
git clone https://github.com/hishamhm/htop.git
cd htop
./autogen.sh && ./configure && make
sudo make install
```

Note that these commands will install the htop in the default location. In
order to install `htop` in different path, use
```
./autogen.sh && ./configure --perfix=/somewhere/over/rainbow && make
```


### Customizing the htop

Regarding the installation method, the `htop` can be invoked, like a top,
without any argument. So, to start it, just type `htop` on the command line.

We can start our customization by looking into help (`F1` from the bottom
menu). In many cases, there is a little problem. The `F1` key is bound to the
terminal emulator itself (in my case the `terminator`) and invokes the its'
help. What can you do to get to open the `htop` help? Well, it might sound
funny, but try to click F1 button.  Yeah, click it with a mouse. Contrary to
the prevailing opinion, it is possible to write the console program with
support for the mouse. Some ncurses based programs actually support this
feature, and `htop` is one of them. The other options to get built-in help are
the well-known top-like `?` or `h` keys.

With the help read, we can start the setup of our `htop`. The configuration file
is saved in `~/.config/htop/htoprc`, and despite the comment of the author, the
simpler parser used to read the config made the configuration file
human friendly. 

The htop with default configuration looks like: 

![htop default configuration \label{htop default configuration}](images/10-top-htop/htop_default.png)


To start the customization, enter the `Setup` with `F2` key or click on the
`Setup` with mouse :). The first thing that is worth noting is that the meters
section has two columns, and we can freely change the position of all elements. 
To change the position of an element (meter), select it (or use the mouse ;)), then
use `Enter` to enter the element move or add mode, then use arrows to move it
to the chosen place, then hit `Enter` one more time to commit the change. To change
the style of the meter printing (for example, bar chart, text information, or
seven-segment display ) use the `space` key.

The first thing that I'm always doing is removing the CPUs information broken
down into individual CPUs. It's really not practical when working with an 8+ CPUs
system (there are some edge cases when it might be useful, for example, if
there is a single thread application, but most services [DB, WEB, Network
file systems] support multiprocessing and multithreading). To remove this
information I choose (CPU 1/2 then CPU 2/2) metric then use the `delete` key. As
nearly always in htop it's possible to achieve same with the mouse. Next, I add
the **CPU Average** metric, and put it on the top of the left column and change
the printing style to **Text**.

I make similar changes until my left column has:

- Load average [Text]
- CPU [Text]
- Task Counter [Text]
- Memory [Text]
- Swap [Text]

And my right column has:

- Clock [Text]
- Uptime [Text]
- Battery [Bar]

I use the battery because my basic computer is my notebook. But I'm part of
the Glorious PC Gaming Master Race.

![PC MaStEr RaCe \label{PC MaStEr RaCe}](images/10-top-htop/meme1.jpg)

Honestly, I have a great gaming setup that I'm not using because of the lack of
time. Sometimes I wish one day to become rich and spend like a whole
week gaming! Of course, real gamers will consider this amount of time as
pathetic.


Back to the main topic - the next section is **Display options**. I have the following enabled:

- [x] Hide kernel threads - in most scenarios, the kernel threads give only the so-called "data smog".
- [x] Display threads in a different color
- [x] Highlight program "basename"
- [x] Highlight large numbers in memory counters
- [x] Detailed CPU time (SYSTEM/IO-wait/HARD-IRQ/Soft-IRQ/Steal/Guest)
- [x] Count CPUs from 0 instead of 1 - well most programming languages count from 0.

Because in most cases (might depend on your terminal settings), the default
colors scheme is excellent, I will skip **Colors** section, especially that `htop`
provides built-in themes so there is no much to set.

The last setup configuration phase is setting up the **Columns**, called Fields
in the top, I remove **VIRT (M_SIZE)**, metric and for my setup, this is the
end of this phase. There is a little curious that you can add the **OMM** column,
that gives Out-of-Memory (OMM) killer score. This might be useful for
exceptionally heavily loaded systems.


After the setup use the `F10` key to save changes.


My `htop` configurations after changes:

![htop customized \label{htop cutomized}](images/10-top-htop/htop_customized.png)


### Search/filter/sort processes
To search for or filter a process, you can use the `F3` or `F4` key. Search will look for
a single process that command matches the search string. You can kill, renice
or get environment information about the selected (or found) process. The
filter will show all processes that match the search string, the example below
filters processes that have `haroopad` in a name. Note that in both cases the search
string **is not a regular expression**.


![htop filter example \label{htop filter example}](images/10-top-htop/htop_filter.png)


The `htop` can also search for processes by PID. To do that, just type the PID.
The search is incremental. To get what it means - look at the following
example:

Imagine that we have the following  PIDs:

- 1 - systemd 
- 123 - auditd
- 12345 - spotify
- and there are no processes with PID 12 or 1234.

In that case the steps of searching and the results will look like:

- "" ()  
- "1" -> (systemd)  
- "12" ->  (systemd)  
- "123" ->  (auditd)  
- "1234" ->  (auditd)  
- "12345" -> (spotify).  

To sort processes, you can simply use `F6`, then select a column. As said before,
in some terminal emulators, you can also take an advantage of your mouse to click
on the column. What is quite obvious, but still worth mentioning, is that
sorting might be combined with filters. You can invert the sort order with the `I`
key. 

The last type of filters that I would like to demonstrate is filtering by a
user - to do so, use the `u` key then choose the user from the list - it's much more
convenient than having to type the whole username in the `top`. What is also
worth mentioning is that you can type the username and as soon as there is only
one match the `htop` will move the cursor to that user. For example, imagine that
you have a user - `root` and `rpc`. When `r` is typed, nothing happens, but
when the next letter `p` is inserted, `rpc` user will be selected.

### `top` compatibility keys in `htop`

- `M` - Sort processes by memory usage.
- `P` - Sort processes by CPU usage.
- `T` - Sort processes by time consumed by process.
- `k` - Sends chosen signal, mostly used to kill a process.

### Other useful htop commands

- `p` - `p`rint absolute command path
- `e` - Shows the `e`nvironment of the selected process.
- `s` - Enable `s`trace mode of the process (requires strace).
- `l` - display open files (requires lsof).
- `I` - `I`nvert the sort order.
- `a` - Set CPU `a`ffinity: set which CPUs process can use.
- `i` - set IO/Priority (uses ionice).
- `<`, `>`, `.`, `,` `F6` - set the sorting field.


## Summary
After reading this chapter, manuals `man 1 top` and `man 1 htop`, you should
understand not only how to use these programs, but also learn a lot about process-related
topics like what is priority or state in which the processes can be. I also
highly recommend `man 5 proc` that provides information about the Linux `/proc`
pseudo-file system.

\pagebreak

