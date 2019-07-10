#Create ECR registry and code build service role to be able to push images
#https://aws.amazon.com/blogs/devops/build-a-continuous-delivery-pipeline-for-your-container-images-with-amazon-ecr-as-source/

#Create new build in CodeBuild and point it to github repo
# In order build to succeed choose "Priveledged" in Environment settings for CodeBuild

#https://aws.amazon.com/blogs/devops/continuous-deployment-to-kubernetes-using-aws-codepipeline-aws-codecommit-aws-codebuild-amazon-ecr-and-aws-lambda/

#https://medium.com/@BranLiang/step-by-step-to-setup-continues-deployment-kubernetes-on-aws-with-eks-code-pipeline-and-lambda-61136c84bbcd

#From AWS Docs: https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

#When an Amazon EKS cluster is created, the IAM entity (user or role) that creates the cluster is 
#added to the Kubernetes RBAC authorization table as the administrator (with system:master permissions.
#Initially, only that IAM user can make calls to the Kubernetes API server using kubectl.
#For more information, see Managing Users or IAM Roles for your Cluster. Also, the AWS IAM Authenticator for Kubernetes uses the AWS SDK for Go to authenticate against your Amazon EKS cluster. If you use the console to create the cluster, you must ensure that the same IAM user credentials
#are in the AWS SDK credential chain when you are running kubectl commands on your cluster.

#You need to add your CodeBuild service role to EKS configmap 
kubectl edit -n kube-system configmap/aws-auth
#Add your role:
- groups:
  - system:bootstrappers
  - system:nodes
  - system:masters
  rolearn: arn:aws:iam::005577361927:role/CodeBuildServiceRole
  username: CodeBuildServiceRole
