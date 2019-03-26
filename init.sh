bash ./package.sh
awslocal lambda create-function --function-name SQSTest --region us-east-1 --runtime nodejs8.10 --handler index.lambdaHandler --memory-size 128 --zip-file fileb://handler.zip --role arn:aws:iam:awslocal lambda create-function --function-name SQSTest --region us-east-1 --runtime nodejs8.10 --handler index.lambdaHandler --memory-size 128 --zip-file fileb://handler.zip --role arn:aws:iam::000000000000:role/irrelevant:role/irrelevant
awslocal sqs create-queue --queue-name test_queue
awslocal lambda create-event-source-mapping --function-name SQSTest --event-source-arn arn:aws:sqs:elasticmq:000000000000:test_queue
