FROM node:20

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

# Create an empty uploads directory
RUN mkdir -p ./uploads

COPY . .

ENV PORT=3000

EXPOSE 3000

CMD [ "npm", "start" ]