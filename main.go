package main

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Event struct {
	Name string `json:"name"`
}

func HandleRequest(ctx context.Context, sqsEvent events.SQSEvent) error {
	for _, message := range sqsEvent.Records {
		var event Event
		_ = json.Unmarshal([]byte(message.Body), &event)

		fmt.Println(event.Name)
	}

	return nil
}

func main() {
	lambda.Start(HandleRequest)
}
