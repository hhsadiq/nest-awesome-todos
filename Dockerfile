FROM node:lts AS dist
COPY package.json yarn.lock ./

RUN yarn install

COPY . ./

RUN yarn build:prod

FROM node:lts

ARG PORT=3000

ENV NODE_ENV=production
ENV TZ=Asia/Karachi

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY --from=dist dist /usr/src/app/dist
COPY --from=dist node_modules /usr/src/app/node_modules

# Ensure the i18n directory is copied to the dist folder
COPY ./src/i18n /usr/src/app/dist/i18n

# Removed to prevent copying local node_modules into the container
# COPY . /usr/src/app

EXPOSE $PORT

CMD [ "yarn", "start:prod" ]
