#!/bin/bash
ACCOUNT_ID=147997139858   # correct AWS account id
REGION=us-east-1

# service_name => build_path mapping
declare -A SERVICES
SERVICES=(
  ["customer"]="./customer"
  ["shopping"]="./shopping"
  ["proxy"]="./proxy"
)

# Authenticate Docker with ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Loop through services
for SERVICE in "${!SERVICES[@]}"; do
    CONTEXT=${SERVICES[$SERVICE]}
    echo "Building and pushing $SERVICE image from $CONTEXT to ECR..."

    # Build Docker image
    docker build -t $SERVICE $CONTEXT

    # Tag image for ECR
    docker tag $SERVICE:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$SERVICE:latest

    # Push image to ECR
    docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$SERVICE:latest
done

echo "✅ All images have been pushed to ECR."
