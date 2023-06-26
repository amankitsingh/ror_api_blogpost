# Use the official Ruby image as the base image
FROM ruby:3.0.2

ENV BUNDLER_VERSION=2.4.14

# Install dependencies for PostgreSQL
RUN apt-get update -qq \
    && apt-get install -y  build-essential postgresql-client
    # && rm -rf /var/lib/apt/lists/*
		
# Set environment variables for database configuration
# ENV DATABASE_URL="postgresql://postgres@db:5432/index_developement"

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install the project dependencies
RUN bundle check || bundle install 

# Copy the entire project directory to the container
COPY . .


# Start the Rails server when the container starts
ENTRYPOINT ["./docker-entrypoint.sh"]

