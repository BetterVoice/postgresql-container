PostgreSQL Dockerfile
==================

This project can be used to deploy a PostgreSQL server inside a Docker container. There are two kinds of deployment types for this container standalone and replicated. When the container is deployed in a replicated deployment the container can serve one of two roles master and slave. Finally, the container also supports continuous archiving to S3 as an additional measure of precaution.

### Running the Container

To run a standalone container with all the default settings.

```sudo docker run --name postgresql -p 5432:5432/tcp bettervoice/postgresql:9.3```

### Deployment Environment Variables

**PG_DEPLOYMENT_TYPE** - The type of database deployment. Possible options are "standalone" and "replicated". (default: standalone)

**PG_ROLE** - The role played by the container. Possible options are "master" and "slave". (default: master)

**PG_PASSWORD** - The password for the postgres user. (default: bettervoice)

### Database Configuration Environment Variables

**PG_ALLOWED_ADDRESSES** - A comma separated list of IP addresses allowed to connect to the database. They can be a host name, made up of an IP address and a CIDR mask that is an integer (between 0 and 32 (IPv4) or 128 (IPv6) inclusive) that specifies the number of significant bits in the mask. Instead of a CIDR-address, you can write "samehost" to match any of the server's own IP addresses, or "samenet" to match any address in any subnet that the server is directly connected to. (default: 0.0.0.0/0)

**PG_MAX_CONNECTIONS** - The maximum number of supported connections to the database. (default: 100)

**PG_PORT** - The port number used by the database. (default: 5432)

**PG_SHARED_BUFFERS** - Sets the amount of memory the database server uses for shared memory buffers in megabytes. (default: 128)

**PG_DATA_DIRECTORY** - Specifies the directory to use for data storage. (default: /var/lib/postgresql/9.3/main)

**PG_WAL_LEVEL** - Determines how much information is written to the WAL. (default: minimal)

**PG_CHECKPOINT_SEGMENTS** - Maximum number of log file segments between automatic WAL checkpoints (each segment is normally 16 megabytes). (default: 32)

**PG_MAX_WAL_SENDERS** - Specifies the maximum number of concurrent connections from standby servers or streaming base backup clients. (default: 3)

**PG_WAL_KEEP_SEGMENTS** - Specifies the minimum number of past log file segments kept in the pg_xlog directory, in case a standby server needs to fetch them for streaming replication. (default: 8)

**PG_REPLICATION_USER** - The user name used by the slave for replication. (default: replicator)

**PG_REPLICATION_USER_PASSWORD** - The password for the replication user. (default: bettervoice)