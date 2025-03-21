<div align="center">

<img width="400" src="https://github.com/user-attachments/assets/309acbc1-7cfa-4205-afc3-5e17db251e43" 
alt="Postgres logo wide" />

# Deployment

</div>

`Postgres` deployment is split into two options:

1. Managed - the infrastructure provider manages the instances for you
   including data backups and failover in the event of a crash/corruption.

2. Unmanaged - we the engineers or operations team need to manage it
   including data integrity and availability.

Both have their place.
But if you are not an _experienced_
Database Administrator
([DBA](https://en.wikipedia.org/wiki/Database_administration))
or System Administrator
([SysAdmin](https://en.wikipedia.org/wiki/System_administrator)),
you should seriously consider a _managed_ service.
The risk of data loss greatly outweighs
the cost of a _managed_ service.

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
has **_deliberately_ confusing pricing**:
[aws.amazon.com/rds/aurora/pricing](https://aws.amazon.com/rds/aurora/pricing)
They have costs for I/O requests, storage,
backtrack (backup) and data transfer.
By contrast `DigitalOcean` has _transparent_
pricing based on the VPS (Memory, CPU and SSD) used.
But `DigitalOcean` also gets _very_ expensive ...
So we decided to invest the time to _self-manage_.
