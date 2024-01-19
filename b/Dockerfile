FROM alpine
RUN apt-get install node.js
ADD git pull https://github.com/shubhamkalsait/devops-fullstack-app.git
WORKDIR /devops-fullstack-app.git/frontend/
RUN npm install && npm start
EXPOSE 3000
