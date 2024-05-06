# Setup 

## 1. Login to `DigitalOcean`

Login to your `DigitalOcean` account
e.g: 
[cloud.digitalocean.com](https://cloud.digitalocean.com/projects/a2887b9d-c8d1-42b4-b018-c83161fb8146/resources?i=933568)

<img width="1412" alt="image" src="https://github.com/user-attachments/assets/ce506524-fa27-4de8-87bd-e8e28321a5fb">

> **Note**: We've had a
[`DigitalOcean`](https://github.com/dwyl/learn-digitalocean)
account for over a decade, ⏳
but paused our usage in 2018
because our clients were all using
[`AWS`](https://github.com/dwyl/learn-amazon-web-services),
[`Azure`](https://github.com/dwyl/learn-microsoft-azure)
or
[`Heroku`](https://github.com/dwyl/learn-heroku)
all duly documented.
It means our `DO` account is all setup and ready-to-go
but has "_Estimated costs: $0.00_".

## 2. Create!

Click the `Create ▼` button and select "Databases":

<img width="1412" alt="digital-ocean-managed-postgres-create" src="https://github.com/user-attachments/assets/7be915c8-c86a-4305-80cc-79ee84659b60">

On the "Create Database Cluster" chose your desired datacenter region -
in our case `London` -
and "PostgreSQL" as the database engine:

<img width="1481" alt="digital-ocean-managed-postgres-create-database-cluster" src="https://github.com/user-attachments/assets/608921aa-d4c8-4aea-85f9-c183df08c967">

Scroll down the page
and define the
unique database cluster name
and then click
"Create Database Cluster":

<img width="1481" alt="digital-ocean-managed-postgres-create-final" src="https://github.com/user-attachments/assets/1788d983-16e2-4038-8ba5-dc0a5eaf2d9a">

You should see something similar to the following:

<img width="1482" alt="digital-ocean-managed-postgres-creating" src="https://github.com/user-attachments/assets/d0449efa-aaba-4ca2-8aaa-b271244dff97">

It takes a few minutes to provision. ⏳

> **Note**: during setup,
we are starting with the _bare minimum_ **`$15/month`** single instance.
As soon as we _deploy_ something to the this cluster,
we will scale it to 2 instances with more resources
for failover.

## 3. Connect to Cluster

