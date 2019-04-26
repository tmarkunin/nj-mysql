FROM mariadb:10.4

ADD sql/ /docker-entrypoint-initdb.d

ENV MYSQL_ROOT_PASSWORD password
ENV MYSQL_DATABASE test


EXPOSE 3306

CMD ["mysqld"]