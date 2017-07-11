FROM ruby:2.4.1-slim

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \
  build-essential \
  nodejs


# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /sample_app
WORKDIR /sample_app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test

# Set Rails to run in production
ENV RAILS_ENV production
ENV CCS_BIND_APP bridge-app
ENV PORT 80
EXPOSE 80

# Copy the main application.
COPY . ./

ARG rails_master_key

# Precompile Rails assets
RUN bundle exec rails assets:clobber    RAILS_MASTER_KEY=$rails_master_key
RUN bundle exec rails assets:precompile RAILS_MASTER_KEY=$rails_master_key

# Start puma
CMD bundle exec puma -C config/puma.rb
