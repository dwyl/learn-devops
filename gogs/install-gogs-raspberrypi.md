# Install Gogs on Raspberry Pi

This guide follows and expands 
on the official **`Gogs`** 
installation guide:
https://gogs.io/docs/installation ...

Our objective is to capture _all_ the steps
required so that _anyone_ can follow along
and replicate our _exact_ result.


## Prerequisites

Ensure you have a working Raspberry Pi running 
Ubuntu:
https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview


> We are using Ubuntu because it's _ubiquitous_
> and will help with deployment to Cloud/VPS later
> so getting it working on the Pi is a good first step. ✅


### **`Postgres`**

The default DB for **`Gogs`** 
is be **`MySQL`**,
but we prefer **`Postgres`**. 

Install Postgres on Ubuntu:
[learn-postgresql#ubuntu](https://github.com/dwyl/learn-postgresql#ubuntu)

```sh
sudo apt-get install -y postgresql postgresql-contrib postgresql-client libpq-dev
```
<br />

### `git`

Install `git` if not already installed in your Ubuntu instance:

```sh
sudo apt update && sudo apt upgrade
sudo apt-get install -y git
```

If you see something similar to the following:

```sh
git is already the newest version (1:2.25.1-1ubuntu3.2).
```

You already have `git` and can proceed.

Create a new user called `git` to run `gogs`:

```sh
sudo adduser --disabled-login --gecos 'Gogs' git
```

<br />

### `Go`s

We are going to compile `gogs` from source
so we need the `Golang` compiler:

```sh
sudo su - git
mkdir $HOME/local && cd $_
```

> **Tip**: Check https://go.dev/dl/ 
> for the latest version of `Go` 
before running the next command.

Download Go:

```sh
wget https://storage.googleapis.com/golang/go1.18.linux-arm64.tar.gz
```

This will take a few seconds depending on your Internet connection speed ...

```sh
go1.18.linux-arm64.t  59%[==========>         ]  79.99M  4.92MB/s    eta 12s
```

Once it's downloaded, extract it:

```sh
tar -C /home/git/local -xvzf go1.18.linux-arm64.tar.gz
```

Set the `GOPATH` environment variable 
to specify the location of our workspace. 
We will set the variables in our `.bashrc` 
file so they will be available every time we enter the shell.

```sh
echo 'export GOROOT=$HOME/local/go' >> $HOME/.bashrc
echo 'export GOPATH=$HOME/go' >> $HOME/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> $HOME/.bashrc
source $HOME/.bashrc
```

Note
We need to specify the `GOROOT` environment variable 
since we are installing Go to a custom location.
Check that Go is properly installed:

```sh
go version
```

You’ll see output that resembles the following:
```sh
go version go1.18 linux/arm64
```

With `Go` and `Postgres` installed, 
you're all set to install `Gogs`!

<br />

## `Gogs`!

Download and install Gogs
following the official instructions:
https://gogs.io/docs/installation/install_from_source



```sh
# Clone the repository to the "gogs" subdirectory
git clone --depth 1 https://github.com/gogs/gogs.git gogs

# Change working directory
cd gogs

# Compile the main program, dependencies will be downloaded at this step

```

Build the Gogs binary:

```sh
go build -o gogs
```

> This may take a few minutes 
> during which your console 
> will appear unresponsive.

It will produce a binary named `gogs` 
in the current directory. 

Execute the binary:

```sh
./gogs web
```

In your terminal, you should see output similar to the following:

```
2022/04/10 12:34:24 [ INFO] Gogs 0.13.0+dev
2022/04/10 12:34:24 [TRACE] Work directory: /home/git/local/gogs
2022/04/10 12:34:24 [TRACE] Custom path: /home/git/local/gogs/custom
2022/04/10 12:34:24 [TRACE] Custom config: /home/git/local/gogs/custom/conf/app.ini
2022/04/10 12:34:24 [TRACE] Log path: /home/git/local/gogs/log
2022/04/10 12:34:24 [TRACE] Build time:
2022/04/10 12:34:24 [TRACE] Build commit:
2022/04/10 12:34:24 [ INFO] Run mode: Development
2022/04/10 12:34:24 [ INFO] Listen on http://0.0.0.0:3000
```

In the case of running Ubuntu as a server,
you will need the local network IP address
in order to access the Gogs server.
Run the following command in the Terminal 
on the Raspberry Pi to get the IP:

```sh
hostname -I
```

Output should be similar to the following:

```sh
192.168.1.196
```

Armed with this IP address, 


<br /><br />

## Relevant Reading / Research

+ Install `Gogs` on Debian:
https://www.linode.com/docs/guides/install-gogs-on-debian/ <br />
Last updated Oct 2020, some things deprecated.
But still good as a reference. 