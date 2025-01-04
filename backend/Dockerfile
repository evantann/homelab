FROM node:23-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 5000

CMD ["node", "index.js"]


# docker build -t backend .
# docker run --network=homelab --name mysql -e MYSQL_ROOT_PASSWORD=NATNAVE123 -d -p 3306:3306 -v $(pwd)/db:/docker-entrypoint-initdb.d -v homelab:/db/data mysql:latest
# docker run --name=backend --network=homelab -d -p 5000:5000 --env-file .env backend