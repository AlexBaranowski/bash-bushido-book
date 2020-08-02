# Bash History
Fortunately, we will not concern ourselves with hard to tell, morally
ambiguous, and incarnate humans/nations histories. We will talk about the GNU
History library that saves and manages the previously typed lines.
The chapter will focus on controlling the history behaviour through environment
variables, practical tricks and mostly unknown usage. In theory, the Bash history is just
simple files that store the previously invoked commands, but as always there is
quite a lot to discover! For example, it can save the timestamps or even be
shared between concurrent sessions! After this short introduction - Hey HO,
Let's Go!


## Where does the History go?
Down the toilet (like most of my education) ^^. As said before, the Bash history
(like nearly everything in Unix) is a file. In this case, it's a simple text
file where each line represents one command. 

Let's look at the following examples:
```bash
Alex@Normandy$ echo "I love rock \
> and roll"
I love rock and roll
Alex@Normandy$ echo I love\
>  rock and roll
I love rock and roll
Alex@Normandy$ for i in {1..3};
> do
> echo $i
> done
1
2
3
Alex@Normandy$ history | tail -7
...(some commands)
  495  echo "I love rock \
and roll"
  496  echo I love rock and roll
  497  for i in {1..3}; do echo $i; done
  498  history | tail -7
```
As you can see, Bash is quite smart and squash longer "blocks" like
loops or long commands that are split with `\` into a single one.  


The file where history is/will be saved is defined by environment variable
`HISTFILE`. `HISTFILE` has default value set to `~/.bash_history`
```bash
[Alex@SpaceShip ~]$ echo $HISTFILE
/home/Alex/.bash_history
```

You can change the variable and save history to the new file. Look at the
following listening.
```bash
[Alex@SpaceShip ~]$ bash # Invoking the second bash
[Alex@SpaceShip ~]$ export HISTFILE=~/REMOVE_ME_TEST
[Alex@SpaceShip ~]$ echo "NEW HISTORY"
NEW HISTORY
[Alex@SpaceShip ~]$ exit # exit the subshell
exit
[Alex@SpaceShip ~]$ cat ~/REMOVE_ME_TEST
export HISTFILE=~/REMOVE_ME_TEST
echo "NEW HISTORY"
exit
```

## Getting the 10 most popular commands
To get the 10 most frequently used commands you can use the following
one-liner.
```bash
history | awk '{print $2}' | sort | uniq -c | sed "s/^[ \t]*//" | sort -nr | head -10
```
For example
```
[Alex@SpaceShip ~]$ history | awk '{print $2}' | sort | uniq -c | sed "s/^[ \t]*//" | sort -nr | head -10
62 bind
51 ls
47 echo
27 git
26 cd
19 vim
17 history
```
As you can see, before writing this text, I experimented a lot with the `bind`
command. 

## Let's erase our history!
There are multiple reasons why one would want to delete the history:

- History can be not set properly, so, it is storing sensitive data like
  "export MY_UNIQUE_BANK_PASSWORD='MAMA_JUST_KILLED_A_MAN'".
- You just got fired, so, in little exchange you make a little d\*\*\* move and delete
  the history. That makes the new admin's life a little bit harder. (BTW that is one
  from a thousand reasons why you should use automation platforms like
  Puppet, Salt or Ansible. It's also quite likely that fully a backed up server
  [like a snapshot] can easily recover this file).
- If you are a little freak, you can set HISTFILE to `/dev/null` and HISTSIZE
  to 0.

You can clear your history with `history -c`.
```
[vagrant@localhost ~]$ history
    1  w
    2  df ­h
    3  uname ­a
    ...
    70 history
[vagrant@localhost ~]$ history ­-c
[vagrant@localhost ~]$ history
    1  history
[vagrant@localhost ~]$
```
It's worth to mention that after using `history -c`, the history file is still
intact (you might lose the newest part of the history, more about it in the succeeding
subparagraphs). It's because out-of-box history is saved when you end the
session.

We can recover **freshly (not removed)** cleared history with `history -r`.
```bash
[root@kojinew ~]# history
    1  cd /etc/pki/some_service/
    2  ls
    3  ./certgen.sh nothing
    ... 
    116  ./certgen.sh 
[root@kojinew ~]# history -c
[root@kojinew ~]# history -r
[root@kojinew ~]# history
    1  history -r
    # ... rest of the history file
```

Mnemonics:

- `history -c`lear
- `history -r`ead

## Saving and sharing history in real time?
History lib is excellent, but it might be annoying when working with multiple
terminals (sessions) at the same server at once. They share the starting state
of history, then overwrite it. What is also even more frustrating is that this
sessions don't share invoked commands as long as our console session doesn't
end (but then each session overwrites the previous one!). So ideally the
following criteria should be met.

1. History saves after each command.
2. History is read after each command.

You can achieve it with the previously introduced `PROMPT_COMMAND`.
```
shopt -s histappend # Set appending to history
# PROMPT_COMMAND was introduced in prevoius chapter
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
```
History `a`ppend lines from current session to history file, then `c`lear it then `r`ead
it.

If you can't read an important command that was just invoked in another
session (terminal), just hit enter with an empty command line. It triggers the
PROMPT_COMMAND execution, so that the history resyncs.

The best thing about this solution is also the worst. Imagine that you have
separate sessions where you are using quite similar commands. The "collision"
with commands from other terminals might be dreadful. Still, it's one of my
favourite bash tricks.

## History with date and time

Bash has another variable called `HISTTIMEFORMAT`. This variable is responsible
for the format in which time that the command execution happened is saved/presented.
To start fun with the timed history, set it to something meaningful, then export
it.

```bash
export HISTTIMEFORMAT="%Y-%m-%d %T "
```
Please note that there is a space after `%T`. Without it, the commands blend with
time. Another thing that is worth noting is that the old history entries (not
presented in the current session) are timestamped to the moment when the
current session started.


Look at following example:
```
[root@localhost ~]# su - test_user
Last login: Sun Oct  7 18:32:02 UTC 2018 on pts/0
[test_user@localhost ~]$ export HISTTIMEFORMAT="%Y-%m-%d %T "
[test_user@localhost ~]$ echo 'export HISTTIMEFORMAT="%Y-%m-%d %T "' >> .bashrc
[test_user@localhost ~]$ history
    1  2018-10-07 18:32:21 echo "this is test"
    2  2018-10-07 18:32:21 echo "This commands are from previous session/s"
    3  2018-10-07 18:32:34 export HISTTIMEFORMAT="%Y-%m-%d %T "
    4  2018-10-07 18:32:41 echo 'export HISTTIMEFORMAT="%Y-%m-%d %T "' >> .bashrc
    5  2018-10-07 18:32:45 history
[test_user@localhost ~]$ 
```

And here is where things get even more interesting. Analyse this next example:
```
[test_user@localhost ~]$ logout
[root@localhost ~]# su - test_user
[test_user@localhost ~]$ echo "After logout"
After logout
[test_user@localhost ~]$ history
    1  2018-10-07 18:35:37 echo "this is test"
    2  2018-10-07 18:35:37 echo "This commands are from previous session/s"
    3  2018-10-07 18:32:34 export HISTTIMEFORMAT="%Y-%m-%d %T "
    4  2018-10-07 18:32:41 echo 'export HISTTIMEFORMAT="%Y-%m-%d %T "' >> .bashrc
    5  2018-10-07 18:32:45 history
    6  2018-10-07 18:35:44 echo "After logout"
    7  2018-10-07 18:35:48 history
[test_user@localhost ~]$ 
```
So, the previous commands (1,2) have a newer date than the latter (3,4)? BUT WHY?
THOUSAND QUESTIONS WITHOUT AN ANSWER? So, let's log out, then look at our
history from another perspective.
```
[test_user@localhost ~]$ logout
[root@localhost ~]# cat /home/test_user/.bash_history 
echo "this is test"
echo "This commands are from previous session/s"
#1538937154
export HISTTIMEFORMAT="%Y-%m-%d %T "
#1538937161
echo 'export HISTTIMEFORMAT="%Y-%m-%d %T "' >> .bashrc
#1538937165
history
#1538937344
echo "After logout"
#1538937348
history
[root@localhost ~]#
```
As you can see, there is a special "#NUMBER", and this number is a Unix timestamp
also called UNIX Epoch time, Unix time or just Epoch. This number represents
the number of seconds that passed from 00:00:00 1 January 1970. This is an
elegant solution for storing a date with time with 1-second precision. So,
the, commands (1,2) have no timestamp; therefore, their execution date and time
is set to the start of the shell process.

## Controlling what the history should forget
There is a possibility not to save an executed command. To do so, the space must
be the first character. You probably already guessed that there is a particular
Bash variable that is responsible for it - and you are right (I love IT because
of smart people like YOU!). The `HISTCONTROL` is the ~~droid~~ variable we are
looking for.

`HISTCONTROL` might be set to the following.

1. Not set or set to an invalid value.
2. ignorespace - lines that begin with a space character are not saved.
3. ignoredups - ignores lines matching the previous history entry.
4. erasedups - all previous lines matching the current line are removed from the history.
5. ignoreboth -  ignorespace + ignoredups

Which one is the most popular? Well, it's quite easy to check with the GitHub search.

| TYPE  | NUMBER  | GitHub Query Link  |
|--|-|-------|
| ignorespace  | 8,657   | github.com/search?l=Shell&q=HISTCONTROL%3Dignorespace&type=Code |
| ignoredups   | 15.234  | github.com/search?l=Shell&q=HISTCONTROL%3Dignoredups&type=Code |
| erasedups    | 5,745   | github.com/search?l=Shell&q=HISTCONTROL%3Derasedups&type=Code  |
| ignoreboth   | 29,907  | github.com/search?l=Shell&q=HISTCONTROL%3Dignoreboth&type=Code |

The ignoreboth is definitely the winner. This phase is more popular than all
competitors combined :). Another thing worth mentioning is that because HISTCONTORL
is a colon-separated list, there is a possibility to get `ignoreboth` with
`ignorespace:ignoredups`.

Now, with all this theory, you might want to look at the following example:
```
[root@localhost ~]# echo "my_new_pass" | passwd --stdin root
Changing password for user root.
passwd: all authentication tokens updated successfully.
[root@localhost ~]#  echo "my_new_pass2" | passwd --stdin root
Changing password for user root.
passwd: all authentication tokens updated successfully.
[root@localhost ~]# history
    1  2018-07-31 11:25:55 echo "my_new_pass" | passwd --stdin root
    2  2018-07-31 11:26:04  echo "my_new_pass2" | passwd --stdin root
    3  2018-07-31 11:26:08 history
[root@localhost ~]# echo "export HISTCONTROL=ignoreboth" >> .bashrc
[root@localhost ~]# . .bashrc
[root@localhost ~]#  echo "my_new_pass3" | passwd --stdin root
Changing password for user root.
passwd: all authentication tokens updated successfully.
[root@localhost ~]# history
    1  2018-07-31 11:25:55 echo "my_new_pass" | passwd --stdin root
    2  2018-07-31 11:26:04  echo "my_new_pass2" | passwd --stdin root
    3  2018-07-31 11:26:08 history
    4  2018-07-31 11:26:36 echo "export HISTCONTROL=ignoreboth" >> .bashrc
    5  2018-07-31 11:26:43 . .bashrc
    6  2018-07-31 11:26:53 history
```
As the listening shows, the ` echo "new_pass3" | passwd --stdin root` was not
saved. Just as expected! Thanks to this, you can safely add secrets, passwords
and tokens to commands without thinking about leaking them through the history
file.

## How deep is your ~~love~~ history?

The default history size might not be suitable for heavily used machines (like
the desktops). To get more space for the history entries, we can extend it.
There are two variables responsible for it. The first one is `HISTSIZE`  and
the second is `HISTFILESIZE`. During my research, I saw at least two
discussions where they weren't properly described. In the same time, the Bash
manual describes them unambiguously. The descriptions below are taken from the Bash
manual. As always the `...` is the truncated text.

```
HISTSIZE 
   The number of commands to remember in the command history...  The default value is 500.
...
HISTFILESIZE
   The maximum number of lines contained in the history file.  When this
   variable is assigned a value, the history file is truncated, if necessary,
   by removing the oldest entries, to contain no more than that number of
   lines.  The default value is 500. The history file is also truncated to
   this size after writing it when an interactive shell exits.
```

You can set a reasonably long history like `1000` or even `10000` entries
without noticing the performance issue. There is also a possibility to discard
any history with setting `HISTSIZE` to `0`. In that case, the history will be
empty.

Look at the following example:
```
[root@localhost ~]# history
    1  ls
...
   15  history
[root@localhost ~]# echo "export HISTSIZE=0" >> .bashrc
[root@localhost ~]# . .bashrc 
[root@localhost ~]# history
[root@localhost ~]# cat ~/.bash_history 
ls
...
history
echo "export HISTSIZE=0" >> .bashrc
. .bashrc 
[root@localhost ~]# logout # After logout the history state is saved
[vagrant@localhost ~]$ sudo -i
[root@localhost ~]# cat .bash_history
[root@localhost ~]# history
[root@localhost ~]# 
```

I prefer both settings to be set to 2000, but there is no real science
or any more profound thought behind it. So, part of my `~/.bashrc` file looks
like:
```
export HISTSIZE=2000
export HISTFILESIZE=2000
```

## Ignoring particular commands

Well, imagine that you go through the new code repository. After cloning it,
you probably will read the README, go through the directories, list the files, go to
another directory, grep on file, then list files, then read some file, then go
to another directory, list files, grep on files, read a file, and so on. After
something like this, your history is going to be cluttered with multiple `cd`, `ls`,
`cat`, and `grep` commands variances.

To keep the more essential commands in the history file, you can ignore the ones
that are popular but don't tell much. For example, `cd` or `ls`. Once more, there
is a special Bash variable that allows to do so - `HISTIGNORE`. 

The HISTIGNORE that I'm using looks like:
```
export HISTIGNORE="cd*:false:history:htop:ls*:ll*:la:l:popd:pushd*:reset:top:true"
```
The `*` makes HISTIGNORE matching everything after the string. Without it, the commands
like `cd Documents` would be saved.

```
[Alex@SpaceStation ~]$ export HISTIGNORE="cd"
[Alex@SpaceStation ~]$ cd /tmp
[Alex@SpaceStation tmp]$ history | tail -2
  518  cd /tmp
  519  history | tail -2
[Alex@SpaceStation tmp]$ export HISTIGNORE="cd*"
[Alex@SpaceStation tmp]$ cd /var
[Alex@SpaceStation var]$ history | tail -2
  520  export HISTIGNORE="cd*"
  521  history | tail -2
```

### .bashrc generator
As mentioned in the previous chapter - you can use the bashrc builder -
[https://alexbaranowski.github.io/bash-rc-generator/](https://alexbaranowski.github.io/bash-rc-generator/)
to build your own bashrc. There is a separate section dedicated to the Bash
history settings.

\pagebreak

