# Essential Bash Shortcuts
Some inexperienced Linux users use arrows to navigate the command line. You
can use up and down arrows to change the current position in the history
(previously executed commands) and left or right arrow to change the current
position of the cursor. It is simple, intuitive and ssssllloooooowww. 

When I see a Linux administrator/developer/power user using the arrows to
navigate on the command line, something breaks inside of me as this is one of the
saddest view in the world. People who operate one of the greatest achievements
of humankind (Unix/Linux Operating System) don't use the console properly! How
someone for whom command line is bread and butter for more than ten years
might not know **the basic** key bindings? Well, the answer is obvious - they never
read "Bash Bushido", Bash Manual or info pages about the GNU Readline!

## GNU Readline
Bash, like most software, uses the external/shared libraries to implement the
functionalities. When it comes to reading and manipulating the user input, Bash
uses the popular GNU Readline library. One of its core features is the control of the
line you are currently typing. This lib (it's common to use the abbreviation
for library) is as old as ~~the Universe~~ Bash. So, it has an extremely
stable and mature interface. Actually, lots of software working in the REPL
(Read-Eval-Print Loop) manner uses GNU Readline as the input library or readline-like 
shortcuts to navigate/control the line. Some of the examples
are `python`, `perl` or `psql` - the PostgreSQL interactive terminal. 

To get the current Readline configuration, you can use bash built-in `bind`.

```bash
[Alex@SpaceShip ~]$ bind -P 

abort can be found on "\C-g", "\C-x\C-g", "\e\C-g".
accept-line can be found on "\C-j", "\C-m".
alias-expand-line is not bound to any keys
arrow-key-prefix is not bound to any keys
... (output truncated)
```
There is a ton of commands there! Don't panic! Throughout this book, you will
read about the most important ones.


## Previous and next command. ↑ and ↓.
The `ctrl` + `p` shortcut works like the arrow up (which asks Bash history about
the previous command). The opposite is `ctrl` + `n` (which asks the bash for
the next command in the history). With these two shortcuts, you don't have to
move your right hand to the arrow area to go through the Bash history.

```bash
[Alex@SpaceShip ~]$ echo 1
1
[Alex@SpaceShip ~]$ echo 2
2
[Alex@SpaceShip ~]$ echo 3
3
[Alex@SpaceShip ~]$ echo 3 # After ctrl+p
[Alex@SpaceShip ~]$ echo 2 # After ctrl+p
[Alex@SpaceShip ~]$ echo 3 # After ctrl+n
```


Mnemonics:

- `ctrl` + `p`revious command
- `ctrl` + `n`ext command

## Character forward and backwards. → and ← arrows.
To move forward by one character, use `ctrl` + `f`, and to move the cursor 
backward by one character, use `ctrl` + `b`. After remembering these and previous
shortcuts, the arrows become obsolete :).


Mnemonics:

- `ctrl` + `f`orward
- `ctrl` + `b`ackward


## `home` and `end` keys
Instead of using `home` key (moves the cursor to the beginning of the current
line) and `end` key (moves the cursor to the end of the current line), which,
by the way, is not that bad (it at least shows that someone can read what is
written on the keyboard that she/he/they is sitting in front of for YEARS or
even decades of life). You can use `ctrl`+`e` key combination that works like
the `end` key and `ctrl` + `a` key combination that works like the `home` key.

Mnemonics:

- `ctrl` + `e`nd
- `ctrl` + `a`ppend to the beginning

You might ask yourself if it's really that better than `home` and `end` keys.
Well, yes! Even if you have to move your left hand a little bit to hit `ctrl`
, the movement is by far shorter than the right hand leaving the typing area to
get to the navigation keys area.

## `Delete` and  `backspace`
Surprisingly, many people don't know the difference between `backspace` and
`delete` keys. The `backspace` key removes the character **before the cursor**, while
`delete` key removes the character **under the cursor**.


Armed with this theoretically obvious knowledge, you can learn two different
shortcuts. `ctrl` + `d` removes the character under the cursor. `ctrl` + `h` removes
the character before the cursor. I hope that you didn't think there will be
an actual shortcut for the `backspace` key :).

Mnemonics:

- `ctrl` + `d`elete
- `ctrl` + `h`rHrHrHrHr - sound that cat a makes when it wants to remove the character before the cursor.

## Different ways to `Enter`!
This one is quite useless because the `enter` key is exceptionally close to your right-hand's
little finger, but if you want, you can use `ctrl` + `j` or `ctrl` + `m` instead
of the regular boring `enter` key. Both of those shortcuts are bound to the `accept-line` function.

```bash
[Alex@SpaceShip ~]$ bind -P | grep 'C-m'
accept-line can be found on "\C-j", "\C-m".
```

## One word forward and backward.
Up until this moment, you have learned a bunch of useful shortcuts, but each of them can be
replaced with a single key-stroke. The really powerful shortcuts are those which are not
represented by a single keyboard key - the first one that you will learn is
moving forwards and backwards but by the distance of whole words instead of one pitiful
character. The `alt` + `f` and `alt` + `b` key combinations, move the cursor
forwards and backwards by one word, respectively.

Mnemonics:

- `alt` + `f`orward
- `alt` + `b`ackward


## Remove from the cursor position to the end of the word.
You might already notice that some shortcuts have a more **powerful** version
when you hit `alt` key instead of `ctrl` key. `ctrl` + `d` removes one
character when `alt` +`d` removes the whole word.

Note: There is group of shortcuts that uses both `alt` and `ctrl` in most
cases the version with `alt` is way more powerful.

Mnemonics:
- `alt` + `d`elete


## Remove from the cursor to the {start, end} of command line

To remove all text from the current cursor position to the end of the line use
`ctrl`+`k`. In order to remove all text from the current cursor position to the
start of the line use `ctrl`+`u`. 

For example, when the cursor is set on the first b letter (shown with the `|` character):
``` bash
$ aaa |bbb ccc
$ aaa  # After `ctrl` +k
$ aaa |bbb ccc
$ bbb ccc  # After `ctrl` + u
```

Mnemonics:

- `ctrl` + `k`ill everything 
- `ctrl` + `u`proot everything 

## How to practise it?
Well, there is a little repository I made at
https://github.com/AlexBaranowski/bash-shortcuts-teacher. It aims to help you
learn the most important Bash shortcuts. Whenever you use arrows, home or end
keys, it prints a message that there are shortcuts for that, it is a simple
penalty mechanism - you have to remove this message :).

\pagebreak

