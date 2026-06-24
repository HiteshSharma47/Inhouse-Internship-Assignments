FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y openjdk-21-jdk wget tar && \
    apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Spark
ENV SPARK_VERSION=3.5.6

RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop3 /opt/spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

ENV SPARK_HOME=/opt/spark
ENV PATH=$JAVA_HOME/bin:$SPARK_HOME/bin:$PATH

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["spark-submit", "pyspark_dataframe.py"]