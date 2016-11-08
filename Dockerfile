FROM node:4-slim

ENV PORT 80
ENV ROOT_URL http://fleetr.eu

WORKDIR /app

ADD /bundle /app

EXPOSE 80

CMD ["node", "main.js"]
