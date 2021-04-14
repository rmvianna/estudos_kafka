FROM python
LABEL AUTHOR="Renato Vianna <marquez.vianna@gmail.com>"

WORKDIR /var/kafka_producer
COPY producer.py /var/kafka_producer

RUN pip install kafka-python

ENTRYPOINT [ "python", "/var/kafka_producer/producer.py" ]