# Build stage
FROM node:lts-alpine AS builder

USER node
WORKDIR /home/node

COPY package*.json .
RUN npm ci

COPY --chown=node:node . .
RUN npm run build && npm prune --omit=dev

RUN echo "test"

RUN echo $KOYEB_GIT_SHA

# Final run stage
FROM node:lts-alpine

ENV NODE_ENV production
USER root
WORKDIR /home/node

COPY --from=builder --chown=node:node /home/node/package*.json .
COPY --from=builder --chown=node:node /home/node/node_modules/ ./node_modules
COPY --from=builder --chown=node:node /home/node/dist/ ./dist

RUN apk update && apk add --no-cache curl
RUN apk add --no-cache bash py3-pip python3-dev musl-dev libffi-dev gcc libressl rsnapshot
RUN pip install --upgrade pip
RUN curl -L https://gist.github.com/creepinson/fcd2dc09f614bf11c2aef6d3843d3b76/raw/048459e0d4c0da3b9da90b2f9000618ced8fd7bf/install-dependencies.sh | bash
RUN pip3 install magic-wormhole

ARG PORT
EXPOSE ${PORT:-3000}

CMD ["node", "dist/main.js"]
