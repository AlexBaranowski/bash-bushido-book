# Extra cool keyboard shortcuts in Bash:
In the previous chapter, we looked into the basic shortcuts that help edit the
current line. In this chapter, we are going to look into shortcuts that will
boost your performance.

## Clear the screen
`ctrl` + `l` is the one **ESSENTIAL** shortcut for all power users - it clears
the screen, just like the `clear` command. However, to keep even a simple
`clear` command faithful to the spirit of Bash Bushido, I encourage readers to
check what happens when we put `clear` in a Bash script, then invoke it. You
can try it on different terminal emulators to determine if this behaviour is
terminal emulator dependent.

## History search
Edit note: If your knowledge about the bash history mechanism is near zero, you
might read the [Bash History](#bash-history) chapter first.

To search the Bash history the from current position in the history (most
likely the end), use `ctrl` + `r`. This key combination is bind to
**reverse-search-history** function. Then type-in the beginning of the command you want
to find. Let's assume that your previous commands look like that:

```
1 echo "first on history"
...
150 banner "I like this"
...
250 banner2 "I love this"
..
500 echo "I'm last"
```

We also assume here that both banner and banner2 are unique throughout the whole
history file. So, after invoking the reverse-search-history and typing "bann" you
might get

```
(reverse-i-search)`bann': banner2 "I love this"
```

After invoking a command, you always arrive at the end of the history. However, if
you press `esc` during the reverse history search, your current position in the history
is going to be set to the position of currently found match. In our example
with `bann`, it will be 250. Therefore, a subsequent reverse search will search
lines from 250 to 1. So, the next reverse search for "bann" will return the
command `banner "I like this"`.  


To get back to the end of history, you can use a **smooth** trick - hit enter
with the empty prompt. The other fancier solution is to use `end-of-history`
Readline function that is bound to the `alt` + `>` key combination.

The second less-known history search type the is **forward-search-history** that is
bound to `ctrl` + `s`. Because in most cases your current position is at the end
of the history, it's not as well known and to be honest - not frequently used.
Let's use our imaginary history file (the one presented above) once again.
Firstly, you might use the `beginning-of-history` Readline function bound to
the `alt` + `<` key combination, then invoke the forward search and type
'bann':

```
(i-search)`banner': banner "I like this"
```

Mnemonics:  

- `alt` + `<` - start of some section (`<`) in multiple languages (ex. HTML, XML,
  C/C++(include, templates, etc.))
- `alt` + `>` end of some section (`>`) in multiple languages (ex. HTML, XML,
  C/C++(include, templates, etc))
- `ctrl` + `r`everse  - search from the current position in REVERSE mode
- `ctrl` + `s`tart - search from the START 

## Get current Bash version
`ctrl`+`x` then `ctrl` + `v` prints the Bash version.  If bash is not in 4+ or 5+
version, it means that you are working on a legacy system or Apple MacOS. Apple
won't update bash to 4.X because of the license change to GPL v3+. To be fair, in
most cases it's not a big deal, but if a script uses some newer
features (e.g. using associative arrays introduced in Bash 4.0) it can become
quite a problem. In the beginning of 2019, version 5.0 was released. I highly
recommend reading its release notes.

Mnemonics:  

- `ctrl`+`x` then `ctrl` + `v`ersion.
- My mnemonics for `ctrl`+`x` - `ctrl`+e`x`pert :)

## UNDO in Bash
Sometimes when editing a crazy-long line, you might make some mistakes.
Then the `ctrl` + `_` can be used to undo the ~~damage~~ change.  The same
effect can be achieved with `ctrl` + `7`. Both `ctrl`+`_` (note that `_`
requires the `shift` key), and `ctrl` + `7` send the same input to Bash. You can check
it with **quoted-insert** that is described in 
[Making your own command line shortcut](#making-your-own-command-line-shortcut).


Mnemonics:  

- `ctrl`+`x` then `ctrl` + `u`ndo.

## Invoke your favourite $EDITOR

Sometimes there is a need to type a longer script ad-hoc. It's more convenient to
use the favourite text editor than to type the script line by line. For this use-case, there 
is a great **edit-and-execute-command** function, that is a bind to the `ctrl` + `x` 
then `ctrl` + `e` key combo.

According to bash source code (file `bashline.c`), the function responsible for
this behaviour is actually named `edit_and_execute_command`.  For the default
(emacs) key bindings, the command invoked is `fc -e \"${VISUAL:-${EDITOR:-emacs}}`,
which means that the first variable that will be used is VISUAL, then EDITOR 
(if VISUAL is not set), lastly if none of them worked, `emacs` will be used.
Emacs used to be a popular text editor (I personally know only a few people 
that use it on a regular basis, but some of the most famous
programmers like the great Linus Torvalds [Original creator and Lead of Linux
development] love it) made by Richard Stallman (the guy who started the free/libre
software movement). A side note, the default Readline bindings are emacs-like :).

To set your favourite editor, you can add the following to your `~/.bashrc` file:

```
EDITOR=vim
```

Lastly, because Richard Stallman is in my opinion a very serious figure, here is
a not-so-serious Richard Stallman picture. Kawaii-Stallman the guru of 4chan's /g/
board.

![Stallman Kawaii \label{Stalman Kawaii}](images/03-cool-shortcuts/stallman-kawaii.png)


## shell-expand-line
`ctrl` + `alt` + `e` is one of my favourite bash shortcuts. This function can
be used to check if a command is aliased, expand a subshell and make a history
expansion. There are also other expansions, but they are not as popular as
this one. You can find them with `bind -P | grep expand`. 

Examples:

```bash
[Alex@SpaceShip BashBushido]$ mkdir {1,2,3}{a,b,c}
[Alex@SpaceShip BashBushido]$ echo $(ls -d 1*) # # `ctrl`+`alt`+`e`
# Changes into
[Alex@SpaceShip BashBushido]$ echo 1a 1b 1c
```
```bash
[Alex@SpaceShip BashBushido]$ grep # `ctrl`+`alt`+`e`
# Changes into 
[Alex@SpaceShip BashBushido]$ grep --color=auto
```
```bash
[Alex@SpaceShip BashBushido]$ history | head -3
    1  vim ~/.bashrc 
    2  vim ~/.bashrc 
    3  bash
[Alex@SpaceShip BashBushido]$  !2 # `ctrl`+`alt`+`e`
# Changes into
[Alex@SpaceShip BashBushido]$ vim ~/.bashrc 
```

Unfortunately  `shell-expand-line` function won't expand globs.

## glob-expansion 
Because `glob` might be a new word for some people, here is a minimalistic
definition - globs are patterns that specify the pathname. I highly recommend
reading the `glob(7)` manual page. The key biding for `glob-expansion` is 
`ctrl` + `x` then `*`. To understand globs let's look at the following example.

```bash
# This shell expansion makes directory a/a a/b and a/c
[Alex@SpaceShip ~]$ mkdir -p a/{a,b,c}/ 
# This shell expansion makes three empty files with song.mp3 name
[Alex@SpaceShip ~]$ touch a/{a,b,c}/song.mp3
[Alex@SpaceShip ~]$ ls a/*/*mp3 
# After hitting glob-expand-word.
[Alex@SpaceShip ~]$ ls a/a/song.mp3 a/b/song.mp3 a/c/song.mp3 
```

Another example:
```bash
Alex@Normandy:~/$ ls -1 /etc/[d]*
# After hitting glob-expand-word.
Alex@Normandy:~/$ ll -d /etc/dbus-1 /etc/dconf /etc/default #... output truncated
```

Mnemonics:

- `ctrl` + `x` then `*`. The `*` is a wildcard in the most popular regular expression.

## Is that all?
NOOO! There are many more functions implemented in Bash and Readline library.
So many that some of them aren't even bound out of box to any shortcut. To list
all of them in a nice format with a name, use the previously introduced `bind -P`
command. 

\pagebreak

