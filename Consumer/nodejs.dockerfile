FROM node
LABEL AUTHOR="Renato Vianna <marquez.vianna@gmail.com>"

WORKDIR /var/kafka_consumer
COPY consumer.js /var/kafka_consumer

RUN npm install kafkajs

ENTRYPOINT [ "node", "/var/kafka_consumer/consumer.js" ]