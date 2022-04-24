<div align="center">
    <h1>Deploy & Maintain a <code>Gogs</code> Server</h1>
    <a href="https://gogs.io/">
        <img src="https://user-images.githubusercontent.com/194400/162528448-5df0e9e8-a132-4644-b216-5107e0df0204.png">
    </a>
    <p>
        A <em><strong>quick guide</strong></em> to 
        <strong><code>Gogs</code></strong> (<em>Git Server</em>)
        for <em><strong>complete beginners</strong></em>.
    </p>

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/learn-devops/issues)
[![HitCount](http://hits.dwyl.com/dwyl/learn-devops-gogs.svg)](http://hits.dwyl.com/dwyl/learn-devops-gogs)

</div>

# _Why_? 🤷‍♂️

You need a simple **Git server** 
without the steep learning curve of 
[Git SCM](https://git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server)
or _overhead_ of running a **GitLab** instance.

**`Gogs`** is a performance-friendly 
Git web interface written in the **`Go`** programming language. 
It claims to make setting up and managing GIT painless;
let's test that!


# _What_? 📦

In our case **`@dwyl`**,
we are _mostly_ happy with the GitHub service. 👌<br />
Except for a few annoying aspects of the interface
and the occasional outage, GitHub is good.
We are exploring having a **`Gogs`** server running as a 
[**_hot_ backup**](https://en.wikipedia.org/wiki/Backup_site#Hot_site)
which we can use when GitHub is unavailable
or if they ever lose our data! 

# _Who_? 🤓

The audience for this guide is "_us_" 
[**`@dwyl`**](https://github.com/dwyl). <br />
If anyone `else` finds it helpful that's a bonus. <br />
Please ⭐ the repo if you find it useful. Thanks!

# _How_? 👩‍💻

There are several options for running `Gogs`:
1. **Directly** on your main machine/workstation -
    can be advantageous in terms of setup speed,
    but clutters your main machine with a server
    that requires resources + maintenance.

2. On your machine using **Docker** - provides
   good isolation/separation, 
   reasonably fast startup times
   and can be easily "killed" when no longer needed.

3. On a **_secondary_ computer** e.g. **RaspberryPi** - complete isolation,
   more "hackable" and simulates production more closely.
   Obviously having a second machine is a luxury 
   not everyone has. But we figure a 
   [$15](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/)
   RasbperryPi Zero is not a stretch for most people doing DevOps.

4. On **3rd Party/Cloud Service** e.g. AWS or **Fly.io** -
   perfect once you have decided `Gogs` is for you 
   and you want a Production instance for your project.
   We use Fly.io because it's: <br />
   a) Simplicity: deploying to Fly.io is 
   _much_ simpler than other VPS/Cloud services (AWS!). <br />
   b) _Cheaper_ than an equivalent ($2/month) <br />
   c) Our _main_ app already runs on Fly.io 
   so having the `Gogs/Git` server co-located 
   is good for latency/speed/performance.

We chose to install `Gogs` on a **RaspberryPi**
for 3 reasons: <br />
a) Keeps it fully isolated on a separate machine. 
Which simulates "production". <br />
b) Allows us to test connecting to it over a network. i.e. real world tests.<br />
c) Means we can run the instance long-term 
and store actual (backup) data on it.<br />

There are quite a few steps for setting this up,
so we documented them in a separate doc.
See: [`/install-gogs-raspberrypi.md`]()

Once we had setup the `Gogs` server on the `RPi`
with `nginx` and `systemd` to auto-boot 
whenever we restart the `RPi`,
we tested connecting to `Gogs` on the `RPi`
and documented the steps:
[`/connect-to-raspberrypi.md`]()

Once we confirmed that everything was working 
on the local **`RaspberryPi`**,
we felt confident to deploy to Fly.io 

### Fly.io

Once we had everything working & tested
on the **`RaspberryPi`**,
we felt confident 
so we deployed a "Production" instance to Fly.io.

See: https://github.com/dwyl/gogs-server






<br />

## Reading 📚


Pages we read on the journey:

+ https://pimylifeup.com/raspberry-pi-gogs/
+ https://www.techrepublic.com/article/how-to-connect-to-your-local-gogs-repository-from-the-git-command-line/