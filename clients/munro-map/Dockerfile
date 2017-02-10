FROM node:6.9.5

COPY ./cmd.sh /

RUN mkdir -p /app
COPY . /app
WORKDIR /app
RUN cd /app && npm install

EXPOSE 3000

USER node
CMD ["/cmd.sh"]
