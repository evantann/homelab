FROM node:23-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM nginx:stable-alpine

# copy build output to nginx default location for html files
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# runs docker in the foreground so the container doesn't exit
CMD ["nginx", "-g", "daemon off;"]

# docker build -t frontend .
# docker run --name=frontend --network=homelab -d -p 80:80 frontend