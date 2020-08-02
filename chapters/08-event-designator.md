# Event designator, word designator, modifiers
This chapter is dedicated to some advanced Bash features. Because the presented material might be somehow overwhelming, the last subchapter contains the most frequent commands.

## What does `!` mean in Bash?
`!` is a special character for the Bash shell. It's a mighty Event Designator.
The Bash manual explains it as:
```
An event designator is a reference to a command line entry in the history list.  Unless the reference is absolute, events are relative to the current position in the history list.
```
So easily speaking, `!` allow us to reuse the previous commands (stored in the history).

## sudo + !! = fRiends 4 EVEER!!!1
The most common usage of `!` (in many cases without knowing what it is) is
invoking it with a second `!`. `!!` is a special shortcut that says `invoke the
last command as it was`. It's most frequently used with a privilege escalation
via sudo. Look at the following example.

```bash
[Alex@SpaceShip ~]$ cat /etc/gshadow | head -1
cat: /etc/gshadow: Permission denied
[Alex@SpaceShip ~]$ sudo !!
sudo cat /etc/gshadow | head -1
root:::
[Alex@SpaceShip ~]$ 
```
As said before, this is the most popular event designator usage and one that you can find in nearly every Bash course.

## Invoking a command by number in the history
Sometimes, it's easier to list a subset of commands than to search it
interactively. Then you can leverage on event designator by invoking it with
`![NUBMER]`. Look at the following example:

```bash
[Alex@SpaceShip ~]$ history | grep grep
1 grep -v bash /etc/passwd | grep -v nologin
2 grep -n root /etc/passwd
101 grep -c false /etc/passwd
202 grep -i ps ~/.bash* | grep -v history
404 grep nologin /etc/passwd
501 history | grep grep
[Alex@SpaceShip ~]$ !404
# Will invoke `grep nologin /etc/passwd`
```

There is also another trick with negative numbers. In multiple programming languages, the negative indexes mean that we are counting indexes from the end instead of from the start. For example, `-1` means the last element on a list and `-3` means the third element from the end. The same rule goes with invoking the event designator. Look at the following example:

``` bash
[Alex@SpaceShip ~]$ echo In Musk We Trust
In Musk We Trust
[Alex@SpaceShip ~]$ echo Mars
Mars
[Alex@SpaceShip ~]$ echo Earth
Earth
[Alex@SpaceShip ~]$ !-2
echo Mars
Mars
[Alex@SpaceShip ~]$ !-2
echo Earth
Earth
[Alex@SpaceShip ~]$ !-2
echo Mars
Mars
[Alex@SpaceShip ~]$ !-2
echo Earth
Earth
```

Some of the readers might have already noticed that we can replace `!!` with
`!-1`.

## Invoking a command starting with a string
To invoke the last command that **starts** with a given string, use the event designator with a string so that the command looks like `!<string>`.
Example below:
```
[Alex@SpaceShip cat1]$ whoami
Alex
[Alex@SpaceShip cat1]$ who
Alex :0 2018-04-20 09:37 (:0)
...
[Alex@SpaceShip cat1]$ !who
who
Alex :0 2018-04-20 09:37 (:0)
...
[Alex@SpaceShip cat1]$ !whoa
whoami
Alex
```

## Invoking a command containing the chosen string
`!?string?` substitutes the most recent command that **contains** a `string`. Note that which command is the most recent depends on your position in the history. As said before you can always get to the end of history with empty command line or with `ctrl` + `>`.

The usage of `!string!?` is presented by the following example:
```
[Alex@SpaceShip ~]$ echo Mamma mia
Mamma mia
[Alex@SpaceShip ~]$ echo ", here I go again"
, here I go again
[Alex@SpaceShip ~]$ !?mia?
echo Mamma mia
Mamma mia
[Alex@SpaceShip ~]$ !?go
echo ", here I go again"
, here I go again
```


Note that you can omit the second `?` if there are no additional arguments. To
get what it means, look at the example below:

```bash
Alex@Normandy$ echo mama mia
mama mia
Alex@Normandy$ !?mama? here I go again
echo mama mia here I go again
mama mia here I go again
Alex@Normandy$ !?mama there are some additional args
bash: !?mama there are some additional args: event not found
```

## Word Designator
Another huge thing in Bash is the word designator. Once more I decided to cite
the part of the Bash manual.

```
Word  designators are used to select desired words from the event. A : separates the event specification from the word designator.  It may be omitted if the word designator begins with a ^, $, *, -, or %.  Words are numbered from the beginning of the line, with the first word being denoted by 0 (zero). Words are inserted into the current line separated by single spaces.
```

Of course, the word designator is optional, but the quite exciting thing is the
fact that it is also optional when we are using modifiers (we will talk about
them later).  Before showing some samples, I would like to once more quote part
of the bash documentation - this time in a tabular form.


| Designator | Function |
|----|--------|
|`0 (zero)`| The zeroth word.  For the shell, this is the command word.|
|`n`| The nth word.|
|`^`| The first argument.  That is, word 1.|
|`$` | The last argument. |
|`x-y` | A range of words **-y** abbreviates **\0-y**. |
|`*` | All of the  words but the zeroth.  This is a synonym for ** 1-$ **.  It is not an error to use * if there is just one word in the event; the empty string is returned in that case.|
|x\*| Abbreviates x-\$. |
|x- | Abbreviates x-\$ like x\*, but omits the last word. |
|%| The word matched by the most recent **?string?** search. |

If a word designator is used without an event number, the last event is used.

The word designator usages are presented with the following examples:

```bash
[Alex@SpaceShip ~]$ echo use printf `use echo\n`
use printf use echo\n
[Alex@SpaceShip ~]$ !!:2* # You can also use !:2*
printf `use echo\n`
use echo
```
We can put together arguments from multiple events (commands from the history). 

```bash
[Alex@SpaceShip ~]$ echo I love rock \'n\' roll  
I love rock 'n' roll 
[Alex@SpaceShip ~]$ echo I love rock \'n\' roll 
I love rock 'n' roll
[Alex@SpaceShip ~]$ echo I love rock \'n\' roll  
I love rock 'n' roll
[Alex@SpaceShip ~]$ echo I love rock \'n\' roll           
I love rock 'n' roll
[Alex@SpaceShip ~]$ echo I love rock \'n\' roll  
I love rock 'n' roll
```

```bash
[Alex@SpaceShip ~]$ history | tail -6
583 echo I love rock \'n\' roll
584 echo I love rock \'n\' roll
585 echo I love rock \'n\' roll
586 echo I love rock \'n\' roll
587 echo I love rock \'n\' roll
588 history | tail -6
```

```bash
[Alex@SpaceShip ~]$ echo !583:1 !584:2 !585:3 !586:4 !587:5
I love rock 'n' roll
``` 

And also use whole arguments groups from the previous commands.

```
Alex@SpaceShip ~]$ !583:0-3 !584:4*
echo I love rock \'n\' roll
I love rock 'n' roll
```

Now we can get a `!!` shortcut in another (third) way.

```
[Alex@SpaceShip ~]$ yum update
...
You need to be root to perform this command.
[Alex@SpaceShip ~]$ sudo !:0*
sudo yum update
...
No packages marked for update
```

## Modifiers - additional operations on word designator/s

After optional word designator, we can execute additional operations, getting even more control over the command line, these operations are called modifiers. Each modifier is prefixed a with `:` (colons).

For the last time in this chapter, I am going to quote the bash manual (I hope that GNU project won't sue me) in the form of a table.

| Modifier | do |
|----|--------|
|h|Remove a trailing file name component, leaving only the head.|
|t|Remove all leading file name components, leaving the tail.|
|r|Remove a trailing suffix of the form .xxx, leaving the basename.|
|e|Remove all but the trailing suffix.|
|p|Print the new command but do not execute it.|
|q|Quote the substituted words, escaping further substitutions.|
|x|Quote the substituted words as with q, but break into words at blanks and newlines.|
|s/old/new/| Substitute new for the first occurrence of old in the event line. Any delimiter can be used in place of /.  The final delimiter is optional if it is the last character of the event line.  The delimiter may be quoted in old and new with a single backslash.   If  & appears in new, it is replaced by old.  A single backslash will quote the &.  If old is null, it is set to the last old substituted, or, if no  previous  history  substitutions took place, the last string in a !?string[?]  search.|
|&|Repeat the previous substitution.|
|g| Cause changes to be applied over the entire event line. This is used in conjunction with ':s' (e.g., ':gs/old/new/') or ':&'.  If used with ':s', any delimiter can be used in place of  /, and the final delimiter is optional if it is the last character of the event line.  And may be used as a synonym for g.|
|G| Apply the following 's' modifier once to each word in the event line.|

Yeah, that a lot! When you think about it `s` is a substitution, and the rest (`&gGqx`) of them are controls how this substitution is going to behave.
Finally, you can imagine the event designator as following structure:

```
![number,string or !][:word_designator][:modifier_1][:modifier2]...
```

Modifier can be repeated multiple times. To get different set of words from
the word designator you have to write a new event designator.

After this horrible theory, let's look at some examples:
```bash
[Alex@SpaceShip ~]$ echo aaa bbb /a/b/c/aaa.txt
aaa bbb /a/b/c/aaa.txt
[Alex@SpaceShip ~]$ !!:s/aaa/bbb # substitutes aaa with bbb once
echo bbb bbb /a/b/c/aaa.txt
bbb bbb /a/b/c/aaa.txt

[Alex@SpaceShip ~]$ echo aaa bbb /a/b/c/aaa.txt
aaa bbb /a/b/c/aaa.txt
[Alex@SpaceShip ~]$ !:gs/aaa/bbb # substitutes aaa with bbb multiple times, note that there is default value of event designator (last event) so we can use only one `!`
echo bbb bbb /a/b/c/bbb.txt
bbb bbb /a/b/c/bbb.txt
[Alex@SpaceShip ~]$ echo aaa bbb /a/b/c/aaa.txt
aaa bbb /a/b/c/aaa.txt
[Alex@SpaceShip ~]$ echo !!:e
echo .txt
.txt
[Alex@SpaceShip ~]$ echo aaa bbb /a/b/c/aaa.txt
aaa bbb /a/b/c/aaa.txt
[Alex@SpaceShip ~]$ !!:r
echo aaa bbb /a/b/c/aaa
aaa bbb /a/b/c/aaa
[Alex@SpaceShip ~]$ echo aaa bbb /a/b/c/aaa.txt
aaa bbb /a/b/c/aaa.txt
[Alex@SpaceShip ~]$ !!:h
echo aaa bbb /a/b/c
aaa bbb /a/b/c
```
  
## Fast substitution in the previous command
When you make a typo or want to change an argument or any other string in the
last invoked command, the following trick might be handy - `^old^new^` It
replaces the `old` string with the `new`. You should also know that substitution by
default works only on the first match. Look at the following examples:

```bash
[Alex@SpaceShip ~]$ dgi google.com | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1
bash: dgi: command not found...
Similar command is: 'dig'
[Alex@SpaceShip ~]$ ^dgi^dig^
dig google.com | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1
172.217.16.46
[Alex@SpaceShip ~]$ grep "net.ipv4." /etc/sysctl.conf
...
[Alex@SpaceShip ~]$ ^v4^v6 # Note the absence of last ^
grep "net.ipv6." /etc/sysctl.conf
[Alex@SpaceShip ~]$ echo "echo printf?\n"
echo printf?\n
[Alex@SpaceShip ~]$ echo aaa bbb aaa
aaa bbb aaa
[Alex@SpaceShip ~]$ ^aaa^bbb^ ccc ddd # With new args
echo bbb bbb aaa ccc ddd
bbb bbb aaa ccc ddd
```
As you might suspect, the `^old^new` is similar to the usage of the last
command with word designator that uses substitution modifier. So finally we
can write it as `!!:s/old/new/` what is equal ` !-1:s/old/new` what is equal
`!:s/old/new`. 

To get multiple substitutions, we can add a word modifier.
```
[Alex@SpaceShip ~]$ echo aaa bbb aaa
aaa bbb aaa
[Alex@SpaceShip ~]$ ^aaa^ccc^:& # With '&' modifier.
echo ccc bbb ccc
ccc bbb ccc
```


## histchars – let's control the history characters :)
This trick is connected with both Bash history and word designator. There is a
possibility to change the special characters of history by setting the
`histchars` env variable. `histchars` is one of this special variable that
for unknown reason is lowercased.

The histchars has three characters that are:

1. Event designator (history expansion). `!` is default.
2. Quick substitution, used only if it is the first character on the command line. `^` is default.
3. Comment - It's crucial to understand that this is a comment for history substitution, not the shell parser - to be honest, it's quite useless I never saw anyone using it this way.

Check these two examples:


Default characters:

```bash
[Alex@SpaceShip ~]$ echo "Bash is great"
Bash is great
[Alex@SpaceShip ~]$ !!
echo "Bash is great"
Bash is great
[Alex@SpaceShip ~]$ ^Bash^Fish
echo "Fish is great"
Fish is great
[Alex@SpaceShip ~]$ # This is a comment
```


Now with histchars set to `+=@`

```bash
[Alex@SpaceShip ~]$ histchars="+=@"
[Alex@SpaceShip ~]$ echo "Bash is great"
Bash is great
[Alex@SpaceShip ~]$ ++
echo "Bash is great"
Bash is great
[Alex@SpaceShip ~]$ =Bash=Fish
echo "Fish is great"
Fish is great
[Alex@SpaceShip ~]$ @ This is comment
bash: @: command not found...
```

## Disable ! (event designator)
Imagine that you are writing a fantastic, maybe not as amazing as the one that
you are reading, book about Bash. The first thing that you would show might
be the famous `Hello, world!`.

In the case of Bash, you will think probably about something like: `echo "Hello World!"`
After reading this chapter, you probably already know the output.
```
[Alex@SpaceShip ~]$ echo "Hello, world!"
bash: !": event not found
```

The solution is simple - use `'` instead of `"`.
However, there are at least two other solutions.

First one is set `histchars` to nothing.
```
[Alex@SpaceShip ~]$ histchars=
[Alex@SpaceShip ~]$ echo "Hello, world!"
Hello, world!
```

There is another workaround/nasty hack/possibility. You can disable history expansion with:
`set +o histexpand`.
```
[Alex@SpaceShip ~]$ set +o histexpand
[Alex@SpaceShip ~]$ echo "Hello, world!"
Hello, world!
[Alex@SpaceShip ~]$ set -o histexpand
[Alex@SpaceShip ~]$ echo "Hello, world!"
bash: !": event not found
```

## So, what is really useful?
It depends. In my opinion, most of this chapter might be treated as a
mental exercise, that I describe because it's a cool feature that many
experienced Bash users don't know about. It's obvious that in times of advanced
terminal emulators, with support for the mouse (the middle button for copy and
paste) and normal copying and pasting, the most of these tricks (especially
modifiers) are not as useful as they used to be. So, to sum up, I decided to put
the most frequently used commands/tricks:

- `sudo !!` 
- `^old^new^`
- `![number]` and `!-[number]`
- `!string` - Invoking a command starting with the string
- `!?string?  - Invoking a command containing the string


\pagebreak

