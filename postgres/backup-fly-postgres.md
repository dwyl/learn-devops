# How to Backup Fly.io Postgres Database


## Why? 🤷‍♀️

You need to get the data
from a Fly.io `Postgres` instance.

## How? 👩‍💻

### 0. Before You Start

Before you attempt to access the `Postgres` database on `Fly.io`,
ensure you are authenticated with your `Fly.io` account;
run the command:

```sh
fly auth whoami
```

This will confirm you are (or not) authenticated.
If you not, use the command:

```sh
fly auth login
```

And follow the instructions.

### 1. Forward the server port to your `localhost`

> **Note**: if you have `Postgres` running locally on `TCP` Port `5432`,
> you may need to temporarily shut it down
> while performing this command as it will
> need to use the `Postgres` `TCP` Port `5432`.

```sh
fly proxy 5432 -a {postgres-app-name}
```

In our case it was:

```sh
fly proxy 5432 -a hits-db
```

In our terminal we saw the following: 

```sh
Proxying local port 5432 to remote [hits-db.internal]:5432
```

### 2. Use the `pg_dump` command to generate the backup

Sample:

```sh
pg_dump -h localhost -U {username} -d {database name} > backup.sql
```

Or:

```sh
pg_dump -p 5432 -h localhost -U postgres -W -c -f flyback.bak -d hits
```

In our case we used:

```sh
pg_dump -h localhost -U hits_e2k5m6j4k46d0v7p -d hits --verbose > backup.sql
```

> **Note**: If you need to get the password for the
`Postgres` instance, use the following command:
```sh
flyctl ssh console -a hits -C "printenv DATABASE_URL"
```
> in our case it was:
```sh
flyctl ssh console -a hits -C "printenv DATABASE_URL"
```
We saw:
```sh
postgres://hits_e2k5m6j4k46d0v7p:baf3d9f0bdf155bfetc@hits-db.internal:5432/hits?sslmode=disable
```
Where the first section `postgres://` is the protocol,
the `hits_e2k5m6j4k46d0v7p` is the DB username,
`baf3d9f0bdf155bfetc` is the password
and `hits` is the name of the database.
Ref:
https://community.fly.io/t/how-to-view-environment-variables-in-a-fly-machine/10830/2
Once you have the password,
export it as an environtment variable:
```sh
export PGPASSWORD="$put_here_the_password"
```
> in our case it was:
```sh
export PGPASSWORD="baf3d9f0bdf155bfetc"
```

Our backup was **_several_ gigabytes** so it took a _long_ time to export.
So we included the **`--verbose`** flag to get some visual confirmation
in the terminal while running the `pg_dump` command.

Once the `pg_dump` command finishes, proceed to the next step.

### 3. Close your port forwarding

Kill the connection to the `Fly.io` instance 
using keyboard shortcut: `Ctrl` + `C` (twice).

### 4. Restore your local database

To restore the database you just backed up to `Postgres`
running on your `localhost`,
you _first_ need to ensure that `Postgres` is indeed running!


With the `backup.sql` on your `localhost`,
run the following command in the working directory:

```sh
psql -U {username} -d {database name} < backup.sql
```

In our case on `localhost`:

```sh
psql -U postgres -d hits_dev < backup.sql
```

### 5. _Confirm_ The Backup + Restore _Worked_

Using your choice of `Postgres` query interface
(e.g: [`pgweb`](https://github.com/dwyl/learn-postgresql/issues/94))
we can execute a query on the DB running on `localhost`:
```sql
SELECT COUNT(*) FROM hits h
JOIN repositories r ON h.repo_id = r.id
JOIN users u ON r.user_id = u.id
WHERE r.name = 'start-here'
AND u.name = 'dwyl'
```
e.g: http://localhost:8081/#
<img width="942" alt="image" src="https://github.com/user-attachments/assets/097f5aec-f5cf-44b0-a411-b7920f754818">

`13389` is very close to the actual value: `13392`:

<img width="562" alt="image" src="https://github.com/user-attachments/assets/8fabfa34-c7c5-4405-8721-a56821394957">

i.e. there have been 3 page views on https://github.com/dwyl/start-here since we did the SQL dump a few mins ago. 

We can check the "live" count at: https://hits.dwyl.com/dwyl/start-here.svg e.g: ![hits-start-here-svg](https://hits.dwyl.com/dwyl/start-here.svg)

But this tells us that the DB dump and restore worked. 🎉
So we can now proceed to restoring it on `DigitalOcean`!
[dwyl/learn-devops#90](https://github.com/dwyl/learn-devops/issues/90)


## References 🔗

+ `pg_dump` docs:
https://www.postgresql.org/docs/current/app-pgdump.html
+ Fly.io Backup and Restore `Postgresql` forum thread:
https://community.fly.io/t/backup-and-restore-postgresql/11320
+ How to pass in password to `pg_dump`?
https://stackoverflow.com/questions/2893954/how-to-pass-in-password-to-pg-dump

Thanks + credit to
[@tellodaniel](https://github.com/tellodaniel)
for: "Dump your Fly.io PostgreSQL DB locally"
https://tello.io/blog/flyio-dump-your-postgresql-db-locally
We used his _outline_ as a starting point.


## Context 👎

At the time of writing,
Fly.io still only has _unmanaged_ `Postgres`.
And they recently migrated
one of our (production) DB instances
to a new machine within their data center
which took our App offline:
[dwyl/hits#294](https://github.com/dwyl/hits/issues/294)
sadly, this is far from the _first_ time
that Fly.io has wasted our time with their "You're On Your Own"
`Postgres` ... ⏳ 😢
Ref:
[dwyl/mvp#449](https://github.com/dwyl/mvp/issues/449)
and
[dwyl/auth#325](https://github.com/dwyl/auth/issues/325)
Both of which were company-killing issues
which really soured us to the Fly.io experience. 🙅
**_Zero_ support** even on **_paid_ plan**.
