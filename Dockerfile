###############################################################################
# Step 1 : Builder image
#
FROM node:8-stretch AS builder

# Change working directory
WORKDIR "/app"

# Update packages and install dependency packages for services
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get clean \
 && echo 'Finished installing dependencies'

ENV NODE_ENV=production


# Install npm production packages
COPY package.json /app/
RUN cd /app; npm install

COPY . /app

###############################################################################
# Step 2 : Test image
#
FROM builder AS test

# Copy the test files
COPY tests tests

# Override the NODE_ENV environment variable to 'dev', in order to get required test packages
ENV NODE_ENV dev
# 1. Get test packages; AND
# 2. Install our test framework - mocha
RUN npm update && \
    npm install -g mocha
# Override the command, to run the test instead of the application
CMD ["mocha", "tests/test.js", "--reporter", "spec", "--exit"]


###############################################################################
# Step 3 : Run image
#
FROM builder AS prod


ENV PORT 3000

EXPOSE 3000

CMD ["npm", "start"]


