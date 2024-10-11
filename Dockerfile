# Build stage
FROM node:lts-alpine AS builder

USER root
WORKDIR /home/node

COPY package*.json .
RUN npm ci

COPY --chown=root:root . .
RUN npm run build && npm prune --omit=dev

# Final run stage
FROM node:lts-alpine AS runner

ENV NODE_ENV production

USER root
WORKDIR /home/node

COPY --from=builder --chown=root:root /home/node/package*.json .
COPY --from=builder --chown=root:root /home/node/node_modules/ ./node_modules
COPY --from=builder --chown=root:root /home/node/dist/ ./dist

EXPOSE 8000
ENV PORT 8000
