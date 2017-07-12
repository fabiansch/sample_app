FROM ruby:2.4.1
MAINTAINER Fabian Schimke
LABEL version="0.0"
LABEL description="First image with Dockerfile."

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y \
      build-essential \
      nodejs

# cleanup
RUN apt-get -qy autoremove

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /sample_app
WORKDIR /sample_app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile* ./
RUN gem install bundler && \
    bundle install --jobs 20 --retry 5 --without production

# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# Run the image as a non-root user
RUN useradd -m myuser
USER myuser

## Start puma
CMD bundle exec rails server

