# Learn DevOps

Learn the craft of "DevOps" (Developer Operations)
to _easily/reliably_ deploy your App and keep it Up!

![devops-process](https://user-images.githubusercontent.com/194400/28494977-ce74a632-6f36-11e7-9f86-f48abde49479.png)

## Why?

You should learn more "advanced" DevOps if:

+ You / your team have "out-grown"
[Heroku](https://github.com/dwyl/learn-heroku)
(_e.g: your Heroku bill is more than $100/month_)
+ You want "more control" over your infrastructure
e.g: to run a specific version of software or database.
+ Your client/boss has instructed you
to use a _specific_ "cloud" provider.
+ Curiosity to extend your
"back end infrastructure" knowledge to be a more
"well-rounded" developer.

## What?

> "_DevOps integrates developers and operations teams
> in order to improve collaboration and productivity
> by automating infrastructure, automating workflows
> and continuously measuring application performance._"
> from: ["**What is DevOps**?"](https://youtu.be/_I94-tJlovg) by RackSpace

## Who?

Everyone that wants to _seriously consider/call_ themself
a "***Full Stack***" **Developer** ***must*** know how to deploy,
secure and monitor their app on their chosen infrastructure.


## How?

This tutorial uses a ***Linode*** Virtual Machine,
if you are new to Linode we prepared a _quick_ start guide:
[`linode-setup.md`](https://github.com/dwyl/learn-devops/blob/master/linode-setup.md)

Once you have a running Linode instance,
we can move onto setting up deployment.

Initialize Vagrant VM:
```
vagrant up --debug &> vagrant.log
```
> Note: ensure you add the `vagrant.log` to your `.gitignore` file
as it's **thousands of lines** which change each time an instance
is created. e.g:
```
echo "vagrant.log >> .gitignore"
```

### Travis-CI Continuous Delivery

We're using Travis-CI to both test and (_automatically_) _deploy_ our application.

If you are new to Travis-CI, see:
[https://github.com/dwyl/**learn-travis**](https://github.com/dwyl/learn-travis)



### Create an RSA Key for Deployment

On the server, create an SSH key (_wihtout a password_):

```
ssh-keygen -t rsa -b 4096 -C "travis-ci-deployment-key"
```

![ssh-keygen](https://user-images.githubusercontent.com/194400/28845900-6ddce118-7701-11e7-8e2b-682dbfa01d4e.png)


see:  https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/

### Add the `public` key to the `authorized_keys` file

On the VM run the following command to add the `public` key to `authorized_keys`:
```
 cat id_rsa.pub  >> ~/.ssh/authorized_keys
```


### Download the Private Key File

On your `localhost`, download the `private` key you created in the previous step.

```
scp root@51.140.86.5:/root/.ssh/id_rsa ./deploy_key
echo "deploy_key" >> .gitignore
```

![download-ssh-key](https://user-images.githubusercontent.com/194400/28846821-c8570300-7704-11e7-993c-478010457fbd.png)

_Ensure_ you don't accidentally commit the _private_ key
to GitHub by your `.gitignore` file.

### Encrypt the Private Key

Again, on your localhost, encrypt the `private` key using Travis' CLI:

```
gem install travis
touch .travis.yml && travis encrypt-file ~/.ssh/deploy_key --add
```

You should have a `deploy_key.enc` file in your working directory.
This should be added/commited to GitHub so that Travis can use it.


### _First_ Upgrade Deployment

Build Upgrade based on the version currently on Staging:
```
mix edeliver build upgrade --auto-version=git-revision --from=$(1.0.3) --to=$(git rev-parse HEAD) --verbose --branch=continuous-delivery
```

Get the version that was created and use it as the `--version` in the next command:

```
mix edeliver deploy upgrade to production --version=1.0.3+3a4f948 --verbose
```


> _**NOTE**: We have an **Open issue** for deploying an **UPGRADE**
via Continuous Integration:_ https://github.com/dwyl/learn-devops/issues/19 <br />
> _We requested help on:_ https://github.com/edeliver/edeliver/issues/234 <br />
> _But sadly, no reply, yet ..._
_if you have time to help please comment on the issue!_


## Resources

### Videos

+ What is DevOps: https://youtu.be/I7vHqXY22gg
+ What is DevOps? - In Simple English: https://youtu.be/_I94-tJlovg
(_good info but last minute is a RackSpace pitch_)
+ DevOps for Beginners Course Introduction: https://youtu.be/v7ZcZfGBFcU

### Background Reading

+ https://en.wikipedia.org/wiki/DevOps
+ https://theagileadmin.com/what-is-devops
+ https://newrelic.com/devops/what-is-devops

### Linod-specific How-tos

+ SSH with Public Keys:
https://www.linode.com/docs/security/use-public-key-authentication-with-ssh
+ Using Vagrant for Environment Management:
https://www.linode.com/docs/applications/configuration-management/vagrant-linode-environments

### Using a Different Cloud Infrastructure Provider?

While this tutorial has focussed on using Linode,
we @dwyl have _experience_ of using _several_ infrastructure providers:

+ Amazon Web Services: https://github.com/dwyl/learn-amazon-web-services
+ Azure: https://github.com/dwyl/learn-microsoft-azure
+ Digital Ocean: https://github.com/dwyl/DigitalOcean-Setup
+ Heroku: https://github.com/dwyl/learn-heroku

if you have a question specific to using Linode or one of the _other_
"cloud" providers, please
[**open an _issue_**](https://github.com/dwyl/learn-devops/issues)
and we will attempt to help!

<!--

## <sup>1</sup>Why Not "_Just Use Heroku_"?

Heroku is great for _most_ use-cases.
But it gets _expensive_ very quickly!
The moment you start to pay for an app it's $7/month
(_which may not sound "expensive" on the surface_)
But it's the _Database_ that's the _expensive_ part!

### Heroku Database _Extortion_

The moment you go beyond the "_hobby_" plan:
![heroku-hobby-dev](https://user-images.githubusercontent.com/194400/28563894-543876d8-711f-11e7-9b09-cb548e10ee84.png)

![heroku-hobby-basic](https://user-images.githubusercontent.com/194400/28563938-77966842-711f-11e7-9668-eaa694325a79.png)

![heroku-database-pricing](https://user-images.githubusercontent.com/194400/28563258-4e7628d2-711d-11e7-81e0-b3997d9d05ca.png)

As you can see, from the pricing, the _resources_ do offer value-for money
once the project's database goes above a certain size.

-->
