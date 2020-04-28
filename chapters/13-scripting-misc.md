# Miscellaneous scripting topics

This chapter is the essence of Bash Bushido, it's the longest chapter in the
whole book, and it contains a lot of small solutions and programs that any
sysadmin/devops/production engineer can use.


## Repeat until success.

Sometimes there is a need to repeat the command as long as there is no success.
In most cases, three constructions are used.

1. Run until success - never give up :) (meme below)
2. Run until success with a counter.
3. Run until success with a timeout.

![Endless loop](images/13-scripting/genius.jpg)


- 1st case:
  ```bash
  while true; do
      this_command_might_fail && break;
      sleep 5; # Sleep well little angel!
  done
  ```
- 2nd case:
  ```bash
  RETRY_COUNTER=1
  while true ;do
      if [[ RETRY_COUNTER -gt 10 ]]; then
          echo "Sorry it didn't work"
          exit 1
      fi
      echo "I'm trying for $RETRY_COUNTER time"
      this_command_might_fail && break;
      RETRY_COUNTER=$((RETRY_COUNTER+1))
      sleep 5; # You might add some sleep
  done
  ```
- 3rd case:
  ```bash
  MY_TIMEOUT=60
  MY_BASE_TIME=$( date +%s )
  while true; do
      MY_CURRENT_TIME=$( date +%s )
      if [[ $(( MY_BASE_TIME - MY_CURRENT_TIME + MY_TIMEOUT )) -lt 0 ]]; then
          echo "Timeout trap - sorry :(."
          exit 1
      fi
      this_command_might_fail && break;
      echo "It didn't work! I hope that I won't hit timeout!"
      sleep 5; # You might add some sleep
  done
  ```


In the third case, we use epoch time - a number of seconds since 00:00:00 UTC,
Thursday, 1 January 1970. It's also called Unix Time.

## Print lines based on the lines number.

`sed` is one of the mysterious, powerful tools from Unix that only guys with
beards longer than their... FINGERS can understand. SED stands for Stream
EDitor - it means that it takes stream (the file, pipe, stdin) of characters
and performs an operation on it. That's it :). It sounds simple - but like a lot
of things in Unix - the simple, clean ideas can result in absurdly powerful
tools.

One of the easiest problems that can be solved with sed is printing only
selected lines. To do so, use 'N,Mp' command. The `N` and `M` are numbers of
lines when `p` is sed command that accepts address range. In the example below,
lines from 3 to 10 are printed.

```
[root@Normandy ~]# cat -n /etc/passwd > n_passwd # cat -n number the lines
[root@Normandy ~]# sed -n '3,10p' n_passwd 
     3  daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4  adm:x:3:4:adm:/var/adm:/sbin/nologin
     5  lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6  sync:x:5:0:sync:/sbin:/bin/sync
     7  shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8  halt:x:7:0:halt:/sbin:/sbin/halt
     9  mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    10  operator:x:11:0:operator:/root:/sbin/nologin
```

There is a possibility to get similar results without sed, but they require
multiple commands and are slower.

```bash
[root@Normandy ~]# cat  n_passwd | head -10 | tail -8
     3  daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4  adm:x:3:4:adm:/var/adm:/sbin/nologin
     5  lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6  sync:x:5:0:sync:/sbin:/bin/sync
     7  shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8  halt:x:7:0:halt:/sbin:/sbin/halt
     9  mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    10  operator:x:11:0:operator:/root:/sbin/nologin
```

In both cases, `cat` command can be omitted. I decide to add it only to make
the examples cleaner.

## Tail on changes
When debugging services admins look into log files. But the logs grow and
reading the full content each time can be extremely time consuming or even
impossible. The answer to this problem is the tail `follow` mode. In this mode `tail`
prints data appended to the file.  The flag (switch/option) that enables it is
`-f` or `--follow.` Sample with `/var/log/audit/audit.log.`

```
[root@tmpcdn ~]# tail -1 -f /var/log/audit/audit.log type=SERVICE_STOP ...
# Add some enters to separate events. Next part
# was logged after sudo invocation

type=USER_CMD msg=audit(1537357799.016:603): ...  
```

## Substitute the string in a file.
The most popular usage of sed is replacing (substituting) a string in a file. To
demonstrate this capability, I used the following text:

```
sed is a stream editor.
Sed is sed SED SED sed
```

That is saved as **orig.txt**.
To replace a string use following sed command `s/OLD/NEW/[MODS]`,
where **MODS** can be skipped.  A simple change from sed to seed:

```bash
[Alex@Normandy tmp]$ sed 's/sed/seed/' orig.txt 
seed is a stream editor.
Sed is seed SED SED sed
```
As you can see only the first occurance in a line was changed. To make the replacing
"global", so it changes multiple occurrences in line that has them add the **g**
modifier.

```bash
[Alex@Normandy tmp]$ sed 's/sed/seed/g' orig.txt 
seed is a stream editor.
Sed is seed SED SED seed 
```

To make the `sed` replacing case insensitive, add **i** modifier.

```bash
[Alex@Normandy tmp]$ sed 's/sed/seed/gi' orig.txt 
seed is a stream editor.
seed is seed seed seed seed
```


## Remove selected line/lines from a file.
Sed can also be used to remove the line/lines from the file. Imagine a test
file named **remove.txt** that has the following content:

```
     1  root:x:0:0:root:/root:/bin/bash
     2  bin:x:1:1:bin:/bin:/sbin/nologin
     3  daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4  adm:x:3:4:adm:/var/adm:/sbin/nologin
     5  lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6  sync:x:5:0:sync:/sbin:/bin/sync
     7  shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8  halt:x:7:0:halt:/sbin:/sbin/halt
     9  mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
    10  operator:x:11:0:operator:/root:/sbin/nologin
```


It was made with `cat -n /etc/passwd | head -10`. Now, to remove line number 9
that has mail user the following sed command can be used **N[,M]d**. The N,M
are integers.  The `[,M]` parameter, this parameter creates a range, can be
skipped, in that case sed will remove only the selected line.

```
[Alex@Normandy tmp]$ sed '9d' remove.txt 
     1  root:x:0:0:root:/root:/bin/bash
     2  bin:x:1:1:bin:/bin:/sbin/nologin
     3  daemon:x:2:2:daemon:/sbin:/sbin/nologin
     4  adm:x:3:4:adm:/var/adm:/sbin/nologin
     5  lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6  sync:x:5:0:sync:/sbin:/bin/sync
     7  shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8  halt:x:7:0:halt:/sbin:/sbin/halt
    10  operator:x:11:0:operator:/root:/sbin/nologin
```


To remove lines from 2 to 9, the following `sed` command can be used:

```
[Alex@Normandy tmp]$ sed '2,9d' remove.txt 
     1  root:x:0:0:root:/root:/bin/bash
    10  operator:x:11:0:operator:/root:/sbin/nologin
```


## Change the file with sed in place
To change the file in place, the `-i` option can be used. Let's reuse orig.txt
file from the previous examples.


```
sed is a stream editor.
Sed is sed SED SED sed
```

After using:

```bash
[Alex@Normandy tmp]$ sed 's/sed/seed/gI' orig.txt 
seed is a stream editor.
seed is seed seed seed seed 
```

The file stays the same. But if you run sed with `-i` option sed will change
the file `i`n place
```bash
[Alex@Normandy tmp]$ sed -i 's/sed/seed/gI' orig.txt 
[Alex@Normandy tmp]$ cat orig.txt 
seed is a stream editor.
seed is seed seed seed seed 
```

## Make the script exit on the first error
One of the most common mistakes that programmers make is the fact that their
scripts don't stop on the first error. Most programming languages will
terminate if there is an exception that is not handled. But not Bash. BaSh iS
StRoNG, aNd NeVer DooonT GiVE Up! Let's look at the following code:


```bash
#!/usr/bin/env bash

destroy_entire_planet(){
    echo "Refresh the trigger"
    touch /tmp/death_star_trigger
    sleep $((RANDOM%3 +1))
    echo "Planet $1 destroyed"
}

# Check if it's safe to destroy planet exit if false
check_if_planet_save_to_destroy_or_exit
# actually destroy a planet
destroy_entire_planet $1
```


This code was written by one of the interns that decided that automating his
job is a great idea! Then decided to try it on planet "ButtHurt", where all the fans
(like me) of the older Star Wars live.

```
[intern128539494@DeathStar my_home]$./destroy.sh ButtHurt
./destroy.sh: line 11: check_if_planet_save_to_destroy_or_exit: command not found
Refresh the trigger
Planet ButtHurt destroyed
```
And BANG BANG! Even if the whole function (routine, subprogram) is not
implemented, Bash didn't stop the execution. It's great when using command line
interactively, so each typo like `pdw` instead of `pwd` doesn't log the user out,
but it's really undesirable for scripts. There is interesting option that
enables instant exit when a command fails (based on not zero exit status!). It
is `-e` it can be set in script with the `set` command.

```bash
#!/usr/bin/env bash
# Stop script on first error
set -e

destroy_entire_planet(){
```
To disable it, you can use `set +e`. Disabling might be useful when you know
that a command might fail, and you want to branch the script depending on its
exit status.


There is also the possibility to set the options for bash with `env` in
shebang, but **only in the newer coreutils**. Then the first line of the script
looks like:

```bash
#!/usr/bin/env -S bash -e
```

The `-S` options inform the `env` that is should split the rest of the string
('bash -e' -> ['bash', '-e']).


## More safety features in bash scripts
There are at least two basic additional safety features that everyone should
use. First one is the usage of a not defined variable. Imagine the following code
that is saved in removeHome.sh
```
#!/usr/bin/env bash
set -e

TO_REMOVE=$1

echo "Gonna remove all files from /home/$TO_REMOVE"
# rm -rf /home/$TO_REMOVE
```

This script will work! What's gonna happen when the first argument is not
provided? Well, the `/home/` will be removed (EUID must be equal to 0). There
is another safety feature in Bash that treats the usage of unset variable as an
error.  With the `-e` option, it will stop the script execution. This option
can be set with  `set -u`. After a little change in the script
```
#!/usr/bin/env bash
set -eu
```

The script that uses not defined/unbound variable won't work.

```
[Alex@Normandy tmp]$ ./removeHome.sh 
./removeHome.sh: line 4: $1: unbound variable
```

Without `set -e` the `-u` won't exit, but it will mark command as failed.
Following example uses `$$` variable that contains current shell PID and `$?`
variable that contains the last command exit status.

```
[Alex@SpaceStation ~]$ echo $$ # Bash 1
26333
[Alex@SpaceStation ~]$ bash # starting shell in shell
[Alex@SpaceStation ~]$ echo $$ # Bash 2 
26800
[Alex@SpaceStation ~]$ echo $asdfasdf # this variable doesn't exist

[Alex@SpaceStation ~]$ echo $? # but echo returns 0
0
[Alex@SpaceStation ~]$ set -u  # enables -u
[Alex@SpaceStation ~]$ echo $asdfasdf # this variable doesn't exist
bash: asdfasdf: unbound variable
[Alex@SpaceStation ~]$ echo $? #command returns 1; echo wasn't even executed
1
[Alex@SpaceStation ~]$ echo $$ # we are still  in second shell
26800
[Alex@SpaceStation ~]$ set -e
[Alex@SpaceStation ~]$ echo $asdfasdf # this command will fail and exit shell
bash: asdfasdf: unbound variable 
[Alex@SpaceStation ~]$ echo $$ # Bash1
26333
```



Another feature that should be used, is checking if **any** command in the pipe
exited with a not-zero status.

Look at the code saved into **test_fail.sh**:
```
#!/usr/bin/env bash
set -eu

true | false | true
echo "Ain't nothing but a mistake"
false | true
echo "Tell me why "
false | true | true
echo "I never want to hear you say"
false | false | true
echo "I want it that way"
```


When invoked it prints part of chorus from "I Want It That Way" by Backstreet Boys.
```
[Alex@Normandy tmp]$ ./test_fail.sh 
Ain't nothing but a mistake
Tell me why
I never want to hear you say
I want it that way
```

Note that each time the last command in the pipe exit with 0 exit code/status, but
some commands inside the pipe failed (non-zero exit status). It's safe to
conclude that as long as the last command exits with a zero, the whole pipe is
considered correct. But in the real world, it's undesirable. The failed program
inside the pipe means that something went wrong. The other aspect is that a lot
of commands nearly always finish with a zero status, for example, `sort`.

It's highly recommended that the `-o pipefail` is set. This option mark the
whole pipe failed if **any** of its components fails.

So after change `set` line into
```
set -euo pipefail
```
The `./test_file.sh` won't print anything (exits after the first pipe). The
`set -euo pipefail` is considered a standard minimal safeguard for scripts.


## echo to stderr
Sometimes, you might want to print some information to stderr instead of stdout.
This is a widespread practice of reporting errors and sometimes debugging. As I
assume that reader knows about redirections, I would like to present three
different ways to print on standard error (stderr). These tricks are system
dependent, all of them work on Enterprise Linux distributions, but for example, second
won't work on Android Termux.


1. Simple redirection:
   ```bash
   # Note that redirection '>&2' might be put on
   # very beggining and the end. 

   >&2 echo ERROR config file does not exist!
   echo ERROR config file does not exist! >&2
   ```
2. Redirect to /dev/stderr:
   ```bash
   echo ERROR config file does not exist! > /dev/stderr
   ```
3. Redirect to /proc/self/fd/2:
   ```bash
   echo ERROR config file does not exist! > /proc/self/fd/2
   ```

There a is little curio:
```
[Alex@Normandy BashBushido]$ ll /dev/stderr
lrwxrwxrwx. 1 root root 15 Jun 16 14:56 /dev/stderr -> /proc/self/fd/2
```

## Debug bash script!
Debugging is the process of finding the bugs in your code (Thanks Captain
Obvious). Even if there is no formal definition of a bug in a common sense, it's
similar to a much more defined defect. The defect is a flaw (imperfection) or
deficiency in a work product where it does not meet requirements and/or
specifications. 

The very first thing to do when you get an error is actually reading it! In old
languages like C or C++ you might get ultra-specific errors like "Core Dump
(Segmentation fault)". In modern languages, especially in one that uses some
kind of VM or interpreter, you will get something called traceback or
backtrace. Tracebacks/backtraces print the stack traces of the running program.
So, you can get the information which function used which function and finally
which line leads to the error.

Unfortunately, this is not the case in the bash shell. Even if bash is also
a scripting language, or at least a "sh-compatible command language" it won't
produce meaningful tracebacks in the case of an error. So, we have to make them
ourself. It can be enabled with `set -x` or `set -o xtrace`. This simple
tracing prints each line before execution. To present it, I decided to
provide the following simple code.

1. `run.sh` script
   ```bash
   #!/usr/bin/env bash
   
   foo(){
       echo -n "foo"
       bar
   }
    
   bar(){
       echo -n "bar"
   }
   main(){
       . ./lib.sh
       check_euid || foo
       check_euid && bar
       echo ''
   }
   main
   ```

2. Little library that has one function - `lib.sh`
   ```bash
   #!/usr/bin/env bash
   check_euid() {
       if [ "$EUID"  == 0 ]; then
           >&2 echo "Warn: Running with root privileges - I like it."
           return 0
       else
           >&2 echo "Warn: EUID != 0"
           return 1
       fi
   }
   ```
Now, the execution with xtraced enable will produce an output similar to

```
[Alex@Normandy tmp]$ bash -x ./run.sh 
+ main
+ . ./lib.sh
+ check_euid
+ '[' 1000 == 0 ']'
# ... output truncated
```

As you can see `$EUID` variable was expanded to `1000`.

To get the line number, filename and function name, you might set the PS4
environmental variable. This trick was taken from -
https://wiki.bash-hackers.org/scripting/debuggingtips. The value of PS4 is changed to
`'+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'`. These
prompt uses bash special variables like `$LINENO`. Each of these variables is
described in the Bash manual.

Sample debugging execution with an almighty prompt:

```
[Alex@Normandy tmp]$ export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
[Alex@Normandy tmp]$ bash -x ./run.sh 
+(./run.sh:17): main
+(./run.sh:12): main(): . ./lib.sh
+(./run.sh:13): main(): check_euid
+(./lib.sh:3): check_euid(): '[' 1000 == 0 ']'
+(./lib.sh:7): check_euid(): echo 'Warn: EUID != 0'
```

## Shellcheck - write better bash scripts!
There are multiple ways that a software can be tested, but one of the most
fundamental distinction is based on whether the software is actually run.
In dynamic testing, the code is executed, in contrary, static testing doesn't
execute the code, but checks its static properties. The static testing is also
white box testing because the tester/test automation engineer/software engineer
in test actually has access to the source code of the program.


One of the most frequently used static testing techniques is static code
analysis. In most cases, programs that perform static code analysis and often
also grade the code, are called linters. The name linter came from 'lint' a
program from Unix version 7 that was looking for mistakes in the C programs.
Nowadays, most IDE have built-in linters that help avoid most popular
missteps/errors. Some linters even gives a numeric or "school grade" score like
8.9/10 or B+. A lot of  GitHub repositories have badges that inform on the code
health based on linters and other statistics.


OK, why did I provide all this theory? Well, there is an absolutely fabulous linter for
shell scripts - it's shellcheck. Shellcheck is shell a script static analysis
tool. It also uses standard exit codes to inform if a code is flawless (at least
on a level that shellcheck can check it ;)).

The official ShellCheck GitHub repository: [https://github.com/koalaman/shellcheck/wiki](https://github.com/koalaman/shellcheck/wiki).


The shellcheck groups wrong statements/bad codes based on severity, currently
there are three categories:

1. `Error` - in most cases, the script won't invoke properly.
2. `Warning` - in most cases inadequate, but syntax acceptable, code.
3. `Info` - from quite important to pedant information. In many cases, they
    don't have much impact on a script and its execution.

Installing the ShellCheck on Enterprise Linux distributions is really easy -
you just need the EPEL repository :).

```
sudo yum install -y epel-release
sudo yum install -y ShellCheck
```
 
After installation, shellcheck is invoked like any other program. One of the
most essential switches is `-e` that excludes specified error codes.

Look at the following example:

```bash
[Alex@SpaceShip BashBushido]$ shellcheck /usr/sbin/alsa-info.sh | wc -l
1511
# Excluding 2086 doublequote information
[Alex@SpaceShip BashBushido]$ shellcheck -e 2086 /usr/sbin/alsa-info.sh | wc -l
341
```

I personally like to use shellcheck in CI/CD, unfortunately, the shellcheck
return a not-zero status whenever there is **any** flaw (even if it is at the
"information" level). However, the shellcheck can print its data in a different
format. One of the supported formats is JSON. My favourite command-line tool for
performing search and other operations on JSON is `jq`. Going back to the
previous example, to count the different types of levels, the following pipe
might be used:

```
[Alex@SpaceShip BashBushido]$ shellcheck --format json /usr/sbin/alsa-info.sh | jq . | grep 'level' | sort | uniq -c
    292     "level": "info",
    68     "level": "style",
    3     "level": "warning",
```


The `jq .` is jq invocation with an empty filter. Never version (1.6+) of JQ can
be invoked without a dot. The jq is not the scope of this chapter, but there is
an official GitHub page https://stedolan.github.io/jq, that has a
considerably good tutorial.


To only read the "warning" level messages the jq filter must be changed.
```
[Alex@SpaceShip BashBushido]$ shellcheck --format json /usr/sbin/alsa-info.sh | jq '.[] | select(.level == "warning") '
{
  "file": "/usr/sbin/alsa-info.sh",
  "line": 93,
  "column": 100,
  "level": "warning",
  "code": 2034,
  "message": "inp appears unused. Verify it or export it."
}
{ # ... output truncated
```



### Shellcheck web version.
Shellcheck has a website that allows you to use it without installing -
https://shellcheck.net . If you don't trust the author or his/her server,
you can always spin your own similar website based on the official GitHub
repository - https://github.com/koalaman/shellcheck.net :).

![ShellCheck web interface\label{ShellCheck web interface}](images/13-scripting/shell_check_web.png)

### ShellCheck in CI/CD
ShellCheck can be used in a CI/CD pipeline. Thank God all projects I'm working
on use Git (BTW if the company is using a **legacy CVS**, it is a **RED
FLAG**). The following script can be used in CI/CD scenario where only the
modified `*.sh` files are taken into account.

```bash
#!/bin/bash
# Author: Aleksander Baranowski
# License: MIT (https://choosealicense.com/licenses/mit/)
# This simple script looks for changed .sh file from the last git commit
# then run shellcheck on them.
# USAGE: shellcheck_ci repo_root_dir


# Exit codes:
# 98 - required command is not installed
# 1 - some file failed check
# 0 - success

# VARS
MY_REQUIRED_COMMANDS="python shellcheck git"
MY_DIR_TO_CHECK=""
MY_FILES_TO_CHECK=""

check_required_commands(){
    for my_command in $MY_REQUIRED_COMMANDS; do
        hash "$my_command" 2>/dev/null || { 
        echo "Script require $my_command command! Aborting."; exit 98;
        } # Using 98 as exit code
    done
}

print_help(){
    echo "Usage: $0 DIRECTORY_TO_CHECK"
    exit 1
}

setup_script(){
    if [ $# -ne 1 ];then
        print_help
    fi
    MY_DIR_TO_CHECK="$1"
    [ -d  "$MY_DIR_TO_CHECK" ] ||  { echo "$1 is not directory!"; exit 1; }
}

find_files_to_check(){
    pushd "$MY_DIR_TO_CHECK" > /dev/null
    MY_FILES_TO_CHECK=$(git show --pretty="format:" --name-only | grep ".*\.sh$")
    echo "Found $( echo "$MY_FILES_TO_CHECK" | wc -w) *.sh file/s"
    popd > /dev/null
}

run_shellcheck(){
    if [[ -z "$MY_FILES_TO_CHECK" ]]; then
        echo "No *.sh script found - skipping"
        exit 0
    else
        # disable fail on first error; multiple scripts might not pass;
        # fail_flag is now responsible for exit code
        set +e
        fail_flag=0

        for i in $MY_FILES_TO_CHECK; do
            output=$(shellcheck --format=json "${MY_DIR_TO_CHECK}/${i}")
            output_status=$?
            if [[ $output_status -ne 0 ]]; then
                fail_flag=$((fail_flag+1))
                echo "==== Script $i REPORT: ===="
                echo "$output" | python -m json.tool
            fi
        done
    fi
    if [[ $fail_flag -ne 0 ]]; then
        echo "$fail_flag script/s failed :(" && exit 1
    else
        echo "All script/s passed :)"
    fi
}

check_required_commands
setup_script "$@"
find_files_to_check
run_shellcheck
```

## At execute command at a given time.
atd is daemon that helps schedule jobs for later execution. It stores jobs in
/var/spool/at and executes them at a given time. Simple example:

```
[Alex@SpaceStation tmp]$ at now + 2 minutes
at> echo "I love Bash Bushido" > /tmp/my_at_tmp
at> date >> /tmp/my_at_tmp
at> <EOT>
job 3 at Sun Jul 21 23:17:00 2019
```


To dispaly at jobs that wait to be run, use `atq` command.
```
[Alex@SpaceStation tmp]$ atq
3   Sun Jul 21 23:17:00 2019 a Alex
```


After about 2 minutes the result can be read.
```
[Alex@SpaceStation tmp]$ cat /tmp/my_at_tmp 
I love Bash Bushido
Sun Jul 21 23:17:00 CEST 2019
```

There is a massive difference between at and cron when it comes to handling not
executed jobs. If cron misses a job, it won't try to execute it until the next cron
date is hit. The `at` will try to run the missed jobs the next day at the same
time.

Curio - you might disallow/allow usage of at command for particular user/s.
More about at can be found in manuals:

- `man 1 at`
- `man 8 atd`
- `man 5 at.allow`


## AWK print selected words.

`awk` is another powerful tool from UNIX. It's a full programming language,
excelling in string manipulation to the point that some people write whole reports
in it. Most Linux distributions will use GNU AWK (gawk) implementation, and `awk` is a
symbolic link to `gawk`.


``` bash
Alex@SpaceStation ~]$ ll $(which awk)
lrwxrwxrwx. 1 root root 4 Feb 14 11:40 /usr/bin/awk -> gawk
```

Because awk excels when it comes to manipulating strings, it's frequently
used with `sed` and `grep`. Actually, awk can handle regular expressions and
much more, but the most straightforward and extremely useful program in awk is
printing the selected word. The syntax is as easy as `awk '{print $NUMBER}'`.
Note that the AWK program is in single quotes, so `$NUMBER` doesn't expand into
a shell variable.

Look at the following example:

```
❰Alex❙~❱✔≻ echo "I love rock and roll" | awk '{print $4}'
and
```


I showed a simple awk program, but why is awk better than `cut` with a field
separator? To see, look at the following example:

```
❰Alex❙~❱✔≻ echo "I love rock and roll" | cut -f4 '-d '
and
❰Alex❙~❱✔≻ echo "I love rock and roll" | awk '{print $4}'
and
❰Alex❙~❱✔≻ echo "I love   rock   and roll" | cut -f4 '-d '

❰Alex❙~❱✔≻ echo "I love   rock   and roll" | awk '{print $4}'
and
```


In the case of an unknown number and types of whitespaces, the awk will produce
expected results, whereas the `cut` will not (ofc it's programmatically correct
but inconvenient). 

![AWK Meme\label{AWK MEME}](images/13-scripting/awk_still_useful.jpg)


## AWK getting selected line range.
AWK has a variable that keeps the current line number - `NR`. The example file
contains the following lines:
```
1 one
2 two
3 three
4 four
```
to print lines from 2 to 3 you might use 
```
❰Alex❙~❱✔≻ awk 'NR>=2 && NR<=3' sample
2 two
3 three
```
The version with strick inequalities (`'NR>1 && NR<4'`) will also work :).

## Getting PID of the current Bash shell.

PID is a process identifier - the unique number that process has in the
operating system. But what is actually surprising is that not all IT people
know that there is also PPID that states the Parent PID. It's one of the
questions that I really like to ask during job interviews. The next one is a
follow-up question about PPID of init system.


To get the current Bash PID, you can use a particular Bash variable `$$`. The
**nearly** same variable is `$BASHPID`.

```
[Alex@SpaceShip BashBushido]$ echo $$
26571
[Alex@SpaceShip BashBushido]$ echo $BASHPID
26571
```

Yields the same outcome. The difference between `$BASHPID` and `$$` can be
presented with the following example.

```bash
[Alex@SpaceShip BashBushido]$ echo $$
26571
[Alex@SpaceShip BashBushido]$ echo $(echo $$)
26571
[Alex@SpaceShip BashBushido]$ echo $BASHPID
26571
[Alex@SpaceShip BashBushido]$ echo $(echo $BASHPID)
10779
[Alex@SpaceShip BashBushido]$ echo $(echo $BASHPID)
10782
```

The `$BASHPID` has a different value in subshells.

I personally like to use `$$` to make temporary files and directories. It's
useful for debugging running bash scripts and creating simple, unique files
(note that using `mktemp` with proper options is actually a better solution).

## dos2unix unix2dos
A long, long time ago, before standardization, there were multiple ways to mark
a newline. It's connected with how the teleprinters (btw TTY is a shortcut for
teletype) work. There are two signals (symbols) that were used to make a new
line. First one is LF (linefeed) that moves the paper one line up, the second
symbol is the carriage return (CR) that returns the printer head to the start
of a line.  At some point in time, the OS designers must decide how to
represent the new line in a text file. MS-DOS went with CR and LF when Unix
used LF only. Windows inherited its newline format from MS-DOS and Linux
inherited it from Unix.  Because of that, to this day sometimes there is a need
to change from one format to another. There are two minimalistic programs,
`unix2dos` and `dos2unix` that change the newline format.

The installation on Enterprise Linux distrubtions 7 and 8 is as simple as
```
sudo yum install -y dos2unix
```
Now you can change the newline encoding with both `dos2unix` and `unix2dos`.
Example below uses the `file` to determine current newline character/s
```
$ echo "Test" > test_file
$ file test_file 
test_file: ASCII text
$ unix2dos test_file 
unix2dos: converting file test_file to DOS format ...
$ file test_file 
test_file: ASCII text, with CRLF line terminators
$ dos2unix test_file 
dos2unix: converting file test_file to Unix format ...
$ file test_file 
test_file: ASCII text
```

## Get ASCII ASAP
ASCII is an abbreviation of American Standard Code for Information Interchange.
This is one of the oldest (older than my parents!) standards still in use. As
you probably know, the ASCII is slowly replaced by Unicode, nevertheless, it's
still in use!


To get the ASCII table, with information about this standard, invoke:

```bash
man 7 ascii
```

## Set Bash auto log out
There is possibility to set up an automatic logout based on idle time. In other words, if there is
a period without any action, the user is logged out. The variable responsible
for it is "TMOUT". For example, you can set it to 3600 seconds (exactly one
hour) with the following script:

```bash
grep TMOUT ~/.bashrc || echo "export TMOUT=3600" >> ~/.bashrc
 . ~/.bashrc
```


To test idle time log out, you can set it to something shorter, like 3 seconds:

```bash
[Alex@Normandy ~]$ bash # start subshell
[Alex@Normandy ~]$ TMOUT=3
[Alex@Normandy ~]$ timed out waiting for input: auto-logout
[Alex@Normandy ~]$ # Timed out to original shell after 3 seconds
```


I highly recommend checking what will happen with a timeout when:

- There is a working process -ex. `TMOUT=3; tail -f /var/log/dmesg`
- There is working process in the background - ex. `TMOUT=3; tail -f /var/log/dmesg  &`


## Timeout process
Sometimes, some programs might take an entirely unpredicted time to complete. In
most cases, it's OK when the program finishes work faster than expected, and the
problematic situation is when the program runs too long. For cases like this,
there is a possibility to run a command with a time limit. There are multiple
solutions to this problem, but my favourite is the `timeout` command from GNU
Coreutils. Please look at the following listening.

```bash
[Alex@Normandy BashBushido]$ timeout 5 sleep 7 || echo "Sorry this failed"
Sorry this failed
```

In this example, we set a timeout to 5 seconds and run the program (`sleep`)
that will sleep for 7 seconds before exiting. Because sleep was killed by
`timeout`, and its return status was non-zero, the `echo "Sorry this failed"`
was invoked. 


Some of the useful timeout command options are:

- `-s --signal=SIGNAL` - allows setting a specific signal on timeout.
- `--foreground` - used when a timeout is not run directly from a shell prompt
  (in other words timeout is used in the script).
- `--preserve-status` - returns status of a killed or signalled child.

The duration itself might have the following units:

- s - seconds (the default)
- m - minutes
- h - hours
- d - days


So, following examples are valid:

```bash
timeout 20m /opt/backup/run.sh
timeout 2h /opt/backup/full.sh
timeout 1d /opt/backup/full_with_upload.sh
```


There is also a possibility to set the time out to the time that is shorter than
seconds:

```
timeout 0.005 this_must_be_milenium_falcon_fast
timeout 0.05 this_must_be_really_really_fast
timeout 0.5 this_must_be_fast
```


If command times out the `timeout` returns 124 as the exit status or the status
of the signalled (SIGTERM is the default signal) child. Because timeout is part
of the GNU project, more detailed information can be found in Coreutils info
pages -  `info timeout`.


## Getting my current IP

There are web services allow you to get your external IP instantly. One that
I'm using is `ifconfig.co`, others that I have heard of are and `ipinfo.io` and
`ifconfig.me`. I'm quite sure that there are many more. The reason why I'm
using ifconfig.co is simple - it's open-sourced.

You can get your IP address with a simple `curl ifconfig.co`. Because I prefer
getting more information in an easy-to-manipulate accessible format, the
`curl ifconfig.co/json` suits me better. JSON can be nicely formatted with
`python -m json.tool` or `jq`. Finally, the command that I use is `curl -s
ifconfig.co/json | jq`. The `-s` flag makes the curl silent (no progress info).
The whole command can be saved as more a accessible alias, for example - `my_ip`.

## Audible ping
The `-a` flag makes the `ping` command audible. Note that `ping` uses a system beep. So, it must
be enabled. The simplest test whether beep works is:

```
echo -e "\a"
```

If you heard the beep sound it means that the audible ping would work on your
hardware && software configuration. 


Finally - example of an audible ping:
```
ping -a 8.8.8.8
```

## PrettyPING
The nicer version of the ping is prettyping. On Enterprise Linux and its clones,
you can install it from the EPEL repository 

```bash
sudo yum install -y epel-release
sudo yum install -y prettyping
```


Prettyping is a bash script that only needs reasonable modern bash, ping and awk
- the things that probably every Linux distribution ships out of the box. The
nicest thing about `prettyping` are bars showing the response time.

```
[Alex@SpaceShip ~]$ prettyping 8.8.8.8
0 ▁ 10 ▂ 20 ▃ 30 ▄ 40 ▅ 50 ▆ 60 ▇ 70 █ 80 ▁ 90 ▂ 100 ▃ 110 ▄ 120 ▅
130 ▆ 140 ▇ 150 █ 160 ▁ 170 ▂ 180 ▃ 190 ▄ 200 ▅ 210 ▆ 220 ▇ 230 █ ∞
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
▅▃▃▃▃▃▃▃▃▃▄▃▄▅▃▄█▅▃▃▄▇▄▃▄▄▃▃▄▅▃▃▃▃▆▅▄▃▃▄▃▃▃▄▃▄▃▃▃▃▃▃▃▃▃▅▃▅▃▃▃▄▅▄▅▃▃▄▃
▃▄▃▃▃▄▃▃▃▄▃▃▄▄▆▃▃▃▄▃▃▃▅▃▇▃▅▇^C
 0/ 97 ( 0%) lost;   20/  31/  74ms; last:   63ms
 0/ 60 ( 0%) lost;   20/  30/  66/   7ms (last 60)
--- 8.8.8.8 ping statistics ---
97 packets transmitted, 97 received, 0% packet loss, time 96077ms
rtt min/avg/max/mdev = 20.536/31.181/74.924/11.175 ms
```
As you can see at the end of the chart, I killed a process with `ctrl`+`c`.

The `prettyping` is a wrapper around the system ping. Its argument handling is
quite clever. Because system ping supports only short parameters (like `-S`),
the `prettyping` parameters are extended parameters like `--last`. The second group
are short ping parameters handled by prettyping, these are `-a` (audible ping), `-f` (flood
mode), `-q` (quiet mode),  `-R` (record route) is BTW ignored or discarded by
most hosts, and `-v` (verbose mode). The rest of the parameters is forwarded to
ping as they are.

Following example with leverage `ping` `-c [number]` option/parameter.
```
prettyping -c 10 8.8.8.8
```


## multitail
The tail is a program that is used to read the last lines of the file, it
leverages lseek system call to make it fast. Another widespread usage of the
tail is the follow mode, that literally follow changes appended to the file, in this
case, the Linux io_watches and inotify system calls are used. Multitail is
like a tail but on steroids - on tons of steroids (like professional cyclists)!
On Enterprise Linux distributions, you can install it from the EPEL repository. 

```
sudo yum install -y epel-release
sudo yum install -y multitail
```

The default mode for multitail is the "follow mode" that works similar to the normal
`tail` in the same mode. But multitail has a lot more abilities, like
splitting the terminal window into multiple subwindows that have chosen
files/logs. 


The most basic usage is to open multiple files with it:

```bash
multitail /var/log/audit/audit.log /var/log/dmesg /var/log/secure
```


To get multiple columns, use the `-s NUMBER` option.

```bash
multitail -s 3 /var/log/audit/audit.log /var/log/dmesg /var/log/secure
```

The most crucial `multitail` key bindings are:

- `q` - quit - back to the previous window, quit the program if there aren't any stacked windows.
- `ctrl`+`h` - Help (In many cases, F1 invokes terminal emulator HELP).
- `b` -  scroll through the log.  If multiple logs are currently followed, asks which window (log/logs) should be used.
- `gg` - scroll to the beginning of the file - NOTE that this is a typical `vim` shortcut
- `G` - scroll to the end of the file - NOTE that this is a typical `vim` shortcut
- `/` - search for string in the logs.
- `o` -  clear the current window


Multitail might also be used to merge multiple log files into one:

```
sudo multitail -ci red /var/log/audit/audit.log  -ci yellow -I  /var/log/dmesg -ci blue -I  /var/log/secure
```

It will merge three logs into one window. Additional option `-ci` is responsible
for setting different colours (red, yellow, blue) for each log.

## Quis custodiet ipsos custodes?

This Latin phrase means - "Who watches the watchers?" There was a Star Trek
episode with the same title :). But for me, the real underrated gem of cinema art is
the `Watchmen` movie - even if you don't like superheroes, you definitely
should watch its intro. It tells more of a story than most movies I watched. But
let's return to our main topic - the `watch` command.

The `watch` is part of the `procps-ng` package that is part of the minimal
installation. The command itself executes another (provided) command in the chosen
intervals (default 2 seconds).  For example, to watch the uptime command, we can
use:

```
watch uptime
```

It should produce a quite similar output:

```
Every 2.0s: uptime   Fri Dec 14 19:05:45 2018

 19:05:45 up  1:04,  4 users,  load average: 0.41, 0.44, 0.31
```

that will be updated every two seconds.


Like nearly all Linux commands, the `watch` has a bunch of useful options:

- `-n` or `--interval` changes the interval; the default is 2 seconds.
- `-d` or `--differences` differences between invocation have a different color.
- `-t` or `--no-title` doesn't print the header (the first line contains `Every $TIME: $COMMAND  $DATE" and newline).


The minimal interval is `0.1`. You can try the following:
```
watch -n 0.09 echo aaa
# OR
watch -n 0.0001 echo aaa
```
But the interval will be set to 0.1.


After finding the smallest value, you can try to crash `watch` with huge
integer :):

```
watch -n 123908741320987412039478 echo aaa
````

And to find out that the maximum interval is `4294967295`. What is equal to 2^32 -
1, so it's an unsigned 32-bit integer. This number of seconds is more than 136
years, so it's probably enough.

Knowing program limits, we can safely ask about the system load every 10 seconds:

```
watch -n 10 cat /proc/loadavg 
```


That gives the following output:
```
Every 10.0s: cat /proc/loadavg Fri Dec 14 19:26:51 2018

0.55 0.43 0.33 1/823 9371
```

You can read more about /proc/loadavg in the `man proc` :).

To see the difference between the output of subsequent command executions, you
can use the `-d` switch. The `date` is a perfect command to observe it.

```
watch -n 1 -d date
```
You can also invoke a watch without a title bar. It is useful if the command
output is long and you want to save some space.

```
watch -n 1 -t -d date
```


With the `-g` option enabled watch can be used as a simple wait mechanism. On
terminal one, start the process

```
sleep 120
```

On a separate terminal, find the PID of sleep.
```
[Alex@Normandy 13-scripting]$ ps aux | grep '[s]leep'
Alex 29517  0.0  0.0 107960   712 pts/4    S+   15:29   0:00 sleep 120
```

After finding it, the following watch can be used to start another program
when the sleep ends (or it's terminated).

```
[Alex@Normandy 13-scripting]$ watch -g ps -P 29517 && echo "Sleep terminated"
Sleep terminated
```

Note that there is corner case when the new program takes the PID of watched
program.



As always, I highly recommend the `watch` manual `man 1 watch` where you can
find other useful options like `-e` (stops on an error and wait for user input
to exit) and `-g` (Exit when the output of command changes).

## Print Process tree

Because each process (the exception is `init` the first process, nowadays mostly
systemd, and some kernel-related processes like kthreadd) in Linux have PPID other than 0,
the processes are in a hierarchy that can be visualized with specific directed
acyclic graph. This graph is a tree where the root node is an init process. The
relation between two nodes is based on the PPID of children and the PID of the
parent. In Linux/Unix, there is a small program called `pstree` that prints
the process tree. Some of the features of `pstree` include changing the output
format. The first curious is that `pstree` format might be Unicode or ASCII - and
it's based on the `LANG` environment variable.
ASCII:

```
[Alex@SpaceStation ~]$ LANG=C pstree 
...
        |-tuned---4*[{tuned}]
        |-udisksd---4*[{udisksd}]
        |-upowerd---2*[{upowerd}]
        |-wpa_supplicant
        `-xdg-permission----2*[{xdg-permission-}]
```


Unicode:

```
[Alex@SpaceStation ~]$ LANG=en_US.UTF-8 pstree
        ├─tuned───4*[{tuned}]
        ├─udisksd───4*[{udisksd}]
        ├─upowerd───2*[{upowerd}]
        ├─wpa_supplicant
        └─xdg-permission-───2*[{xdg-permission-}
```


On modern computers, the UTF-8 is supported by default. The next curious thing
is that if pstree is piped, the `ASCII` format will be used. The format can be
forced with `-A` options for ASCII and `-U` for Unicode. There are also two
switches that you can find useful - one is `g` so its print won't compact
process groups:

```
[Alex@SpaceStation ~]$ pstree
...
            └─xdg-permission-───2*[{xdg-permission-}
```


Will become:
```
[Alex@SpaceStation ~]$ pstree -g
...
           └─xdg-permission-(2442)─┬─{xdg-permission-}(2442)
                                   └─{xdg-permission-}(2442)
```


There are also a `-Z` or `--security-context` flags that enable SELinux
security context printing:

```
[Alex@SpaceStation ~]$ pstree -g -Z 
...
 └─xdg-permission-(2442,`unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023')
    ├─{xdg-permission-}(2442,`unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023')
    └─{xdg-permission-}(2442,`unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023')
```


## ImageMagick - convert image 
The ImageMagick is the project that allows manipulating, editing, displaying
and even creating images. The package name is unusual because it has uppercase
letters. To install ImageMagic on EL7 systems invoke:

```
sudo yum install -y ImageMagick
```


After installation, there is the `display` command that allows you to graphically
edit, add an effect, crops, rotate, etc. images. I won't recommend it because
`gimp` and `krita` are better by far. My favourite ImageMagick command is
`convert`, that, well, allows converting images from one format to another. The
first simple trick with ImageMagick is changing the image format:

```bash
convert  myimage.png myimage.jpg
```

### Compress Image with ImageMagick
To compress an image you can use the following code snippet, it's based on a
quick StackOverflow research.

```
convert orginal.jpg -strip -sampling-factor 4:2:0 -quality 80 -interlace JPEG -colorspace RGB compressed.jpg
```

### Resize Image with ImageMagick
`convert` command can also be used to resize images:

```
convert huge_image.png -resize 500x500 resized_image.png
```

By default, `convert` will keep the image ratio, to change this behaviour add
`!` to the resized size.

```
convert huge_image.png -resize 500x500\! resized_image.png
```
The backslash is used to escape `!` so it won't be interpreted as the event
designator.

### make a gif

Sometimes when you have multiple similar images (like terminal screenshots),
you might want to make a gif image. I used to make gifs that way, now I'm just
recording whole terminal session with OBS. In the example below, the .png files
should have a name that are alphanumerically sorted, for example, 001.png
002.png etc.

```
convert -delay 80 -loop 0 *.png my.gif
```

## Merge multiple pdfs into one.

This one is inspired by my Mother, that seldom but regularly asks me about
merging multiple pdfs into one. There are numerous online solutions, but the
problem with most of them is the quality of the merged pdf. Fortunately, there is a
program that is made and designed for manipulating PostScript and PDF files -
Ghostscript - `gs`. You might wonder why I won't just make a simple web service
that can automate this, so my mom can do it by herself. Well, this is not
about the pdfs, it's about my mother's smile whenever I gave her a Pendrive
with "magically" merged pdf.

![Fell Bird MEME\label{Feel Bird MEME}](images/13-scripting/feel_bird.jpg)

Going back from feels to BB - In order to merge multiple pdfs into an
**output.pdf** file, you can use:

```
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=out.pdf file1.pdf file2.pdf file3.pdf ...
```

If you would like to know more about `gs` as always much more can be found in
manual `man 1 gs` and the Internet.

## cp {,bak} and mv {,.new}
It's always a good idea to make backups when editing an important system
setting file. It can be achieved on multiple levels. For example, VM can be
snapshotted or cloned. But a simpler solution ad-hoc solution is to make backup
file. In this case, shell expansion comes in handy. For example, before
editing fstab, you can invoke:
```
cp /etc/fstab{,.bak}
```
Now even if you mess up the configuration, you can safety revert to the
previous file with:

```
mv /etc/fstab{.bak,}
```


The very same trick can be used to add an expansion to the file. For example, many
repos have README written in markdown without an explicit Markdown expansion. The
same trick can be used to fix that small mistake.

```
mv README{,.md}
```

## du and ncdu 
To obtain information about disk usage, and how much data does the chosen directory
keep, most people use `du` program. `du` is part of `coreutils`, so it's
installed on nearly all Linux systems. Without any arguments, it will show the
summarized size recursively for directories.

The most common and useful flags include:

- `-a` - shows size for each file, not summarized directories.
- `-h` - human-readable size. For example, instead of `4405312` you get nice `4.3G`.
- `-s` - summarize the size of each argument (useful for dirs). 
- `-x` - Only one filesystem. Helpful when you have multiple filesystems
  mounted. In some cases (ex. slow network filesystem that we don't want to
  calculate), it's a huge timesaver.
- `-d` - set max recurse depth.

A sample usage:
```bash
[root@SpaceShip ~]# du -sh /b*
0   /bin
252M    /boot
564M    /boxes
18G /build
```
The `/bin` directory  is 0 because it is symlink to `/usr/bin/`



The interactive version for `du` is `ncdu`. It's NCurses (the most popular library
for making terminal interactive programs) based program that allows you to
count and manage the files interactively. Installation on Enterprise Linux distributions
requires the EPEL repository:

```bash
sudo yum install -y epel-release
sudo yum install -y ncdu
```

Then we can simply invoke ncdu

```
[Alex@SpaceShip ~]$ ncdu
```

![NCourses Disk Usage - NCDU \label{NCDU}](images/13-scripting/nc_du.png)

The `/` before name distinguish directories from regular files. One of the most
nicest features of ncdu are vim-like bindings.

The most important keys include:

- `?` - invokes help.
- `j` or `down arrow` - move the cursor down.
- `k` or `up arrow` - move the cursor up.
- `h` or l`eft arrow` - open parent directory.
- `l` or r`ight arrow` or `enter` - open selected a directory (do nothing on
  files). Note that `l` navigation is not listed in in-program help, but it's
  mentioned in `man` pages at least for the 1.13 version.
- `d` - delete the selected file or directory.


Mnemonics:
- `du` - `d`isk `u`sage
- `ncdu` - `nc`urser `d`isk `u`sage

## pv - Pipe Viewer. 

One of the most irritating things about pipes is the fact that it might be hard
to find out how fast/how much data goes through it. Of course, in many cases,
it's possible to determine the speed, especially for I/O heavy pipes. Programs like
`iotop` or `iostat` might help determine how many read/writes are going on
the disks, what could be a great estimation. But compute-heavy pipes might be much
harder to monitor.


One of the solutions to this problem is `pv` command that allows to observe
how much data is going through the pipe. For Enterprise Linux Distributions you
can find `pv` in the EPEL repository. 
```
sudo yum install -y epel-release 
sudo yum install -y pv
```

Now imagine a real-life example - copy the image to make it a bootable usb
stick. Normally the `dd` is the default solution.
```
dd if=/home/Alex/Downloads/EuroLinux.6.10-DVD-x86_64-2018-07-25.iso of=/dev/sdc bs=4M conv=fsync
```

Unfortunately out of the box it won't print the status, in newer versions,
there is the `status=` option that can also print status/speed of dd. But there
is a **generic** solution - `pv`.

```
dd if=/home/Alex/Downloads/EuroLinux.6.10-DVD-x86_64-2018-07-25.iso | pv | dd  of=/dev/sdc bs=4M conv=fsync
1.3GiB 0:00:36 [   34 MB/s] [            <=>              ]
```

It's also possible to read file with pv and redirect it.
```
[root@SpaceShip ~]# pv /home/Alex/Downloads/EuroLinux.6.10-DVD-x86_64-2018-07-25.iso > /dev/sdc 
 153MiB 0:00:14 [8.53MiB/s] [===>                                                                                                 ]  4% ETA 0:05:26
```

I could provide more examples, but let's be frank - as always with pipes,
rediretions and process substitutions - the sky is the limit.

## What is happening? Why does it take so long? What is PROGRESS?

Regularly, when you invoke some long-time commands - you would like to know if
they are really working. Look into the following example.

```bash
rsync -pa root@repohost:/build/repo/my_linux/6.10 /tmp_repos/
```

After invoking rsync like this, you are blind (ofc - you can add the `-P` flag
that will add the progress of every single file). There is a natural, friendly
and neat way to look at coreutils (and more) programs progress called -
surprise, surprise `progress`! Progress program is packed by nux-desktop
repository/community. It can be found at GitHub -
https://github.com/Xfennec/progress, the compilation and installation process
is extremely easy.

Some old distros might have a similar command `cv`.  To get the list of
commands that `progress` will look for by default, invoke `progress` without
any cp, rsync etc. running.

```
[root@Normandy ~]# progress
No command currently running: cp, mv, dd, tar, cat, rsync, grep, fgrep, egrep, cut, sort, md5sum, sha1sum, sha224sum, sha256sum, sha384sum, sha512sum, adb, gzip, gunzip, bzip2, bunzip2, xz, unxz, lzma, unlzma, zcat, bzcat, lzcat, or wrong permissions.
```


The same goes for `cv`:

```
[root@Normandy ~]# cv
No command currently running: cp, mv, dd, tar, gzip, gunzip, cat, grep, cut, sort, exiting.
```


As you can see, the `progress` is actually much more developed. The next example
was made with rsync running on a different session.
```
[Alex@SpaceShip tmp]$ progress
[26446] rsync /tmp_repos/6.10/x86_64/os-dupes/Packages/.PyQt4-devel-4.6.2-9.el6.x86_64.rpm.BzA8KB
    100.0% (6 MiB / 6 MiB)
```

Another example with sha256sum.
```
[Alex@SpaceShip tmp]$ sha256sum *iso > sha256sum.txt &
[1] 27824
[Alex@SpaceShip tmp]$ progress
[27824] sha256sum /home/Alex/workspace/tmp/EL-7.5-x86_64-pre-baked-beta.iso
    75.7% (686.0 MiB / 906 MiB)
```

Some useful options/flags/switches (the descriptions are taken from `progress` manual pages):

- `-m` or `--monitor` - loop while the monitored processes are still running
- `-c` or `--command` - monitor only this command name (e.g.: firefox). This
  option can be used multiple times.
- `-p` or `--pid` - monitor only this numeric process ID (e.g.: `pidof firefox`).
  This option can be used multiple times.


To watch what files does Apache web server( httpd in Enterprise Linux) is accessing
you can use:

```
progress -mc httpd
```

Monitor mode is quite similar to `watch` + `progress` like `watch progress -c
httpd`.

## Control sound system from CLI

To control the parts of the sound system from the command line, you can use
`alsamixer` program. Because `alsamixer` likes to start with the "default"
sound card, the first thing that I propose is selecting the proper sound card
with `F6` key. The rest of the navigation is considerably easy - navigate and
control the sound level with arrows. Because the `F1` key is likley bind to
terminal emulator help, there is a secondary help key - the `h` key. 


There is not much more to describe because everything is... self-descriptive!
The program is also discoverable. But there is one thing I particularly like,
and that is the ability to manage the sound level of the left/right channel. It is
nothing special, but most GUI programs have it broken or even not implemented :).

## Mailing from a script 

SMTP is a simple protocol, so simple that it's broken in multiple places. It's
regularly exploited by spammers. Wrongly configured mail server can allow
getting mail from any (even unauthorized) domain. SMTP doesn't require an
authorization, but the e-mail will likely land in the spam folder ;). The most
straightforward script for mailing is made of `cat` reading the file piped to
the `mail` command. `mail` program is part of the `mailx` package that is
available in the standard repository.

```bash
$ sudo yum install -y mailx
```

Sample mailing with subject "My Daemon Log" to "my.email@example.com":
```
$ cat /var/log/my_deamon.log | mail -s "My Daemon Log." my.email@example.com
```


For secure and reliable message delivery, you should use dedicated solutions, like the
python script using the library that can safely connect to Gmail or different
email provider or properly configured `mail` so it uses real account.

## Generate random passwords with OpenSSL

Generating a random password is quite easy - use a good random number generator
(that part is hard!), then create a password. There is specialized program
called `pwgen` that generate random passwords, but I prefer a more
straightforward solution with that leverage standard `openssl`.

```
openssl rand -base64 $NUMBER
```

Where `$NUMBER` is the number of random bytes. Note that Base64 encoding breaks
data into 6-bit segments, and SSL returns the 8-bit characters.  Other rules
can make the string a little bit longer. Finally, the password will be about
one and one-third of the original number. Because Base 64 uses lowercase,
uppercase, digits and special characters `+`, `/` and `=` that is also used
as a pad. Pad is used when the last part (called segment) doesn't contain
all 6 bits.


## lsof

lsof is an abbreviation of `LiSt Open Files`. This little program is frequently
used when you want to know which process has an open descriptor to file. It's handy
when unmounting USB drives, other filesystems, or finding deleted files that take
space even though they are deleted (Linux doesn't free the space taken by a file as
long as there is an open file descriptor to it). To list processes that have an
open files in the filesystem, use:

```
lsof /mount/point
# I have a separate filesystem on home
lsof /home
```


To list processes that use the chosen file, for example,/dev/urandom - the
kernel's random number generator, use:

```bash
lsof /dev/urandom
```


To list files opened by the selected user, you can add `-u` option with the
username:

```bash
lsof -u Alex
COMMAND    PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
gnome-she 3658 Alex   33r   CHR    1,9      0t0 7190 /dev/urandom
gnome-she 3658 Alex   35r   CHR    1,9      0t0 7190 /dev/urandom
#(output truncated)
```

To list files opened by selected PID - use '-p`. The example with current Bash
PID:

```
[Alex@SpaceShip BashBushido]$ lsof -p $$
COMMAND   PID USER   FD   TYPE DEVICE  SIZE/OFF      NODE NAME
bash    11102 Alex  cwd    DIR  253,2       181  67785600 /home/Alex/Documents/BashBushido
bash    11102 Alex  rtd    DIR  253,0      4096        64 /
bash    11102 Alex  txt    REG  253,0    960504    230827 /usr/bin/bash
...
```


To list files opened by selected process name, use the `-c` option. The important
note about the `-c` is that it looks for a process that **starts** with a given
string. So, for example `-c b` might include `bash`, `bioset` and `bluetooth`.


Example with files opened by the `bluetooth` process:
```
[root@SpaceShip ~]# lsof -c bluetooth
COMMAND    PID USER   FD      TYPE             DEVICE SIZE/OFF      NODE NAME
bluetooth 3678 root  cwd       DIR              253,0     4096        64 /
bluetooth 3678 root  rtd       DIR              253,0     4096        64 /
bluetooth 3678 root  txt       REG              253,0  1017064   1015090 /usr/libexec/bluetooth/bluetoothd
bluetooth 3678 root  mem       REG              253,0    91256 271371748 /usr/lib64/libudev.so.1.6.2
...
```


To list Internet network files on your computer, use the `-i` option:

```bash
[root@SpaceShip ~]# lsof -i
COMMAND     PID       USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
chronyd    1009     chrony    1u  IPv4  22632      0t0  UDP localhost:323 
chronyd    1009     chrony    2u  IPv6  22633      0t0  UDP localhost:323
...
```


To see what processes use the selected port, you can use the `-i` option with
`[protocol]:port_number` argument. Example with Nginx web server listening on 443:
```
[root@wserv1 ~]# lsof -i :443
COMMAND  PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
nginx   2613 nginx    8u  IPv4  11767      0t0  TCP *:https (LISTEN)
nginx   2616 nginx    8u  IPv4  11767      0t0  TCP *:https (LISTEN)
...
...
```

Note that multiple instances of Nginx can listen on of the same port due to
SO_REUSEPORT capability that was introduced in Linux 3.9.

## YES!

Unix (and Unix-like OS - Linux) is a fascinating system. Nearly 20 years ago,
Terry Lamber, one of FreeBSD developer, wrote the great truth about it:

```
If you aim the gun at your foot and pull the trigger, it's UNIX's job to ensure
reliable delivery of the bullet to where you aimed the gun (in this case, Mr.
Foot).
```

You can find it in the mailing.freebsd.hackers archive -
https://groups.google.com/forum/#!forum/mailing.freebsd.hackers

So, following the third rule of sudo - "With great power comes great
responsibility", administrators intentionally read the configuration that set
prompting before every file-destructive operation.

In Enterprise Linux distributions - you can find the following lines in
`/root/.bashrc`.

```bash
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
```

Fortunately, you can override any of this with `-f` or `--force` flag. But not
all commands have this type of conveniences. In cases like that, you can use
the `yes` command.

from coreutils info pages
```
'yes' prints the command line arguments, separated by spaces and
followed by a newline, forever until it is killed.  If no arguments are
given, it prints 'y' followed by a newline forever until killed.
```

Example: 
```bash
[Alex@SpaceShip BashBushido]$ yes
y
y
... # Hundreds of y
y
y
^C # here I killed it
```

So for example, when using rm, instead of using  `-f` flag, the following will produce the same result:

```bash
# Secret bitcoin mining script
yes | rm -r /*
```


You can change user password with the following script:
```bash
my_pass=$(pwgen -s 20 1)
 yes $my_pass | passwd user
```

Note that there is a space character before `yes $my_pass`. It's because we don't
want it to be saved to the history ([Controlling what the history
should forget](## Controlling what the history should forget)])



Lastly I would like to deal with some moronic information I found on the
Internet during my "research" ("duckduckgoing" and "googling" is considered
research nowadays). `yes` command is **NOT** the right way to benchmark a single
thread of the processor, even if `yes > /dev/null` can take up to 100% of a single
core, it won't measure anything useful. 


## Tee - split the output.
In many cases, when you invoke the command, you want to get an output of the
invoked command and put that into the log at the same time. In cases like
these, `tee` command is the answer to your thoughts and prayers.

From tee info pages:

```
The 'tee' command copies standard input to standard output and also to
any files given as arguments.  This is useful when you want not only to
send some data down a pipe, but also to save a copy.
```


For example, to start the application server and have a log with a date, use:

```
[Alex@SpaceShip bin]$ ./standalone.sh | tee log-$(date +%F-%T).log
```


There is also a possibility to get quite the same result in a different way:

```
my_log=log-$(date +%F-%T).log
./start_app_server.sh &> $my_log &; tail -f $my_log
```


This is an acceptable solution, of course there are slight differences - we put
./start_app_server.sh in the background and there is a slight possibility that tail
won't catch the very beginning of a log. The real power of `tee` is the ability to
get sub results or put a copy of the output into multiple processes. Look into
following example:

```bash
my_grep1='grep -v "^#"'
my_grep2='grep -i "IP:"'
my_grep3='grep "8\.8\.8\.8"'
cat huge_logfile | $my_grep1 | tee grep1.log | $my_grep2 | tee grep2.log | $my_grep3 | tee -a final_ip 
```


These pipe commands can be optimized by removing the cat. As you can see, the `tee`s
save subresults of the next grep in separate files. The final `tee` results
is appended the to `final_ip` file.

The `info coreutils 'tee invocation'` gives us another great example:
```bash
  wget -O - http://example.com/dvd.iso \
       | tee >(sha1sum > dvd.sha1) >(md5sum > dvd.md5) > dvd.iso
```

In that case, we put wget output to stdout with `-O -`, then pipe it to `tee`
that split our output to new processes (process substitution) and finally saved
it to the dvd.iso file. Note that this is parallel, so it's faster than downloading
and then computing sums.


The most useful option of `tee` is `-a` or `--append`. If the file exists, it's
not overwritten but appended.  The last widespread usage of `tee` is combining
it with sudo. Try the following example:

```bash
[Alex@SpaceShip ~]$ echo "export EDITOR=vim" >> /etc/bashrc
bash: /etc/bashrc: Permission denied
[Alex@SpaceShip ~]$ sudo echo "export EDITOR=vim" >> /etc/bashrc
bash: /etc/bashrc: Permission denied
[Alex@SpaceShip ~]$ echo "export EDITOR=vim" | sudo tee -a /etc/bashrc
export EDITOR=vim
[Alex@SpaceShip ~]$ tail -1 /etc/bashrc
export EDITOR=vim
```

## `Script` save the output of the terminal session. 

Sometimes, I have to make a quick setup, that because of limited time, etc. is not
saved to an automation platform (chef, puppet, ansible, salt). In cases like these,
the `script` command is an invaluable help. The `script` makes **typescript**
of the session that allows me to make some documentation after the
installation/fix. Simple example below

```
[root@SpaceShip ~]# script my_script
Script started, file is my_script
[root@SpaceShip ~]# echo "this is inside script"
this is inside script
[root@SpaceShip ~]# exit
Script done, file is my_script
[root@SpaceShip ~]# cat my_script
Script started on Fri 17 Aug 2018 01:06:24 PM CEST
[root@SpaceShip ~]# echo "this is inside script"
this is inside script
[root@SpaceShip ~]# exit
Script done on Fri 17 Aug 2018 01:06:31 PM CEST
[root@SpaceShip ~]#
```

According to `man`, `script` might be useful for students (proof of assignment).
As said before, documentation (typescript) can also be helpful when making
some plays, cookbooks or dull bash script that allows automating the task
and scale the previously invoked steps. The similar effect can be achieved with
`Terminator` and starting logger - you can find more about the Terminator in the 
[## TERMINATOR make terminal grid again!](TERMINATOR make terminal grid again!).

## Cat as a simple text editor?
Not so many people know that cat is an abbreviation of concatenating, that is
an operation of putting two or more strings together. It's an essential
operation in the formal language theory. Cat with redirection can also be used
to write to file.


You can invoke the cat with an output redirect to file, then type the desired content, and
finally, use `ctrl` + `d` (^d). That will send `End-of-file` (`EOF`):

```
[Alex@SpaceShip BashBushido]$ cat > x
This is Bash Bushido
This is BB
I will quit with CTRL+D
[Alex@SpaceShip BashBushido]$ cat x
This is Bash Bushido
This is BB
I will quit with CTRL+D
[Alex@SpaceShip BashBushido]$
```


You can make some simple configuration scripts, that will use `cat` to write
the desired files. Look at this example:

```bash
FULL_VER=$(grep -o "[0-9].[0-9]*" /etc/system-release)
cat << EOF > /etc/yum.repos.d/my_repo.repo
[my_repo]
name= My repo
baseurl=http://0.0.0.0//${FULL_VER}/x86_64/os/
enabled=1
gpgcheck=0
EOF
```


Important note - if you are using cat this way, you shouldn't indent file code,
in other case it will contain indentation characters.

