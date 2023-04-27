import csv
import os
from json import dumps
from kafka import KafkaProducer
from time import sleep
from datetime import datetime

#set the env variable to an IP if not localhost
KAFKA_ADDRESS=os.getenv('KAFKA_ADDRESS', 'localhost')

producer = KafkaProducer(bootstrap_servers=[f'{KAFKA_ADDRESS}:9092'],
                         key_serializer=lambda x: dumps(x).encode('utf-8'),
                         value_serializer=lambda x: dumps(x, default=str).encode('utf-8'))

file = open('../1_data/customer_shopping_data.csv')

csvreader = csv.reader(file)
header = next(csvreader)
for row in csvreader:
    key = {"invoice_no": str(row[0])}
    
    value = {"invoice_no": str(row[0]),
            "customer_id": str(row[1]),
            "gender": str(row[2]),
            "age": int(row[3]),
            "category": str(row[4]),
            "quantity": str(row[5]),
            "price": float(row[6]),
            "payment_method": str(row[7]),
            "invoice_date": datetime.strptime(row[8], '%d/%m/%Y'),
            "shopping_mall": str(row[9])
            }

    producer.send('customer_shopping_data.json', value=value, key=key)
    print(value)
    sleep(1)