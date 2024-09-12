# Build stage
FROM node:lts-alpine AS builder

USER root
WORKDIR /home/node

COPY package*.json .
RUN npm ci

COPY --chown=root:root . .
RUN npm run build && npm prune --omit=dev

# Final run stage
FROM node:lts-alpine

ARG KOYEB_GIT_SHA
ENV gitsha=${KOYEB_GIT_SHA}
echo gitsha

ENV NODE_ENV production

USER root
WORKDIR /home/node

COPY --from=builder --chown=root:root /home/node/package*.json .
COPY --from=builder --chown=root:root /home/node/node_modules/ ./node_modules
COPY --from=builder --chown=root:root /home/node/dist/ ./dist

ARG PORT
EXPOSE ${PORT:-3000}

CMD ["node", "dist/main.js"]
