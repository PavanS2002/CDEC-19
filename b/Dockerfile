FROM alpine
RUN apt-get install node.js -y
ADD git clone https://github.com/shubhamkalsait/devops-fullstack-app.git
WORKDIR /devops-fullstack-app.git/frontend/
RUN npm install && npm start
EXPOSE 3000
