<div align="center">

# Migrate `Postgres` DB to `Hetzner` Cluster

</div>

Migrate/restore a snapshot of `Postgres` Database
from `Fly.io` (unreliable) to a
[high availability](https://en.wikipedia.org/wiki/High_availability)
cluster
running on `Hetzner`.

## 0. Before You Start: Get the Snapshot

We wrote _detailed_ instructions for backing up
a `Postgres` DB running on `Fly.io`,
see:
[postgres/backup-fly-postgres.md]

<img width="644" alt="backup.sql" src="https://github.com/user-attachments/assets/71cca34d-02e3-4013-87c3-9da118b2a36c" />

With the `backup.sql` on your `localhost`,
you can start.

## 1. Connect To `Hezner` VPS Using `Cyberduck`

There are several ways to upload large files to a remote server,
we've been using
[`Cyberduck`](https://en.wikipedia.org/wiki/Cyberduck)
for the past few decades and it works very well.
It uses
[`SFTP`](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol)
to securely transfer files
and is Open Source:
[github.com/iterate-ch/cyberduck](https://github.com/iterate-ch/cyberduck)

> The Official Docs are great:
[docs.cyberduck.io](https://docs.cyberduck.io/cyberduck/)
and if you get stuck,
just Google:
[google.com/search?q=cyberduck+tutorial](https://www.google.com/search?q=cyberduck+tutorial)

Open `Cyberduck`
and navigate to the `/tmp` directory of the VPS:

<img width="591" alt="hits-upload-backup-to-hetzner" src="https://github.com/user-attachments/assets/96047430-cc08-4163-be1e-ca4c73071ff1" />

Drag the `backup.sql` file from the `finder` window on `localhost`
to the `Cyberduc` window to start the upload.

<img width="613" alt="hits-upload-backup-in-progress" src="https://github.com/user-attachments/assets/abb82001-f65f-4ae3-8bb5-6b3d5d0f6f2c" />

Take a screen break and refill your water bottle
while you wait for upload to complete.

<img width="613" alt="hits-upload-complete" src="https://github.com/user-attachments/assets/f8400730-aefb-4f72-b45f-ded1adf68ba4" />