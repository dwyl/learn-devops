# PostgreSQL Setup

The purpose of this guide is to show how _we_ setup Postgres on a standard VPS.
No prior **DevOps** experience is assumed/expected,
however some understanding of basic Postgres concepts is _useful_.

> **Note**: if you are new to Postgres or need a refresher,
please see: 
[github.com/dwyl/**learn-postgresql**](https://github.com/dwyl/learn-postgresql)


## 1. Create a VPS Instance

If you don't already have a Virtual Private Server (VPS) instance,
create one. 

> In the case of this guide, 
we are using DigitalOcean 
because they have a good balance of Price/Performance.
> We did a bunch of research into the comparative cost/perf:
[learn-devops/issues/58](https://github.com/dwyl/learn-devops/issues/58#issuecomment-660650080)
We concluded that the **NVMe SSD Block Storage** of DigitalOcean,
was the best in the cost/perf tradeoff. 

At the time of writing,
there is no 1-click Postgres setup in the DO Marketplace:
https://marketplace.digitalocean.com
So we are doing our setup from scratch.


Visit: 
Select the instance Operating System and Plan:
![do-create-01-select-instance-type](https://user-images.githubusercontent.com/194400/87891845-4a7bed80-ca33-11ea-8bf5-eb3095eeafe6.png)



Select the instance Operating System and Plan:
![do-create-01-select-instance-type](https://user-images.githubusercontent.com/194400/87891845-4a7bed80-ca33-11ea-8bf5-eb3095eeafe6.png)

Scroll down to the "Add Block Storage" section and enter 1gb into the field:
![do-create-02-block-storage](https://user-images.githubusercontent.com/194400/87891890-667f8f00-ca33-11ea-9043-cca1b44cc334.png)

We're going to increase the size in a later step, so keep it low for now just to set it up.
https://www.digitalocean.com/docs/volumes/how-to/increase-size/

Select `Ext4` for the filesystem and then select the datacenter region that bests suits your needs.

> We selected `Ext4` filesystem based on reading this post:
https://blog.pgaddict.com/posts/postgresql-performance-on-ext4-and-xfs
It _appears_ to be 10% faster for Postgres. 

Scroll down until you see the "Choose a hostname" field. Enter a relevant name, in our case "hits":
![do-create-04-hostname](https://user-images.githubusercontent.com/194400/87892697-b3646500-ca35-11ea-854a-364a4ae0a964.png)

Scroll to the bottom of the page and click "**Create Droplet**".

Given that the data directory will be on the _separate_ block storage,
we aren't bothering with the $1/month backup.

Once your server has been created,
follow the initial server setup guide:
https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04




2. Install Postgres

Following this guide:
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-18-04

Login to the VPS using ssh:
```
ssh root@159.65.85.59
```

Update the OS and install Postgres:

```sh
sudo apt update
sudo apt install postgresql postgresql-contrib
```

Once everything is installed,
Switch to the Postgres user:

```
sudo -i -u postgres
```

You should see the following in your terminal 
to indicate that you're logged in as the postgres user:

```
postgres@hits:~$
```


```
createuser --interactive
```

```
hitsnodelete
```
This username is fairly self-evident.
We want a user that can `insert` records but not `delete` any data.

```
Shall the new role be a superuser? (y/n)
```

Select `n`, for all options
as we don't _want_ our user to be a `superuser`.


## 3. Change Postgres Directory to use Block Storage


Following this guide:
https://www.digitalocean.com/community/tutorials/how-to-move-a-postgresql-data-directory-to-a-new-location-on-ubuntu-18-04


Login to postgres:
```
sudo -u postgres psql
```

Display the data directory:
```
SHOW data_directory;
```

You should see:
```
       data_directory
-----------------------------
 /var/lib/postgresql/10/main
(1 row)
```

Quit postgres:

```
\q
```

Shut down postgres:

```
sudo systemctl stop postgresql
```

Confirm the status of postgres:
```
sudo systemctl status postgresql
```

You should see something similar to the following:
```
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
   Active: inactive (dead) since Mon 2020-07-20 03:11:02 UTC; 7s ago
 Main PID: 8928 (code=exited, status=0/SUCCESS)

Jul 20 02:25:23 hits systemd[1]: Starting PostgreSQL RDBMS...
Jul 20 02:25:23 hits systemd[1]: Started PostgreSQL RDBMS.
Jul 20 03:11:02 hits systemd[1]: Stopped PostgreSQL RDBMS.
```


Copy the postgres data directory to the block storage volume:

```
sudo rsync -av /var/lib/postgresql /mnt/volume_lon1_01
```

In our case our mounted block storage is `/mnt/volume_lon1_01`


Rename `main` data to `main.bak` just so we have a backup:
```
sudo mv /var/lib/postgresql/10/main /var/lib/postgresql/10/main.bak
```


Edit the postgres config:

```
sudo nano /etc/postgresql/10/main/postgresql.conf
```


Find the `data_directory` line and update it to:
```
data_directory = '/mnt/volume_lon1_01/postgresql/10/main'
```

Save and quit the file.

Start postgres again:

```
sudo systemctl start postgresql
```

Check the status:
```
sudo systemctl status postgresql
```

You should see the following:

```
● postgresql.service - PostgreSQL RDBMS
   Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
   Active: active (exited) since Mon 2020-07-20 03:17:59 UTC; 5s ago
  Process: 20422 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 20422 (code=exited, status=0/SUCCESS)

Jul 20 03:17:59 hits systemd[1]: Starting PostgreSQL RDBMS...
Jul 20 03:17:59 hits systemd[1]: Started PostgreSQL RDBMS.
```

Login to `psql`:

```
sudo -u postgres psql
```

Show the `data_directory`:

```
SHOW data_directory;
```

You should see:

```
             data_directory
----------------------------------------
 /mnt/volume_lon1_01/postgresql/10/main
(1 row)
```

Success.
