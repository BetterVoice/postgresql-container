# Ubuntu PostgreSQL.

FROM ubuntu:16.04
MAINTAINER Thomas Quintana <tquintana@inteliquent.com>

# Install an HTTP client.
RUN apt-get update && apt-get install -y wget

# Add the PostgreSQL release repositories for Ubuntu.
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
ADD repos/postgresql.list /etc/apt/sources.list.d/postgresql.list

# Add the BDR release repositories for Ubuntu.
RUN wget --quiet -O - http://packages.2ndquadrant.com/bdr/apt/AA7A6805.asc | apt-key add -
ADD repos/2ndquadrant.list /etc/apt/sources.list.d/2ndquadrant.list

# Install PostgreSQL + BDR Plugin.
RUN apt-get update && apt-get install -y postgresql-bdr-9.4 postgresql-bdr-9.4-bdr-plugin

# Install Dependencies and Tools.
RUN apt-get update && apt-get install -y cron logrotate python python-dev python-pip sudo vim

# Install Python Tools.
RUN pip install --upgrade pip
RUN pip install trt

# Clean Up.
RUN apt-get autoremove && apt-get autoclean

# Add the utility scripts to the conainer.
ADD scripts/pgsql-change-dir /usr/bin/pgsql-change-dir
ADD scripts/pgsql-create-bdr-db /usr/bin/pgsql-create-bdr-db
ADD scripts/pgsql-sync-slave /usr/bin/pgsql-sync-slave
RUN chmod +x /usr/bin/pgsql-change-dir /usr/bin/pgsql-create-bdr-db /usr/bin/pgsql-sync-slave

# Add the PostgreSQL templates to the container.
ADD templates/postgresql/postgresql.conf.template /usr/share/postgresql/9.4/postgresql.conf.template
ADD templates/postgresql/pg_hba.conf.template /usr/share/postgresql/9.4/pg_hba.conf.template
ADD templates/postgresql/recovery.conf.template /usr/share/postgresql/9.4/recovery.conf.template

# Add the logrotate configuration.
ADD templates/logrotate/logrotate.conf /etc/logrotate.conf
ADD templates/logrotate/postgresql /etc/logrotate.d/postgresql

# Open the container up to the world.
EXPOSE 5432/tcp

# Initialize the container and start PostgreSQL.
CMD /bin/bash -c " \
  if [ -z ${PGSQL_INIT+x} ];then \
    service postgresql start; \
    tail -f /var/log/postgresql/postgresql-9.4-main.log; \
    exit 0; \
  fi; \
  PGSQL_INIT=`echo $PGSQL_INIT | awk '{print tolower($0)}'`; \
  if [ $PGSQL_INIT=true ];then \
    echo 'Initializing the BDR PostgreSQL 9.4 Container.'; \
    if [ ! -z ${PGSQL_DATA_DIR+x} ];then \
      pgsql-change-dir $PGSQL_DATA_DIR; \
    fi; \
    if [ ! -z ${PGSQL_DEPLOYMENT_TYPE+x} ] && \
       [ ! -z ${PGSQL_ROLE+x} ] && \
       [ ! -z ${PGSQL_MASTER_ADDRESS+x} ] && \
       [ ! -z ${PGSQL_MASTER_PORT+x} ];then \
      if [ $PGSQL_DEPLOYMENT_TYPE=replicated ] && [ $PGSQL_ROLE=slave ];then \
        if [ ! -z ${PGSQL_DATA_DIR+x} ];then \
          pgsql-sync-slave -d $PGSQL_DATA_DIR \
                           -h $PGSQL_MASTER_ADDRESS \
                           -p $PGSQL_MASTER_PORT; \
          trt -s /usr/share/postgresql/9.4/recovery.conf.template \
              -d $PGSQL_DATA_DIR/recovery.conf \
              -ps environment; \
        else \
          pgsql-sync-slave -d /var/lib/postgresql/9.4/main \
                           -h $PGSQL_MASTER_ADDRESS \
                           -p $PGSQL_MASTER_PORT; \
          trt -s /usr/share/postgresql/9.4/recovery.conf.template \
              -d /var/lib/postgresql/9.4/main/recovery.conf \
              -ps environment; \
        fi; \
      fi; \
    fi; \
    trt -s /usr/share/postgresql/9.4/postgresql.conf.template \
        -d /etc/postgresql/9.4/main/postgresql.conf \
        -ps environment; \
    trt -s /usr/share/postgresql/9.4/pg_hba.conf.template \
        -d /etc/postgresql/9.4/main/pg_hba.conf \
        -ps environment; \
    if [ ! -z ${PGSQL_PASSWORD+x} ];then \
      service postgresql start; \
      sudo -u postgres psql -U postgres -d postgres \
           -c 'alter user postgres with password '$PGSQL_PASSWORD';'; \
      service postgresql stop; \
    fi; \
  fi; \
  service postgresql start; \
  tail -f /var/log/postgresql/postgresql-9.4-main.log; \
"
