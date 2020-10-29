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
_secure_ and _monitor_ their app on their chosen infrastructure.


## How?

Over the years we @dwyl have deployed/managed Apps,
both our own and those of our clients,
on a wide variety of infrastructure and platform providers.

_Most_ of our Apps have been deployed to **Amazon Web Services** ("**AWS**")
e.g: https://www.sciencemuseum.org.uk  <br />
We have _several_ clients who use (_and **love**_) Heroku e.g:
https://www.ellenmacarthurfoundation.org <br />
For the National Health Service (NHS) in England,
(_who have a major contract with Microsoft_) we deployed
https://www.healthlocker.uk to Azure. <br />
We have clients who still own their own "_Bare Metal_" Servers.

### Provider-Specific Guides

We have produced a guide for each of our most-used
infrastructure/platform providers:

+ AWS: https://github.com/dwyl/learn-amazon-web-services
+ AWS Lambda: https://github.com/dwyl/learn-aws-lambda
+ Azure: https://github.com/dwyl/learn-microsoft-azure
+ Heroku: https://github.com/dwyl/learn-heroku
+ Linode: [linode-setup.md](https://github.com/dwyl/learn-devops/blob/master/linode-setup.md)
+ DigitalOcean: [nodejs-digital-ocean-centos-dokku.md](https://github.com/dwyl/learn-devops/blob/master/nodejs-digital-ocean-centos-dokku.md)

### Node.js

+ Node.js with Dokku:
[nodejs-digital-ocean-centos-dokku.md](https://github.com/dwyl/learn-devops/blob/master/nodejs-digital-ocean-centos-dokku.md)
+ Node.js "Zero Downtime" Production Deployment with PM2:
[nodejs-pm2-zero-downtime.md](https://github.com/dwyl/learn-devops/blob/master/nodejs-pm2-zero-downtime.md)


> If you would like to see a guide for a _different_ service provider,
please open an issue with your suggestion(s):
https://github.com/dwyl/learn-devops/issues


### Testing, Continuous Integration & Delivery

Deployment is what you do with your app once you have
built, tested and documented it.

If you are unfamiliar with Test-Driven Development (TDD),
please see: https://github.com/dwyl/learn-tdd <br />

Next you should be proficient with Continuous Integration.
For that we recommend using Travis-CI, see:
[https://github.com/dwyl/**learn-travis**](https://github.com/dwyl/learn-travis)




https://github.com/dwyl/learn-travis/blob/master/encrypted-ssh-keys-deployment.md

<!--
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
-->

## Resources

### Videos

+ What is DevOps: https://youtu.be/I7vHqXY22gg
+ What is DevOps? - In Simple English: https://youtu.be/_I94-tJlovg
(_good info but last minute is a RackSpace pitch_)
+ DevOps for Beginners Course Introduction: https://youtu.be/v7ZcZfGBFcU

### Background Reading

+ https://en.wikipedia.org/wiki/DevOps
+ https://theagileadmin.com/what-is-devops
+ https://newrelic.com/devops/what-is-devops
+ https://logit.io/blog/post/what-is-devops

### Linode-specific How-tos

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
