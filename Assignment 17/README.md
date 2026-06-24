# Steps to Build the Project

Create `sales_data.csv` and add the sales dataset.

Create `pyspark_dataframe.py` and write the PySpark DataFrame application.

Create `requirements.txt` and add:

```txt
pyspark==3.5.6
```

Create a `Dockerfile` with Java 21, Python, and Apache Spark dependencies.

Build the Docker image:

```bash
docker build -t pyspark_dataframe .
```

Run the Docker container:

### Windows PowerShell

```powershell
docker run --rm -v "${PWD}:/app" pyspark_dataframe
```

### Linux / macOS

```bash
docker run --rm -v $(pwd):/app pyspark_dataframe
```

The application executes automatically and:

- Reads `sales_data.csv`.
- Sorts products by sales in descending order.
- Displays the top 3 products with the highest sales values.
- Filters products with sales greater than 80,000.
- Saves the results as CSV files in:
  - `output/sorted_products`
  - `output/top3_products`
  - `output/filtered_products`