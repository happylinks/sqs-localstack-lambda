REGION = us-east-1
FUNCTION_NAME = SQSTest
QUEUE_NAME = test_queue

.PHONY: setup
setup: zip create-function create-queue create-event-source-mapping

.PHONY: update
update: zip update-function

.PHONY: zip
zip:
	@(cd src; zip -r ../handler.zip .)

.PHONY: create-function
create-function:
	@awslocal lambda create-function --function-name $(FUNCTION_NAME) --region $(REGION) --runtime nodejs8.10 --handler index.handler --memory-size 128 --zip-file fileb://handler.zip --role arn:aws:iam::000000000000:role/irrelevant:role/irrelevant

.PHONY: update-function
update-function:
	@awslocal lambda update-function-code --function-name $(FUNCTION_NAME) --zip-file fileb://handler.zip

.PHONY: create-queue
create-queue:
	@awslocal sqs create-queue --queue-name $(QUEUE_NAME)

.PHONY: create-event-source-mapping
create-event-source-mapping:
	@awslocal lambda create-event-source-mapping --function-name $(FUNCTION_NAME) --event-source-arn arn:aws:sqs:$(REGION):000000000000:$(QUEUE_NAME)

.PHONY: invoke
invoke:
	@awslocal lambda invoke --function-name $(FUNCTION_NAME) outfile.txt && cat outfile.txt | jq

.PHONY: send-message
send-message:
	@awslocal sqs send-message --message-body="{}" --queue-url "http://localhost:4576/queue/$(QUEUE_NAME)"

.PHONY: receive-message
receive-message:
	@awslocal sqs receive-message --queue-url "http://localhost:4576/queue/$(QUEUE_NAME)"
