<div align="center">
  <h1>Connect to Local <code>Gogs</code> Server on RaspberryPi</h1>

</div>


> **Prerequisite**: This guide assumes you already have `Gogs`
running on a local **`RaspberryPi`**. <br />
If you don't, please
see: [`/install-gogs-raspberrypi.md`]()

## Two Options: `SSH` & `REST`

In this guide we are connecting to `Gogs` via two methods:

1. **`SSH`** - this gives us the full `Git` experience.
2. **`REST API`** - subset of actions but `JSON` interface.
see: https://github.com/gogs/docs-api


## 1. Connect via `SSH`

There are a couple of steps here.

### 1.1 Add your Public SSH Key to `Gogs`

> Note: this step assumes you already have an SSH Key.
> If you don't already have an SSH Key,
> follow these steps first:
> https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent


Copy the ***`public`*** `ssh` key on your main computer.
In my case the `id_rsa.pub` file is located at 
`~/.ssh/id_rsa.pub` 
on my Mac.
So to copy the contents of the file, 
I run the following command:

```sh
pbcopy < ~/.ssh/id_rsa.pub 
```

Next, connect to the `Gogs` Server running on the RaspberryPi from my Mac,
and visit the `/user/settings/ssh` page:  http://192.168.1.196/user/settings/ssh

<img width="1143" alt="image" src="https://user-images.githubusercontent.com/194400/164250739-eafe33ff-0ab3-46d5-a0ec-bdb0f250b24c.png">

> Note: The IP address of your RaspberryPi on your network will be different.

Click on the (blue) **`Add Key`** button, and you will see the following input:

<img width="1169" alt="image" src="https://user-images.githubusercontent.com/194400/164257659-ed8310e4-330c-43e8-b6c8-a2045f12314f.png">

Once you have pasted the contents of the 
`id_rsa.pub` file into the **`Content`** textarea field, 
click on the (_green_) **`Add Key`** button below the input.


You should see a message confirming that the 
"**New SSH key** was added successfully!"
e.g:

<img width="1186" alt="image" src="https://user-images.githubusercontent.com/194400/164258071-40832cf6-a6ff-464a-ab98-b033942ec829.png">



### 1.2 Clone a Repository

During the `Gogs` server setup,
I had previously created a test repository:
http://192.168.1.196/nelsonic/my-awesome-repo

<img width="1148" alt="image" src="https://user-images.githubusercontent.com/194400/164259188-95e2407c-73b1-46a6-9c38-f2daf4215994.png">

In the UI there is a link you can copy to clone the repository,
annoyingly the link has a base URL of `localhost`
i.e. `git@localhost:nelsonic/my-awesome-repo.git`

If we replace the `localhost` with the IP address of the RaspberryPi
in our case `192.168.1.196` then the `git clone` command will work:

```
git clone git@192.168.1.196:nelsonic/my-awesome-repo.git
```

You will see output similar to the following:

```sh
Cloning into 'my-awesome-repo'...
remote: Enumerating objects: 8, done.
remote: Counting objects: 100% (8/8), done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 8 (delta 1), reused 0 (delta 0)
Receiving objects: 100% (8/8), 6.86 KiB | 6.86 MiB/s, done.
Resolving deltas: 100% (1/1), done.
```

Change into the repo directory e.g:

```sh
$ cd my-awesome-repo
$ ls

LICENSE		README.md
```


### 1.3 Make Changes to the `README.md` of the Repo

Open the `README.md` file in your editor,
e.g:

```sh
vi README.md
```


<img width="697" alt="image" src="https://user-images.githubusercontent.com/194400/164260417-bd970d49-a3f8-4f57-9117-276518ed7ec7.png">

Make a basic change/addition to `README.md` 
and save the file.


### 1.4 Commit and Push the Change

```sh
git add . && git commit -m 'update README.md on mac'
```

You should see output similar to:

```sh
[master be03eb4] update README.md on mac
 1 file changed, 3 insertions(+), 1 deletion(-)
```

Push the changes to the `Gogs` server:

```sh
git push
```

You should see output similar to the following:

```sh
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 315 bytes | 315.00 KiB/s, done.
Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
To 192.168.1.196:nelsonic/my-awesome-repo.git
   623a46d..be03eb4  master -> master
```

Visit the repo in your web browser:
http://192.168.1.196/nelsonic/my-awesome-repo

confirm that the change was persisted to the `Gogs` server.

<img width="1158" alt="gogs-update-readme-file-on-mac" src="https://user-images.githubusercontent.com/194400/164272289-4cf4defb-d233-4336-a0f9-43262d2f8d9d.png">

Success!

<br />


## 2. Connect via `REST API` (`HTTPS`)

The second way of connecting to `Gogs` is via the REST API.
Here we will be following and expanding on the official docs:
https://github.com/gogs/docs-api

Visit: `/user/settings/applications` of your `Gogs` instance,
e.g: 
http://192.168.1.196/user/settings/applications

<img width="1161" alt="gogs-create-access-token" src="https://user-images.githubusercontent.com/194400/164336619-d4f9e5b7-ae40-4b1d-8af5-fce06aba531d.png">

And click on **`Generate New Token`**.

Then input the name of your token,
in case you end up with multiple tokens.

<img width="1161" alt="gogs-generate-token" src="https://user-images.githubusercontent.com/194400/164336855-43378a2f-99a3-460b-931f-cfed939ba54a.png">

Token generated:

<img width="1160" alt="image" src="https://user-images.githubusercontent.com/194400/164337037-9b1d4dcf-cdbc-4302-9134-8c9c9d13de97.png">

My access token is: 
**`04b3e63399da5e04258bf56ede5ad7646f1cda35`**.
We will be using this below. Make a note of yours.

> Don't worry, this is only valid for my test instance on my local RaspberryPi.
By the time you read this I will have already reset it and the token will be invalid. 


With this access token in-hand we can now run `cURL` commands
to test the REST API, e.g:

```sh
curl -u "nelsonic" 'http://192.168.1.196/api/v1/users/unknwon/tokens'
```

Response:

```sh
[{"name":"Mac\u003c-\u003eRPI","sha1":"04b3e63399da5e04258bf56ede5ad7646f1cda35"}]%   
```

> OK, I regret naming my token **`Mac<->RPI`** now ... 🙄
> But you get the idea. It works!


```sh
curl 'http://192.168.1.196/api/v1/repos/nelsonic/my-awesome-repo?token=04b3e63399da5e04258bf56ede5ad7646f1cda35'
```

```json
{
	"id": 1,
	"owner": {
		"id": 1,
		"username": "nelsonic",
		"login": "nelsonic",
		"full_name": "",
		"email": "nelson@gmail.com",
		"avatar_url": "https://secure.gravatar.com/avatar/f937427bea8db9d88608a54b2b803f1a?d=identicon"
	},
	"name": "my-awesome-repo",
	"full_name": "nelsonic/my-awesome-repo",
	"description": "test repo",
	"private": false,
	"fork": false,
	"parent": null,
	"empty": false,
	"mirror": false,
	"size": 49152,
	"html_url": "http://localhost:3000/nelsonic/my-awesome-repo",
	"ssh_url": "git@localhost:nelsonic/my-awesome-repo.git",
	"clone_url": "http://localhost:3000/nelsonic/my-awesome-repo.git",
	"website": "",
	"stars_count": 1,
	"forks_count": 0,
	"watchers_count": 1,
	"open_issues_count": 1,
	"default_branch": "master",
	"created_at": "2022-04-12T16:06:13Z",
	"updated_at": "2022-04-12T16:06:13Z",
	"permissions": {
		"admin": true,
		"push": true,
		"pull": true
	}
}
```

curl -I http://192.168.1.196/api/v1/repos/nelsonic/my-awesome-repo?token=04b3e63399da5e04258bf56ede5ad7646f1cda35

```
curl -H "Authorization: token 04b3e63399da5e04258bf56ede5ad7646f1cda35" http://192.168.1.196/api/v1/repos -H "Accept: application/json" 
```

```sh
/api/v1/repos/:username/:reponame/raw/:ref/:path
```

Example:

```sh
curl 'http://192.168.1.196/api/v1/repos/nelsonic/my-awesome-repo/raw/master/README.md?token=04b3e63399da5e04258bf56ede5ad7646f1cda35'
```

Response:

```md
# My Awesome Repo!

This is my Markdown editor.
It totally works in the browser.

Updated in Vim on Mac. 
```


<br /><br />

[![HitCount](http://hits.dwyl.com/dwyl/learn-devops-gogs-connect-rpi.svg)](http://hits.dwyl.com/dwyl/learn-devops-gogs)