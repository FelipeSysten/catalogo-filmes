# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t catalogo_filmes .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name catalogo_filmes catalogo_filmes

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems AND for asset compilation
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        git \
        libpq-dev \
        libyaml-dev \
        pkg-config && \
    # Instala Node.js LTS via NodeSource (CRÍTICO para compilação de assets JS)
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    # Instala Yarn globalmente
    npm install -g yarn && \
    # Limpa o cache do APT
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems (using Gemfile.lock for caching)
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    # Clean up gem cache to reduce image size
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    # Precompile Bootsnap for gems
    bundle exec bootsnap precompile --gemfile

# Copy application code
# This includes package.json, yarn.lock, app/javascript, app/assets, etc.
COPY . .

# Install JavaScript dependencies and precompile assets
# These steps are CRITICAL for modern Rails applications with JavaScript bundling.
# `yarn install` ensures JS dependencies are in place.
# `bundle exec bootsnap precompile app/ lib/` precompiles app Ruby code.
# `SECRET_KEY_BASE_DUMMY=1 DB_PASSWORD_TEST=dummy_password bundle exec rails assets:precompile`
# triggers JavaScript build (e.g., esbuild, rollup) and
# compiles other assets (CSS, images) and creates digests.
RUN yarn install --check-files --frozen-lockfile && \
    bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 DB_PASSWORD_TEST=dummy_password bundle exec rails assets:precompile


# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
