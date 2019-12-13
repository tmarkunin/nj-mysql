#create cluster
aws ecs create-cluster --cluster-name fargate-cluster
#list task definitions
aws ecs list-task-definitions
#deregister task definition
aws ecs deregister-task-definition --task-definition first-run-task-definition:1 
#register task definition 
aws ecs register-task-definition --cli-input-json file://fargate-docker-sample.json
