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

The full config including the TLS is in
`/etc/nginx/sites-available/default`

## 3. Configure `nginx` Subdomain

```sh
cd /etc/nginx/sites-enabled/autobase.dwy.is
```

Test `nginx` config:

```sh
nginx -t
```

You should see output similar to the following:

```sh
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Test a specific configuration file:

```sh
nginx -t -c /path/to/conf
```

In our case:

```sh
nginx -t -c /etc/nginx/sites-enabled/autobase
```

If your config fails the test for any reason,
try checking it online:
[google.com/search?q=nginx+syntax+check+online](https://www.google.com/search?q=nginx+syntax+check+online)
e.g:
[getpagespeed.com/check-nginx-config](https://www.getpagespeed.com/check-nginx-config)

Restart `nginx`:

```sh
sudo service nginx restart
```

## 4. Wildcard Certificate (Failed)

Wildcard Certificate for Domain:
https://www.baeldung.com/linux/letsencrypt-certbot-add-subdomains

```sh
sudo certbot certonly -i nginx -d example.com -d *.example.com
```

In our case:

```sh
sudo certbot certonly -i nginx -d dwy.is -d *.dwy.is -v
```

Output:

```sh
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
You have an existing certificate that contains a portion of the domains you
requested (ref: /etc/letsencrypt/renewal/dwy.is.conf)

It contains these names: dwy.is

You requested these names for the new certificate: dwy.is, *.dwy.is.

Do you want to expand and replace this existing certificate with the new
certificate?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(E)xpand/(C)ancel: E
Renewing an existing certificate for dwy.is and *.dwy.is
Performing the following challenges:
dns-01 challenge for dwy.is

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.dwy.is.

with the following value:

8GC-85xs1BGQDlU7YKpxA5fyHBV20PqBU8aMA9lAN10

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.dwy.is.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
```

I created the `TXT` record immediatley:

https://ap.www.namecheap.com/domains/domaincontrolpanel/dwy.is/advancedns

![dwyis-txt-record](https://github.com/user-attachments/assets/80ddea19-d06c-4d71-8c8e-f86ee2acd9dc)

But it never propagated ... ⏳

https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.dwy.is

![google-dig-txt](https://github.com/user-attachments/assets/6ccbb156-6c34-4d67-9c13-f69db9b47a76)

I refreshed this like a million times over `48h`
but it never updated.

```sh
dig -t txt _acme-challenge.dwy.is
```

Sadly, adding the wildcard TLS cert was a dead-end
because the `TXT` record never updates on `NameCheap` ...
I guess it's _Cheap_ for a _reason_ ... 😢

...

I decided to contact `NameCheap` support via live chat.


Final output:

```sh
Renewing an existing certificate for dwy.is and *.dwy.is
Reloading nginx server after certificate issuance

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/dwy.is/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/dwy.is/privkey.pem
This certificate expires on 2025-06-21.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```