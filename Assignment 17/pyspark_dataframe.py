from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder \
    .appName("PySparkDataFrameSales") \
    .getOrCreate()

#Load CSV to DataFrame
df = spark.read.csv("sales_data.csv", header=True, inferSchema=True)

print("\n===== Products Sorted by Sales (Descending) =====")

res = df.orderBy(col("sales").desc())
res.show()

print("\n===== Top 3 Products by Sales =====")

res2 = res.limit(3)
res2.show()

print("\n===== Products with Sales > 80000 =====")

res3 = df.filter(col("sales") > 80000)
res3.show()

#Save every output as a Single CSV File

# 1. Sorted products
res.write.mode("overwrite").option("header", "true").csv("output/sorted_products")

# 2. Top 3 products
res2.write.mode("overwrite").option("header", "true").csv("output/top3_products")

# 3. Filtered products
res3.write.mode("overwrite").option("header", "true").csv("output/filtered_sales")