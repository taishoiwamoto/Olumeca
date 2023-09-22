# From the Ruby base image
FROM ruby:3.1.2 as base

# Create a directory
WORKDIR /Olumeca

# Install dependencies in the container
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

# Copy the Gemfile and the Gemfile.lock in the container app folder.
COPY Gemfile .
COPY Gemfile.lock .

# Install ruby gems
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
