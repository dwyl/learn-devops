# Deploy an Elixir or Phoenix application

This markdown summarise the research done
on how to deploy a Phoenix application.


## PaaS vs VPS

In the past we have mostly used Platform as a Service
to deploy Elixir application. The main advantage of PaaS
is it is quick to setup and have your application running
for your users.
However on a long term using a PaaS can become costly.
Virtual Private Server are in contrast normally cheaper to run
but require more setup time and devops knowledge.

### PaaS

#### Heroku

We are used to deploy Elixir/Phoenix on Heroku
and we have already a ["how to"](https://github.com/dwyl/learn-phoenix-framework/blob/master/heroku-deployment.md) guide of this process.

However there are some limitations when using Heroku with Phoenix (see https://hexdocs.pm/phoenix/heroku.html):
![image](https://user-images.githubusercontent.com/6057298/83642784-2e1d1200-a5a7-11ea-8c97-9c7dd920469c.png)

pricing:
![image](https://user-images.githubusercontent.com/6057298/83641712-cc0fdd00-a5a5-11ea-8cbf-49981ae3747e.png)

The pricing above doesn't include the database which needs to be added to the total cost, see https://elements.heroku.com/addons/heroku-postgresql


### Gigalixir

Similar to Heroku [Gigalixir](https://www.gigalixir.com/) provides
a platform which focus on deploying Elixir/Phoenix application.

Deploying: https://elixircasts.io/deploying-with-gigalixir-%28revised%29

Pricing:

![image](https://user-images.githubusercontent.com/6057298/83643629-290c9280-a5a8-11ea-89da-648daec204f3.png)

Gigalixir vs Heroku:

![image](https://user-images.githubusercontent.com/6057298/83644108-d1225b80-a5a8-11ea-869a-c8c0e4a28012.png)

Like Heroku you need to add the cost for using the database:

![image](https://user-images.githubusercontent.com/6057298/83644296-09c23500-a5a9-11ea-9fdd-c50532195c95.png)

see also tiers pricing page: https://gigalixir.readthedocs.io/en/latest/tiers-pricing.html


### Render

[Render](https://render.com/) is another Paas similar to Heroku

pricing:

![image](https://user-images.githubusercontent.com/6057298/83645052-e9df4100-a5a9-11ea-8d3e-f1b18bb4cc02.png)



## Virtual Private Server

VPS allow us to manage ourself the deployement
setup. This allow us to customise the server and
the costs linked to it.


### Linode

#### Ubuntu

Linode provides and support Ubuntu:
![image](https://user-images.githubusercontent.com/6057298/83647811-3bd59600-a5ad-11ea-893c-b99e3df7f605.png)


From there the idea is install Erlang and Elixir on the server
and then to run the application.

- Install Erlang/Elixir with asdf:
    - `git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.8`
    - Edit `~/.bashrc file` and add `. $HOME/.asdf/asdf.sh` and run `source ~/.barhrc` to access the `asdf` command
    - Install required pacakges for Erlang `sudo apt install libssl-dev make automake autoconf libncurses5-dev gcc`
    - Add erlang plugin to asdf: `asdf plugin-add erlang`
    - Install Erlang: `asdf install erlang latest`
    - Install Elixir: `asdf install elixir latest`
    - Define which Elixir version to use `asdf global elxir <version>`

- Instsall Nodejs using nvm
    - `wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash` (from https://github.com/nvm-sh/nvm#installing-and-updating)
    - run `nvm install node`

- Clone and run the Phoenix application
    - Clone the application, e.g. `git clone https://github.com/dwyl/hits.git`
    - Make sure to have all the environemt variables for the application defined
        - e.g. for the secret key: `mix phx.gen.secret` then `export SECRET_KEY_BASE=<secret>`
    - Compile assets (see https://hexdocs.pm/phoenix/deployment.html#compiling-your-application-assets) 
        - `npm run deploy --prefix ./assets`
        - `mix phx.digest`
    - Start the server with `Mix`: `MIX_ENV=prod mix phx.server`

- Another way to run the server is to use `mix release`: https://hexdocs.pm/phoenix/releases.html

#### FreeBSD/OpenBSD

I've also been investigating how to run
an Elixir/Phoenix applicaiton on FreeBSD (and OpenBSD)

Linode provides a way to create server from image,
however the backup system won't support server running FreeBSD:
![image](https://user-images.githubusercontent.com/6057298/83650091-d931c980-a5af-11ea-8ed1-ffc693d79e41.png)

The following guide explain how to install FreeBSD on Linode:
https://www.linode.com/docs/tools-reference/custom-kernels-distros/install-freebsd-on-linode/

I've also tested the installation on one of my machine: https://github.com/SimonLab/FreeBSD-installation

The idea is then to use the FreeBSD package manager to install Elixir and Erlang:
- `pkg install erlang`
- `pkg install elixir`


### DigitalOcean

DigitalOcean provides a FreeBSD droplet:
![image](https://user-images.githubusercontent.com/6057298/83651322-472ac080-a5b1-11ea-8ce3-764cb9fe7927.png)

see https://www.digitalocean.com/products/linux-distribution/freebsd/

However OpenBSD can't be installed directly.
There are some way we could install it and investigate
if it can be used safely and without any blockers with DigitalOcean:
https://dev.to/nabbisen/custom-openbsd-droplet-on-digitalocean-4a9o

see also: https://www.digitalocean.com/community/tutorials/how-to-get-started-with-freebsd


## Current Conclusion

After reading and testing some Elixir/Phoenix/Linux/BSD installations
I can see that Linode (or similar) can be on a longer term a better tool
to manage the applications.

The simple deployement used above with Ubuntu works well,
however I still have some research and testing to do especially
linked to continuous deployment without downtime.
From reading the chapter 11 "Deploy Your Application to Production" of
Real Time Phoenix, the solutions to deploy witout downtime are based on running
applications on Elixir clusters. I'd like to learn more about this aspect
but from a MVP perspective this point might take too much time to assimilate
and I think a PaaS might be best to use at the moment.



