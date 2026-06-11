FROM node:22-alpine

WORKDIR /app
COPY app/package*.json ./

RUN npm ci --only=production || npm install --omit=dev

COPY app/. ./

EXPOSE 3000

CMD ["node", "server.js"]