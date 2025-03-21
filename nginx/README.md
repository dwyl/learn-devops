# `nginx` Fast Setup

This is a speed run of using `nginx`
to proxy an app on a `Hetzner` server.

## 1. Install `nginx` on `Ubuntu`

Official instructions:
https://ubuntu.com/tutorials/install-and-configure-nginx#1-overview

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

Visit:
http://88.99.81.115

![nginx-running](https://github.com/user-attachments/assets/f8754c78-7243-4844-9ab6-eb642d4ab2e7)



## 2. Certbot

Instructions:
https://certbot.eff.org/instructions?ws=nginx&os=ubuntufocal

```sh
sudo snap install --classic certbot
```

Output:

```sh
2025-03-21T11:48:11Z INFO Waiting for automatic snapd restart...
certbot 3.3.0 from Certbot Project (certbot-eff✓) installed
```

Link the command:

```sh
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

```sh
sudo certbot --nginx
```

Output:

```sh
Requesting a certificate for dwy.is

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/dwy.is/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/dwy.is/privkey.pem
This certificate expires on 2025-06-19.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

Deploying certificate
Successfully deployed certificate for dwy.is to /etc/nginx/sites-enabled/default
Congratulations! You have successfully enabled HTTPS on https://dwy.is

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

Dry run renewal:

```sh
sudo certbot renew --dry-run
```

```sh
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Processing /etc/letsencrypt/renewal/dwy.is.conf
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Account registered.
Simulating renewal of an existing certificate for dwy.is

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Congratulations, all simulated renewals succeeded:
  /etc/letsencrypt/live/dwy.is/fullchain.pem (success)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

## 3. Configure `nginx` Proxy

```sh
cd /etc/nginx/
```