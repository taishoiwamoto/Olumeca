FROM ruby:3.1.2 as base

WORKDIR /Olumeca

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    sudo \
    postgresql \
    postgresql-contrib \
    curl \
    libvips \
    libpq5 \
    openssl \
    tzdata

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
