# Install

Assuming you have awslocal installed in init.sh.

```
docker-compose up
```

Wait for localstack to be ready.

```
bash ./init.sh
```

# Confirm invoking the function works
awslocal lambda invoke --function-name SQSTest outfile.txt

# SQS Should trigger the function aswell
awslocal sqs send-message --message-body="{}" --queue-url "http://localhost:4576/queue/test_queue"

# Confirming the queue got the message
awslocal sqs receive-message --queue-url "http://localhost:4576/queue/test_queue"

# Expected Behaviour 
SQS Triggers the lambda function SQSTest.

# Actual Behaviour
SQS Does not trigger the lambda event


