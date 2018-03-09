FROM ruby:2.3-slim

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=1

RUN apt-get update \
 && apt-get install -y \
    curl \
    libmysqlclient-dev \
    nginx \
    nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && rm /etc/nginx/sites-enabled/default \
 && echo "install confd" \
 && curl --silent --show-error --location --output /usr/local/bin/confd "https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64" \
 && echo "a67bab5d6c6d5bd6c5e671f8ddd473fa67eb7fd48494d51a855f5e4482f2d54c /usr/local/bin/confd" | sha256sum --check - \
 && chmod +x /usr/local/bin/confd \
 && confd --version \
 && echo "install tini" \
 && curl --silent --show-error --location --output /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v0.14.0/tini-amd64" \
 && echo "eeffbe853a15982e85d923390d3a0c4c5bcf9c78635f4ddae207792fa4d7b5e6 /usr/local/bin/tini" | sha256sum --check - \
 && chmod +x /usr/local/bin/tini \
 && tini -s true

WORKDIR /app/

COPY Gemfile* /app/
RUN buildDeps='git-core build-essential' \
  && apt-get update \
  && apt-get install -y --no-install-recommends $buildDeps \
  && rm -rf /var/lib/apt/lists/* \
  && bundle install --without development:test \
  && apt-get purge -y --auto-remove $buildDeps

COPY ./confd /etc/confd
COPY . /app/

RUN DATA_ENCRYPTION_KEY=key_for_precompile DATA_SALT=salt_for_precompile rake assets:precompile tmp:cache:clear \
 && bin/build_pdf.rb public/arcus.pdf

EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/tini", "--"]

CMD ["./docker-start.sh"]

HEALTHCHECK CMD curl --fail --location --insecure http://localhost/admin/login || exit 1
