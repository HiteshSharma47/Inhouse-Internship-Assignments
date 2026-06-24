## Steps to Build and Run the Project

1. Create `pyspark_app.py` and add the PySpark application code.
2. Create `requirements.txt` and add:
   ```txt
   pyspark==3.5.6
   ```
3. Create a `Dockerfile` with Python, Java, and Spark dependencies.
4. Build the Docker image:
   ```bash
   docker build -t spark_partition_demo .
   ```
5. Run the Docker container:
   ```bash
   docker run --rm spark_partition_demo
   ```

## Expected Output

```text
Initial Partitions: <default_partitions>
Partitions after repartition(12): 12
Partitions after coalesce(3): 3
```