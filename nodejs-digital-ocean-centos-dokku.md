# Deploying Any App(s) Using Dokku PaaS

A guide to deploying Any App(s) to your own "Platform-as-a-Service" using Dokku.

![dokku-paas-header-image](https://user-images.githubusercontent.com/194400/40890782-5509ca8a-6773-11e8-9d3e-3dda57349b88.png)
<!-- if you can improve on, or want/need to edit this intro image, go for it!
https://docs.google.com/drawings/d/1_JbCorCr96NeJZ9lAzkT6DT7Ze3Jw_PdXfioRLoR8IU
-->
<br />
Like having your own (_self-managed/hosted_) Heroku platform
with full VM access/control at a _fraction_ of the cost.

## Why?

We need a way of deploying _multiple_ apps
to the _same_ Digital Ocean VPS/instance.

Digital Ocean is a _great_ alternative
to the "main" cloud providers (Amazon, Google & Microsoft);
it has a _much_ more intuitive (_UX-focussed_) "control panel"
which means you can get your "DevOps" learning and _work_ done a _lot_ faster!

### Why _Not_?

Managing your own infrastructure (or "Platform") is a "**rabbit hole**";
it might be _easy_ to get started, but if (_when_) things go "wrong",
it can take a while to _understand_ the issue (_lots of googling!_).
This is "OK" if you are the type of person who _enjoys debugging_ Docker/Linux,
but if you prefer focus on the _features_ of your App, let someone `else`
handle the infra/PaaS until you achieve "critical mass" and can afford
to hire a _professional_ DevOps person.


## What?

Deploy "unlimited"<sup>1</sup> apps to a Virtual Private Server (VPS) instance
with great service quality and minimal cost.


In this guide we will be using the following:

+ Digital Ocean Droplet (Virtual Private Server "VPS")
+ CentOS (Operating System) - though any "mainstream linux" will work,
and Ubuntu/Debian is the most _popular_.
+ Dokku "Platform as a Service" ("PaaS") based on Docker.
+ LetsEncrypt Free SSL Certificates.

If you do not _already_ have a Digital Ocean account,
please use the following link to register: https://m.do.co/c/29379863a4f8
and get **$10 in Credit**.

> _**Note**: we are **launching** a **Digital Ocean instance** in this tutorial.
unless you used the "referral link" above, you will incur a **small cost**.
If you use the 1GB instance and go through the tutorial in 1 hour
it will cost you **0.007 cents** (less than **one cent**)_.
_If you chose to **use** this method for running your apps it will
cost you $5/month which is cheaper than the **cheapest** paid tier on Heroku,
and since we will cover how to run **multiple apps**,
it will cost you **less than $1 per month** (per app) if you run 5+ apps.
Crucially, the **service quality/speed** will be **much better** than
the "free apps" on Heroku!_

<sup>1</sup>"unlimited" apps is not _strictly_ true;
we _are_ limited by the RAM resources of the instance.


## Who?

Anyone that needs to deploy one or _more_ App(s)
to DigitalOcean and needs a _step-by-step_ guide.


## _When_?

It's _only_ worth investing the time to create your own
"Mini Platform-as-a-Service" once you have used (_and "out-grown"_) Heroku.

Heroku offers _significant_ advantages including logging/alerting and "teams",
which are _not_ covered here.

_If you have **never used Heroku**, or this is your **first time**
deploying a Node.js app, we **highly recommend** following the_
[`https://github.com/dwyl/learn-heroku`](https://github.com/dwyl/learn-heroku)
_guide **first**_. <br />

> _**Bookmark** (**Star**) this repo/tutorial **now** so you can return to it
when you are spending more than **$10/month** on **Heroku**;
it does not make sense to run your own "PaaS" before then!_


## How?

These are _step-by-step_ instructions,
follow them in order
and _don't skip_ steps!

### 0. Pre-requisites

_Before_ we start, please ensure you have the following:

+ [x] Digital Ocean Account
(_New to "DO"? Please use this link:_ https://m.do.co/c/29379863a4f8
_to register_)
  + [x] Public SSH Key uploaded to https://cloud.digitalocean.com/settings/security
  (_so that you can login to the instance we are about to launch!_)
  see: https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets
+ [x] Basic Node.js knowledge
(_but this guide works for **Any** app e.g: Ruby, Python, Elixir, Go, Java, Scala, etc!_)
+ [x] 30 mins of time.

### 1. Create the DigitalOcean Instance

Go to: https://cloud.digitalocean.com/droplets/new and Create a Droplet!

> _**Note**: We are using a "blank" instance as opposed to a "One-click app",
because this will show us how to setup "from scratch"
and will thus be applicable to **any** cloud provider_.

The instance we are creating is a **CentOS 7.5** Droplet with **1GB RAM**.

![digital-ocean-dokku-create-droplet](https://user-images.githubusercontent.com/194400/40320319-2adb2f92-5d23-11e8-88c7-74c9aab084dc.png)

Select your desired region (_datacenter_);
(_pick the nearest to your users or dev team_) e.g:

![digital-ocean-dokku-choose-region](https://user-images.githubusercontent.com/194400/40320737-943863c8-5d24-11e8-8c42-fd8ceb2ec4bc.png)

The default `hostname` for the instance (_based on the selected options_)
is: `centos-s-1vcpu-1gb-lon1-01` let's change that to: `centos-dokku-paas`
so that we know what the instance _does_ from reading it's hostname.

![digital-ocean-dokku-default-hostname](https://user-images.githubusercontent.com/194400/40320799-bd9da58e-5d24-11e8-9812-62560338e6ac.png)

> This also means that if/when we "scale" the instance up
we don't need to **rename** it when the CPU/RAM changes.
<br />

`hostname` updated:
![dokku-hostname-updated](https://user-images.githubusercontent.com/194400/40320800-bdb615c4-5d24-11e8-9b75-9f876c58c490.png)

Click on the "Create" button.

You will see a "loading" progress bar for a few seconds
while the instance is being created:

![digital-ocean-instance-creation-progress-bar](https://user-images.githubusercontent.com/194400/40321021-983b5362-5d25-11e8-8e4f-c0e78222f791.png)

and then something like this:

![digital-ocean-dokku-instance-created](https://user-images.githubusercontent.com/194400/40321034-a27d2d0a-5d25-11e8-9fc1-2b1b9b1d8ae2.png)

### 2. Login to the Instance via SSH/Console

There are two ways to access your Digital Ocean instance:
the first is via the Web-based console:

![do-centos-dokku-console](https://user-images.githubusercontent.com/194400/40321524-49f9d0f0-5d27-11e8-81cb-2cfd295aa494.png)

We only tend to use the web-based console when on a device
that does not have a "_native_" terminal app. (_e.g: an iPad_)

get the instance's IP (v4) Address, e.g: `138.68.163.126`
and run the following command into your terminal
to **login** to the instance **via SSH**:

```sh
ssh root@138.68.163.126
```

While logged in as `root` run the _update_ command:

```sh
yum update
```
There are _security_ updates: <br />
![image](https://user-images.githubusercontent.com/194400/40326841-9e2c5b6e-5d38-11e8-9313-66e369777807.png)

Update complete: <br />
![image](https://user-images.githubusercontent.com/194400/40326822-8e8e5bda-5d38-11e8-83d1-f8fa03520e17.png)

`root` _is the_ `default` _user for Digital Ocean instances,
we prefer to **minimise** the activity of "root" or `sudo` users
on our instances for security.
So our **next step** we will create a new user called_: `dokku`
_with reduced privileges_.


### 3. Add `dokku` User

Create a `dokku` user on the server (_so that we can avoid running as `root`_)""


```sh
cat ~/.ssh/id_rsa.pub | ssh root@<ip4> "sudo sshcommand acl-add dokku root"
```

e.g:
```sh
cat ~/.ssh/id_rsa.pub | ssh root@138.68.163.126 "sudo sshcommand acl-add dokku root"
```

If you are already logged into the server,
run the following command:
```
cat ~/.ssh/id_rsa.pub | sudo sshcommand acl-add dokku root
```

#### 3.i Need to _Remove_ the Dokku User?

If you ever need to _remove_ the `dokku` user on the instance, run:

```
sshcommand acl-remove <USER> <NAME>
```
e.g:
```sh
sshcommand acl-remove dokku root
```



### 4. Configure Custom Domain Name (Optional/Recommend)


In this section we'll walk through:
+ Finding and registering a domain name
+ Point the domain's DNS record to DigitalOcean
so the "droplet" is configured to receive all traffic for all subdomains.

> _**Note**: If you **already have** a domain name you can use for this,
then skip the registration step. <br />
You will still need to "point" the domain's
DNS to DigitalOcean for the rest to work_.

#### 4.1 Register the Domain

We registered a custom domain name as we intend to use
this server to host multiple "demo" apps, <br />
`ademo.app` seemed like a _logical_ name for the domain.

We use https://domainr.com to _lookup_ if the domain is available:

![image](https://user-images.githubusercontent.com/194400/40326177-5344d0ce-5d36-11e8-90da-392c016194ab.png)

And then use https://iwantmyname.com to _register_ the domain.



#### 4.2 Update the DNS (NameServer) Records to DigitalOcean
In the settings (where you registered the domain),
point DNS servers at the DigitalOcean's name servers:
  + ns1.digitalocean.com
  + ns2.digitalocean.com
  + ns3.digitalocean.com

![do-cetos-ademo-app-dns](https://user-images.githubusercontent.com/194400/41946140-c918da82-79a8-11e8-91c5-0810513e9796.png)
![do-cents-ademo-dns-full](https://user-images.githubusercontent.com/194400/40325945-80c6ac8a-5d35-11e8-8ff1-000caa8f296f.png)

This indicates the settings update is in progress ... <br />
![dns-settings-updated](https://user-images.githubusercontent.com/194400/40325773-e206ace4-5d34-11e8-9697-82629244a54d.png)


#### 4.3 Verify the Domain Servers using `whois` Command

Verify that the new domain servers are listed by running the `whois` command:
```sh
$ whois <domain.com> | grep "Name Server"
```
e.g:
```sh
whois ademo.app | grep "Name Server"
```
You should see something like this: <br />
![image](https://user-images.githubusercontent.com/194400/40325923-69823cf6-5d35-11e8-808c-448bc510b03a.png)


#### Background Reading for DNS on Digital Ocean

https://www.digitalocean.com/community/tutorials/an-introduction-to-digitalocean-dns

> Now that we know the domain (DNS) is configured to "point" to DigitalOcean
we can move on to creating the SSL Certificate for the domain!

### 5. LetsEncrypt Wildcard SSL Certificate!

In order to have multiple subdomains on the same server,
e.g: `hello.ademo.app` and `awesome-word-game.ademo.app`
you will need to have a Wildcard SSL Certificate!

Thankfully you can get one for _free_ with about 10 mins work.
We wrote a _separate_ (_self-contained_) tutorial for that:

[letsencrypt-wildcard-certificate.md](https://github.com/dwyl/learn-devops/blob/master/letsencrypt-wildcard-certificate.md)

once you have finished setting it up, return here and continue.


### 6.Install Dokku

#### 6.1 Install Docker (Dependency)

Given that there is no "package" for CentOS we need to
install `dokku` _manually_ using the "advanced" instructions: <br />
http://dokku.viewdocs.io/dokku/getting-started/advanced-installation

Run the following commands on your DO instance
to install Extra Packages for Enterprise Linux ("EPEL")  
https://fedoraproject.org/wiki/EPEL to get `nginx`:

```sh
sudo yum install -y epel-release
```

Install Docker

```sh
curl -fsSL https://get.docker.com/ | sudo sh
```

![image](https://user-images.githubusercontent.com/194400/40327507-26251036-5d3b-11e8-9014-e0da8194873b.png)



#### 6.2 Install Dokku

Once Docker is installed, proceed to installing Dokku using the following script:

```sh
curl -s https://packagecloud.io/install/repositories/dokku/dokku/script.rpm.sh | sudo bash
sudo yum install -y herokuish dokku
sudo dokku plugin:install-dependencies --core
```

![image](https://user-images.githubusercontent.com/194400/40327556-53261c6a-5d3b-11e8-9615-6c32a8f8fe58.png)

That will install quite a _few_ packages, so go for a walk!

![image](https://user-images.githubusercontent.com/194400/40327867-499e990a-5d3c-11e8-9f2e-a748c2c51da5.png)


#### 6.3 Install Dokku LetsEncrypt Plugin

```sh
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
```
You should see the following output:

```sh
-----> Cloning plugin repo https://github.com/dokku/dokku-letsencrypt.git to /var/lib/dokku/plugins/available/letsencrypt
Cloning into 'letsencrypt'...
remote: Counting objects: 454, done.
remote: Total 454 (delta 0), reused 0 (delta 0), pack-reused 454
Receiving objects: 100% (454/454), 94.57 KiB | 0 bytes/s, done.
Resolving deltas: 100% (276/276), done.
-----> Plugin letsencrypt enabled
Removed symlink /etc/systemd/system/docker.service.wants/dokku-redeploy.service.
Created symlink from /etc/systemd/system/docker.service.wants/dokku-redeploy.service to /etc/systemd/system/dokku-redeploy.service.
-----> Migrating zero downtime env variables to 0.5.x. The following variables have been deprecated
=====> DOKKU_SKIP_ALL_CHECKS DOKKU_SKIP_DEFAULT_CHECKS
=====> Please use dokku checks:[disable|enable] <app> to control zero downtime functionality
=====> Migration complete
=====>
-----> Migrating zero downtime env variables to 0.6.x. The following variables will be migrated
=====> DOKKU_CHECKS_ENABLED -> DOKKU_CHECKS_SKIPPED
=====> Migration complete
=====>
Adding user dokku to group adm
-----> Migrating DOKKU_NGINX env variables. The following variables will be migrated
=====> DOKKU_NGINX_PORT -> DOKKU_PROXY_PORT
=====> DOKKU_NGINX_SSL_PORT -> DOKKU_PROXY_SSL_PORT
=====> Migration complete
-----> Priming bash-completion cache
```


#### 6.4 Add Domain to Dokku

Add the desired domain to dokku so that it knows
we want to deploy our app(s) to that.

```sh
dokku domains:add-global <domain.com>
```
e.g:
```sh
dokku domains:add-global ademo.app
```

via: http://dokku.viewdocs.io/dokku/configuration/domains/#customizing-hostnames


<!--
#### 6.6 Quick "Progress" Check

To _confirm_ that everything installed ok,
visit the IP Address of your droplet e.g: http://138.68.163.126
![image](https://user-images.githubusercontent.com/194400/40328106-2763230a-5d3d-11e8-9be0-beb70ce960c1.png)
-->


### 7. Configure Dokku

Run the following commands (on the instance) to add your ssh (public) key
to the `dokku` user:
```sh
sudo cp /root/.ssh/authorized_keys /home/dokku/.ssh/dokku.pub
sudo chown dokku:dokku /home/dokku/.ssh/dokku.pub
sudo dokku ssh-keys:add dokku /home/dokku/.ssh/dokku.pub
```

#### 7.1 Create the `/home/dokku/VHOST` File

```
vi /home/dokku/VHOST
```
paste the following:
```
A   *.ademo.app  138.68.163.126
```


### 7.2 Configure Dokku `nginx.conf.sigil`


Find the file:
```
find / -name nginx.conf.sigil
```

On CentOS the file is located at:
```
/var/lib/dokku/core-plugins/available/nginx-vhosts/templates/nginx.conf.sigil
```



For reference, this is the `git diff` ("before and after") the change:
https://github.com/dwyl/learn-devops/compare/82919299ceaa2d0eb308c7501b8aa95b6be2b848...2da1a06365cce145d98e293a263a8ae747fb2f01


For details on nginx configuration in Dokku,
see: https://github.com/dokku/dokku/blob/master/docs/configuration/nginx.md



### 8. Create a Dokku App

Run this command while logged in (via SSH) to the DO instance:
```sh
dokku apps:create hello
```
You should see:

```sh
-----> Creating hello... done
```

#### 8.1 Add the SSL Certificate to the App

```sh
dokku certs:add yourapp < /etc/letsencrypt/live/ademo.app/certs.tar
```
e.g:
```sh
dokku certs:add hello < /etc/letsencrypt/live/ademo.app/certs.tar
```

### 9. Add Dokku Git Remote


using https://github.com/nelsonic/hello-world-node-http-server as my "hello world" app.

```
git remote add dokku dokku@138.68.163.126:hello
```
Now push the app to the Dokku server:

```
git push dokku master
```

You should see output similar to the following:

![image](https://user-images.githubusercontent.com/194400/40329183-a744e4e8-5d40-11e8-8bd0-325de5d25b53.png)

#### 9.1 Confirm The App Deployed Successfully

In our case we deployed our `hello` app to: https://hello.ademo.app

![hello-world-example-app](https://user-images.githubusercontent.com/194400/42243002-d2c3ad82-7f07-11e8-9bf4-5a9ce6098020.png)


<!--
### 9. Add App to Domain
```
dokku domains:enable hello
```

### 10. Configure the "Main" Domain for the Instance

http://dokku.viewdocs.io/dokku/configuration/nginx
-->


### 10. Deploy Another App to _Prove_ it Was not a "Fluke"!

#### 10.1 Create New Dokku App on Instance

Create a `new` Dokku app (_on the instance_):

```sh
dokku apps:create hello-world-node
```
Output (_you should see_):
```sh
-----> Creating hello-world-node... done
```

#### 10.2 Add a git remote for the app

```
git remote add dokku dokku@138.68.163.126:hello-world-node
```
Now push the app to the Dokku server:

```sh
git push dokku master
```

In my case I am working on a branch so I did:
```sh
git push dokku dokku-paas-deployment-issue#24:master
```
This pushes the _branch_ but tells Dokku to treat it as `master`
So it will be deployed.

The "new" app `hello-world-node` was successfully deployed to:
https://hello-world-node.ademo.app
![hello-world-node](https://user-images.githubusercontent.com/194400/42243190-61f49aa2-7f08-11e8-9cc4-b52dc54bca70.png)


# Done!

You have successfully deployed your first App to A Dokku PaaS!


<br />

### nginx Server Root and Configuration

Dokku uses nginx as its server for routing requests to specific applications.

If you want to start serving your own pages or application through Nginx,
you will want to know the locations of the Nginx configuration files
and default server root directory.

#### Default Server Root

The default server root directory is `/usr/share/nginx/html`.
Files that are placed in there will be served on your web server.
This location is specified in the default server block
configuration file that ships with Nginx,
which is located at `/etc/nginx/nginx.conf`

#### Server Block Configuration

Any additional server blocks, known as Virtual Hosts in Apache,
can be added by creating new configuration files in
`/etc/nginx/conf.d` Files that end with `.conf`
in that directory will be loaded when Nginx is started.

#### Nginx Global Configuration

The main Nginx configuration file is located at /etc/nginx/nginx.conf. This is where you can change settings like the user that runs the Nginx daemon processes, and the number of worker processes that get spawned when Nginx is running, among other things.

#### Default Log Files for Apps

By default, access and error logs are written for each app to /var/log/nginx/${APP}-access.log and /var/log/nginx/${APP}-error.log respectively


#### Default Dokku Nginx Conf

`/home/dokku/*/nginx.conf`
e.g:
```
/home/dokku/hello/nginx.conf
```

 nginx -t -c /etc/nginx/conf.d/dokku.conf





<br />

## Useful Dokku / Nginx Commands

### nginx Check (Test) Config

```sh
nginx -t
```
via: http://dokku.viewdocs.io/dokku/getting-started/troubleshooting/

### nginx start, stop & restart

```sh
nginx -s reload
```

via: https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-7

### Nginx Running?

To check if `nginx` is running on the CentOS instance run:

```sh
ps waux | grep nginx
```

e.g:
```sh<br <>br <>br <>br <>br <>br <>br <>br <>br <>br <>br <>br <>br <>b
root     14575  0.0  0.0 112704   968 pts/0    S+   20:39   0:00 grep --color=auto nginx
root     19119  0.0  0.2 141272  2100 ?        Ss   18:31   0:00 nginx: master process nginx
nginx    19120  0.0  0.3 141660  3572 ?        S    18:31   0:00 nginx: worker process
```

### Kill all Nginx Processes

```sh
kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
```
or the _cleaner_ version:
```sh
pkill nginx
```


### Check Running Apps

```
dokku apps:list
```

Sample response:
```sh
=====> My Apps
hello
```

via: https://github.com/dokku/dokku/blob/master/docs/deployment/process-management.md

### Proxy Settings

```sh
dokku proxy:report hello
```
Sample output:
```sh
[root@centos-dokku-paas hello]# dokku proxy:report hello
=====> hello proxy information
       Proxy enabled:                 true                     
       Proxy type:                    nginx                    
       Proxy port map:                http:80:5000  
```
via: http://dokku.viewdocs.io/dokku/networking/proxy-management/

### Re-Start an App

```sh
dokku ps:restart <app>
```
e.g:
```sh
dokku ps:restart hello
```

via: https://stackoverflow.com/questions/21247195/what-is-the-proper-command-to-restart-a-dokku-app-from-ssh



### Destroy (Delete) an App

To delete or "destro" an app run:
```sh
dokku apps:destroy <app>
```
e.g:
```sh
dokku apps:destroy hello
```

via: https://github.com/dokku/dokku/issues/36

### Docker Info

```sh
docker -D info
```






## Background / Further Reading

+ https://github.com/dokku/dokku
+ https://github.com/gliderlabs/herokuish
+ https://www.upcloud.com/support/get-started-dokku-centos
+ Nginx beginners guide: https://nginx.org/en/docs/beginners_guide.html
+ How to install nginx on CentOS: https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-7
+ https://stackoverflow.com/questions/14434120/nginx-set-multiple-server-name-with-ssl-support
+ See git commit hash of running Dokku app?
https://stackoverflow.com/questions/29801570/see-git-commit-hash-of-running-dokku-app
+ How To Set Up Nginx Server Blocks (Virtual Hosts)  
https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-16-04
+ Nginx Reverse Proxy (_good docs_):
https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy
+ How to set up TravisCI for projects that push back to github
https://gist.github.com/willprice/e07efd73fb7f13f917ea
+ Deploy With Travis CI and Git
https://jorin.me/deploy-with-travis-and-git/ (v. "high level"...)
+ Deploying from Travis CI to dokku:
http://blog.abarbanell.de/linux/2017/09/09/deploy-from-travis-to-dokku
+ push a specific commit to a remote:
 https://stackoverflow.com/questions/3230074/how-can-i-push-a-specific-commit-to-a-remote-and-not-previous-commits

## Credits


This tutorial stands on the shoulders of _several_ giants.
The _particular_ "guide" we found the _most_ useful
was written by Gleb Bahmutov [`@bahmutov`](https://github.com/bahmutov)
https://glebbahmutov.com/blog/running-multiple-applications-in-dokku
PDF snapshot: [running-multiple-applications-in-dokku.pdf](https://github.com/dwyl/learn-devops/files/2023606/running-multiple-applications-in-dokku.pdf) <br />
His post is 2 years old, uses a much older version Dokku,
and is focussed on Ubuntu, so we had to fill-in quite a few "gaps".
But on the whole, it's a _superb_ post!


### Troubleshooting

#### "failed to push some refs"

```
To 138.68.163.126:hello-dokku
 ! [remote rejected] dokku-paas-deployment-issue#24 -> master (pre-receive hook declined)
error: failed to push some refs to 'dokku@138.68.163.126:hello-dokku'
```

I ended up having to "kill" the `nginx` server ***`before`***
pushing the app to the server.

see:
[/bin/deploy.sh#L32-L38](https://github.com/nelsonic/hello-world-node-http-server/blob/5b6f2a29d8d4568cf7337a84ceecf666e50d353e/bin/deploy.sh#L32-L38)

#### `DOKKU_PROXY_PORT_MAP`

By default Dokku sets the App's TCP Port to `5000`.
Unless you have a _very good_ reason to change it, leave it as the default.
If you see the following error message:

```
-----> Configuring ademo.app...(using built-in template)
-----> Configuring hello-dokku....(using built-in template)
-----> Configuring hello-dokku.ademo.app...(using built-in template)
-----> Creating https nginx.conf
-----> Running nginx-pre-reload
       Reloading nginx
Job for nginx.service invalid.
-----> Configuring ademo.app...(using built-in template)
-----> Configuring hello-dokku....(using built-in template)
-----> Configuring hello-dokku.ademo.app...(using built-in template)
-----> Creating https nginx.conf
-----> Running nginx-pre-reload
       Reloading nginx
Job for nginx.service invalid.
```

It's because you are attempting to override the `PORT` environment variable.
(_we learned this he **hard way** ... don't make the same mistake!_)


<!--
### XX. Add Temporary SSL/TLS Certificate

```sh
dokku certs:generate <app> DOMAIN
```
e.g:
```sh
dokku certs:generate hello ademo.app
```
-->
