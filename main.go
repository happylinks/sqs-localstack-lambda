package main

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

type Event struct {
	Name string `json:"name"`
}

type Record struct {
	Body string `json:"body"`
}

type SQSEvent struct {
	Records []Record `json:"records"`
}

type Response struct {
	Message string
}

func HandleRequest(ctx context.Context, event SQSEvent) (string, error) {
	name := ""

	for _, record := range event.Records {
		var event Event
		_ = json.Unmarshal([]byte(record.Body), &event)

		name = event.Name
	}

	response := &Response{
		Message: fmt.Sprintf("Hello %s!", name),
	}
	json, err := json.Marshal(response)

	return string(json), err
}

func main() {
	lambda.Start(HandleRequest)
}
