# VIM me like you do VIM me like you do
The title of this chapter is inspired by the song 'Love Me Like You Do'.
Unfortunately, this song was used (or even made for, I don't care) in 50 shades
of Grey movie (I read about 25% of the first book, it was enough to make me
temporary blind). As DevOps/admin/whatever-I-am-even-doing I simply love Vim. 

## What about the Bash readline's vi(m) mode?
Well, the vi(m) mode sucks. Really. The reason why it sucks is quite easy to
explain - the readline (emacs like) configuration is perfect for editing a
single line. The strongest features of vim. like home row navigation and the ability
to repeat something multiple times are not very useful when you edit a single
line. There is also a problem with the fact that Bash does not show the
current vim mode (FISH shell for example does) out of the box. What it's even
more irritating is that some of the most useful shortcuts, like `ctrl` + `l`,
won't work. Aaaand finally, even with the vi mode enabled you still have to use
the subset of commands from emacs mode.

It's a free country, though, so if you really want to use bash in vi mode, you
can enable it with `set -o vi`.

As a self-proclaimed `vim` lover, I recommend staying with the `emacs` shortcuts.

![Even prequels are better than the new films. \label{Even prequels are better than new the films.}](images/04-about-vim/treason.jpg)

## Best 30 minute investment - vimtutor.
Well, there are three types of people in the Linux world. The first group are
those old enough to use a pretty good operating system that includes: mailer,
news reader, web browser, directory editor, CVS interface and a finally text
editor - `emacs`. The second group are people who acknowledge that in nearly
all distributions, on all servers, there is a minimalistic program called `vi`.
Ahhh, and the last group are normies.

Vim is an abbreviation of Vi IMproved :). You can think about the `vi` program
as a subset of `vim` functionalities. So, when you dig into the basics of "real"
`vim`, you also learn `vi`.

Some benefits of using vim:

- It exists on all kinds and flavours of Unix, and all "worth your time" Linux platforms (in most
  cases in a minimal install) - the coverage alone is enough of a reason to learn it.
- Home-row navigation. No, you don't have to use cursor (arrow) keys - it's
  much faster to stay in the home-row.
- Home-row centric, so you rarely move your fingers from the home row.
- Nearly every repetitive task has a shortcut - everyone loves shortcuts.
- Vim conserves keystrokes if you want to delete 100 lines, you just type
  `100dd`.
- Easy to learn bookmarks.
- Every worthy IDE has vim-like key bindings. Even some more exotic ones like
  RStudio or Haroopad (markdown Editor) do.
- S\*\*\*LOAD of plugins.
- Did I mention home row?

Some additional tips:

- Switching ECS with CAPS LOCK FTW! Remember that this might be irritating when
  using someone else's computer.

![TwEeT sCreEnShOtS aRe NoT mEmEs \label{TwEeT sCreEnShOtS aRe NoT mEmEs}](images/04-about-vim/developer_tweet.png)

To learn the basics of vim:

1. Install vim: `sudo yum install -y vim`.
2. Invoke `vimtutor`.

Vimtutor should take you about 25-30 minutes, and it's worth every second of
your time.

To make vim your default editor, you can use the following code:

```bash
[Alex@SpaceShip ~]$  { grep -q "EDITOR=vim" .bashrc &&  echo "EDITOR=vim is already set" ; } || echo "export EDITOR=vim" >> ~/.bashrc
```

## I don't need vim - I have my powerful IDE.

Well, it's true - vim is small, even with the best plugins, most popular IDEs will
probably in many aspects surpass it. However, as said before, nearly all IDEs have
the vim plugin. With this approach, you can get the best of two worlds. A lot of my
"serious" development is done with JetBrains IDE's. Fortunately, the IdeaVim
plugin supports all of the most popular operations.

## Edit file over ssh, HTTP, FTP and more with Vim.

As console warriors, sometimes we must edit remote files. We usually log into a
machine and then open our editor of choice. The second option is to copy the file,
edit it on our machine then overwrite it on the target machine. 

In the first solution, the editor of our choice must be present on the machine (don't
expect `vim`, but `vi` will be on 99.9% systems). Even if we had the editor of
our choice: we lose the whole (amazing) configuration, favourite plugins and
custom key bindings.

The second solution requires three steps (copy, edit, push into the host) - so
it might be too long (it's easy to script though).

Fortunately, there is also another vim specific solution that is way cooler!
You can ask vim politely to edit a remote file.

```bash
#vim PROTOCOL://USER@HOST//PATH
vim scp://alex@jumphost:/etc/ssh/sshd_config
```

Supported protocols include:
 - ftp
 - http
 - rcp
 - scp 

## Further reading about vim

The best way to start a journey with `vim` is to use the `vimtutor`. Other
resources that I can recommend are `:help` that is built in vim, **vim.org**
and **vim.fandom** websites. 

\pagebreak

