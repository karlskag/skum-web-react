# build environment
FROM node:12-alpine as react-build
WORKDIR /app
COPY . .
RUN yarn
RUN yarn build
# production environment
FROM nginx:alpine
COPY nginx/nginx.conf /etc/nginx/conf.d/configfile.template
ENV PORT 8080
ENV HOST 0.0.0.0
RUN sh -c "envsubst '\$PORT'  < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf"
COPY --from=react-build /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]