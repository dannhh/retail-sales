from typing import List
import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType,StructField, StringType, IntegerType,ArrayType,MapType
from pyspark.sql.functions import col,struct,when

from pyspark.sql.types import (IntegerType,
                               StringType,
                               DoubleType,
                               StructField,
                               StructType,
                               LongType,
                               BooleanType,
                               TimestampType,
                               ArrayType)

schema = {
    'raw_data': StructType([
        StructField("invoice_no", StringType(), True),
        StructField("customer_id", StringType(), True),
        StructField("gender", StringType(), True),
        StructField("age", IntegerType(), True),
        StructField("category", StringType(), True),
        StructField("quantity", IntegerType(), True),
        StructField("price", DoubleType(), True),
        StructField("payment_method", StringType(), True),
        StructField("invoice_date", TimestampType(), True),
        StructField("shopping_mall", StringType(), True)
      ])
}