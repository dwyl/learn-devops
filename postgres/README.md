# `Postgres` Setup

`Postgres` deployment is divided into two options:

1. Managed - the infrastructure provider manages the instances for you.
2. Unmanaged - we the engineers or operations team need to manage it.

Both have their place.
But if you are not an _experienced_
Database Administrator (DBA)
or System Administrator (SysAdmin),
you should seriously consider a _managed_ service.

With that in mind we have prepared a quick guide
to deploying _managed_ `Postgres` on `DigitalOcean`:
[`/managed-postgres-digitalocean.md`](./managed-postgres-digitalocean.md)

If you are still feeling adventurous,
or curious to see how the _unmanaged_ setup works,
see:
[`/postgres/self-managed-vps.md`](./postgres/self-managed-vps.md)

There are _many_ other options for "cloud" providers
for managed `Postgres` and other `SQL` databases.
We looked at all the major ones including
`AWS`, `GCP`, `Azure`.
Sadly, `AWS Aurara` while appealing, 
has _deliberately_ confusing pricing:
https://aws.amazon.com/rds/aurora/pricing
They have costs for I/O requests, storage,
backtrack (backup) and data transfer.
By contrast `DigitalOcean` has _transparent_
pricing based on the VPS (Memory, CPU and SSD) used.
