#!/bin/bash

#variables

REGION=us-east-1
STACK_NAME=Dev-OhSecrets

API_USER=fillme
API_PASS=fillme

DATABASE_ENDPOINT=fillme
DATABASE_NAME=fillme
DATABASE_PORT=fillme
DATABASE_USER=fillme
DATABASE_PASS=fillme

docker-compose up -d

if ! awslocal cloudformation describe-stacks --region $REGION | grep $STACK_NAME ; then

echo -e "\nStack does not exist, creating ..."

awslocal cloudformation create-stack --stack-name $STACK_NAME \
  --template-body 'file://${PWD}/store.yaml' --parameters \
  ParameterKey=ApiUsername,ParameterValue=$API_USER \
  ParameterKey=ApiPassword,ParameterValue=$API_PASS \
  ParameterKey=DatabaseEndpoint,ParameterValue=$DATABASE_ENDPOINT \
  ParameterKey=DatabaseName,ParameterValue=$DATABASE_NAME \
  ParameterKey=DatabasePort,ParameterValue=$DATABASE_PORT \
  ParameterKey=DatabaseUsername,ParameterValue=$DATABASE_USER \
  ParameterKey=DatabasePassword,ParameterValue=$DATABASE_PASS \
  --region $REGION

else

echo -e "\nExisting Stack found, updating ..."

awslocal cloudformation update-stack --stack-name $STACK_NAME \
  --template-body 'file://${PWD}/store.yaml' --parameters \
  ParameterKey=ApiUsername,ParameterValue=$API_USER \
  ParameterKey=ApiPassword,ParameterValue=$API_PASS \
  ParameterKey=DatabaseEndpoint,ParameterValue=$DATABASE_ENDPOINT \
  ParameterKey=DatabaseName,ParameterValue=$DATABASE_NAME \
  ParameterKey=DatabasePort,ParameterValue=$DATABASE_PORT \
  ParameterKey=DatabaseUsername,ParameterValue=$DATABASE_USER \
  ParameterKey=DatabasePassword,ParameterValue=$DATABASE_PASS \
  --region $REGION

fi

CREATE_STACK_STATUS=$(awslocal cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query 'Stacks[0].StackStatus' --output text)

echo $CREATE_STACK_STATUS

while [ $CREATE_STACK_STATUS == "CREATE_IN_PROGRESS" ]; do
        sleep 30
        CREATE_STACK_STATUS=$(awslocal --region $REGION cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query 'Stacks[0].StackStatus' --output text)
done

awslocal cloudformation describe-stack-resources --stack-name $STACK_NAME --region $REGION
