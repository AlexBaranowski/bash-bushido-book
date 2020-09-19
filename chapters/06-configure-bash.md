# Configure BASH
This chapter is dedicated to various Bash configuration options. When Bash
starts as interactive shell, the following configuration files are read:

1. /etc/profile
2. ~/.bash_profile
3. ~/.bash_login
4. ~/.profile
5. ~/.bashrc
6. ~/.bash_logout
6. /etc/bash.bash_logout

To keep things simple (KISS principle), most Linux users put their
configuration into just one file - '~/.bashrc'.

## Change Your prompt
Default `bash.rc` configuration that the user gets by default (at least in most of
the distributions) is located in `/etc/skel/.bashrc` (the content of /etc/skel
is copied to the home directory during user creation). In many cases, this
`.bashrc` reads `/etc/bashrc` that sets the PS1 environmental variable to something
like `PS1="[\u@\h \W]\\$ "`

This prompt translates to `[USER@HOST WORKING_DIRECTORY]$`. This is a
reasonable default configuration for a prompt, that might be enough. However, if
you want a colourful, more customized prompt, you can use one of the websites
that help you build one (they are amazing and handy). Alternatively, read the
PROMPTING section in `man bash`, and make your own.

My favourite  website to make a custom prompt is http://ezprompt.net/ . You can
generate your nice colourful, customised prompt there, then copy it to your
`~/.bashrc`. If this is not enough, you can read about setting up a prompt, how to
enable a particular color on text, then make something even more suited to
your tastes.  This might be particularly useful when your terminal supports True
Colour (16 million colours in the terminal instead of 256). There is excellent
GitHub gist describing it. It is the first result in the DuckDuckGo search
engine (that search engine does not personalise output, so it's much more
reliable than Google). The query that I used is "terminal true colour support".
In the case that this little recommendation doesn't convince you, here is the link
- https://gist.github.com/XVilka/8346728 .

## Executing the chosen commands before the prompt
Bash has a special variable `PROMPT_COMMAND`. According to the Bash
documentation:

```
If set, the value is executed as a command before issuing each primary prompt
```


Example:
```
[Alex@SpaceShip ~]$ export PROMPT_COMMAND='date +%F-%T |tr -d "\n"'
2018-08-20-22:58:22[Alex@SpaceShip ~]$ # Enter
2018-08-20-22:58:23[Alex@SpaceShip ~]$ # Enter 
2018-08-20-22:58:26[Alex@SpaceShip ~]$ # Enter
```

### Is this out-of-season April's Fool Joke?
Because literally no one knows about the `PROMPT_COMMAND`, you can make a little
out of season April fool joke. It's gonna be definitely better than the Diablo Immortal
announcement.


For your safety remember if your colleague tries to kill you after doing that, just say
```
IT'S A PRANK
IT'S JUST A PRANK BRO 
 -- Anonymous before getting shot.
```

Ok so let's get to the code
```
export PROMPT_COMMAND='python -c "import random; import time; time.sleep(random.random()*5)"'
```
Python random.random() will return value [0, 1) (uniform distribution). So, in
the worst case scenario, you have to wait 5 seconds for your prompt :). Another
thing worth pointing out is that this command works with both Python 2 and 3.

Now you can add it to /etc/.bashrc.
```
echo "export PROMPT_COMMAND='python -c \"import random; import time; time.sleep(random.random()*5)\"'" | sudo tee -a /etc/bashrc
```
Note that, as according to the documentation  PROMPT_COMMAND is invoked only for
the interactive session. It might be an **IDIOTIC** joke (production, critical,
non-standard configured hosts, services that start in an interactive session
[you shouldn't do that anyway], etc).

## Are Clear and `ctrl` + `l` the same?
The last thing that I would like to show about the `PROMPT_COMMAND` is,
that there is a difference between `clear` and `ctrl` + `l`.  You can export
our "prank code", and check that after the `clear` command you have to wait for
your prompt, but when you use `ctrl` + `l`, you get the same cleared screen
without waiting. It's because after `ctrl`+`l`, the `PROMPT_COMMAND` is not invoked.

## Making your own command line shortcut
As you know from the previous chapters, the library responsible for binding shortcuts
is GNU Readline. This excellent library allows us to make our own shortcuts
with the `bind` command.


However, before you bind the key to a custom command, you should know the real
key code that is sent to the terminal. In the case of `ctrl-v` the codes are obvious,
but what about special keys? For example the `F9` key is encoded as `^[[20~`. How
do I know that? I used the following combination: `ctrl-v`, then `F9`.  To get
information about what function is bound to `ctrl` + `v`, invoke:

```
[Alex@SpaceShip ~]$ bind -P | grep '\C-v'
display-shell-version can be found on "\C-x\C-v".
quoted-insert can be found on "\C-q", "\C-v", "\e[2~".
```

From the following output, it's obvious that `ctrl`+`v` invokes quoted-insert.
Quoted-insert is the mode in which the next key combination is displayed in
verbatim (key code).


After this short off topic, you can make your own shortcut.In the following
example, we bind the `F9` key with the `date` command.
```
[Alex@SpaceShip BashBushido]$ # ^[[20~ - F9 found in quoted mode
[Alex@SpaceShip BashBushido]$ bind '"\e[20~":"date\n"'
[Alex@SpaceShip BashBushido]$ date # F9
Sun Sep 23 13:43:21 CEST 2018
```
The `bind` command has the following format `bind '"Key/s-code/s":"string that will be inserted"'`.
Note that there is `\n` after `date`, so `date` the command is instantly executed.
Another thing that is worth mentioning (we will discuss it later) is that there
is a "translation" from `^[` to `\e`.

Another example will be `ctrl` + `q` bound to `date` and `whoami` commands. Some
readers might notice that by default `ctrl` + `q` it redundantly bound to
`quoted-insert`.
```
[Alex@SpaceShip BashBushido]$ # ^Q - ctrl-q found in quoted-insert
[Alex@SpaceShip BashBushido]$ bind '"\C-q":"whoami\n"' # ctrl-q
[Alex@SpaceShip BashBushido]$ whoami
Alex
```

*The exercise for reader* - does using `C-Q` instead of `C-q` change anything?
Note that currently our bindings are not persistent, so to "unbind" just
start the new terminal/session.

The next example is `alt`+`q` that will be bound to the `uptime` command.
```
[Alex@SpaceShip BashBushido]$ # ^[q - alt-q found in quoted insert
[Alex@SpaceShip BashBushido]$ bind '"\eq":"uptime\n"'
[Alex@SpaceShip BashBushido]$ uptime # alt-q
 14:00:52 up  1:38,  4 users,  load average: 0.08, 0.07, 0.21
```

As previously recognized, the bound command won't work with the direct output of the
quoted mode (for example "^[q"). We have to make a little change to the quoted
mode format or the output will not be understandable for readline library. 
For example `alt`+`q` verbatim is `^[q` that was changed into readline-understandable `\eq`.
The following table shows the simple rules of conversion/translation from one
notation to another.

| Notation | Interpretation  |
|---|---|
| `\e`  | The escape key. Used also for another binding such as special characters (for example, F9) or connected with meta key. Meta key on most keyboards is known as `alt`. Used when the prefix is `^[` |
| `\C-` | Represents the held `ctrl` key.  Used when there is `^` before the key code.|

*Exercise for reader* get `ESC` key in the quoted-insert mode.


## Make our key bindings persistent

One of the most important lessons that every
SysAdmins/DevOps/ConfigManager(WhatEverNameTheyWantToCallThem) has to go
through is that to make a configuration and to make a persistent configuration are two
separate activities. In the previous chapter, we made a configuration that will
work in the interactive shell and will be forgotten/die with it. Now we will
make the configuration persistent. There are two fundamental ways to
achieve it.

First, and in my opinion the better way is it to put the `bind` commands in
`.bashrc`. As said before use KISS - Keep It Simple Stupid principle. Keeping
everything in a single rc file is good idea.

Below is a fragment that you can write to your `.bashrc`.
```
## Custom key bindings.
bind '"\eq":"uptime\n"'
bind '"\C-q":"date\nwhoami\n"'
bind '"\e[20~":"date\n"'
```

The second one (and by the way more by the book ) - is the use of the
configuration file of the readline library (can be overridden with the
`INPUTRC` variable) the `$HOME/.inputrc` file.


Sample `.inputrc` file:
```
"\eq":"uptime\n"
"\C-q":"whoami\n"
"\e[20~":"date\n"
```

As most of readers will quickly notice, the .inputrc has the same format as
arguments passed to the `bind` command.  As there is `/etc/bashrc` there is also
the `/etc/inputrc` file that is a global start-up file used by the Readline
library. The inputrc supports comments ("lines started with #"), conditional
settings and including other files. For example, in Enterprise Linux
distributions (ver 7) the `/etc/inputrc` has conditional statements like

```
$if mode=emacs
# for linux console and RH/Debian xterm
"\e[1~": beginning-of-line
"\e[4~": end-of-line
...
...
$endif
```

More information about inputrc and readline library can be found in the `man bash`
- `readline` section and the info pages `pinfo rluserman`.

I would like to notice that there is also an important difference between
putting custom bindings into the `.bashrc` and the `.inputrc` files. This
difference is scope. The bindings from `.bashrc` works only for the Bash shell,
when the biddings from `.inputrc` are used by **any** programs that use
readline library to get the user input. These programs are mostly interactive
shells like `python`, `perl` or `psql`. That is the second reason why I highly
recommend putting the bindings into the `.bashrc` file.


## Meta == ESC a useless but interesting thing

In the previous chapter, I challenged the reader to find how the `Escape` key is
encoded.

```
[Alex@SpaceShip BashBushido]$ # ^[ - escape
[Alex@SpaceShip BashBushido]$ # ^[q - alt+q
```
With the previous  `bind '"\eq":"uptime\n"'`, there is a possibility to invoke this
binding with the following combination `esc` then `q`.  But there a is huge
distinction between the `alt`+`q` and the `Esc` then `q` combination. Escape will put
the `^[` character only once. So, keeping the `Esc`+`q` pressed will write
`uptime\n` once, then continue to put the `q` on your command line. While
`alt`+`q` will repeatedly write `uptime\n` as long as the keys are pressed.

## Change directory to the previous one
To change directory to the previous one just use `cd -`

This trick works because Bash has the OLDPWD variable set by `cd`. How can we
be sure about that? Well, this time we won't look into the source code :). Just start
a new session and try to use this trick.
```
[Alex@SpaceShip BashBushido]$ bash
[Alex@SpaceShip BashBushido]$ cd -
bash: cd: OLDPWD not set
```
You can read more about it in the manual. I highly recommend also checking what
`cd` is really in your shell. Just invoke `which cd` then `type cd`. Depending 
on your Bash version there might be the `/usr/bin/cd`. But when you try to invoke it
it doesn't work as expected.


Look at the following example:
```
[Alex@SpaceStation ~]$ pwd
/home/Alex
[Alex@SpaceStation ~]$ /usr/bin/cd /home  # it won't work
[Alex@SpaceStation ~]$ pwd  # RLY
/home/Alex
[Alex@SpaceStation ~]$ cd /home/
[Alex@SpaceStation home]$ rpm -qf /usr/bin/cd # check which package own the file
bash-4.2.46-31.el7.x86_64
[Alex@SpaceStation home]$ file /usr/bin/cd
/usr/bin/cd: POSIX shell script, ASCII text executable
[Alex@SpaceStation home]$ cat /usr/bin/cd
#!/bin/sh
builtin cd "$@"
[Alex@SpaceStation home]$ builtin cd /home/Alex # builtin work as expected
[Alex@SpaceStation ~]$ pwd
/home/Alex
```
Can you indicate why this didn't work?

![Maybe because you started another process?  \label{Maybe because you started another process? }](images/06-configure-bash/spongebob_magic.jpg)

## Pushd and popd friends of mine
A short story of everyday console user: You are making changes in one
directory, then cd to another, then once more to another, then to another. Then
you would like to go "back" to the previous one. So, you use `cd -`, but then
you cannot go any further. Your directory "browsing" history is like, well -
a single directory. What is even more embarrassing is the fact that in most cases
it's enough - maybe being a Linux power user is not as hard as most people tend
to believe ;)?


Nevertheless, there is nice a solution to this situation, the `popd` and `pushd`
commands. There is also a third command, one called `dirs`. The `pushd` changes
directory and pushes it to the directory stack, popd pop the directory from the stack
and change the directory to the poped value (ofc as long as the stack is not empty).
The `dirs` command prints the current directory stack. The sample usage looks like this.

```
[Alex@garrus ~]$ pushd /usr/share/
/usr/share ~
[Alex@garrus share]$ dirs
/usr/share ~
[Alex@garrus share]$ pushd ~/workspace/
~/workspace /usr/share ~
[Alex@garrus workspace]$ pushd /etc/sysconfig/
/etc/sysconfig ~/workspace /usr/share ~
[Alex@garrus sysconfig]$ dirs
/etc/sysconfig ~/workspace /usr/share ~
[Alex@garrus sysconfig]$ popd
~/workspace /usr/share ~
[Alex@garrus workspace]$ popd
/usr/share ~
[Alex@garrus share]$ popd
~
[Alex@garrus ~]$ popd
-bash: popd: directory stack empty
```

However, this is BashBushido - we can do it a little bit better and maybe
smarter :)! I enjoyed switching from `cd` to something that better suits me ->
pushd with popd. 

To do so, I added the following to my .bashrc. I would like to note that this
solution is loosely based on "Jonathan M Davis" Unix and Linux Stack Exchange
https://unix.stackexchange.com/a/4291/183070
```
alias cd='pushd'
alias back='popd'
popd()
{
  builtin popd > /dev/null
}
pushd()
{
  if [ $# -eq 0 ]; then
    builtin pushd "${HOME}" > /dev/null
  elif [ $1 == "-" ]; then
      builtin popd > /dev/null
  else
    builtin pushd "$1" > /dev/null
  fi
}
```
Please note that this solution works well with the default workflow of most
Linux users. There is no need to switch the from well-known (even automatic)
`cd` to `pushd`.
```
[Alex@garrus ~]$ cd /usr/share/
[Alex@garrus share]$ dirs
/usr/share ~
[Alex@garrus share]$ cd ~/workspace/
[Alex@garrus workspace]$ cd /etc/sysconfig/
[Alex@garrus sysconfig]$ dirs
/etc/sysconfig ~/workspace /usr/share ~
[Alex@garrus sysconfig]$ back
[Alex@garrus workspace]$ dirs
~/workspace /usr/share ~
[Alex@garrus workspace]$ cd -
[Alex@garrus share]$ dirs
/usr/share ~
[Alex@garrus share]$ popd 
[Alex@garrus ~]$ dirs
~
[Alex@garrus ~]$ cd -
-bash: popd: directory stack empty
[Alex@garrus ~]$
```
Another nice thing about this solution is that it works as expected with both
`cd -` and empty `cd` :).


The pushd and popd can also be used in scripts. I personally used them when:

1. You have to change the specific directory (that is unknown before running,
so it can't be hardcoded).
2. Saving some information (in the most cases path) that is **relative** to this directory.
3. Use Popd and/or pushd directory to another.
4. Reconstruct the **relative** information, then popd. 

It might look like an overkill but sometimes it's the simplest solution. In my
case, the other solutions used a try-and-error method to reconstruct the data
placement.

## shopts and autocd
`shopt` - is a little shell built-in that can enable some additional shell
behaviour. To get a list of options that it can enable, invoke `shopt`
without any argument. One of my favourite options that I used to turn on is
`autocd`.  If the first argument (normally the command) is a directory, Bash
invokes `cd` that changes our location to it.

To get what I'm talking about look at the following example:

```
[Alex@Normandy: BashBushido]$ shopt -s autocd
[Alex@Normandy: BashBushido]$ /home
cd /home
[Alex@Normandy: home]$ /home/Alex
cd /home/Alex
[Alex@Normandy: ~]$ echo $OLDPWD
/home
[Alex@Normandy: ~]$ shopt -u autocd
[Alex@Normandy: ~]$ /home
bash: /home: Is a directory
```

As you can deduce `shopt -s autocd` enables (sets) and `shopt -u` disables
(unsets) the option. The minor inconvenience is that the directory changed this
way won't use our aliased `cd` command that leverage the `pushd` and `popd`
(described in the previous chapter).  This is the reason why I decided not to use
it anymore. On the other hand, it correctly set the `OLDPWD` variable, what, as
said before, is enough for most users.

## bashrc generator
Because I can and had some free time, I decided to make a simple GitHub website
that allows you to generate the .bashrc with options presented through this
chapter and many more! You can find it here:
[https://alexbaranowski.github.io/bash-rc-generator/](https://alexbaranowski.github.io/bash-rc-generator/)

\pagebreak

