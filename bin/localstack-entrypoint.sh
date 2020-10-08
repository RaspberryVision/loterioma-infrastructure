#!/usr/bin/env bash
printf "Configuring localstack components..."

readonly LOCALSTACK_S3_URL=http://localstack:4566
readonly LOCALSTACK_SQS_URL=http://localstack:4566

sleep 5;
set -x

aws configure set aws_access_key_id foo
aws configure set aws_secret_access_key bar
echo "[default]" > ~/.aws/config
echo "region = us-east-1" >> ~/.aws/config
echo "output = json" >> ~/.aws/config

printf "Create queue"

aws --endpoint $LOCALSTACK_SQS_URL sqs create-queue --queue-name low-prio-queue
aws --endpoint $LOCALSTACK_SQS_URL sqs create-queue --queue-name medium-prio-queue
aws --endpoint $LOCALSTACK_SQS_URL sqs create-queue --queue-name high-prio-queue

printf "Create bucket"

# create tmp directory to put sample data after chunking
mkdir -p /tmp/localstack/data

# create bucket
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket loterioma-dev

# Grant bucket public read
aws --endpoint-url=$LOCALSTACK_S3_URL s3api put-bucket-acl --bucket loterioma-dev --acl public-read

set +x