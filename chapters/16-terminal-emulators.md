# Terminals emulator

For starter, a meme about how different roles in software development team see
each other.

![Team Members meme\label{Team Members Meme}](images/16-terminals/how_see_meme.jpg)

I personally started using Linux terminal with cheesy green on black
Matrix-like colors. To this day, every sensible terminal emulator supports this
type of "Matrix" like color scheme/profile. I know few skilled Linux admins that
use the standard console (terminal emulator), provided with their
environment/window manager like gnome-terminal or Konsole. As I respect their
skills, I also believe that choosing the right emulator is actually essential
to boosting productivity.  Sysadmin/Developer/DevOps spends quite a lot of time
literally working in it. For the sake of this chapter, I made some basic
features that a good terminal emulator must have:

- Support for colors.
- Possibility to choose different color profiles.
- Possibility to make/import user-defined color profiles.
- Support for mouse events (scrolling + clicking)
- Text resizing/wrapping depending on current terminal width/size.
- Possibility to make multiple tabs.


Other features that good terminal should have:

- Possibility to set a background image. 
- The support for True Color.
- Save output to file (logging).
- "Infinite scrolling" or at least ability to store one thousand lines.
- Windows split to make multiple terminals - both horizontal and vertical splitting
  should be possible.


Lastly there are features that I tried but found useless:

- Displaying Images/Video in a terminal.


In this chapter, I will show some terminal emulators that I personally used
during my journey with Linux. First chapters are about dropdown terminals that
are a handful when doing some quick editing/checking. Then, I will present, in
my opinion, the best terminal emulator `Terminator`. Finally, I will give some
necessary information about the `screen` and show some useless but excellent
for presentation terminal emulator named `Cool Retro Term`. Before going
further, I would like to stress that I recommend choosing the tool that will
seamlessly integrate with your workflow.

## Short history of dropdown terminals

In the life of any superuser, there is a time when you want to invoke a
command **now** without an additional fuss like switching to another
workspace/window. In other cases, you might wish for the nice placeholder for
invoking/observing the time-consuming processes. In the very same time, it's
always nice to have a terminal that you can get/check right away. Of course,
you might make new windows/tabs of your current terminal or even switch between
"real" terminals (TTY). But it's ineffective. So, if you want a swift and
convenient solution, you might try the other way - the dropdown terminal.

The whole idea of a dropdown terminal came from the video games (btw. shouldn't they
be called computer games already?)! Yeah, that little thing that according to
the president of the United States, Donald Trump causes violence and mass
shooting. Thank God even from such unspeakable/horrible blasphemy like the video
games an excellent idea can arise. The dropdown terminals started with a Quake
cheat console.

![Quake Dropdown Cheat Console\label{Quake Dropdown Cheat Console}](images/16-terminals/quake_console.png)

As it's easy to predict, the people that make free software ~~steal~~ adapt the
idea of drop-down terminals and then perfect it. In Bash Bushido, we will
discuss the two most popular dropdown terminals - Guake and Yakuake. Note that
both have names that end with **ake** to honor the **Quake** game.


## Guake - Gnome Drop Down Terminal

The development of guake, as many other free/open-source software, takes place
on the GitHub platform https://github.com/Guake/guake . As multiple python based
project guake changed version numbering from 0.83.13 to 3.0; the reason for this
is simple - the support for python 2.7 was dropped and having the separate
numbers for a new version makes sense. Guake installation in at Enterprise
Linux distributions is as simple as installing the epel-release package then installing the
Guake from the EPEL repository.

```
sudo yum install -y epel-release
sudo yum install -y guake
```


After installation, I recommend invoking `guake` that will ask about biding
itself to the `F12` key. I highly recommend this because only a small percentage
of applications actually uses `F12` and in most cases (like a web browser and
developer tools), they are also bound to other keys combination (like
`ctrl`+`shift`+`i` in Firefox). After configuration `guake` might be
showed/hidden with `F12` or any other chosen key.


This paragraph is gnome 3 specific - to add guake to autostart in gnome you
might use `gnome-tweak-tools` or `gnome-session-properties`. The
`gnome-tweak-tools` uses `desktop` files from `/usr/share/applications` when
`gnome-session-properties` allows to run any command.


Guake supports:

- Colors
- Possibility to choose different color profiles.
- Option to make/import user-defined color profiles.
- Support for mouse events (scrolling + clicking)
- Text resizing and wrapping depending on current terminal width/size.
- Possibility to make multiple tabs.
- Possibility to set a background image. 
- Support for True Color.
- Ability to store more than one thousand of the output lines.

 
Like any other sensible terminal emulator, Guake allows making a new tab with
`ctrl`+`shift`+`t`. Terminal tabs switching are bound to `ctrl`+ `Page
Up`/`Page Down`.



Below, resized (so it won't crash the e-book readers) screenshot from my glorious
21:9 monitor.
![Guake\label{Guake }](images/16-terminals/guake_21_9.png)


## Yakuake - KDE Dropdown Terminal

The main competitor of the Guake project is Yakuake, it's part of never ending
competition between Gnome and KDE. This competition makes me and any other
Linux user happy because having a choice itself is great. Yakuake development
is managed by KDE foundation on their Git. I must say that I like the fact that it is
GitHub/GitLab independent, but I have no idea how contributing/issue reporting
is managed.


Like Guake Yakuake is also available in the EPEL repository. Installation is 
as straightforward as:

```
sudo yum install -y epel-release 
sudo yum install -y yakuake
```


Like `guake`,  `yakuake` also asks about setting the F12 as on/off key during
first start. When it comes to the features Yakuake supports the following:

- Colors
- Color profiles.
- Create/import user-defined color profiles.
- Support for mouse events (scrolling + clicking)
- Text resizing and wrapping depending on the current terminal width/size.
- Possibility to make multiple tabs.
- Possibility to set a background image. 
- Support for True Color.
- Ability to store the "infinite" number of output lines.
- Vertical and horizontal splitting allows multiple terminals in one window.


Older Yakuake version screenshot:
![Yakuake\label{Yakuake }](images/16-terminals/yakuake.png)


The thing that I dislike about Yakuake are default key bindings. For example the full
screen is `ctrl` + `shift` + `F11` instead of `F11`. The new tab is
`ctrl`+`shift`+`t` but to change the tab you have to use `shift` + arrow
instead of `Page Up\Page Down`. It's tweakable and works well with other KDE
apps, but it's not to my taste. Generally speaking, the Yakuake is more
powerful than Guake, but it also requires more effort to learn and develop
different habits.


## TERMINATOR make terminal grid again!

The Terminator authors describe it as - "Multiple GNOME terminals in one
window". Terminators allow you to arrange terminals in grids or as not
technical colleges says in "Matrix". In contrast to `tmux` and `screen`, to
leverage most of the Terminator features you don't have to learn a lot of shortcuts
or how to make a complicated configuration file. In other words, the Terminator
is user-friendly, it's a typical zero entry program that shines without any
configuration. Most of the operations can be achieved with mouse, especially
without learning **any** shortcut. 


To install Terminator on Enterprise Linux Distributions invoke: 

```
sudo yum install -y epel-release 
sudo yum install -y terminator.
```


I also made my build of the newer version that is available on OBS (Open Build
Service) supported and maintained by one of my favourite company SUSE,
https://build.opensuse.org/repositories/home:alex_baranowski/terminator-1.9-epel7).


After installing the Terminator, you can right-click and select horizontal or
vertical split, that will split the current terminal window into two. Another
important capability of Terminator is support for drag and drop, so you can
easily arrange your terminal "matrix" with few clicks and impress less-skilled
Linux users. 

```
Friend A: Have you ever heard the story about Alex the Wise that impress oposite/same sex/gender with his Terminator setup? 
Friend B: No.
Friend A: End.
```


This is actual joke that my friend told me.

### Most important terminator shortcuts:

- `ctrl` + `shift` + `o` - open new terminal horizontally.
- `ctrl` + `shift` + `e` - open new terminal vertically.

There is very simple mnemotechnique for it.

- `ctrl` + `shift` + h`O`rizontally.
- `ctrl` + `shift` + v`E`rtically.


Now when you have multiple terminals, you probably would like to navigate
seamlessly (without using mouse):

- `alt` + ↑ - Move to upper terminal.
- `alt` + ↓ - Move to lower terminal.
- `alt` + ← - Move to terminal on the left.
- `alt` + → - Move to terminal on the right.


What you really have to remember is `alt` + `direction arrow`. It's
trivial and intuitive.


Another handy feature is the ability to maximize single terminal - I personally
named it **focus mode**:

- `ctrl` + `shift` + `x` - maximize the terminal you are currently working on.
  To undo this operation ("restore all terminals") use same shortcut.


### Fan with tabs 
Terminator allows creating multiple tabs. Each tab can have multiple terminals:

- `ctrl` + `t` - add new tab. Tab vanish when all terminals within are closed.
- `ctrl` + `Page UP` - move to the previous tab.
- `ctrl` + `Page DOWN` - move to the next tab.

### Broadcasting
Broadcasting multiply your input to other terminals, it's handy when setting up
with multiple systems.

- `alt` + `a` - turn broadcast on to all terminals. 
- `alt` + `o` - turn broadcast off.

The terminal can also be assigned to custom named group. Each terminal might
have only one group assigned, but group can have multiple terminals. To create
a group, you click on the little icon in the left corner of the terminal. Then
create a group or assign terminal to the existing group. Groups also support
broadcasting, to broadcast to the group use:

- `alt` + `g` - turn broadcast on to a group.
- `alt` + `o` - turn broadcast off.


### Resizing and creating new windows
To perfect your setup, you might resize the terminal, both mouse (drag the
terminal "title" bar) and keyboard might be used to change the terminal size:

- `ctrl` + `shift` + `arrow` - resize the current terminal by one character in
  the arrow direction. You can hold the combination until you get the intended
  size.

To create a new window use:

- `ctrl` + `shift` + `i` 


## Terminal detaching with screen

I don't use screen and tmux because the configuration of each of them is
cumbersome. The only thing that I found unique in them is the ability to run on
a server without X11 (or Wayland :)), and detach. To deatch your screen sesion
use `ctrl` + `a` then `ctrl` + `d`.

```bash
sudo yum install -y screen
screen
# Do you work - ex. setup IRC communicator
# Detach with `ctrl` + `a` then `ctrl` + `d`
screen -r # will resume your previous screen
```


Mnemonics:

- `ctlr` + `a`ctivate (extra options) then `ctrl` + `d`etach
- screen -`r`eattach

## Cool-retro-term.

There is a group of projects that I sometimes call "uncle projects" or "uncle
software". I really like being an uncle, especially at familly gatherings, when
you can babysit the baby for a short time, but when you get tired of it, you
just give him/her back to the parents. The "uncle software" is the same, it's
nice to play with it for a bit, but after a little while, you can just forget
about it. Of course, these words and terms were forged by a single that will die
alone.


You can install the `cool-retro-term` from nux repos (https://li.nux.ro/). Or compile
it from the source. When compiling it from the source on an Enterprise Linux system,
you should change qmltermwidget version. The following script worked for me:

```bash
#!/bin/bash
CRT_URL=https://github.com/Swordfish90/cool-retro-term/archive/1.0.1.tar.gz
WIDGET_URL=https://github.com/Swordfish90/qmltermwidget/archive/v0.1.0.tar.gz

sudo yum -y install qt5-qtbase qt5-qtbase-devel qt5-qtdeclarative qt5-qtdeclarative-devel qt5-qtgraphicaleffects qt5-qtquickcontrols redhat-rpm-config

wget "$CRT_URL" -O cool-retro-term.tar.gz
mkdir cool-retro-term && tar xvf cool-retro-term.tar.gz -C cool-retro-term --strip-components 1
cd cool-retro-term
rm -rf qmltermwidget
wget "$WIDGET_URL" -O qmltermwidget.tar.gz
mkdir qmltermwidget && tar xvf qmltermwidget.tar.gz -C qmltermwidget --strip-components 1
qmake-qt5
make
sudo make install STRIP=true
```


But simpler method to use Cool Retor Term is AppImage. AppImage is a format
that in theory should pack program and all necessary libraries in one file.

```
wget https://github.com/Swordfish90/cool-retro-term/releases/download/1.1.1/Cool-Retro-Term-1.1.1-x86_64.AppImage
chmod 755 Cool-Retro-Term-1.1.1-x86_64.AppImage
./Cool-Retro-Term-1.1.1-x86_64.AppImage
```


After starting the program you can make your own profiles or play with one of
the presets. I recommend trying each of them, then decide which one you like the
most. As I said before, I find this cool-retro-term fun, great for
presentation, and even a little exciting but not suited for everyday work.

![Cool Retro Term - IBM DOS profile\label{Cool Retro Term - IBM DOS profile}](images/16-terminals/cool_retro_term.png)

![Cool Retro Term - IBM 3278 profile\label{Cool Retro Term - IBM 3278 profile}](images/16-terminals/cool_retro_term_2.png)

\pagebreak

