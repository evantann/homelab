FROM node:23.5.0

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]

# docker build -t frontend .
# docker run --name=frontend --network=homelab -d -p 3000:3000 frontend