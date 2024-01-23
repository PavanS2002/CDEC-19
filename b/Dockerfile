FROM ubuntu:latest

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get update && apt-get install -y nodejs

WORKDIR /usr/src/app

COPY package*.json ./

RUN apt-get install -y npm

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]