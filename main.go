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

type Response struct {
	Message string
}

func HandleRequest(ctx context.Context, event Event) (string, error) {
	response := &Response{
		Message: fmt.Sprintf("Hello %s!", event.Name),
	}
	json, err := json.Marshal(response)

	return string(json), err
}

func main() {
	lambda.Start(HandleRequest)
}
