### Setup Kafka
Connect to your VM compute instance as in [2-terraform-gcp-readme.md]() and clone project in VM
```
git clone https://github.com/dannhh/retail-sales.git
```
Move to folder 3_kafka and install conda, docker and confluent-kafka:
```
chmod +x docker-conda.sh
./docker-conda.sh
```
The role of these component:
- Conda is a package management system used to manage the Python dependencies required to interact with Kafka, such as the kafka-python library.

- Docker is used to create lightweight, isolated environments for running Kafka or other services. Kafka can be run inside a Docker container, which makes it easy to deploy and manage Kafka instances in a variety of environments.

- Confluent Kafka is a distribution of Apache Kafka that includes additional tools and features for managing Kafka clusters such as a web-based UI for managing Kafka clusters, connectors for integrating Kafka with other systems, and additional security features.

Type `exit` to close session, then connect again and start kafka instance:
```
export KAFKA_ADDRESS=<external ip address of kafka-instance vm> 
export KAFKA_ADDRESS=35.201.188.31
docker-compose up
```
Here is the processing flow:
1. A producer sends data to a Kafka topic. The Kafka broker responsible for the topic receives the data and writes it to its log. The broker sends an acknowledgement to the producer indicating that the data was received successfully.
2. The Kafka broker notifies ZooKeeper of the new data and updates the metadata for the topic and partition. The Schema Registry is also notified of the new data and checks if the data conforms to the Avro schema. If the data conforms to the schema, the Schema Registry returns the schema ID to the broker.
3. The consumer polls for new data from the Kafka topic. The Kafka broker responsible for the topic sends the data to the consumer.
4. If the data is in Avro format, the consumer requests the schema from the Schema Registry using the schema ID returned by the broker. The consumer deserializes the data using the schema and processes it.
5. The Control Center monitors the performance of the Kafka cluster, displays metrics, and allows for administrative tasks like creating or deleting topics.

Overall, the Kafka brokers play a central role in this processing flow, as they receive and distribute data, manage metadata, and coordinate with ZooKeeper and the Schema Registry. The Schema Registry ensures that data is in a standardized format and manages metadata about the Avro schemas. The ZooKeeper service is responsible for coordination and synchronization of distributed applications, while the Control Center provides a UI for monitoring and managing the Kafka cluster.

### Generate data to Kafka
Generate streaming data for above kafka instance to produce it on kafka broker in partitions using topic 'raw_data`
```
python3 generate_dataset_to_kafka.py
```