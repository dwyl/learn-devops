# `nginx` Fast Setup

This is a speed run of using `nginx`
to proxy an app on a `Hetzner` server.

## 1. Install `nginx` on `Ubuntu`

```sh
sudo apt install nginx
```

That installs and automatically starts the `nginx` server.

Check the status:

```sh
service nginx status
```

Output:

```sh
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Fri 2025-03-21 10:49:46 UTC; 56s ago
       Docs: man:nginx(8)
    Process: 754 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 778 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 803 (nginx)
      Tasks: 3 (limit: 4540)
     Memory: 3.7M (peak: 3.8M)
        CPU: 34ms
     CGroup: /system.slice/nginx.service
             ├─803 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             ├─804 "nginx: worker process"
             └─805 "nginx: worker process"
```

Official instructions:
https://ubuntu.com/tutorials/install-and-configure-nginx#1-overview

