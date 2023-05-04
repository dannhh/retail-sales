### Setup Airflow and DBT
You will need to use the session dedicated for airflow-intance.
```
execute ssh airflow-instance
```
Execute the below command to clone the repo and install spark dependencies:
```
git clone https://github.com/dannhh/retail-sales.git
cd retail-sales/6_airflow
./docker_conda.sh
./airflow.sh
```
Setup environment variables
```
export GOOGLE_APPLICATION_CREDENTIALS="<path>/google_credentials.json" 
export GCP_PROJECT_ID=project-id
export GCP_GCS_BUCKET=bucket-name
```
Forward the port 8080 to your local machine and open localhost:8080 in your browser. Trigger the "transform" dag which will execute hourly.

###
DAG run result:
![dag-run](../images/airflow.png)