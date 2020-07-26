#!/bin/bash

#variables, please fill

REGION=us-east-1
STACK_NAME=Dev-OhSecrets

API_USER=fillme
API_PASS=fillme

DATABASE_ENDPOINT=fillme
DATABASE_NAME=fillme
DATABASE_PORT=fillme
DATABASE_USER=fillme
DATABASE_PASS=fillme

PGP_FILE_NAME=test.pgp
SSH_FILE_NAME=test.ppk

docker-compose up -d

#don't modify here
PGP=default
SSH=default

if [ -s ${PWD}/$PGP_FILE_NAME ] && [ -f ${PWD}/$PGP_FILE_NAME  ]; then
  PGP=`cat $PGP_FILE_NAME`
fi

if [ -s ${PWD}/$SSH_FILE_NAME ] && [ -f ${PWD}/$SSH_FILE_NAME  ]; then
  SSH=`cat $SSH_FILE_NAME`
fi

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
  ParameterKey=PpkKey,ParameterValue="$(echo $PGP)" \
  ParameterKey=SshKey,ParameterValue="$(echo $SSH)" \
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
  ParameterKey=PpkKey,ParameterValue="$(echo $PGP)" \
  ParameterKey=SshKey,ParameterValue="$(echo $SSH)" \
  --region $REGION

fi

CREATE_STACK_STATUS=$(awslocal cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query 'Stacks[0].StackStatus' --output text)

echo $CREATE_STACK_STATUS

while [ $CREATE_STACK_STATUS == "CREATE_IN_PROGRESS" ]; do
        sleep 30
        CREATE_STACK_STATUS=$(awslocal --region $REGION cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query 'Stacks[0].StackStatus' --output text)
done

awslocal cloudformation describe-stack-resources --stack-name $STACK_NAME --region $REGION
