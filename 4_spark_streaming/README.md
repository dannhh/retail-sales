### Setup Spark streaming

You will need to use a seperate spark session to login into master spark machine vm.

execute ssh multinode-spark-cluster-m

Execute the below command to clone the repo and install spark dependencies:

```
git clone https://github.com/dannhh/retail-sales.git
cd retail-sales/4_spark_streaming/
./setup-spark-streaming.sh
```
Configure environment variables:
```
export KAFKA_ADDRESS=<external ip address of kafka-instance>
export GCP_GCS_BUCKET=<bucket name used in creating data (remember terraform apply?)>
export GOOGLE_APPLICATION_CREDENTIALS="<path>/google_credentials.json" 
```
To consume data from kafka broker using spark streaming, execute:
```
cd retail-sales/4_spark_streaming/
spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.2 stream_data.py
```
If there are no errors along the way, you will see files in Google Cloud Storage Data Lake!