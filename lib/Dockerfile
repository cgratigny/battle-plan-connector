# Use the official Ruby image as a parent image
FROM ruby:3.2.2

# Install dependencies
# For Ruby/Rails
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  npm \
  build-essential \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  libpq-dev \
  libxml2-dev \
  libxslt1-dev \
  python3 \
  wkhtmltopdf \
  libmagickwand-dev \
  libsasl2-dev \
  imagemagick \
  libffi-dev \
  autoconf \
  bison \
  libyaml-dev \
  libgdbm-dev \
  ncurses-dev \
  automake \
  libtool \
  libffi-dev \
  libgmp-dev \
  libreadline-dev \
  libcurl4-openssl-dev \
  libglib2.0-dev \
  libtinfo5
  # And any other dependencies that might be missing

# Here you can install mjml globally
# RUN npm install -g mjml

# Set an environment variable to store where the app is installed to inside of the Docker image.
ENV INSTALL_PATH /battle_planner_app
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be run in and is documented on Docker's website extensively.
WORKDIR $INSTALL_PATH

# RUN touch Dockerfile.dummy && echo "$(date)" > Dockerfile.dummy

RUN gem install bundler:2.4.21

# see https://github.com/cgratigny/align/wiki/000-Sidekiq-Pro-Installation for more config options.
#RUN bundle config --local gems.contribsys.com d188b235:fb122fa

# Copy the dummy file (used to invalidate cache)
# COPY Dockerfile.dummy ./

# Ensure gems are cached and only get updated when they change. This will drastically increase build times when your gems do not change.
COPY Gemfile Gemfile.lock ./

# to avoid mismatches with github urls on the gems
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# bundle install, and if it fails try up to 5 times with a 30 second sleep in between
RUN BUNDLE_GEMS__CONTRIBSYS__COM=d188b235:fb122fac bundle install || for i in {1..5}; do sleep 30 && bundle install && break; done

# Copy in the application code from your work station at the current directory over to the working directory.
COPY . .

# Install dockerize for entrypoint.sh
ENV DOCKERIZE_VERSION v0.6.1

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Copy your entrypoint script into the image and make sure it's executable
# COPY entrypoint.sh /usr/bin/

# RUN chmod +x /usr/bin/entrypoint.sh

# Configure the main process to run when running the image
ENTRYPOINT ["./bin/docker-entrypoint"]

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 3000

# The default command to run via the entrypoint, if no other command is specified
CMD ["rails", "server", "-b", "0.0.0.0"]