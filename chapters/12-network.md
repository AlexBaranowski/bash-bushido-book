# Network
In this chapter, we are going to explore network related tools, programs and
tricks. First off there are tricks related to SSH. It is one of the most popular,
heavy-used and battle-tested commands/services. Then we have some `netcat`
tricks. Netcat is sometimes called Swiss Army Knife of Hacking Tools/Network
Tools. Then you will learn how to scan a network and check the open ports.
There are also other goodies!

For a great start - here is one of my favourite XKDC comic:

![XKDC Devotion to Duty Comic\label{XKDC Devotion to Duty Comic}](images/12-network/devotion_to_duty.png)

## SSHFS - SSH File System
Whenever there is a need to edit files that are on a remote server that has
only ssh access, the following pattern occurs:

1. Files are copied, locally edited, then copied back.
2. Files are remotely edited.

The first one is cumbersome, especially if you are doing live patching (it's an
awkward experience that I don't recommend). The second one is good only if the
necessary tools are available on the remote server. But what if there is
another, better, possibility that takes what is best from both worlds? 


Well, it's possible! You can mount remote files locally with sshfs, that
surprisingly leverages SSH. 


The first and most important benefit is that you can edit live on a remote
server, and still use your favourite programs/tools that are on your computer.
The second benefit of sshfs is that it's based on SSH File Transfer Protocol
that is supported on all modern ssh clients and servers. `sshfs` does not
require new software, permission management and open ports on firewalls.
Moreover, SSH is one of the most battle-tested and secure protocols, so you can
safely use it even on public networks.

To install `sshfs` on Enterprise Linux systems, you should install `fuse-sshfs`
package from the EPEL repository:

```
sudo yum install -y epel-release
sudo yum install -y fuse-sshfs
```


`FUSE` is an abbreviation of Filesystem in Userspace. The `sshfs` is FUSE based,
so it doesn't require root privileges to manage mounts. Example `sshfs`:


```
[Alex@SpaceShip ~]$ sshfs Alex@webserver1:/var/www/static /home/Alex/static
```


It will allow editing static content from webserver1 on the local machine. To
unmount the FUSE-based mount, you can use the well-known:


```
umount /home/Alex/static
``` 


But it requires root privileges! If your user has sudo capability, you can use
the `sudo !!` trick.  But, the better solution is to use `fusermount` command with
`-u` like `u`nmount flag:

```
[Alex@SpaceShip ~]$ fusermount -u /home/Alex/static
```

It will unmount the previously mounted sshfs.

I won't recommend using sshfs as an always mounted production network file
system, but it's perfect for small changes, write/reads. The potential problem
with SSHFS are I/O errors, but they should not corrupt the filesystem ;).

### Allow others to use our sshfs (and other FUSE based) mount

Sometimes, sharing FUSE based resources with other users can save us a lot of
fuss. To do so, you have to edit `/etc/fuse.conf` (uncomment or add
`user_allow_other` line. Then pass `allow_other` option to the mount command.
There is no service that have to be restarted because `/etc/fuse.conf` is read each time the
FUSE-based resource is mounted.

Previous example with `sshfs` that makes shared mount:

```
sshfs Alex@webserver1:/var/www/static /mnt/static -o allow_other
```

## SSH with the X server
Sometimes you want to use a graphical tool from a host that only has the ssh
enabled (99.9% of prod servers). For example, adding the next disk to a virtual machine is
much easier from a hypervisor graphical console (ex. VirtualBox). In that
case, you can easily set up X11 forwarding with ssh. The `-X`  option must you
use (Yoda voice). A system from which you will forward GUI programs needs
proper libraries installed, but if there are graphical tools, it's quite likely
that it already has them.


The listening below will start `firefox` on the remote host:
```
[Alex@SpaceShip ~]$ ssh -X myuser@remote
[myuser@remote]$ firefox
```


There are some security considerations. According to Red Hat 7 Security Guide,
X11 forwarding is not recommended for an unknown host. Another important note
is that there is an X11 replacement that is under massive development -
Wayland. Wayland can somehow forward in X11 style with Xwayland, but some users
claim that it's buggy.


## Port forwarding with ssh

In many environments, there is a host called "jump server", jump hosts or
jumpbox that is used to access computers in another security zone (like company
LAN). Sometimes you need to get a service (like a web server) from this zone.
In cases like that, the SSH port forwarding, also called SSH tunnelling, might
come in handy.



There are two types of forwarding. The first one is the local forwarding.
Because it's much easier to get it with an example look at the following
command:

```
ssh -L 9999:webserver:443 root@jumphost
```

It will open the local port 9999. When the user opens a browser (or uses
anything that can use https like curl or wget) with the address
`https://localhost:9999`, the connection will be transferred to jumphost, that
will ask the webserver for content.

Another way is the remote port forwarding, it is the same but reverse :). Look
at the following example:

```
ssh -R 8080:localhost:80 root@jumphost
```

It will allow anyone that has access to jumphost asks about
`http://jumphost:8080` to connect to the localhost on port 80.

Please note that examples above use web servers, but any other protocol that
uses TCP will work. There is also a great answer on superuser.com how to
achieve port forwarding for UDP services. You can read it here
[https://superuser.com/questions/53103/udp-traffic-through-ssh-tunnel](https://superuser.com/questions/53103/udp-traffic-through-ssh-tunnel).

When it comes to ssh tunnelling, there are some security considerations -
because it's possible to transfer anything that jump host has access to, it
might be wise to add some extra security. SSH tunnelling might be used to make
backdoors, so proper hardened jump host SSH  daemon configuration should
prevent it.

But there are also benefits of using port forwarding. For example, when you
have an insecure web application that is using HTTP instead of HTTPS, then you
can locally forward the connection to the server itself: 


```
ssh -L 9999:localhost:80 root@webserver
```

Now your connection between the web server and your host are SSH grade
encrypted!


SSH port forwarding can also be used when your idiotic boss orders the blocking
of some significant websites like facebook.com or ilovemyself.my. Sometimes
there is an even more natural way to bypass them, but ssh forwarding with some
of your external servers (every self-respecting admin should have at least one
private VPN) will work.

## Add SSH host key to .ssh/known_host if they don't exist

One of the problems that you may encounter during scripting is that the host key is not in the
~/.ssh/known_hosts file. In that case, scripts that are not interactive won't
work. But there is a small utility called `ssh-keyscan` that can be used to get
the ssh keys provided by the host. For the previously mentioned problem, look at
the following solution:


```
TO_HOST=this.is.my.host.com
[ $(grep  -cim1 "$TO_HOST" ~/.ssh/known_hosts) -gt 0 ] || ssh-keyscan "$TO_HOST" | tee -a  ~/.ssh/known_hosts 
# Now the ssh commands can be invoked.
```


`-cim1` means `--count` `--ignore-case` and `--max-count=1`, so it returns 1 or
0. If the test that is in `[` `]` fails, then the second part that leverages
ssh-keyscan with a tee in append (`-a`) mode runs.


## Instant directory content sharing with Python

Sometimes you have to share files with random people. One of the most
straightforward solutions is to share the content of a directory on a web
server. To achieve this, we can invoke the standard Python module. It's like
having a minimalistic web server that serves static content, always with you
:)!


For Python2, use:

```
python2 -m SimpleHTTPServer
```


For Python3, use:

```
python3 -m http.server
```


Because Python 2 will hit EOL soon, I recommend using Python 3. You can
also change the port on which our webserver will listen (default 8000):

```
python2 -m SimpleHTTPServer 8080 # port 8080 on 0.0.0.0
python3 -m http.server 8080 # port 8080 on 0.0.0.0
```
Of course - 0.0.0.0 means all interfaces.



In Python 3, we can also choose on which interface our server should listen.

```
python3 -m http.server 8080 -b 10.10.1.123 # port 8080 on 10.10.1.123
```

There might be small complications:

- If you want to use a standard port like 80, you need to have root privileges,
  not privileged users can use ports that are higher than 1024. In that case,
  ports like 8080 are not formally standardized but frequently used. 
- The other complication is the firewall - if it's enabled the proper
  configuration has to be done. Also, remember to clean-up these temporary
  firewall rules.


## Scan ports with Nmap

Nmap is a security scanner that allows finding open ports on the host, it has
lots of specially crafted packages, that helps to determine not only ports,
services but sometimes service flavour (vendor and version) or even host
OS. In most countries, although no law explicitly forbids port scanning, doing it
without permission can be detected as a potential attack and drag you into
legal hell. It's because port scanning is used/might be used as one of the
first phases of a cyber-attack.


Before performing a network scan, you should get a written consent that allows
you to do it. There is an excellent article on nmap.org -
[https://nmap.org/book/legal-issues.html](https://nmap.org/book/legal-issues.html)
that gives a real-life example of what can potentially happen.

Nevertheless, after being warned, the nmap is frequently used by users to scan their own
networks. It's so popular that most distributions have it in their repo.
Installing it on EL7 is as simple as:

```
sudo yum install -y nmap
```


Now you can start scanning your network :). I personally use it to determine open ports on hosts that are "forgotten" and find IP addresses of printers.


To scan for TCP open ports, use:

```
nmap -sT HOST
```


To scan for UPD open ports, use:

```
nmap -sU HOST
```


To enable OS detection, use:

```
nmap -O --osscan-guess HOST
```

The most commonly used options is `-A` (like all) with `-T4`. The `-T`
option sets the timing, there is a possibility to also use names. The values are
from 0 to 5, or from paranoid (0) to insane (5). The 4 is also called
aggressive. `-A` options enable things like OS detection, version detection,
scripts scanning and traceroute. As always more can be found in the nmap
manual.

```
nmap -A -T4 HOST
```

To scan a whole network (local network in your workplace) just choose whichever
IP and add a mask (nmap will automatically convert it to a network).
```
nmap -A -T insane 192.168.121.111/24 
```

To get more information about nmap, I recommend the official website -
nmap.org, there is a separate book section. The author of Nmap - Gordon
“Fyodor” Lyon, wrote the book half of which is available online -
https://nmap.org/book/toc.html. If you are really interested in network
scanning, you might consider buying the official book; in way you support
the development and show the gratitude towards the author.


Bonus meme describing the Bash Bushido author.
![Nmap hacker Meme\label{Nmap hackerman meme}](images/12-network/hackerman.jpg)

## Monitor traffic with traf-ng
There are multiple tools to monitor traffic, the most well-known is Wireshark,
but it's a GUI program. There is a tshark project that allows you to get some
of the Wireshark capabilities into CLI, but Wireshark is one of these rare
programs where GUI is, and will be, more potent than CLI.

But don't lose hope! There is a tool to monitor the network from CLI, its name
is `iptraf` and because it's a rewritten version it has `-ng` at the end. It's
not as robust and powerful as Wireshark, but it allows monitoring the most
basic network functions, statistics, load, etc. and in many cases it is enough.

The `iptraf-ng` is a standard package at Enterprise Linux distribution to
install it, you might use
```
sudo yum install -y iptraf-ng
```
The iptraf-ng requires superuser permissions. Because it's the interactive
program, it doesn't require additional arguments to startup.

![iptraf menu\label{iptraf menu}](images/12-network/iptraf-ng1.png)


IPtraf-ng is self-explanatory with great discoverability. So, I decided to
provide just 2 screenshots that show some capabilities of the iptraf program.


To watch the hosts that our computer connects to you can choose "IP traffic
monitor":

![iptraf IP traffic monitor\label{iptraf IP traffic monitor}](images/12-network/iptraf-ng2.png)


To watch detailed interface statistics choose "Detailed interface statistics"
(WoW, rLy?):

![iptraf IP traffic monitor\label{iptraf IP traffic monitor}](images/12-network/iptraf-ng3.png)


As said before, the program is self-explanatory, but there is little curio
about this program. It leverages signals in a non-standard manner. So according
to the manual, there are two signals:
```
SIGNALS
    SIGUSR1 - rotates log files while program is running
    SIGUSR2 - terminates an IPTraf process running in the background.
```


Both are defined in the POSIX standard as signals that a programmer (user)
can define. In this case, SIGUSR2 can be used to terminate the process. To
check it out, you can use commands from the listening below:


``` bash
> sudo iptraf-ng -g -B
> pgrep iptraf-ng
31431
> sudo kill -s 12 31431
> pgrep iptraf-ng
>
```


## Network LOAD - nload
nload is the minimalistic program that shows, well, - the network load. There are
options like period, interval or unit, but there is not much to see. As always,
I recommend reading the manual. Even so basic program like nload has some
configuration that can be set and saved. `F2` invoke configuration window and
`F5` save the configuration to a file.

`nload` is not part of Enterprise Linux distributions, but fortunately, it's in
EPEL repository, so installation is straightforward as:
```
sudo yum install -y epel-release
sudo yum install -y nload
```
After installation, nload can be invoked without any parameters. To change the
currently inspected interface, use arrows. And that all :).


Sample statistics for my wireless card:

![nload label{nload}](images/12-network/nload.png)

## ss - another utility to investigate sockets

`ss` is a utility to get information about the sockets. It's really similar to
`netstat`, but it's newer and much faster. Still, not all `netstat`
functionalities are fully implemented in `ss`, some of the old `netstat`
commands are represented in `ip` command. 

To list **all** connections in your system you might use `ss` without any
parameter
```
Alex@Normandy$ ss
Netid  State      Recv-Q Send-Q  Local Address:Port    Peer Address:Port 
u_str  ESTAB      0      0       /run/systemd/journal/stdout 645671 * 642860               
u_str  ESTAB      0      0       * 89062               * 93582                
u_str  ESTAB      0      0       /run/dbus/system_bus_socket 79026 * 72610                
u_str  ESTAB      0      0       @/tmp/dbus-EEfUpzdsKr 64988   * 65714 
```


To list the TCP connection, use `-t` option

```
Alex@Normandy$ ss -t
State      Recv-Q Send-Q Local Address:Port                 Peer Address:Port                
ESTAB      0      0      192.168.0.12:40630                 94.23.88.39:https 
```

Similarly, to list the UDP connections, you might use `-u`. When it comes to
Unix socket use  `-x`.


By default, the `ss` report only established connections, to enable **all**
connections, use `-a` option.

To get which process is using the particular socket the `-p` parameter should
be used.


```
Alex@Normandy$ ss -tp
State      Recv-Q Send-Q Local Address:Port                 Peer Address:Port                
ESTAB      0      0      192.168.0.12:40134                172.217.16.3:http                  users:(("firefox",pid=5778,fd=165))
```


`ss` can try to resolve the DNS name of a host. The option that enables it, is `-r`.
```
Alex@Normandy$ ss -tpr
ESTAB      0      0          Normandy:49918                stackoverflow.com:https                 users:(("firefox",pid=5778,fd=116))
```

To check the listening sockets, the `-l` option can be used, it's useful to
check what services are running on the current host, and what are the addresses
of these services. It's commonly used with `-n` that won't show the service
name but the numeric value of the port, for example instead of https `ss` shows
443. Note that in most cases, to get more specific information about the
process, the superuser privileges are required.


This example below shows the same line for sshd with and without root privileges:

```
Alex@Normandy$ ss -nltp
State       Recv-Q Send-Q       Local Address:Port      Peer Address:Port
LISTEN     0      128          *:22                       *:*                  
LISTEN     0      128         :::22                      :::*  
```


```
sudo ss -nltp
State       Recv-Q Send-Q       Local Address:Port      Peer Address:Port
LISTEN     0      128          *:22                       *:*      users:(("sshd",pid=7411,fd=3))
LISTEN     0      128         :::22                      :::*      users:(("sshd",pid=7411,fd=4))
```

SS can be also used to get some simple statistics about sockets:

```
Alex@Normandy$ ss -s 
Total: 1077 (kernel 0)
TCP:   13 (estab 3, closed 1, orphaned 0, synrecv 0, timewait 0/0), ports 0

Transport Total     IP        IPv6
*     0         -         -        
RAW   1         0         1        
UDP   11        8         3        
TCP   12        8         4        
INET      24        16        8        
FRAG      0         0    0 
```


The other useful functionality of ss is ability to show SELinux context. Like in
most command line utilities, the option responsible for printing SELlinux related
information is `-Z`. The following example has condensed output for IPv4 sshd:

```
sudo ss -ltZ
State     Recv-Q Send-Q  Local Address:Port  Peer  Address:Port
LISTEN    0      128     *:ssh               *:*   users:(("sshd",pid=7411,proc_ctx=system_u:system_r:sshd_t:s0-s0:c0.c1023,fd=3))
```


To display only IPv4 connection the `-4` option must be set. The similar
option for IPv6 is obviously `-6`.

`ss` can display TCP timers. To enable it use `-o` flag. For example:


```
Alex@Normandy$ ss -etro
State      Recv-Q Send-Q Local Address:Port                 Peer Address:Port                
ESTAB      0      0      Normandy:49918                stackoverflow.com:https                 timer:(keepalive,9min22sec,0)
```

SS also has the ability to filter the connections based on their state, port
number, and host.

```
ss -nt dst 10.10.1.100 # tcp connection to host 10.10.1.100
ss -nt dst 10.10.1.100/24 # tcp connection to network 10.10.1.100/24
ss -nt dport = :80 # Port number must be used with ":" think about it as part of host:port combination with empty host
# The filter can be put together 
ss -nt '( dport = :80 or dport = :443 or dport =: 443  )'
```

As always, more can be found in the manual, in this case, it's the section 8 -
system administration commands, `man 8 ss`.

## Ncat (Netcat)
Ncat is a simple yet extremely powerful and popular tool to read and write
from/to TCP, UPD, and UNIX socket connections. In many cases, it's a backend
that is frequently middle layer in scripts, and other programs. 

The Ncat is the reimplementation of popular netcat, both commands have the same
aberration (nc). The most popular implementation implementation is one from
the nmap project, it combines the most prominent options from other netcat's.
Installation on EL7 is as simple as:


```
sudo yum install -y nmap-ncat
```

After installation, there is a `ncat` command and the symbolic link to it `nc`.

### Connect to service with netcat
Netcat might be used to connect to any specific port/host combination.

To connect to host with TCP, use:

```
ncat HOST PORT
```


To connect to host with UPD, use:
```
nc -u HOST PORT
```

To connect to a Unix socket use:
```
nc -U /path/to/my.socket
```

To dump session to a file the `-o` option can be used.
```
ncat -o FILENAME HOST PORT
```

The first application of ncat is to determine if a specific port is open (it's
one of the first things to check when a service doesn't work as expected).
Usually, NMap is better suited for this job, but ncat package is about 40 times
smaller, and nc is loved because of its minimalistic nature. Another usage of
netcat is sending commands, files or payload. The payload is a technical term
that can mean the actually delivered message (when you send the message to a
server, there is a lot of metadata - like hops, source, destination, that are
necessary to deliver a package through a network), the second meaning is the
harmful code that is delivered by an exploit. Payload term is frequently used by
pentesters.

Some "payload" payload.txt (HTTP request) to sample Heroku application.
```
GET / HTTP/1.0
Host: example.herokuapp.com

```


Because RFC 2616 (Hypertext Transfer Protocol -- HTTP/1.1) defines that
linebreak is of `CRLF` type (more information about this problem can be found
at [dos2unix unix2dos](## dos2unix unix2dos) then before piping the HTTP
request that is written in the file, the unix2dos should be used.

```
$ unix2dos payload.txt
```


After this operation cat piped to netcat works like a charm.

```
cat payload.txt | nc example.herokuapp.com 80
```

### Ncat transfer files 
Ncat is frequently used to transfer the files over the network. Because I
prefer self-contained examples, the localhost is used, but in a normal situation,
there is a different host. 


To start ncat in the listening mode use the `-l` option:

```
nc -l -p 6969 > output_file
```


To transfer the file, you might use the file redirection (`<`), or pipe:

```
nc localhost 6969 < file.txt
```


After these operations, the output_file should be identical to file.txt. Note
that in a normal situation, the firewall rules should block the connection between
hosts.

### Ncat Transfer the whole directory
Ncat can quickly transfer directory (and subdirectories). On the one end, the
tar output is used as input to ncat, and on the second session, the ncat output
is input for tar. You might also use compression (in my case it is bzip2).
 
On the receiving host use:
```
nc -l 4242 | tar xvzf -
```

Then on the sending host use:
```
tar cvzf - /path/to/directory |  nc HOST 4242 
```

## Telnet check if port works
Telnet is mostly a legacy, not encrypted way to communicate between computers.
It was used to remotely control web servers thousands of years ago (if you used
telnet frequently, don't look at your metric -  you are probably old!). Because
telnet passes the data in clear-text, it's not advisable to use it on public
networks, but to be honest, also not on any network/system. But because telnet
is text-based, it might also be used to test some services.

For example, to test if web server works, you might do the following:
```
[Alex@SpaceShip ~]$ telnet 192.168.121.170 80
Trying 192.168.121.170...
Connected to 192.168.121.170.
Escape character is '^]'.
GET /
Never gonna give you up,
Never gonna let you down,
Never gonna run around and desert you,
Never gonna make you cry, Never gonna say goodbye,
Never gonna tell a lie and hurt you
Connection closed by foreign host
```
In that example, we use an HTTP defined method "GET" on a path "/" which is the
root of the web server.

Telnet can also check if it is possible to connect to the specified port (5432 [Postgres]):
``` 
[Alex@SpaceShip ~]$ telnet 192.168.121.170 5432
Trying 192.168.121.170...
telnet: connect to address 192.168.121.170: Connection refused
```

After starting the Postgresql server that listens on 5432, the same command will print
```
telnet 192.168.121.170 5432
Trying 192.168.121.170...
Connected to 192.168.121.170.
Escape character is '^]'.
```

## telnet Star Wars
This trick is one of the simplest in whole Bash Bushido. With telnet installed
you can watch the part of Star Wars Episode IV:


```
telnet towel.blinkenlights.nl
```

If your network supports the IPv6, you might get the better IPv6 version with:
```
telnet -6 towel.blinkenlights.nl
```

I didn't test it, so if it's not working you might make an issue on GitHub repo
- https://github.com/AlexBaranowski/bash-bushido-errata .

To exit telnet, use `ctrl` + `]` (exit character), then `ENTER`, after that you
should get `telnet>` prompt where you can send EOF (`ctrl` +  `d`) that closes
a session.


As my friend said about this amazing telnet movie - "This is a typical Open
Source project - it's great, fun to use and watch, but also half-finished". And
with this pure gold quote, let's finish this chapter.

\pagebreak

