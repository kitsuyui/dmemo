FROM ruby:2.6.2-slim-stretch
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev default-libmysqlclient-dev nodejs-legacy curl git
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get -y install nodejs
RUN mkdir /app

RUN export FREETDS_HASH=f3ce8e48bc8fd08777a35c7fc0a26b6c8e7e53748c8c0afec49231df93afcdee && \
    export FREETDS_VERSION=freetds-1.1.6 && \
    mkdir /tmp/freetds && \
    cd /tmp/freetds && \
    curl -o "${FREETDS_VERSION}.tar.gz" "ftp://ftp.freetds.org/pub/freetds/stable/${FREETDS_VERSION}.tar.gz" && \
    echo "${FREETDS_HASH}  ${FREETDS_VERSION}.tar.gz" | sha256sum -c && \
    tar -xzf "${FREETDS_VERSION}.tar.gz" && \
    cd "${FREETDS_VERSION}" && \
    ./configure --prefix=/usr/local --with-tdsver=7.3 && \
    make && \
    make install

ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
RUN cd /tmp && bundle install -j5 --deployment --without test

ADD vendor/assets/package.json /tmp/vendor/assets/package.json
RUN cd /tmp/vendor/assets && npm install && rm -rf node_modules/jquery

WORKDIR /app
RUN mv /tmp/vendor /app
ADD . /app

# Avoid Missing `secret_key_base` Error
RUN SECRET_KEY_BASE=dummy \
    bundle exec rake assets:precompile RAILS_ENV=production

CMD ["./bin/docker_start.sh"]
