# Calendars
In this chapter, we discuss an exceptionally lightweight topic - how to use
calendars from the command line. Calendars are ultra-important tools to keep
track of the upcoming events (like birthdays of loved ones or your favourite
conferences). According to some productivity practices, you should keep your
schedule as full as possible. And in that case, a good calendar client is a
must-have. 

## Basic calendar
The most basic calendar in the command line environment is the `cal`endar. The
`cal` program is a part of the `util-linux` package. In most Linux distros,
it's installed even on the most minimalistic (cloud) images. Invoking `cal` without
an argument prints the current month layout.

```
[Alex@localhost ~]$  cal
      July 2017     
Su Mo Tu We Th Fr Sa
 1  2  3  4  5  6  7
 8  9 10 11 12 13 14
15 16 17 18 19 20 21
22 23 24 25 26 27 28
29 30 31
```

`Cal` can also be asked about a particular date, in this case my friend's birthday.

```
[Alex@localhost ~]$ cal 13 5 1994
      July 1994     
Su Mo Tu We Th Fr Sa
                1  2
 3  4  5  6  7  8  9
10 11 12 13 14 15 16
17 18 19 20 21 22 23
24 25 26 27 28 29 30
31
```

There is also a useful option `-3` that will print the previous, the current and the next
month's dates.

```
[Alex@localhost ~]$ cal -3
      July 2018 
Su Mo Tu We Th Fr Sa
 1  2  3  4  5  6  7 
 8  9 10 11 12 13 14 
15 16 17 18 19 20 21 
22 23 24 25 26 27 28 
29 30 31 
      August 2018 
Su Mo Tu We Th Fr Sa  
          1  2  3  4  
 5  6  7  8  9 10 11 
12 13 14 15 16 17 18  
19 20 21 22 23 24 25  
26 27 28 29 30 31

September 2018    
... (output truncated)
```

This option can be combined with any given date.

```
[Alex@localhost ~]$ cal -3 1 7 1994
      June 1994
Su Mo Tu We Th Fr Sa
          1  2  3  4
 5  6  7  8  9 10 11
12 13 14 15 16 17 18
19 20 21 22 23 24 25
26 27 28 29 30

      July 1994               
Su Mo Tu We Th Fr Sa
                1  2
 3  4  5  6  7  8  9
10 11 12 13 14 15 16
17 18 19 20 21 22 23
24 25 26 27 28 29 30
31

August 1994 
... (output truncated)
```

To print the whole year, type it as the first and only argument.

```
[Alex@Normandy ~]$ cal 2020
                               2020                               

       January       
Su Mo Tu We Th Fr Sa 
          1  2  3  4 
 5  6  7  8  9 10 11 
12 13 14 15 16 17 18 
19 20 21 22 23 24 25 
26 27 28 29 30 31    
... (output truncated)
```

Note: United States ~~of the LULZ~~ decided that it's a good idea to use imperial
units, "logical" date format (see picture below) and what is annoying in our
case - have a week start set to Sunday. To overcome this cringe use this
alias:

```
[Alex@SpaceShip ~]$  echo "alias cal="cal -m" >> ~/.bashrc
```

![USA vs Europe date format logic \label{USA vs Europe date format logic}](images/05-calendars/usa-vs-europe.jpg)

## Manage Google Calendar from the command line

One of the most popular Internet calendar services is the one provided by Google
with the extremely creative name - Google Calendar. By the way, when the company image is
failing, names like "$COMPANY_NAME $PRODUCT" also start to sound bad. But I digress, you
can view, edit, delete, and even import events from other sources without
leaving the command line! All of this is possible with the `gcalcli` program. The
name is easy to remember `Google CALendar Command Line Interface` -
`gcalcli`.


Github project page: https://github.com/insanum/gcalcli


To install it you need the `pip` - the Python package manager. In case of
Enterprise Linux it can be   be installed from the EPEL repository.

```
sudo pip install gcalcli vobject parsedatetime
```

After installation, the `gcalcli` can be invoked with `list` argument (a
subcommand). If calendar is not configured, it will start the browser to
configure access to a Google calendar.

```
[Alex@SpaceShip el7]$ gcalcli list
```

After this straightforward procedure, the `list` should list an actual calendar.

```
[Alex@SpaceShip el7]$ gcalcli list
 Access  Title
 ------  -----
  owner  my.gmail.mail@gmail.com
 reader  Contacts
...
```

To list all calendar events for the week:

```
[Alex@SpaceShip el7]$ gcalcli calw 
```

To list the week for the particular calendar (my.gmail.mail@gmail.com) combine
`calw` with `--calendar` option.

```
[Alex@SpaceShip el7]$ gcalcli calw --calendar my.gmail.mail@gmail.com
```
To list the whole month, replace `w`eek with `m`onth in `cal` subcommand (I feel relaxed looking at the output of this command)

```
[Alex@SpaceShip el7]$ gcalcli calm 
```

To list holidays, you might use the Holidays calendar.

```
[Alex@SpaceShip el7]$ gcalcli calm --calendar Holidays
```

Making an event is dead simple because it is an interactive form :).

```
[Alex@SpaceShip el7]$ gcalcli add 
Title: Bash Bushido Grammarly check
Location: Cracow
When: 10/10/2018 18:00
Duration (mins): 120
Description: BB check
Enter a valid reminder or '.' to end: 30
Enter a valid reminder or '.' to end: .
```
With a lot of events in the calendar, you might want to search for the chosen
event with the `search` subcommand.

```
[Alex@SpaceShip el7_builder]$ gcalcli search bash

2018-10-10   6:00pm  Bash Bushido Grammarly check
```

The event deletion functionality searches for matching events first and then
asks for removal confirmation.

```
[Alex@SpaceShip el7_builder]$ gcalcli delete bash

2018-10-10   6:00pm  Bash Bushido Grammarly check
Delete? [N]o [y]es [q]uit: y
Deleted!
```

`gcali` has embedded help invoked with `-h` or `--help`
parameter. By the way, any option that starts with `h` will work, so
`--hasjxcvzvwW` also yields a help message. The official GitHub repository's README.md is
also a good source of information about this great program.

## Other projects
The other projects that can be used to manage calendars that support the CalDAV
protocol are:

- `khal` - The Khal project requires `vdirsyncer` to sync the calendars.
  Because of that, the setup might be tedious (`vdirsyncer` is a vast project
  with an extensive documentation). 
- `calendar-cli` - this one is much easier to setup.

Unfortunately, because your calendar provider might implement CalDAV the
"right" (bite my shiny metal ass) way, these projects might not work correctly
with all calendar services/providers. It happened in my case. Therefore, I
would love to say that there are projects that allow manipulating calendars
with an excellent command-line interface. However, I won't recommend and
elaborate on any of them as they didn't work as expected with my "enterprise"
Indie calendar provider.

![Struggle is real \label{Struggle is real}](images/05-calendars/first_world_problem_meme.jpg)

\pagebreak

