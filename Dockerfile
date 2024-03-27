# Etapa de construcción (build)
FROM node:20 AS build
WORKDIR /app
COPY package.json .
RUN yarn --frozen-lockfile
COPY . .
RUN yarn build

# Etapa de producción (prod-deps)
FROM node:20 AS prod-deps
WORKDIR /app
COPY package.json .
RUN yarn --production

# Etapa de desarrollo (dev-deps)
FROM node:20 AS dev-deps
WORKDIR /app
COPY package.json .
RUN yarn install --frozen-lockfile

# Etapa de ejecución (runner)
FROM node:20 AS runner
WORKDIR /app
COPY --from=build /app .
COPY --from=prod-deps /app/node_modules ./node_modules
EXPOSE 3000
CMD ["yarn", "dev"]
