FROM node:14.15.4-alpine

COPY runner.sh /usr/local/bin/runner

RUN chmod +x /usr/local/bin/runner \
    && apk update \
    && apk --quiet add openrc bash wget ca-certificates \
    && rm -rf /var/cache/apk/*

# Postgres installation 
RUN apk add postgresql postgresql-contrib \
    && (addgroup -S postgres && adduser -S postgres -G postgres || true) \
    && mkdir -p /var/lib/postgresql/data \
    && mkdir -p /run/postgresql/ \
    && chown -R postgres:postgres /run/postgresql/ \
    && chmod -R 777 /var/lib/postgresql/data \
    && chown -R postgres:postgres /var/lib/postgresql/data \
    && su - postgres -c "initdb /var/lib/postgresql/data" \
    && echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf

ENTRYPOINT [ "/usr/local/bin/runner" ]