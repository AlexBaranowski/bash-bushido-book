# Bash Bushido - Linux Tricks and Tips

THIS BOOK MAY CONTAIN EXPLICIT LANGUAGE AND MEMES, READ AT YOUR OWN RISK !!!11

## Trademarks
Firefox is a registered trademark of the Mozilla Foundation.  
ImageMagick is a registered trademark of ImageMagick Studio LLC.  
Linux® is a registered trademark of Linus Torvalds in the U.S. and other countries.  
Mac and OS X are trademarks of Apple Inc., registered in the U.S. and other countries.  
Open Source is a registered certification mark of the Open Source Initiative.  
Oracle and Oracle Linux are trademarks or registered trademarks of Oracle Corporation and/or its affiliates in the United States and other countries.  
UNIX is a registered trademark of The Open Group.  
Windows is a registered trademark of Microsoft Corporation in the United States and other countries.  
JetBrains, PyCharm is a registered trademark of JetBrains.  
EuroLinux is a registered trademark of EuroLinux.  
All other product names mentioned herein are trademarks of their respective owners.  

## About the Author
I've written this book, so inserting "Abouth the Author" fell a little - well..

I'm a Linux guy, Red Hat Engineer with a bachelor's degree in Computer Science
currently working at EuroLinux, which is a small, self-funded
company that surprisingly (look at the name again) makes Linux-related
stuff. As a freelancer, I've worked for multiple smaller but also a few more
prominent companies. When it comes to teaching/tutoring, I had the pleasure to
work for a company that is making programming/testing bootstrap courses. I also
worked as the instructor for some of the EuroLinux courses. The current state
of my career (do not waste your time looking it up, it’s boring) can be found on my
LinkedIn profile - linkedin.com/in/alex-baranowski/ .

## Erratum
Any problems, suggestions and ~~bugs~~ errata are welcome at errata
repository https://github.com/AlexBaranowski/bash-bushido-errata, on LinkedIn
messages or my e-mail aleksander . baranowski at yahoo dot pl

All accepted errata will be published and free to download for everyone (GitHub repository).

## Preface

I had the pleasure to write technical blog posts as
part of EuroLinux's marketing strategy. That is when I found out that our subscribers and
visitors love shorter forms with lots of titbits. After some practice, I
started to produce quite clickable and (what is even more important) readable
articles.

Inspired by the Command Line Kung-Fu book, I decided to write a Bash Bushido - a
series of articles about Bash. To be honest, we planned that after 2 or 3
articles, the series will end. However, as it was quite successful
and there was rich material to explore, we kept going. Unfortunately for
international audiences, the series was written in Polish. If you are still
interested, you can find all the articles on EuroLinux blog
https://pl.euro-linux.com.

Then, one of my friends asked me if I could make a video course with him and
publish it on some popular e-learning platforms. I decided to make the pilot
project "Bash Bushido Video Course". After some time, many mistakes, and awful
videos, we realized that making a video course without a good script is a
horrible idea. The book that you are reading was initially made for the video
course :) and ended up as a standalone creation. If this book gains some
popularity (at least 1000 sold copies in the first year :), I will make the said
video course. Otherwise, it's probably not worth the only resource that I don't
have a surplus of - time. 

I would like to stress that some chapters have a lot of my personal
**opinions**. Don't treat them as a source of absolute truth. For example, the
first thing that I wrote about is touch-typing, that by far (**typical
opinion**) is one of the most important skills for any proficient computer
user. I tried to put some humour in this book some of which is sarcastic and
might offended you. If you are offended don't worry - this is natural and
should not interfere with your life functions. In the case of emergency, you
can delete, burn or depending on the buying platform even return the book
(please don't, I need the monies).

![Meme1 \label{Meme1}](images/00/susan.png)

Now let me introduce the minimalistic glossary that will be used throughout the
book:   

- `command line`, `terminal`, `console` are used interchangeably - because you
  can type the command in the terminal, to the console or on the command line.
- The same goes for  `argument`, `flag`, `option`. Technically there is little
  difference (flags are booleans, the options might take one or multiple
  variables) - but who cares?



Bash Bushido is my first (self-published, but still) book. I want to dedicate
it to someone who was always there for me – my Mom.


## Our Bushido
Well, I'm not a Japanese expert (watching ~~chinese~~ cartoons won't make you one :)), but according to one of the most trusted sources on Internet (Wikipedia)[yeah teachers, I wrote the book, and I am saying that Wikipedia might be a good source!], Bushido means _Way of the warrior_. In times of rockstar developers and ninja testers, being just a regular warrior might seem a little boring. But I see it quite differently - administration, automation, keeping infrastructure safe and up-to-date is hard work that requires a lot of talent. Sometimes little tweaks in Linux kernel options can save thousands of dollars, one wrong config that gives too broad access might make a company go bankrupt and put users/clients data at risk. In case of infrastructure, you need a warrior, someone who can spend countless hours debugging, testing, tweaking and automating. Lastly, Bash Bushido sounds excellent is meaningful and original.


![Meme2 \label{Meme2}](images/00/rockstar.jpg)

## Installation problems
Well, there are a lot of Linux distributions. You know, like, about few
hundreds at the least. From the top of my head, I can list more than 10 package
managers, plus one that's a must for Apple users. The installation steps for
each of the popular system/package managers sometimes would be longer than
actual trick or tip discussed. 

Because of that, I only present the installation procedure for Enterprise Linux
version 7.X (CentOS, RHEL, Scientific Linux, Oracle, EuroLinux) these
distributions have a long lifespan and won't be obsolete in next 2 or 3 years.

\pagebreak

