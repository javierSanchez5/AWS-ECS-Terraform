# Infrastructure

## Description
**Network\n**
The proposed networking architecture in the AWS cloud consists of a VPC with an Internet
Gateway to allow access to our application. Within the VPC we will have two availability
zones, one active and the other on standby to support failover.
Within each AZ, there will be a public and a private subnet. In the public subnet, the
Application Load Balancer resource will be deployed, distributing the incoming traffic to our
ECS with Fargate, which will be within our private network and the Database. This is in order
not to expose these resources for security reasons

**Scaling and microservice deployment\n**
In the proposed architecture, to support the deployment of microservices and auto-scaling,
the ECS service with Fargate will be used. This allows the deployment of microservices
architecture and at the same time reduces the operational overhead since the administration
of EC2 instances would not have to be carried out by just using ECS. ECS will be deployed
in different AZ to handle failover and these will be added as Target groups within the
application load balancer

**ECR\n*
Additionally, the ECR service will be used, where the images will be hosted. Amazon
Cloudwatch will also be used to monitor resources and applications, When traffic increases,
ECS can scale microservices

**Database RDS postgres\n**
Since RDS is a managed service, RDS performs the database scaling process

[Diagrama] (infrastructure.png)
