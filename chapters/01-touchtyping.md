# Let Keyboard Become Your Very Best Friend
In countless texts, articles and how-tos we read about a better, faster, or
shorter way to do something on the computer. The most prominent example is
coping and pasting. Nearly all computer users know that `ctrl + c` and `ctrl +
v` are the best ~~homework and essay generators~~ friends. Another great
example is the `ctrl` + `alt` + `delete` key combination - the must-know for all
Windows users.


However, a lot of these tricks, tips and shortcuts are not very handy unless
you are touch-typist. Why? Because a lot of them take advantage of typical
hands positions on the keyboard during typing. For example, the whole `vim`
navigation was made to use the home row. To get the right position and
become the power user, you really should learn how to touch type.

Some readers might not know what touch typing is. Fortunately, there is an
excellent definition of touch typing on Wikipedia. To sum it up - touch typing
is the ability to use (type on) the keyboard without looking at it.

### Reasons to learn touch typing

- Average typing speed is about 40 WPM (word per minute), people who type
  without looking at the keyboard can type twice as fast on average. Note that
  the average typing speed includes the group of touch-typers :).
- You can get more things done.
- So, you have more time for ~~work~~ coffee and social activities.
- You see ~~yru~~ your typos as you type (you are looking at the monitor, not
  the keyboard). So, there is higher chance of catching and correcting them.
- When you compose an email, you don't look like tech Amish. 
- From my point of view, the most advantageous fact is that there is no barrier
  between my mind and the code (texts) that I'm writing. The keyboard it the
  "extension" of my body. Writing programs is not easy, and it's easy to lose
  focus when you are "fighting" with the keyboard.

### Reasons not to learn touch typing
- When you are working for a corporation, where you have plenty of time and
  saying that work is done is more important than actually doing it, then touch
  typing might improve your work performance what is not preferred.
- **404** - any real acceptable argument **not found**.


### What is needed to learn touch typing?
About 15 minutes per day for 2-3 months at maximum, I saw my ex-girlfriend
learn that in less than a month. OK, you've got me - I've never had
a girlfriend, the distant friend of my friend (my friends also never had
girlfriends) told that story to me.

### Learn how to touch type in the Linux terminal
This book is committed to the command line and terminal program/stuff. But it's
only fair to say that there are great programs like "klavaro" or "ktouch", with
their fancy GUIs and all necessary lessons, great statistics showing your
progress, interfaces, etc. 

When it comes to the console, there is one minimalistic program that I can honestly
recommend - `gtypist`. `gtypist` is ncurses-based, so it's minimal, yet
powerful.

It's so niched that it's unavailable in many distributions (like EL). So you
have to compile it by yourself.  It requires basic ncurser development
libraries and C language compiler. In the case of Enterprise Linux, you can simply
install **@development** package group that have a lot of development packages
and ncurses-devel package.
```
sudo yum install -y @development ncurses-devel
```
After installation completes:
```
wget https://ftp.gnu.org/gnu/gtypist/gtypist-2.9.5.tar.xz
tar xvf gtypist-2.9.5.tar.xz
cd gtypist-2.9.5/
./configure
make 
sudo make install
```
This will compile gtypist and copy it to the `/usr/local/bin` directory.
Depending on your `$PATH` environment variable, it should be executable right
away.

![GNU Typist - gtypist. \label{GNU Typist -gtypist.}](images/01-touchtyping/1.png)

The program is self-explanatory, there is small help section that you can read,
but it is as minimalistic as the program itself. For touch typing newcomers, I
endorse the T series, as it's easier than the Q series. It introduces each key
slowly and has extensive exercise patterns, that helps to build the foundation
for touch typing. 

When it comes to practice time, multiple studies about learning proved that
**daily** short practice sessions are way more effective than long sessions that
are not regular. Another important consideration is how to replace the old
routine. If you learn how to type a letter correctly, always do it the right way.
It's crucial to replace the old typing habits with the new ones. Because
learning takes time at first, you might type slower, but after some time, your
speed will increase dramatically.

The default gtypist color scheme might be unreadable on some terminal emulators
and color scheme combinations. Luckily, you can experiment and change it.

- `-c` or `--colors`- set the main colors of the program.
- `--banner-colors` - allows setting up all colors used by gtypist.  You can
  choose colors from numbers 0-7, what gives us 64 combinations for foreground
  and background colors.

Sample gtypist invocationwith changed color schemes:
``` 
gtypist -c=0,2
gtypist --banner-colors=0,2,3,2 
```

The `typefortune` is a neat gtypist utility that uses `fortune` command output
and invokes gtypist on it. Because `typefortune` is written in Perl it requires
working interpreter.

\pagebreak

