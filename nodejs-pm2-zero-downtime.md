# _Zero Downtime_ Node.js Deployment using PM2

## _Why?_

We want to deploy and run our Node.js app
on a _generic_ "cloud" hosting provider
Virtual Private Server (VPS) instance.

PM2 allows us to simplify continuous deployment
from our chosen CI service
and have more fine-grained control
over how our App is run.

## _What?_

Use PM2 to deploy your Node.js App
to a Digital Ocean Virtual Private Server (VPS) instance
with built-in monitoring, great service quality and minimal cost.

In this guide we will be using the following:

+ Digital Ocean Droplet (Virtual Private Server "VPS")
+ CentOS (Operating System) - though any "mainstream linux" will work,
and Ubuntu/Debian is the most _popular_.
+ PM2 Process Manager.
+ LetsEncrypt Free SSL Certificates.

> If you do not _already_ have a Digital Ocean account,
please use the following link to register: https://m.do.co/c/29379863a4f8
and get **$10 in Credit**.


## _Who?_

Developers who have _out-grown_ Heroku (_pricing_)
and want to deploy to a different (_affordable_) hosting/cloud provider.

> **Note**: Heroku has _many_ useful features including Logging,
Review Apps, permissions and teams which easily justify the cost.
But if you have reached $100/month you should consider switching,
provided you understand that you will need to work for it!

## _How?_

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
+ [x] 30 mins of time.



### 1. Create the DigitalOcean Instance

Go to: https://cloud.digitalocean.com/droplets/new and Create a Droplet!

> _**Note**: We are using a "blank" instance as opposed to a "One-click app",
because this will show us how to setup "from scratch"
and will thus be applicable to **any** cloud provider_.

The instance we are creating is a **CentOS 7.5** Droplet with **1GB RAM**.


![do-1-create-instance](https://user-images.githubusercontent.com/194400/47529746-915da300-d8a0-11e8-936a-149ce21dc926.png)

Select your desired region (_datacenter_);
(_pick the nearest to your users or dev team_) e.g:

![do-2-select-region](https://user-images.githubusercontent.com/194400/47529745-90c50c80-d8a0-11e8-8853-06b0af10ac60.png)

The default `hostname` for the instance (_based on the selected options_)
is: `centos-s-1vcpu-1gb-lon1-01` let's change that to: `centos-nodejs-pm2`
so that we know what the instance _does_ from reading it's hostname.

![do-3-finalise](https://user-images.githubusercontent.com/194400/47529744-90c50c80-d8a0-11e8-81e0-dbe63bc3366f.png)

Click Create and wait for the instance to be created.


### 2. Login to the Instance via SSH/Console

Get the instance's IP (v4) Address, e.g: `206.189.26.154`
from the UI:
![do-4-instance-ip-address](https://user-images.githubusercontent.com/194400/47529747-915da300-d8a0-11e8-85ec-5e6ec8ab7a5c.png)

and run the following command into your terminal
to **login** to the instance **via SSH**:

```sh
ssh root@206.189.26.154
```

While logged in as `root` run the _update_ command:

```sh
yum update -y
```
There are _security_ updates. Wait for the updates to run until you see
"**Complete**!": <br />
![centos-update-complete](https://user-images.githubusercontent.com/194400/47530712-45f8c400-d8a3-11e8-997a-77ab28e5183b.png)


### 3. Install Node.js

#### 3.1 Install NVM

Install Node Version Manager (NVM) from GitHub:
```sh
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
```

enable the `nvm` command line tool by running the command:
```sh
source ~/.bashrc
```

#### 3.2 Install the Latest Node.js Version (LTS)

Using NVM, install the latests (LTS) version of Node.js:
```sh
nvm install --lts
```

### 4. Install PM2 _Globally_

We install PM2 _globally_ so that it can be used on the server.

```sh
npm install pm2 -g
```
You should see:
![pm2-installed-successfully](https://user-images.githubusercontent.com/194400/47531350-472af080-d8a5-11e8-9396-24a7698c5951.png)


### 5. Install Git

Install Git CLI so that we can get the latest code from GitHub:

```sh
sudo yum install git -y
```

![git-installed](https://user-images.githubusercontent.com/194400/47531909-c66cf400-d8a6-11e8-83e6-11fa71221ab9.png)

### 6. Add Deployment SSH/RSA Public key



### 6.1 Add the Deployment SSH Public Key to `authorized_keys`

Add the deployment SSH **`public`** key
to the list of `authorized_keys` on the VPS:

```sh
vi /root/.ssh/authorized_keys
```

chmod 400 ~/.ssh/deploy_key

#### 6.2

![image](https://user-images.githubusercontent.com/194400/47536290-24a1d300-d8b7-11e8-98b7-ab547a4c90b6.png)

### 7. Deploy The App

Ensure that your App's project/repo has a `ecosystem.config.js` file.

+ Example:

+ Docs:
https://pm2.io/doc/en/runtime/guide/ecosystem-file

Deploy the app using PM2 from your _localhost_:

```sh
pm2 deploy ecosystem.config.js production setup
pm2 deploy production exec "pm2 reload all"
```

![pm2-deploy-success](https://user-images.githubusercontent.com/194400/47532953-b73b7580-d8a9-11e8-894b-d439c7c82a88.png)

PM2 will deploy the app on the default port (3000).
You can view the app by visiting: http://206.189.26.154:3000/

![app-deployed](https://user-images.githubusercontent.com/194400/47533038-17cab280-d8aa-11e8-9a2b-e8d493f02a28.png)

This is our first sign of "success"
but not a something we are going to send to end-users.

+ Deployment Docs: http://pm2.keymetrics.io/docs/usage/deployment/

### 8. Install NGINX

Install NGINX so that we can run it as a Proxy for our Node.js App:

```sh
sudo yum install epel-release -y && sudo yum install nginx -y
```

![image](https://user-images.githubusercontent.com/194400/47533209-c3740280-d8aa-11e8-975f-20980b8e240b.png)

Start NGINX with the command:

```sh
nginx
```

When you visit http://206.189.26.154 you should see:

![nginx-running](https://user-images.githubusercontent.com/194400/47533374-60cf3680-d8ab-11e8-9b51-c4cea8fb5494.png)

This is our _second_ "checkpoint".

### 9. Add a `proxy_pass` directive to `nginx.conf`

Edit the default `nginx.conf` file:

```sh
vi /etc/nginx/nginx.conf
```


In the `nginx.conf` file,
locate the section that starts with `location / {` ... e.g:

```
server {
    listen       80 default_server;
    listen       [::]:80 default_server;
    server_name  _;
    root         /usr/share/nginx/html;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    location / {
    }

    error_page 404 /404.html;
        location = /40x.html {
    }

    error_page 500 502 503 504 /50x.html;
        location = /50x.html {
    }
}
```

Change:
```nginx
location / {
}
```
To:
```nginx
location / {
   proxy_pass http://localhost:3000;
}
```

Stop and re-start nginx:
```sh
pkill nginx
nginx
```

Now when you visit http://206.189.26.154 you should see:

![app-running](https://user-images.githubusercontent.com/194400/47533931-7e050480-d8ad-11e8-9fb8-633d4531d316.png)


### 10. Update the App on Localhost



See:
https://github.com/nelsonic/hello-world-node-http-server/commit/5107062aad2b697b968180ec6de202d7e57e4a1a


### 11. Re-Deploy

```
pm2 deploy production update
pm2 start ecosystem.config.js --env production
```
pm2 deploy ecosystem.config.js production update
pm2 deploy ecosystem.config.js production exec "pm2 reload all"


![app-updated](https://user-images.githubusercontent.com/194400/47537037-7a787a00-d8bb-11e8-827d-011b29eee970.png)

## Recommended Further/Background Reading

+ Clustering Node.js apps in 3 minutes
https://medium.com/@alaabatayneh/clustering-in-node-js-apps-a05e5a9ed444
+ PM2 Process Manager - Zero Downtime — Performance Optimization - Part II
https://medium.com/tech-tajawal/process-manager-pm2-performance-optimization-part-ii-6ca8e431a578
+ Install NGINX:
https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-7
+ NGINX upstream proxy: http://nginx.org/en/docs/http/ngx_http_upstream_module.html
+ Install Git:
https://www.digitalocean.com/community/tutorials/how-to-install-git-on-centos-7
+ PM2 show process:
https://futurestud.io/tutorials/pm2-list-processes-and-show-process-details
