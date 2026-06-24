## Steps to Build the Project

1. Create `employee.csv` and add the employee dataset.
2. Create `pyspark_app.py` and write the PySpark RDD application.
3. Create `requirements.txt` and add:

pyspark==3.5.6

4. Create a `Dockerfile` with Java, Python, and Spark dependencies.
5. Build the Docker image:

docker build -t spark_rdd .

6. Run the Docker container:

### Windows PowerShell

docker run --rm -v "${PWD}:/app" spark_rdd

### Linux / macOS

docker run --rm -v $(pwd):/app spark_rdd


7. The application executes automatically and generates `output.txt` in the project directory.