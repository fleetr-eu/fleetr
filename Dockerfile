FROM fleetr/meteor as builder

WORKDIR /src

COPY ./ ./

RUN meteor npm i --production
RUN meteor build /target --allow-superuser --directory --server-only --architecture os.linux.x86_64

FROM node:4-slim

ENV PORT 80
ENV ROOT_URL http://fleetr.eu

WORKDIR /app

COPY --from=builder /target/bundle .

RUN cd /app/programs/server && npm i --production

EXPOSE 80

CMD ["node", "main.js"]
