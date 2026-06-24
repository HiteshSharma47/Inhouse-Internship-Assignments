from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("PartitionDemo") \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

df = spark.range(5000000)

print("Initial Partitions:", df.rdd.getNumPartitions())

df_repartition = df.repartition(12)
print("Partitions after repartition(12):", df_repartition.rdd.getNumPartitions())

df_coalesce = df_repartition.coalesce(3)
print("Partitions after coalesce(3):", df_coalesce.rdd.getNumPartitions())

spark.stop()