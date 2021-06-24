FROM alpine:3.13

ARG SPARK_VERSION=3.1.1
ARG HADOOP_VERSION_SHORT=3.2
ARG HADOOP_VERSION=3.2.0
ARG AWS_SDK_VERSION=1.11.375

RUN apk upgrade --no-cache && \
    apk add --no-cache bash tini libc6-compat gcompat linux-pam nss openjdk11-jre python3 libidn alpine-sdk build-base

# Download and extract Spark
RUN wget -qO- https://www-eu.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION_SHORT}.tgz | tar zx -C /opt && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION_SHORT} /opt/spark

# Configure Spark to respect IAM role given to container
RUN echo spark.hadoop.fs.s3a.aws.credentials.provider=com.amazonaws.auth.EC2ContainerCredentialsProviderWrapper > /opt/spark/conf/spark-defaults.conf

# Add hadoop-aws and aws-sdk
RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar -P /opt/spark/jars/ && \
    wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar -P /opt/spark/jars/

ENV PATH="/opt/spark/bin:${PATH}"
ENV PYSPARK_PYTHON=python3
ENV SPARK_HOME /opt/spark
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk

WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir

RUN sed -i "s|/usr/bin/tini|/sbin/tini|g" "/opt/spark/kubernetes/dockerfiles/spark/entrypoint.sh"

ENTRYPOINT [ "/opt/spark/kubernetes/dockerfiles/spark/entrypoint.sh" ]