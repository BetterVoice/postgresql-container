PostgreSQL + BDR Dockerfile
===========================

This project can be used to deploy a [PostgreSQL Server](https://www.postgresql.org/) + [BDR](http://bdr-project.org/docs/stable/index.html) cluster using Docker containers. Additional documentation on BDR can be found [here](https://2ndquadrant.com/en/resources/bdr/).

The container has a few built in scripts to help system admins manage the container after it has been launched.

###Start the Container

In order to build a cluster you need 2 or more hosts. On each of those hosts run the following commands to download and launch the container.

```
$] sudo docker pull inteliquent/postgresql:9.4.8_BDR
$] sudo docker run --name pgsql -p 5432:5432/tcp -e PGSQL_INIT=true -d inteliquent/postgresql:9.4.8_BDR
```

###Creating a new Database

When adding a new database the following commands have to be run on each of the master nodes in the cluster.

**_Log into the Container_**

```
$] sudo docker exec -i -t pgsql /bin/bash
```

**_Add a database to the Cluster_**

When adding a database to the cluster make sure to replace the node name `-nn` and IP address `-ba` with the correct values.

```
$] pgsql-create-bdr-db -d bdrdemo -o postgres -n node_1 -ip 127.0.0.1 -p 5432
```
