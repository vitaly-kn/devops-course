FROM node:latest as build
WORKDIR /app
COPY . .
RUN yarn install && yarn build
FROM node:alpine3.19
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json .
CMD ["npm", "run", "start:prod"]
EXPOSE 3000
