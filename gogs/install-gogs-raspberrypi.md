# Install `Gogs` on RaspberryPi

This guide follows and expands 
on the official **`Gogs`** 
installation guide:
https://gogs.io/docs/installation ...

Our objective is to capture _all_ the steps
required so that _anyone_ can follow along
and replicate our _exact_ result.

> _If you get stuck along the way, 
> please don't suffer in silence!
> Ask for help_; 
> [**open an issue**!](https://github.com/dwyl/learn-devops/issues)

## Prerequisites

Ensure you have a working RaspberryPi running 
Ubuntu:
https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview


> We are using Ubuntu because it's _ubiquitous_
> and will help with both Continuous Integration 
> and deployment to Cloud/VPS later
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

Open the PostgreSQL interactive terminal 
to create a new database and user for Gogs:

```sh
sudo -u postgres psql -d template1
```

You should see output similar to the following:

```sh
psql (12.9 (Ubuntu 12.9-0ubuntu0.20.04.1))
Type "help" for help.

template1=#
```

Create new user for Gogs:

```sh
CREATE USER gogs CREATEDB;
```
You should see output similar to:

```sh
CREATE ROLE
```

Set the password for user gogs:

```sh
\password gogs
```

It will prompt you for the password and password confirmation. 
Take note of this password, you will need it later when configuring Gogs.

Create new database for Gogs:

```
CREATE DATABASE gogs OWNER gogs;
```


Exit the psql terminal:

```sh
\q
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

### `Go lang` 

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

**Note**:
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
visit http://192.168.1.196:3000 
(either on the Ubuntu Pi 
or on another computer 
on the same network ...)

![image](https://user-images.githubusercontent.com/194400/162982227-2ce4f772-d574-4ba7-af59-a66df1dddc60.png)

Use the IP address for the PI as the Application URL: http://192.168.1.196:3000/

![image](https://user-images.githubusercontent.com/194400/162982781-18fc0a35-7bd3-405e-ba17-6dac8dcb1320.png)

That way you can connect from other computers on your home network.

https://gogs.io/docs/installation/configuration_and_run


Once configured, created a new user and repo: http://192.168.1.196:3000/nelsonic/my-awesome-repo
![image](https://user-images.githubusercontent.com/194400/163005975-2a2abefa-11a5-4085-96b8-133c8a28f587.png)


## Nginx

1. Create self-signed certificate:

Run the commands as root:
```sh
sudo su -
mkdir /root/certs && cd /root/certs
```

Create the self-signed certificate:
```sh
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out MyCertificate.crt -keyout MyKey.key
```

Accept all the defaults for the certificate creation
this is just for use on your local network.

2. Install Nginx

```sh
sudo apt-get install -y nginx
```

If you visit 
the IP address of your Ubuntu server in a web browser now,
e.g: http://192.168.1.196 
you will see the default Nginx homepage:

![default-nginx](https://user-images.githubusercontent.com/194400/163057616-1bd02d41-342d-4fac-a6b6-8fb3e3e11134.png)

Create the gogs site:

```sh
sudo vi /etc/nginx/sites-available/gogs
```

```nginx
server {
    listen 80 default_server;
    server_name $http_host;
    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass http://localhost:3000;
    }
}

server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /root/certs/MyCertificate.crt;
    ssl_certificate_key /root/certs/MyKey.key;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass http://localhost:3000;
    }
}
```

Link it:
```sh
sudo ln -s /etc/nginx/sites-available/gogs /etc/nginx/sites-enabled/gogs
```

Delete the default nginx config as we don't need it:
```sh
sudo rm /etc/nginx/sites-enabled/default
```

Restart:
```sh
sudo systemctl restart nginx
```

When you refresh the page in your browser you will 
now see the `gogs` page:

![gogs-page-nginx](https://user-images.githubusercontent.com/194400/163059605-be133880-42dc-4794-920e-af6230fca4bc.png)

## Automatic Startup with systemd

Create the `systemd` config file:


```sh
sudo vi /etc/systemd/system/gogs.service
```

```sh
[Unit]
Description=Gogs (Go Git Service)
After=syslog.target
After=network.target
After=postgresql.service
After=nginx.service

[Service]
Type=simple
User=git
Group=git
WorkingDirectory=/home/git/local/gogs
ExecStart=/home/git/local/gogs/gogs web
Restart=always
Environment=USER=git HOME=/home/git

[Install]
WantedBy=multi-user.target
```


Enable the systemd unit file:
```
sudo systemctl enable gogs
```

Start the service:
```
sudo systemctl start gogs
```

Check the status of the service:
```
sudo systemctl status gogs
```

It should display the output like this:

```sh
● gogs.service - Gogs (Go Git Service)
     Loaded: loaded (/etc/systemd/system/gogs.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-04-10 21:58:44 UTC; 4s ago
   Main PID: 127605 (gogs)
      Tasks: 7 (limit: 9021)
     CGroup: /system.slice/gogs.service
             └─127605 /home/git/local/gogs/gogs web

Apr 10 21:58:44 ubuntu systemd[1]: Started Gogs (Go Git Service).
Apr 10 21:58:44 ubuntu gogs[127605]: 2022/04/10 21:58:44 [TRACE] Log mode: File (Info)
```


<br /><br />

## Relevant Reading / Research

+ Install `Gogs` on Debian:
https://www.linode.com/docs/guides/install-gogs-on-debian/ <br />
Last updated Oct 2020, some things deprecated.
But still good as a starting point. 