# Build stage
FROM node:lts-alpine AS builder

USER root
WORKDIR /home/node

COPY package*.json .
RUN npm ci

ARG TEST
RUN echo 'TEST'
RUN echo $TEST

COPY --chown=root:root . .
RUN npm run build && npm prune --omit=dev

# Final run stage
FROM node:lts-alpine AS runner

ENV NODE_ENV production

USER root
WORKDIR /home/node

ARG TEST
RUN echo 'TEST'
RUN echo $TEST

COPY --from=builder --chown=root:root /home/node/package*.json .
COPY --from=builder --chown=root:root /home/node/node_modules/ ./node_modules
COPY --from=builder --chown=root:root /home/node/dist/ ./dist

ARG PORT
EXPOSE 8000
