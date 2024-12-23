FROM node:23.5.0

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 5000

CMD ["node", "index.js"]


# docker build -t backend .
# docker run --network=homelab --name mysql -e MYSQL_ROOT_PASSWORD=NATNAVE123 -e MYSQL_DATABASE=items_db -d -p 3306:3306 -v homelab:/data/db mysql:latest
# docker run --name=backend --network=homelab -d -p 5000:5000 backend