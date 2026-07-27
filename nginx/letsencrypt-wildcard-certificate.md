![letsencrypt-760x320](https://cloud.githubusercontent.com/assets/194400/23311312/8c4cc85a-faad-11e6-912c-9cc96ec21da6.png)

## Why?

We want to deploy several App to our own Virtual Machine(s)
and want all of them to be served over HTTPS (_using SSL/TLS_)
***without*** a much ***extra effort*** for each **_additional_ app**.

## What?

Setup a wildcard certificate to run _any_ App(s) on a specific _subdomain_
such as: `api.example.com` or `auth.example.com`

> We previously covered how to setup LetsEncrypt for Heroku:
[https://github.com/dwyl/learn-heroku](https://github.com/dwyl/learn-heroku/blob/master/SSL-certificate-step-by-step-setup-instructions.md)
If you haven't used Heroku to deploy a "_basic_" App,
we _highly_ recommend doing that _first_
as this is a more "advanced" level.


## Who?

This tutorial is not "complicated"
so _anyone_ with _basic_ development experience _should_ be able to follow it.
However it is _not_ aimed at "_beginners_"
who have never deployed _any_ App(s) before.
If you are `new` to web app development/deployment/"DevOps",
we suggest you use Heroku: https://github.com/dwyl/learn-heroku
(_it's **much easier** and "**free**"!_)
once you are _paying_ for Heroku, come back to this!


## How?

### 0. Pre-requisites

This tutorial _requires_ a "Cloud" Virtual Private Server (VPS) instance. <br />
_Any_ provider will work (AWS EC2, GCP, Azure, DigitalOcean, Linode, etc.)

If you do not yet have an instance go create one _first_.


### 1. Download & Install `certbot`

This approach to downloading `certbot` ensures we get the _latest_ version
and is OS/platform independent. (_tested on CentOS and Ubuntu_)

```sh
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto
sudo ./certbot-auto
```
You should expect to see output similar to the following
(_depending on your OS and "cloud" provider_):

```sh
Bootstrapping dependencies for RedHat-based OSes...
(you can skip this with --no-bootstrap)
yum is /bin/yum
yum is hashed (/bin/yum)
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
epel/x86_64/metalink                                          | 7.2 kB  00:00:00
 * base: mirror.netweaver.uk
 * epel: epel.mirror.constant.com
 * extras: mirror.mhd.uk.as44574.net
 * updates: mirror.netweaver.uk
base                                                          | 3.6 kB  00:00:00     
digitalocean-agent                                            | 3.3 kB  00:00:00     
docker-ce-edge                                                | 2.9 kB  00:00:00     
docker-ce-stable                                              | 2.9 kB  00:00:00     
dokku_dokku/x86_64/signature                                  |  836 B  00:00:00
```


> **Note**: We are runnign the `certbot-auto` program as `sudo` ("root")
> because it certbot-auto needs root access to bootstrap OS dependencies
> the Bash code is very well commented and you can read it in about 20 mins.
> see: https://github.com/certbot/certbot


#### 1.1. Install `certbot` Dependencies

```sh
Dependencies Resolved

===============================================================================
 Package                     Arch     Version            Repository    Size
===============================================================================
Installing:
 augeas-libs                x86_64    1.4.0-5.el7_5.1      updates     355 k
 libffi-devel               x86_64    3.0.13-18.el7        base        23 k
 openssl-devel              x86_64    1:1.0.2k-12.el7      base        1.5 M
 python-devel               x86_64    2.7.5-68.el7         base        397 k
 ...
Installing for dependencies:
 dwz                        x86_64    0.11-3.el7           base        99 k
 keyutils-libs-devel        x86_64    1.5.8-3.el7          base        37 k
 ...
 tcl                        x86_64    1:8.5.13-8.el7       base        1.9 M
 zlib-devel                 x86_64    1.2.7-17.el7         base        50 k

Transaction Summary
===============================================================================
Install  8 Packages (+18 Dependent packages)

Total download size: 12 M
Installed size: 31 M
Is this ok [y/d/N]:
```

Type `"Y"` followed by the `[Enter]` key.

Once the dependencies are installed,
`certbot` will begin the certificate "wizard" ...
but that will not setup a "wildcard" certificate so just _cancel_ it.



### 2. Run the `certbot-auto` Command

Note: this is a multi-line command
the only part you need to change is the last line (_the domains_):


```sh
sudo ./certbot-auto certonly \
--server https://acme-v02.api.letsencrypt.org/directory \
--manual --preferred-challenges dns \
-d *.ademo.app -d ademo.app
```

### 2.1 Input the Certificate Details

```
Enter email address
```
Use an email address you will have access to _long term_.


### 2.2 Create the DNS TXT Record

When you see the following output:

```sh
Please deploy a DNS TXT record under the name
_acme-challenge.ademo.app with the following value:

ZGoegXW6Xsp-kTGBCjvcghTANZDfgl8LRgcmspDGvK0

Before continuing, verify the record is deployed.
```

In your Domain Name (or DNS) provider,
setup the `TXT` record.

on Digital Ocean, go to:
https://cloud.digitalocean.com/networking/domains
and select your domain.

e.g: https://cloud.digitalocean.com/networking/domains/ademo.app
![dokku-dns-txt-record](https://user-images.githubusercontent.com/194400/40445586-735d2c00-5ec4-11e8-9832-d9f82d8b33a2.png)


#### Check that TXT Record is Working

Run the following command:
```sh
dig -t txt _acme-challenge.ademo.app
```

Response:
```
; <<>> DiG 9.10.6 <<>> -t txt _acme-challenge.ademo.app
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54442
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;_acme-challenge.ademo.app.	IN	TXT

;; ANSWER SECTION:
_acme-challenge.ademo.app. 3599	IN	TXT	"ZGoegXW6Xsp-kTGBCjvcghTANZDfgl8LRgcmspDGvK0"

;; Query time: 144 msec
```

Confirm that the response value matches what LetsEncrypt expects!

Via: https://serverfault.com/questions/148721/linux-command-to-inspect-txt-records-of-a-domain


### 2.3 Successful Output

```sh
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/ademo.app/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/ademo.app/privkey.pem
   Your cert will expire on 2018-08-21. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot-auto
   again. To non-interactively renew *all* of your certificates, run
   "certbot-auto renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```


### 3. Add the Ceritifacte to your App

Since we are using Dokku to deploy our apps,
and dokku automatically generates an `nginx.conf` file for each app,
we can _either_ update the file _manually_
***or*** using a the `dokku certs:add` command.


#### 3.a _Automatically_ Add the Cert to Dokku App


There is a _command_ for adding the certificate to a dokku app:

```sh
dokku certs:add <app> CRT KEY   
```

```sh
cd /etc/letsencrypt/live/ademo.app/
dokku certs:add hello fullchain.pem privkey.pem
```
Annoyingly running that command returned the following error:
```sh
CRT file specified not found, please check file paths
```
So, after a bit of searching, I discovered a "workaround":

```sh
cat fullchain.pem > server.crt
cat privkey.pem > server.key
tar cvf certs.tar server.crt server.key
dokku certs:add hello < certs.tar
```
in my case:

```sh
cd /etc/letsencrypt/live/ademo.app/
cat fullchain.pem > server.crt
cat privkey.pem > server.key
tar cvf certs.tar server.crt server.key
dokku certs:add hello < certs.tar
```
This `tar` step only needs to be done _once_.
then all _subsequent_ apps which are a _subdomain_ e.g: `staging.ademo.app`
will just need:

```
dokku certs:add yourapp < /etc/letsencrypt/live/ademo.app/certs.tar
```
e.g:
```sh
dokku certs:add staging < /etc/letsencrypt/live/ademo.app/certs.tar
```

<!--
**Note**: Sadly we cannot use _symbolic links_ for this ... we tried!

The following will _fail_:
```sh
cd /etc/letsencrypt/live/ademo.app/
ln -s fullchain.pem server.crt
ln -s privkey.pem server.key
tar cvf certs.tar server.crt server.key
dokku certs:add hello < certs.tar
```
-->

via: https://github.com/dokku/dokku/blob/master/docs/configuration/ssl.md <br />
with: https://www.hakobaito.co.uk/b/setting-up-lets-encrypt-on-dokku


#### 3.b _Manually_ Update `nginx.conf` file

If you prefer to update your `nginx.conf` _manually_ for any reason,
you will need to locate, open and edit the `nginx.conf` file for your app.

In the case of our `hello` app, the file is: `/home/dokku/hello/nginx.conf`

> **Note** this will still work if you are not using Dokku/Docker,
you simply need to find and update the right `nginx.conf` file.

The only lines we changed were the two that related to the SSL cert:
From:
```sh
ssl_certificate     /home/dokku/hello/tls/server.crt;
ssl_certificate_key /home/dokku/hello/tls/server.key;
```

To:
```sh
ssl_certificate /etc/letsencrypt/live/ademo.app/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/ademo.app/privkey.pem; # managed by Certbot
```

This is where `certbot` stores the certificates, _don't move_ them
(_or the certificate renewal will fail_)


### 4. Reload Nginx

Run the following command to both _test_ the nginx config is _valid_
and to `reload` the server:
```sh
nginx -t && nginx -s reload
```

You should see:
```sh
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
```

### Test The SSL!

To test that the SSL/TLS certificate is setup correctly, test it!
e.g:
https://www.ssllabs.com/ssltest/analyze.html?d=ademo.app


![ssl-report](https://user-images.githubusercontent.com/194400/40444989-c254bf82-5ec2-11e8-8f1c-95517ac1efd4.png)


### Automating it!

Once you have got your Wildcard Certificate setup,
it's a **single command** to add it to any new apps you deploy using Dokku.

For an _example_ of how this can be done see:
https://github.com/nelsonic/hello-world-node-http-server/blob/5b6f2a29d8d4568cf7337a84ceecf666e50d353e/bin/deploy.sh#L47-L49




## Background Reading

My _starting_ point was:

+ Michael S. Hansen [@hansenms](https://github.com/hansenms)
"Creating Wildcard SSL Certificates with Let’s Encrypt":
https://blogs.msdn.microsoft.com/mihansen/2018/03/15/creating-wildcard-ssl-certificates-with-lets-encrypt
+ Cecile Muller [@cecilemuller](https://github.com/cecilemuller)
How to setup Let's Encrypt for Nginx on Ubuntu 16.04
(including IPv6, HTTP/2 and A+ SLL rating):
https://gist.github.com/cecilemuller/a26737699a7e70a7093d4dc115915de8

Neither of these two were for CentOS, Digital Ocean or Dokku
so I had to "assemble" this guide from a few other sources ...

## Additional Resources:

+ https://en.wikipedia.org/wiki/Automated_Certificate_Management_Environment
+ https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/
+ https://www.eigenmagic.com/2018/03/14/howto-use-certbot-with-lets-encrypt-wildcard-certificates/
+ https://community.letsencrypt.org/t/ubuntu-16-04-ppa-how-long-until-certbot-0-22-0-available/55613/8
+ https://stackoverflow.com/questions/33055212/nginx-multiple-server-blocks-listening-to-same-port
+ Dokku Wildcard Certificate issue:
https://github.com/dokku/dokku-letsencrypt/issues/148
+ Zipping the certs to use `dokku certs:add`:
https://www.hakobaito.co.uk/b/setting-up-lets-encrypt-on-dokku/
+ Non-Wildcard:
https://medium.com/@pimterry/effortlessly-add-https-to-dokku-with-lets-encrypt-900696366890
