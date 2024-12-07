Hi friends, my name is Nelson and this is dwyl. <br />
Today we're going to deploy a Postgres Database Cluster
on 
[`Hetzner`]
using [**autobase**](https://autobase.tech).

As always, detailed instructions 
for how we do _everything_ are available on `GitHub`;
link in the description. 🔗

Along the way we will clarify the steps as possible.
But keep in mind it's _not possible_ to cover everything in a **7 minute video**.

If you have questions, suggestions or just want to say hi, 
**please comment on YouTube**;
thanks.

With all that out of the way, lets dive in!

## 1. Login to `Hetzner` Cloud


When you _first_ login to `Hetzner`, 
you will see the message:

"You don't have any servers yet."

<img width="2032" alt="hetzner-no-servers" src="https://github.com/user-attachments/assets/5442e9d8-c343-4f5d-9b93-d27d92f77a1b">

Click the "**Add Server**" button to begin your quest!

## 2. Create a New Server (VPS)

Select all the default options, 
add your `ssh` `public` key 
and create your server.

<img width="2032" alt="new-server-created" src="https://github.com/user-attachments/assets/b6c61f0c-d86a-472d-8a91-5994fb46becb">

## 3. `SSH` into the `Hetzner` Server

Use your `Terminal` to login to the newly created `Hetzner`server, e.g:

```sh
ssh root@116.202.31.52
```

Once you have successfully connected via `ssh`,
a best practice we recommend is to run a quick update.

### Update The Server

Run the following command chain:

```sh
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y
```

> Updates and installs usually take a couple of minutes.
> We speed installs up for brevity.

With everything up-to-date, install the necessary dependencies.


## 4. Install Dependencies

As per the `autobase` getting started guide: 
[autobase.tech/docs#getting-started](https://autobase.tech/docs#getting-started)
run the following command to get the necessary dependencies:

```sh
sudo apt update && sudo apt install -y python3-pip sshpass git
pip3 install ansible
```

### Install `Docker`

The `Ubuntu` Server 

Follow the installation instructions in the **official `Docker` docs**:
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Run:

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

Followed by:
```sh
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Verify that the installation is successful by running the `hello-world` image:

```sh
$ sudo docker run hello-world
```

With that confirmed working, 
go back to the previous step and run the `autobase`command.



## 5. Run `autobase` Console Boot Script

Sample:

```sh
docker run -d --name autobase-console \
  --publish 80:80 \
  --publish 8080:8080 \
  --env PG_CONSOLE_API_URL=http://localhost:8080/api/v1 \
  --env PG_CONSOLE_AUTHORIZATION_TOKEN=secret_token \
  --env PG_CONSOLE_DOCKER_IMAGE=autobase/automation:latest \
  --volume console_postgres:/var/lib/postgresql \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /tmp/ansible:/tmp/ansible \
  --restart=unless-stopped \
  autobase/console:latest
```

You will nee to replace the `localhost` in the `PG_CONSOLE_API_URL` 
with the IP (v4) address of your server
and `secret_token`in the `PG_CONSOLE_AUTHORIZATION_TOKEN`

+ IP: 116.202.31.52 (yours will be different!)
+ Token: 5b0b6259-a7d4-4435-947d-0dff528912ba (create your own!)

Actual: 

```sh
docker run -d --name autobase-console \
  --publish 80:80 \
  --publish 8080:8080 \
  --env PG_CONSOLE_API_URL=http://116.202.31.52:8080/api/v1 \
  --env PG_CONSOLE_AUTHORIZATION_TOKEN=5b0b6259-a7d4-4435-947d-0dff528912ba \
  --env PG_CONSOLE_DOCKER_IMAGE=autobase/automation:latest \
  --volume console_postgres:/var/lib/postgresql \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /tmp/ansible:/tmp/ansible \
  --restart=unless-stopped \
  autobase/console:latest
```


Confirm it worked with the `docker ps` command. You should see something similar to the following:

```sh
CONTAINER ID   IMAGE                     COMMAND                  CREATED              STATUS              PORTS                                                                                    NAMES

9740dfd66c42   autobase/console:latest   "/usr/bin/supervisor…"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 5432/tcp   autobase-console
```


## 6. Login To `autobase`Console Web UI

Visit the IP Address of your server in you web browser e.g: 
http://116.202.31.52/

You should see a login screen:

<img width="686" alt="autobase-console-login" src="https://github.com/user-attachments/assets/66fb030f-80a1-43dd-a118-0f89ec74862a">

Copy-paste the Token you defined in step 5 above.

When you first login you should see that there are **No Postgres Clusters**:

<img width="2032" alt="autobase-no-clusters" src="https://github.com/user-attachments/assets/97c64e3b-c7a2-4325-a4e0-6a89b0d94934">

## 7.  Create Postgres Cluster

Click the "**CREATE CLUSTER**" button:

<img width="169" alt="create-cluster-button" src="https://github.com/user-attachments/assets/66ef1875-2216-41a5-ace9-6541e8f5df74">

Select `hetzner`and the datacenter region you prefer, in our case Europe:

<img width="2032" alt="create-cluster-europe" src="https://github.com/user-attachments/assets/d727159b-7d18-4032-8b70-b16367b288a4">

The default disk storage is **`100Gb`**; 

<img width="2032" alt="cluster-disk-storage" src="https://github.com/user-attachments/assets/aebde3e2-ef97-4470-8881-3c55e6d9e0a5">

this is _way_ too much for most simple projects.
lower it to **`10Gb`** for each instance to instantly save **50%** of the cost! 
(you're welcome!)

<img width="2032" alt="disk-storage-10gb" src="https://github.com/user-attachments/assets/cf2fb520-adee-4a9e-a0a7-616a0de91515">

> **Note**: all values for `DISK`storage, `RAM`, and `CPU`can easily be scaled later. 

Finally, you'll need to add your `public` SSH key.

### Copy Your SSH Public Key

```sh
cat ~/.ssh/id_ed25519.pub | pbcopy
```

Paste it into the `SSH public key*`field:

<img width="2032" alt="add-ssh-key" src="https://github.com/user-attachments/assets/37643591-3493-43a2-8006-475084ac6bd2">

Then scroll down and click the "**CREATE CLUSTER**" button.

You will see a modal window appear prompting you to input a `Hetzner`API Key:

<img width="476" alt="hetzner-api-key-modal" src="https://github.com/user-attachments/assets/7afb3582-6baf-4958-bdc0-fe46ba957e02">

### 8. Generate an API token

Follow the instructions in the official `Hetzner` docs:
https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/

In the `Hetzner`console, navigate to **Security** > **API tokens**.
You should see the message:
"**You haven't generated an API token yet.**"

<img width="2032" alt="hetzner-api-tokens" src="https://github.com/user-attachments/assets/3182d76c-9b8f-40b6-8078-fd84cdc1c90d">

Click on the "**Generate API token**" button:

<img width="205" alt="generate-api-token" src="https://github.com/user-attachments/assets/bf41fc91-ca03-4ba2-ae18-5963958ffb13">

That will open _another_ modal window, input the description for your key, 
e.g:
"postgres-cluster-api-key" 
and select "**Read and Write**":

<img width="559" alt="generate-api-token-modal" src="https://github.com/user-attachments/assets/d8d3d576-b59f-4647-b3ad-c09d68f5a11c">

Finally, click on the "**Generate API token**" button.
You should see a confirmation message:

<img width="2032" alt="token-created" src="https://github.com/user-attachments/assets/970af4d5-5244-4bbb-a0c0-aa6668e6a6fa">

Click to reveal the token you created:

<img width="562" alt="copy-token" src="https://github.com/user-attachments/assets/97258059-1101-4cc6-9728-cd1501254b29">

Copy the token to your clipboard, e.g:

```sh
zH2qdgCeogrKjVKgV7sngMRxCfewgSdDARUBr8yqcjuHhGzlNdY72H13Sjh1il2D
```

Paste it into the Cluster creation window:

<img width="2032" alt="paste-token-in-auto-window" src="https://github.com/user-attachments/assets/670e1a21-51ff-4922-a432-adf350fb7a22">

_Optionally_ save the API Key to the console and then 
click "**CREATE CLUSTER**":

<img width="476" alt="create-cluster" src="https://github.com/user-attachments/assets/cc55c520-760d-42c1-82f6-026b07cfa976">

created:

<img width="2032" alt="cluster-created" src="https://github.com/user-attachments/assets/e554b8c9-17d5-45c9-b892-a3e9692e0b6a">

Cluster details:

<img width="2032" alt="cluster-details" src="https://github.com/user-attachments/assets/9e2dc83a-6332-4d06-9b52-070111fc6607">

The `Postgres` cluster _appears_ to be deployed,
but how do we _know_ that it worked?

## 9. Test The Cluster! 👩‍🔬

First: _connect_ to the **primary** `Postgres` instance.
In our case this is: `10.0.1.4`

<img width="471" alt="postgres-primary" src="https://github.com/user-attachments/assets/ba8207c2-47e5-48ab-8301-da6e35000a6b">

Sample:

```sh
export PGPASSWORD='password';
psql -h 127.0.0.1 -p 5432 -U postgres -d postgres
```

Get the **Password** and  **Port** from the **Connection info** panel:

<img width="461" alt="postgres-connection-info" src="https://github.com/user-attachments/assets/0b28c930-e403-4cda-8356-7b307b7f53bc">

Actual:

```sh
export PGPASSWORD='9Djw2LNRMWwaDS1F9TlxeXiGj4dV3zNk';
psql -h 88.99.81.115 -p 5432 -U postgres -d postgres
```

```sh
psql -h 10.0.1.4 -p 6432 -U postgres -d postgres
```

```sh
psql -h 10.0.1.4 -p 6432 -U postgres -d postgres -c "select version()"
```

Got the following error:

```sh
Command 'psql' not found, but can be installed with:

apt install postgresql-client-common
```

This is a barebones `Ubuntu` instance, remember, so it's not surprising that it doesn't have `psql` installed. So follow the instruction and install it:

```sh
sudo apt install postgresql-client-common
```

The output is:

But when trying to run `psql` again, we still get an error:

```sh
Error: You must install at least one postgresql-client-<version> package
```



## Outro:

Given that this is a technical guide for an evolving system, 
it may need to be enhanced/extended or updated in future,
that will be done on GitHub; 
_everyone_ is welcome to and _encouraged_ to contribute!
Again, link in the description.

Thanks for watching/listening.
If you found it useful and want to see more,
please subscribe. 


## Privacy Disclaimer

By the time you read/watch this, 
all of the sensitive data such as passwords, IP addresses, 
public keys and auth tokens will have been updated.
This avoids anyone getting ideas about accessing backend systems.

We publish our notes and videos on how we do things
so that we can be as transparent as possible.
We have a strong security & privacy focus for all our systems
so all private backend systems like databases are always locked down.

As always, if you have a security question or concern, 
Please contact us responsibly.

