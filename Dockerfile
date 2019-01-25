ARG JAVA_MAJOR_VERSION=8
ARG SPARK_VERSION
ARG NOMAD_VERSION

FROM guangie88/nomad-spark:spark-${SPARK_VERSION}_nomad-${NOMAD_VERSION}_java-${JAVA_MAJOR_VERSION}

RUN set -euo pipefail; \
    # Check https://github.com/apache/hadoop/blob/release-2.7.7-RC0/hadoop-project/pom.xml#L658
    # to see the aws-java-sdk version to be used
    # AWS S3 JARs
    wget -O ${SPARK_HOME}/jars/hadoop-aws-2.7.7.jar \
        http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.7/hadoop-aws-2.7.7.jar; \
    wget -O ${SPARK_HOME}/jars/aws-java-sdk-1.7.4.jar \
        http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar; \
    echo "spark.hadoop.fs.s3a.impl    org.apache.hadoop.fs.s3a.S3AFileSystem" >> ${SPARK_HOME}/conf/spark-defaults.conf; \
    # Google Storage JAR
    wget -O ${SPARK_HOME}/jars/gcs-connector-hadoop2-latest.jar \
        https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar; \
    # Required for prevent snappy compression error because the shared lib is dependent on glibc
    apk add --no-cache libc6-compat; \
    :
