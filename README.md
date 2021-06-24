# spark-on-eks
Code sample on how to run Apache Spark 3.1.1 on an EKS Cluster managed with Step Functions

# Prerequisite
- SBT with scala 2.21
- Docker  
- Cloudformation (sam)
- An existing AWS account with an ECR repository and an S3 bucket

# Build Spark project binaries and upload it to an s3 bucket :

    sbt clean assembly
    aws s3 cp "target/scala-2.12/spark-on-eks-assembly-v1.0.jar" "s3://<BUCKET NAME>/spark-on-eks-assembly-v1.0.jar"

# Build and push the docker image :
    docker build -t <AWS ACCOUNT>.dkr.ecr.<AWS REGION>.amazonaws.com/spark:v3.1.1 .
    docker push <AWS ACCOUNT>.dkr.ecr.<AWS REGION>.amazonaws.com/spark:v3.1.1

# Infrastructure set up (CloudFormation)
    sam build
    sam deploy --guided


CLoudFormation will create the following ressources :
- 2 roles for cluster and nodes on EKS
- 1 role for the Step Functions
- A step function to manage cluster/nodes creation


