from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers='172.19.0.2:9092')
producer.send('LOJA_NOVOPEDIDO', b'1;SMART TV; 1249.90; 3x')
producer.flush()