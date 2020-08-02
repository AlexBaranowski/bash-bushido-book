# Aliases
Alias is an alternative name for computer, command, object, user, etc. Let's
imagine that you are Rey from the new Star Wars movies. Your email would be
like `rey@resitance.org`. Moreover, probably it will be aliased as
`mary.sue@resitance.org`, `disappointment@resitance.org` or something similar.
In other words, aliases are assumed names, also known as (**aka** in the
Internet slang), or nicknames. 

There are thousands of tools that support aliases. In the next chapters, I'm
going to present my favourite aliases for the `bash` and `git` version control
system. Then, together, we will dive a little deeper into aliases in Bash.

## Bash aliases

The command that is responsible for alias management has quite a surprising
name - `alias`. To print the currently used aliases use:

```
Alex@Normandy$ alias
alias back='popd'
(...) # truncated
```

By the way - bash `help` states that the `-p` option is responsible for
printing aliases in a reusable format, but there is no real difference between
empty `alias` and `alias -p`. The only difference that this option makes is
when defining the new alias - it also prints all other aliases (with the new
one ;)).

To define a new alias, use `alias alias_name='command args'`.

There are some aliases that I'm using in my very own environment.
```
alias sudo='sudo '
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias picnic='espeak "problem in chair, not in computer"'
alias r='reset'
alias c='clear'
alias lh='ls -AlhF --color=auto'
hash colordiff &> /dev/null && alias diff='colordiff'
alias mkdir='mkdir -pv'
alias now='date +"%F-%T; %V week"'
alias my_ip='curl -s ifconfig.co/json | python3 -m json.tool'
```
The important and interesting alias is `alias sudo='sudo '`. To get why I'm
aliasing sudo let's look at the following example.

```bash
[Alex@SpaceShip BashBushido]$ alias ok='echo OK'
[Alex@SpaceShip BashBushido]$ sudo ok
sudo: ok: command not found
[Alex@SpaceShip BashBushido]$ alias sudo='sudo '
[Alex@SpaceShip BashBushido]$ sudo ok
OK
[Alex@SpaceShip BashBushido]$ 
```
The reason why aliased sudo works perfectly fine with aliases is described in
ALIASES section of the Bash manual.
```
ALIASES
 ...
 If the last character of the alias value is a blank, then the next command word following the alias is also checked for alias expansion.
``` 

Going back to my favourite aliases. The directory aliases are self-explanatory.
`picnic` uses `espeak` to express my displeasure with some of "URGENT TECHNICAL
QUESTIONS" that I have to support.  Aliased `mkdir` is verbose and makes parent
directories so that I can make full paths at once. `now` prints the date with
the current week number (I set my personal annual goals, so it's important).
`diff` set `colordiff` instead of regular `diff`. However, before aliasing this
one checks if `colordiff` is installed.  Finally, you can read more about
`my_ip` further in the book.

## My favourite Git aliases
Git is the most successful/popular version control system (VCS) currently used.
The original author is The Great Linus Torvalds himself. Git is another
excellent project made by/for the Linux community that spread like ~~cancer~~
the best open source software. There is plenty of great, free, sources on Git.
If you are unfamiliar with this best in the class version control system, you
might look at the official free book Pro Git. I bow down to the Authors of this
excellent publication.


Git commands might be tedious, but git supports aliases, so instead of long
commands, you can type few characters and make some magic. From git 1.5 (really
ancient one :)), git supports executing external shell commands in aliases. The
command must be prefixed with `!`.

My aliases `from ~/.gitconfig`
```config
[alias]
    lol = log --graph --pretty=oneline --decorate --abbrev-commit --all
    ls = log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate
    s = status -bs
    a = add
    b = branch
    c = commit
    ci = commit --interactive
    r = reset
    rv = checkout --
    git-fuckit = !git clean -d -x -f && git reset --hard
    ohh = !git add -A . && git commit --amend
```
The short aliases allow saving some typing. The other are pearls that I found
on the Internet - like `git-fuckit`, others were given by friends, and `ohh`
alias is what I'm saying before swearing :). 

![Git is easy.\label{Git is easy.}](images/09-aliases/homeomorphic_endofunctors.jpg)

However, aliases can also be added from the command line (it's useful if you
have a bootstrap script, that should not override the configuration that
already exists). For example, the `lol` alias can be added with:
```
git config --global alias.lol 'log --graph --pretty=oneline --decorate --abbrev-commit --all'
```

As said before - if you are unfamiliar with Git, please consult the other sources.

## dotfiles
Many people share their configuration files on GitHub, GitLab or BitBucket.
Hackers (ppl who have exceptional software skill) share their config in
repositories that are usually named 'dotfiles'. There is a great site on
this topic - https://dotfiles.github.io/ . It's excellent to start and find the
most known configurations for many programs (like `emacs` or `vim`) or shells
:).

## Check what command is - type
To check what command really is you can use `type` shell builtin.
Type for all possible returned values
```bash
[Alex@SpaceShip ~]$ type type
type is a shell builtin
[Alex@SpaceShip ~]$ type bash
bash is /usr/bin/bash
[Alex@SpaceShip ~]$ type case
case is a shell keyword
[Alex@SpaceShip ~]$ type which
which is aliased to 'alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
[Alex@SpaceShip ~]$ type command_not_found_handle
command_not_found_handle is a function
command_not_found_handle ()
{
    ...
}
[Alex@SpaceShip ~]$ type asdsadf
bash: type: asdsadf: not found
```

The most useful option of `type` is `-t` flag that prints only a single word.
It's useful for scripting.
```bash
[Alex@SpaceShip ~]$ type -t type
builtin
[Alex@SpaceShip ~]$ type -t bash
file
[Alex@SpaceShip ~]$ type -t case
keyword
[Alex@SpaceShip ~]$ type -t which
alias
[Alex@SpaceShip ~]$ type -t command_not_found_handle
function
[Alex@SpaceShip ~]$ type -t asdfasdf
[Alex@SpaceShip ~]$
```

## Check if the command is aliased
We have at least 5 way to do it, 4 of them are easy to script, the last one
should be already known to an attentive reader.

1. Use `type` shell built-in
1. Use `which`.
2. Use `alias` to print all aliases.
3. Use `BASH_ALIASES` variable
4. Use `shell-expand-line`.

```bash
[Alex@SpaceShip ~]$ alias
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias vi='vim'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
[Alex@SpaceShip ~]$ which fgrep
alias fgrep='fgrep --color=auto'
    /usr/bin/fgrep
[Alex@SpaceShip ~]$ echo ${BASH_ALIASES[fgrep]}
fgrep --color=auto
[Alex@SpaceShip ~]$ type -t fgrep
alias
[Alex@SpaceShip ~]$ fgrep 
# after hitting shell-expand-line shortcut `ctrl`+`alt`+`e`
[Alex@SpaceShip ~]$ fgrep --color=auto
```

## Invoke NOT aliased version of a command
Sometimes, we want to invoke an not aliased version of a command. There are at
least two ways of doing that:

1. unalias command, invoke it, then re-alias if desired
2. use `\` before a command.

Look at following listening:
```bash
[Alex@SpaceShip eurolinux7]$ ls
Dockerfile
[Alex@SpaceShip eurolinux7]$ alias ls='echo Hit Me with Your Best Shot'
[Alex@SpaceShip eurolinux7]$ ls
Hit Me with Your Best Shot
[Alex@SpaceShip eurolinux7]$ \ls
Dockerfile
```
### Bashrc builder
Most of the aliases presented in this chapter can also be found in the
previously introduced bashrc generator -
https://alexbaranowski.github.io/bash-rc-generator/


\pagebreak

