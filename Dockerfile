# Ubuntu PostgreSQL.

FROM ubuntu:16.04
MAINTAINER Thomas Quintana <tquintana@inteliquent.com>

# Add the PostgreSQL latest stable release repository for Ubuntu.
RUN apt-get update && apt-get install -y wget
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
ADD repos/pgdg.list /etc/apt/sources.list.d/pgdg.list

# Install PostgreSQL Dependencies.
RUN apt-get update && apt-get install -y apt-utils daemontools libffi-dev libssl-dev logrotate lzop postgresql-9.5 postgresql-client-9.5 postgresql-contrib-9.5 postgresql-9.5-postgis-2.1 python python-dev python-pip sudo

# Install Python Dependencies
RUN pip install --upgrade pip
RUN pip install Jinja2

# Clean Up
RUN apt-get autoremove && apt-get autoclean

# Post Install Configuration.
ADD bin/start-postgres /usr/bin/start-postgres
RUN chmod +x /usr/bin/start-postgres

ADD conf/postgresql.conf.template /usr/share/postgresql/9.5/postgresql.conf.template
ADD conf/pg_hba.conf.template /usr/share/postgresql/9.5/pg_hba.conf.template
ADD conf/recovery.conf.template /usr/share/postgresql/9.5/recovery.conf.template

# Open the container up to the world.
EXPOSE 5432/tcp

# Start PostgreSQL.
CMD start-postgres