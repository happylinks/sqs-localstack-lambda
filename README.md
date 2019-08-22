# Localstack SQS trigger Lambda function working example.

## Install

Assuming you have awslocal installed in init.sh.

```
docker-compose up
```

Wait for localstack to be ready.

```
make setup
```

### Confirm invoking the function works
`make invoke`

### SQS Should trigger the function aswell
`make send-message`

### Confirming the queue got the message
`make receive-message`

