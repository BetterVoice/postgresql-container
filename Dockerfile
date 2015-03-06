# Ubuntu PostgreSQL.

FROM ubuntu:14.04
MAINTAINER Thomas Quintana <thomas@bettervoice.com>

# Install.
RUN apt-get update && apt-get install -y postgresql-9.3 postgresql-client-9.3

# Post Install Configuration.
RUN cp /etc/postgresql/9.3/main/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf.bak
RUN sed -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" \
#	-e "s/ssl_cert_file = '\/etc\/ssl\/certs\/ssl-cert-snakeoil.pem'/ssl_cert_file = '\/etc\/ssl\/certs\/bv-postgres.pem'/" \
#	-e "s/ssl_key_file = '\/etc\/ssl\/private\/ssl-cert-snakeoil.key'/ssl_key_file = '\/etc\/ssl\/private\/bv-postgres.key'/" \
	-e "s/shared_buffers = 128MB/shared_buffers = 3750MB/" < /etc/postgresql/9.3/main/postgresql.conf.bak > /etc/postgresql/9.3/main/postgresql.conf
RUN echo "host	all	all	samenet	md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# Open the container up to the world.
EXPOSE 5432/tcp

# Start PostgreSQL.
CMD service postgresql start && tail -F /var/log/postgresql/postgresql-9.3-main.log
