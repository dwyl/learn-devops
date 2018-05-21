# Deploying Node.js App(s) to Digital Ocean

A guide to deploying Node.js App(s) on Digital Ocean using Dokku.


## Why?

We need a way of deploying _multiple_ apps
to the _same_ Digital Ocean VPS/instance.

Digital Ocean is a _great_ alternative
to the "main" cloud providers (Amazon, Google & Microsoft);
it has a _much_ more intuitive control panel
which means you can get your "DevOps" work don a _lot_ faster!


## What?

We will be using the following:

+ Digital Ocean Droplet (Virtual Private Server "VPS")
+ CentOS (Operating System) - though any "mainstream linux" will work,
and Ubuntu/Debian is the most _popular_.
+ Dokku "Platform as a Service"

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
it will cost you about a $1 per month (per app) if you run 5 apps.
Crucially, the service quality/speed will be **much better** than
the "free apps" on Heroku!_


## Who?

Anyone that needs to deploy one or _more_ App(s) to Digial Ocean
and needs a _step-by-step_ guide.


## _When_?

It's _only_ worth investing the time to create your own
"Mini Platform-as-a-Service" once you have used (_and "out-grown"_) Heroku.

Heroku offers _significant_ advantages including logging/alerting and "teams",
which are _not_ covered here.

_If you have **never used Heroku**, or this is your **first time**
deploying a Node.js app, we **highly recommend** following the_
[`https://github.com/dwyl/learn-heroku`](https://github.com/dwyl/learn-heroku)
_guide **first**_. <br />

_**Bookmark** (**Star**) this repo/tutorial now so you can return to it
when you are spending more than **$10/month** on **Heroku**;
it does not make sense to run your own "PaaS" before then!_



## How?

These are _step-by-step_ instructions, follow them in order
and don't skip steps!

### 0. Pre-requisites

_Before_ we start, please ensure you have the following:

+ [x] Digital Ocean Account (_see above for link if you don't have one!_)
  + [x] Public SSH Key uploaded to https://cloud.digitalocean.com/settings/security
  (_so that you can login to the instance we are about to launch!_)
  see: https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets
+ [x] Basic Node.js knowledge
+ [x] 30 mins of time.

### 1. Launch the Instance

Go to: https://cloud.digitalocean.com/droplets/new and Create a Droplet!

> _**Note**: We are using a "blank" instance as opposed to a "One-click app",
because this will show us how to setup "from scratch"
and will thus be applicable to **any** cloud provider_.

The instance we are creating is a **CentOS 7.5** Droplet with **1GB RAM**.

![digital-ocean-dokku-create-droplet](https://user-images.githubusercontent.com/194400/40320319-2adb2f92-5d23-11e8-88c7-74c9aab084dc.png)

Select your desired region (_datacenter_).
(_pick the nearest to your users or dev team_) e.g:

![digital-ocean-dokku-choose-region](https://user-images.githubusercontent.com/194400/40320737-943863c8-5d24-11e8-8c42-fd8ceb2ec4bc.png)

The default `hostname` for the instance (_based on the selected options_)
is: `centos-s-1vcpu-1gb-lon1-01` let's change that to: `centos-dokku-paas`
so that we know what the instance _does_ from reading it's hostname.

![digital-ocean-dokku-default-hostname](https://user-images.githubusercontent.com/194400/40320799-bd9da58e-5d24-11e8-9812-62560338e6ac.png)

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

We only tend to use the web-based console when on a device that does not have
a "_native_" terminal app. (_e.g: an iPad_)

get the instance's IP (v4) Address, e.g: `138.68.163.126`
and paste the following command into your terminal:

```sh
ssh root@138.68.163.126
```

> _**Note**:_ `root` _is the_ `default` _user for Digital Ocean instances,
we prefer to **minimise** the activity of "root" or `sudo` users
on our instances for security.
So our **next step** we will create a new user called_: `deploy`
_with reduced privileges_.

### 3. Create the `deploy` User on the Instance



### 4. Configure Custom Domain Name (Optional/Recommend)

Get domain and point DNS record at the droplet.

#### 4.1 Register the Domain

We registered a custom domain name as we intend to use
this server to host multiple "demo" apps,
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

![do-cetos-ademo-app-dns](https://user-images.githubusercontent.com/194400/40325944-80b01092-5d35-11e8-8e62-8170cdc67658.png)
![do-cents-ademo-dns-full](https://user-images.githubusercontent.com/194400/40325945-80c6ac8a-5d35-11e8-8ff1-000caa8f296f.png)

This indicates the settings update is "saving" ...
![dns-settings-updated](https://user-images.githubusercontent.com/194400/40325773-e206ace4-5d34-11e8-9697-82629244a54d.png)


#### 4.3 Verify the Domain Servers using `whois` Command

Verify that the new domain servers are listed in
```sh
$ whois <domain.com> | grep "Name Server"
```
e.g:
```sh
whois ademo.app | grep "Name Server" response
```
You should see something like this:
![image](https://user-images.githubusercontent.com/194400/40325923-69823cf6-5d35-11e8-808c-448bc510b03a.png)



4. From the DO droplet's actions pick "Add Domain" and enter the new domain <domain.com>
5. There should be nothing to do, there is already a default @ <ip4> A record created
6. Add wild card mapping for everything else to the same domain - A record * <ip4>
Note just enter a wildcard `"*"` in the first column, and <ip4> address in the second.
7. You should see the following text in the record on the config page



## Background / Further Reading

+ https://github.com/dokku/dokku
+ https://github.com/gliderlabs/herokuish

## Credits


This tutorial stands on the shoulders of _several_ giants.
The _particular_ "guide" we found the _most_ useful
was written by Gleb Bahmutov [`@bahmutov`](https://github.com/bahmutov)
https://glebbahmutov.com/blog/running-multiple-applications-in-dokku
PDF snapshot: [running-multiple-applications-in-dokku.pdf](https://github.com/dwyl/learn-devops/files/2023606/running-multiple-applications-in-dokku.pdf)
His post is 2 years old, uses a much older version Dokku,
and is focussed on Ubuntu, so we had to fill-in quite a few "gaps".
But on the whole, it's a _superb_ post!
