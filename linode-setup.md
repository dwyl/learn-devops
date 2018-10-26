# Linode Setup

![linode-logo](https://user-images.githubusercontent.com/194400/28843865-8f8c1808-76fa-11e7-80f3-a8c7f66fdde1.png)


If you are new to Linode, _please_ signup using the following link<sup>1</sup>:
https://www.linode.com/?r=5b426b2a0a026ebcf71261b824fa3a0ff3a6f82d
and use promo code `DOCS10` for **$10 credit** on your new account.

Signed up:
![image](https://user-images.githubusercontent.com/194400/28494556-052afe86-6f2a-11e7-8b89-e5a456d36c50.png)
![image](https://user-images.githubusercontent.com/194400/28494569-657beba6-6f2a-11e7-8ea6-e626dae58c83.png)

## Create a Virtual Machine "Instance"

There are _two_ options for creating a Virtual Machine (VM):
(A) Manually and (B) Automated.

### A. Manual (Click-to-Create)

#### Step 1: Select an instance type

![image](https://user-images.githubusercontent.com/194400/28494574-773c877e-6f2a-11e7-8e5d-c6bff04fb5dc.png)

Once you've _launched_ the instance, you should see the Linode Manager:
![image](https://user-images.githubusercontent.com/194400/28494579-86556488-6f2a-11e7-8c8f-b3059ca1dc09.png)

#### Step 2: Select the Operating System

Select an Operating System (_we tend to use the most recent Ubuntu "LTS" version_): <br />
![image](https://user-images.githubusercontent.com/194400/28494609-3fb1b21a-6f2b-11e7-9448-7a11ebcd6c3b.png)

#### Step 3: Boot the New Instance

Remember to click on `[Boot]` button to actually _run_ the instance:
![image](https://user-images.githubusercontent.com/194400/28494633-079559c6-6f2c-11e7-94d4-3e5e94d00b8a.png)

#### Step 4: Add your SSH Key to the Linode

Click on the "**Dashboard**" link for your VM:
![04-linode-manager-click-dashboard](https://user-images.githubusercontent.com/194400/28655621-ef1d191c-7294-11e7-84ee-1f75ce16c52f.png)

Click on "**Remote Access**" then click on "**Launch Lish Console**":
![05-linode-manager-dashboard-remote-access-click-lish](https://user-images.githubusercontent.com/194400/28655707-86518052-7295-11e7-9ab4-96cb4b323c4f.png)

Use "Lish Console" to add `public` ssh key to the node:
![image](https://user-images.githubusercontent.com/194400/28494679-53a9c292-6f2d-11e7-910f-55a3a6a31b12.png)

Now can login from localhost using ssh using public key:
![image](https://user-images.githubusercontent.com/194400/28494687-a2e9b524-6f2d-11e7-8cdb-b6d4af9dd514.png)

> SSH using RSA Key:
https://www.linode.com/docs/security/use-public-key-authentication-with-ssh

### B. _Automated_ Virtual Machine Provisioning using Vagrant

> For the next section we are using `Vagrant` to (_automate_) "_provisioning_"
a VM. If you are new to `Vagrant`, please see:
[github.com/dwyl/**learn-vagrant**](https://github.com/dwyl/learn-vagrant)

#### Step 1: Create a Linode API Key

Login to your Linode account and visit `My Profile > API Keys`
then create a new key:

![02-linode-profile-api-keys-named](https://user-images.githubusercontent.com/194400/28654772-d8e4b2dc-728e-11e7-9dfe-925f20d8ff11.png)

You should see something like this:

![03-linode-profile-api-keys-named-display](https://user-images.githubusercontent.com/194400/28655427-cbea2094-7293-11e7-8c37-109dc7d06ad3.png)

> Don't worry, this is not a "epic security fail" ... the key is not active,
it's just for illustrative purposes.

#### Step 2: Copy the API Key (to a Safe Place) and Export as Environment Variable

Copy the newly created **API Key** to a **_safe_ place**
(_your choice of key storage_)
and then `export` it as an **Environment Variable**:

In your terminal window type `export LINODE_API_KEY=` and _paste_ your API Key:
```
export LINODE_API_KEY=aKiuRAOe5WEgnIaGouhWz19jJSInnwQzx8wOdSlAIEMkk4Z8cXGQQHQBdB2MSaRk
```
_confirm_ that Environment Variable was set
by running `printenv` and checking the output.

> _Note: if you are new to using Environment Variables, please see:_
[github.com/dwyl/**learn-environment-variables**](https://github.com/dwyl/learn-environment-variables)


#### Step 3: Install the Linode Vagrant Plugin

Once you have installed Vagrant
you will need to install the `vagrant-linode` plugin:

```
vagrant plugin install vagrant-linode
```
you should see:
```
Installing the 'vagrant-linode' plugin. This can take a few minutes...
Installed the plugin 'vagrant-linode (0.2.8)'!
```

Following this guide:
https://www.linode.com/docs/applications/configuration-management/vagrant-linode-environments

#### Step 4: Create a `Vagrantfile`

Create a `Vagrantfile` for your project and _copy-paste_
the contents of the _sample_:

#### Step 5: Launch a Linode VM using Vagrant

```
vagrant up --debug &> vagrant.log
```
> Note: that command will output the steps the `vagrant up` command
to `vagrant.log` so you can monitor it's progress (eventual success/failure).
Rememver to add the `vagrant.log` to your `.gitignore` file
as it's **thousands of lines** which change each time an instance
is created. e.g:
```
echo "vagrant.log >> .gitignore"
```

You should see something similar to:
![vagrant-up](https://user-images.githubusercontent.com/194400/28662379-e1fd97bc-72b1-11e7-9226-372f95edefb5.png)
Once the `vagrant up` command has completed provisioning the Linode VM,
_login_ to the VM using the command:
```
vagrant ssh
```
that will give you the IP Address of the Vagrant Box, which in our case is:
**213.168.248.157**



If you visit the IP address in a browser you will see a `502` error:

![nginx-502-error](https://user-images.githubusercontent.com/194400/28662539-67d6a608-72b2-11e7-810c-0098edb2396c.png)


That is a _good_ thing because it tells you that NGiNX is working!
(_the `502` is because we don't have a Phoenix app
  running on port `4000`, yet!_)

#### Step 6: Build, Deploy & Start a Phoenix App using Edeliver

```
git clone git@github.com:nelsonic/hello_world_edeliver.git
cd hello_world_edeliver
```
Open the `.deliver/config` file and update:
+ `BUILD_HOST` (IP Address)
+ `BUILD_USER`
+ `PRODUCTION_USER`

to the values you need.
In our case I updated the values to:
```
BUILD_HOST="213.168.248.157"
BUILD_USER="ubuntu"
BUILD_AT="/home/ubuntu/hello_world_edeliver/builds"

PRODUCTION_HOSTS="213.168.248.157"
PRODUCTION_USER="ubuntu"
DELIVER_TO="/home/ubuntu"
```
see: [.deliver/config#L3-L9](https://github.com/nelsonic/hello_world_edeliver/blob/fd65c19118509f06177d58c145dae18669e04479/.deliver/config#L3-L9)

Now run the `edeliver` commands to `build`, `deploy` and `start`
```
mix edeliver build release --verbose --branch=continuous-delivery
mix edeliver deploy release to production --verbose
mix edeliver start production
```

You should see:
![edeliver-deploy-start](https://user-images.githubusercontent.com/194400/28664767-61cacf4e-72b9-11e7-8274-40543cd08c0a.png)

And when you refresh the browser page you should see the Phoenix App!
![phoenix-linode-working](https://user-images.githubusercontent.com/194400/28665164-ab3f5e28-72ba-11e7-90a5-2a59511932fd.png)


So now we have a working server running a Phoenix App on Linode!




<!--
## Notes

Re-sizing a VM appears to be pretty straightforward:
![image](https://user-images.githubusercontent.com/194400/28494605-2807bc9a-6f2b-11e7-976b-80d58416e17d.png)
-->
