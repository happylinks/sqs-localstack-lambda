bash ./package.sh
awslocal lambda create-function --function-name SQSTest --region us-east-1 --runtime nodejs8.10 --handler index.lambdaHandler --memory-size 128 --zip-file fileb://handler.zip --role arn:aws:iam::123456:role/irrelevant
awslocal sqs create-queue --queue-name test_queue
awslocal lambda create-event-source-mapping --function-name SQSTest --event-source-arn arn:aws:sqs:us-east-1:queue:test_queue
