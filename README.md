PostgreSQL + BDR Dockerfile
===========================

This project can be used to deploy a [PostgreSQL Server](https://www.postgresql.org/) + [BDR](http://bdr-project.org/docs/stable/index.html) cluster using Docker containers. Additional documentation on BDR can be found [here](https://2ndquadrant.com/en/resources/bdr/).

The container has a few built in scripts to help system admins manage the container after it has been launched.

**_Start the Container_**

In order to build a cluster you need 2 or more hosts. On each of those hosts run the following commands to download and launch the container.

```
$] sudo docker pull inteliquent/postgresql:9.4.8_BDR
$] sudo docker run --name pgsql -p 5432:5432/tcp -d inteliquent/postgresql:9.4.8_BDR
```

**_Add a database to the Cluster_**

'''
'''
