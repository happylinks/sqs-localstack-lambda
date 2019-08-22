REGION = us-east-1
FUNCTION_NAME = SQSTest
QUEUE_NAME = test_queue

.PHONY: setup-js
setup-js: zip-js create-function-js create-queue create-event-source-mapping

.PHONY: setup-go
setup-go: build-go zip-go create-function-go create-queue create-event-source-mapping

.PHONY: build-go
build-go:
	@GOOS=linux go build main.go

.PHONY: update-js
update-js: zip-js update-function-js

.PHONY: update-go
update-go: build-go zip-go update-function-go

.PHONY: zip-js
zip-js:
	@(cd src; zip -r ../handler-js.zip .)

.PHONY: zip-go
zip-go:
	@(zip -r handler-go.zip main)

.PHONY: create-function-js
create-function-js:
	@awslocal lambda create-function --function-name $(FUNCTION_NAME) --region $(REGION) --runtime nodejs8.10 --handler index.handler --memory-size 128 --zip-file fileb://handler-js.zip --role arn:aws:iam::000000000000:role/irrelevant:role/irrelevant

.PHONY: create-function-go
create-function-go:
	@awslocal lambda create-function --function-name $(FUNCTION_NAME) --region $(REGION) --runtime go1.x --handler main --memory-size 128 --zip-file fileb://handler-go.zip --role arn:aws:iam::000000000000:role/irrelevant:role/irrelevant


.PHONY: update-function-js
update-function-js:
	@awslocal lambda update-function-code --function-name $(FUNCTION_NAME) --zip-file fileb://handler-js.zip

.PHONY: update-function-go
update-function-go:
	@awslocal lambda update-function-code --function-name $(FUNCTION_NAME) --zip-file fileb://handler-go.zip

.PHONY: create-queue
create-queue:
	@awslocal sqs create-queue --queue-name $(QUEUE_NAME)

.PHONY: create-event-source-mapping
create-event-source-mapping:
	@awslocal lambda create-event-source-mapping --function-name $(FUNCTION_NAME) --event-source-arn arn:aws:sqs:$(REGION):000000000000:$(QUEUE_NAME)

.PHONY: invoke
invoke:
	@awslocal lambda invoke --function-name $(FUNCTION_NAME) --payload "{ \"name\": \"Michiel\" }" outfile.txt && cat outfile.txt | jq

.PHONY: send-message
send-message:
	@awslocal sqs send-message --message-body "{\"name\": \"Michiel\"}" --queue-url "http://localhost:4576/queue/$(QUEUE_NAME)"

.PHONY: receive-message
receive-message:
	@awslocal sqs receive-message --queue-url "http://localhost:4576/queue/$(QUEUE_NAME)"
