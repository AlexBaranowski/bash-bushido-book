# Print to console like a hacker (or a script kiddie)
In this chapter, we will look into the way of printing the letters, symbols,
even some kind of Linux memes. Please note that the knowledge from this chapter
is not very helpful when it comes to being a SysAdmin or DevOps.

![Drake Meme\label{Drake meme}](images/11-hacker-printing/drake_meme.jpg)


## banner
The banner is a quite old program (so old that its original code is barely
readable [sh\*\*load of conditional compilation for computers older than
a transistor ;)]), that prints given string in a **gigantic** letters.

Installation on an Enterprise Linux machine (requires EPEL):
```
sudo yum install -y epel-release
sudo yum install -y banner
```

In any other distribution, please try to find it with your package manager, in
most cases, it's called **banner** or **sysvbaner**. Die-hard compilation fans
can find the sources and easily compile it.

With banner installed, now we can answer the development team lead when
he/she/they (gender neutral alphabetical order) asks "Why our application
doesn't work in a production environment?".

::: {class="smaller_font"}

```
[vagrant@localhost ~]$ banner you sucks

#     #  #######  #     #   #####   #     #   #####   #    #   ##### 
 #   #   #     #  #     #  #     #  #     #  #     #  #   #   #     #
  # #    #     #  #     #  #        #     #  #        #  #    #      
   #     #     #  #     #   #####   #     #  #        ###      ##### 
   #     #     #  #     #        #  #     #  #        #  #          #
   #     #     #  #     #  #     #  #     #  #     #  #   #   #     #
   #     #######   #####    #####    #####    #####   #    #   #####  
```

:::

Well, that's like all that the banner can do. This program is dead simple. In the
default implementation, there is not much more that you can do. I personally
made my own implementation that can be found at the GitHub - 
https://github.com/AlexBaranowski/Banner.

I'm not very proud of this program, but since I mentioned it, I would like to
give you a glimpse how to use it. To compile my version of the banner you can
use following commands.

```
git clone https://github.com/AlexBaranowski/Banner.git
cd Banner
make
sudo make install
```

After this, there should be `/usr/bin/banner`, that should also be available
with your `$PATH` environment variable.  The general options for my banner are

- -c [CHAR] change the output character
- -s the printing character is the same as a letter
- -i reads from stdin
- -n ignore options strings after this one

I would like to give two examples. The first one with the same printing
character as the printed character.

::: {class="smaller_font"}
```
Alex@Normandy$ banner -s "I Love U"
IIIII           L                                       U     U 
  I             L                                       U     U 
  I             L        oooo   v     v  eeee           U     U 
  I             L       o    o   v   v  e    e          U     U 
  I             L       o    o   v   v  eeeeee          U     U 
  I             L       o    o    v v   e                U   U  
IIIII           LLLLLL   oooo      v     eeee             UUU   
```
:::

Second one is with the custom character set to **@**.

::: {class="smaller_font"}

```
Alex@Normandy$ banner -c@ "Kiss"
@    @                          
@   @     @                     
@  @             @@@@    @@@@   
@@@      @@     @       @       
@  @      @      @@@@    @@@@   
@   @     @          @       @  
@    @  @@@@@   @@@@@   @@@@@  
```
:::

Once more my personal implementation of the banner is a also simple program,
so there is no much more that you can do.


## FIGlet
Have you ever used torrent? You probably did! You nasty ~~thief~~ ~~broke
student~~ freedom fighter! So, you know that there is always a "kick-ass"
signature of ~~pirates~~ ~~thieves~~ freedom fighters' group that can be found
in the `README.txt` file. You can achieve the same effect with FIGlet. The little
program that "displays large characters made up of ordinary screen characters".


Installation on EL machine (requires EPEL):

```bash
sudo yum install -y epel-release
sudo yum install -y figlet
```

Sample FIGlets of "famous" hacker groups.

::: {class="smaller_font"}

```
$ figlet 'H@Ck01'
 _   _   ____   ____ _     ___  _ 
| | | | / __ \ / ___| | __/ _ \/ |
| |_| |/ / _` | |   | |/ / | | | |
|  _  | | (_| | |___|   <| |_| | |
|_| |_|\ \__,_|\____|_|\_\\___/|_|
        \____/  
``` 
:::

The FIGlet has a built-in support for fonts (**flf** file extension), so we can
deeply customize its output. To get the default font names we can query rpm for
files instaled from a FIGlet package.
```
$ rpm -ql figlet | grep flf | sed 's:.*/::' | sed "s/.flf//"
banner
...
term
```

The following script will print all fonts with a sample output.

```bash
#!/bin/bash
for i in $(rpm -ql figlet | grep flf | sed 's:.*/::' | sed "s/.flf//");
do
    figlet -f  "$i" "font: $i" ;
done
```


Another option is to use `find` to find a file instead of listing them with rpm.


```
FIGLET_DIR=/usr/share/figlet
for i in $(find $FIGLET_DIR -iname '*flf' | sed 's:.*/::' | sed "s/.flf//");
do
    figlet -f  "$i" "font: $i" ;
done
```


My favourite font is `slant`. There is a secret message that I would like to
send to all people that supported and bought this book.

::: {class="smaller_font"}

```
$ figlet -f slant 'thank you <3'
   __  __                __                           __   _____
  / /_/ /_  ____ _____  / /__   __  ______  __  __   / /  |__  /
 / __/ __ \/ __ `/ __ \/ //_/  / / / / __ \/ / / /  / /    /_ < 
/ /_/ / / / /_/ / / / / ,<    / /_/ / /_/ / /_/ /   \ \  ___/ / 
\__/_/ /_/\__,_/_/ /_/_/|_|   \__, /\____/\__,_/     \_\/____/  
                             /____/                            
```
:::

## cowsay
Another well-known alternative way to print the message in the terminal is
`cowsay`. It uses ASCII-Art cow. Not many Linux users know that there are also
symlinked versions like `cowthink` that is printing a "thinking cow" :).
Moreover, `cowsay` has multiple modes, that we will discuss further.

On Enterprise Linux distributions package cowsay can be installed from the EPEL
repository . Installation is as straight forward as:

```bash
sudo yum install -y epel-release
sudo yum install -y cowsay
```

Sample cowsays:
```
Alex@Normandy:~$  cowsay help me!
 __________
< help me! >
 ----------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
The first customization is called a mod (or modifier). Depending on the version
of cowsay, different modes could be found. In the version that I'm using,
there are the following modifiers:

-  -d dead;
-  -b Borg mode;
-  -g greedy mode;
-  -p causes a state of paranoia to come over the cow;
-  -s makes the cow appear thoroughly stoned;
-  -t yields a tired cow;
-  -w is somewhat the opposite of -t, and initiates awired mode;
-  -y brings on the cow's youthful appearance.

There are also multiple images that can be used instead of a standard cow. They
are located in /usr/share/cowsay/ and have ".cow" file extension.


This short script will iterate through all extra cow ASCII pictures and print a
message with the name of the used image.  `-W` parameter sets the terminal
width to 100 characters.

```bash
#!/bin/bash

for i in /usr/share/cowsay/*.cow; do
    cowsay -W 100 -f "$i" "I'm using: $i"
done
```
Here are sample cowsays that use different fonts (images):

::: {class="smaller_font"}

```
Alex@Normandy:~$  cowsay -f kiss 'Sorry baby - I choose Bash Bushido over you!'
 _________________________________________
/ Sorry baby - I choose Bash Bushido over \
\ you!                                    /
 -----------------------------------------
     \
      \
             ,;;;;;;;,
            ;;;;;;;;;;;,
           ;;;;;'_____;'
           ;;;(/))))|((\
           _;;((((((|))))
          / |_\\\\\\\\\\\\
     .--~(  \ ~))))))))))))
    /     \  `\-(((((((((((\\
    |    | `\   ) |\       /|)
     |    |  `. _/  \_____/ |
      |    , `\~            /
       |    \  \           /
      | `.   `\|          /
      |   ~-   `\        /
       \____~._/~ -_,   (\
        |-----|\   \    ';;
       |      | :;;;'     \
      |  /    |            |
      |       |            |
```

```
Alex@Normandy:~$ cowsay -f surgery Where are my testicles, Summer?
 _________________________________
< Where are my testicles, Summer? >
 ---------------------------------
          \           \  / 
           \           \/  
               (__)    /\         
               (oo)   O  O        
               _\/_   //         
         *    (    ) //       
          \  (\\    //       
           \(  \\    )                              
            (   \\   )   /\                          
  ___[\______/^^^^^^^\__/) o-)__                     
 |\__[=======______//________)__\                    
 \|_______________//____________|                    
     |||      || //||     |||
     |||      || @.||     |||                        
      ||      \/  .\/      ||                        
                 . .                                 
                '.'.`                                

            COW-OPERATION                           

```
:::


### Cow say and Ansible
Ansible has a ~~stupid and irritating~~ brilliant 'easter egg' that print steps
of playbooks with `cowsay`. In order to turn it off add `nocows = 1` line to
`ansible.cfg` (in most systems `/etc/ansible/ansible.cfg`). It's even more
irritating when using Ansible properly (each repo has its own `ansible.cfg`
configuration file), because Ansible configuration is not layered (It's using a
single configuration file, and the `/etc/ansible/ansible.cfg` is last in
precedence) you have to put `nocows = 1` in each repository....


## lolcat
Lolcat is an image with funny cats. To make the book look long and full of
content, I put in two lolcat images found on the Internet.


![Sweet sugar. \label{Sweet Sugar.}](images/11-hacker-printing/milk_and_sugar.jpg)


![Cat poop. \label{Cat poop.}](images/11-hacker-printing/cat_poop.jpg)


Apart from being a funny image lolcat is also a command-line tool that prints
text in beautiful rainbow colors. Because lolcat is ruby based, we need `ruby`
and `gem` (RubyGems package manager command line tool). Installation on
Enterprise Linux:

```bash
sudo yum install rubygems -y
gem install lolcat
```

Because lolcat is printing coloured text only if the output is terminal it can
be aliased as cat :).

To invoke lolcat help use `-h` or `--help` flag. When it comes to controls you
can set, the duration, speed, colors options and much more. I personally enjoy
`-a` or `--animate` option, that prints one line then changes its colors for some
time. The second really interestin option is `-t` that enable support for 24-bit true
color in the terminal. 


There is excellent gist about True Color -
[https://gist.github.com/XVilka/8346728](https://gist.github.com/XVilka/8346728).
Even newer (made after 16-03-2019) lame Windows Putty supports it!

Whenever I use a new terminal emulator (I have tested a lot of them), I use
lolcat as true color tester :).


![This screen don't look good at the e-reader\label{This screen don't look good at the e-reader}](images/11-hacker-printing/lolcat.png)

## nms

No More Secret - is a command line tool that animates the "hacking" or
"decoding" process similar to the one presented in the Sneakers movie. This is one of
these cool programs that you use a few times (during a presentation or when you
are bored) and then ~~totally forget~~ use it occasionally.

Installation on EuroLinux (Enterprise Linux) 7:

```bash
sudo yum install -y @development # We need gcc, git and make
git clone https://github.com/bartobri/no-more-secrets.git
cd no-more-secrets
make all
sudo make install
```

Sample usage:

```
cat /etc/passwd | nms
(...) # output is animated - try it yourself.
```

When it comes to parameters, there is one flag that I found useful `-a` that is
auto-decrypt. In other words, animation starts without waiting for you to press
key. 


## Fortune teller
Whenever I'm testing something that requires a little (like literally short)
pseudorandom text input, I'm taking an advantage of `fortune`. Fortune is a
popular program first version of which came out with version 7 Unix (it's older
than dinosaurs). The version used by Enterprise Linux distributions is a little
bit different from the one used by BSD (that has, let's say, a rough history).
You can install **fortune-mod** package from EPEL repository.

```bash
sudo yum install -y epel-release
sudo yum install -y fortune-mod
```

Before invoking `fortune`, I would like to note a particular thing about
this program. As said before, fortune is an ancient program, its data is
residing in the `games` directory (`/usr/share/games` in Enterprise Linux 7). Yeah
games... like really, this is this "old-better" computing world where fortune
teller and fancy terminal printing (like `FIGlet`) were treated as "games". But
there is even more - `fortune`, and `figlet` are programs that actually use
the most hated section of the manual (section 6 - games), that many argue is
useless.

With this interesting but unnecessary knowledge, you can invoke the actual program:
```
-bash-4.2$ fortune
<DarthVadr> Kira: JOIN THE DARK SIDE, YOUNG ONE.
<kira> darth, I *am* the dark side.
```
You can choose from themed fortunes like art, education, goedel, linux,
startrek or the equally imaginative thing called love (I'm sooooo alone, even my
CPU has other CPUs!). The actual fortune database will/might differ, based on
your distribution and/or chosen implementation.

To get fortunes on Linux, use

```
-bash-4.2$ fortune linux
It's now the GNU Emacs of all terminal emulators.
   -- Linus Torvalds, regarding the fact that Linux started off as a terminal emulator
```

You can append other categories to make your favourite set of fortune.  For
example `fortune science art linux` will print only these three categories.

Besides the ability to choose a category, there are three parameters that might be useful.

- `s` - short ( < 160 chars)
- `l` - long ( >= 160 chars)
- `n [number]` - set a number from which characters will be considered long (default is 160) - short/long classificatory.



Another funny thing is that there is a bug in fortune that is described in a
manual, and probably treated as a "feature".  If you ask for a long fortune and
make the short/long classification too high, the fortune will be in a
never-ending loop, so you have to kill it manually.


```bash
# Infinite fortune search
fortune -l -n 600000
```

\pagebreak
