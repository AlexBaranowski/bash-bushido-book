# Bash Bushido Book

This repository contains Bash Bushido Book. You can download it for free from
[GitHub](https://github.com/AlexBaranowski/bash-bushido-book/releases). You can also
purchase for symbolic dolar from [Amazon Kindle store](https://www.amazon.com/dp/B082Z65LCD)


You can read this book on-line here: [GH Pages](https://alexbaranowski.github.io/bash-bushido-book/)

You can read original polish version here: [EuroLinux blog](https://pl.euro-linux.com/blog/tag/s-bash-bushido/)

## Erratas/Bugs/Ideas

Feel free to create issue :).

## About book

Bash Bushido is a book dedicated to Linux/Unix/Windows Subsystem for Linux
(WSL) that have about 150 tricks, tips and pointers about working in and with a
console. All of it is mixed with the author's specific sense of humour and a
bunch of anecdotes. The primary audience of the book are SysAdmins/DevOps
engineers.

## Building and Requirements

Building epub and html formats requires:

- `make`
- `pandoc` 

```
make html
make eupb
```


Building mobi additionally requires

- `kindlegen` - because Amazon removed it from websites, and EULA forbids redistribution I cannot include it, but you can download it from webarchive (https://web.archive.org/web/20150407075108/http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz)

```
make mobi
```

Building PDF requires

- `google-chrome`
- `python 3`

```
make pdf
```

I'm using the chrome printer scripts that I made - https://github.com/AlexBaranowski/chrome-print-page-python or FireFox page printing
