# ohsam

#### Welcome to this OhSam's App, it's an AWS infrastucture template for ECS Service works with many different Secret Information, and due to nature of the requirement, secrets are decided to be reside in infrastructure rather in repository

#### It's super simple to run this, simply just use cloudformation, and fill in the parameter values, however, before running this template, there're some base dependencies is needed. Please run follow following templates in sequence.

1. logstore.template - provides stores for your base infrastructure e.g. flowlogs, billing, cloudtrails 
2. vpc.template - your logical virtual private cloud dedicated to you, private networking, CIDR block works with your network 
3. public-out-subnets.template - design to work with public facing subnets/service such as NAT and ELB/ALBS.
4. nat-gateway-subnets.template - nat, translating private IP addresses
5. nat-subnets.template
6. elb-subnets.template
7. ecs-base.template - where your ecs cluster is.
8. loadbalancer.template - loadlbancer, direct traffic to your targets, servers

#### Note, it all can be automated from [bit.clouded](https://app.bitclouded.io/)

### Parameters Explained

#### Networks, foundations

* VpcId: Please don't use the default VPC due to security reasons (public addresses), use the vpc.template
* EcsCluster: Name of EcsCluster
* ElbTargetSecGroup: SecurityGroup Where ElbSecGroup can communicate, obtained from VPC output
* ElbSecGroup: SecurityGroup of Loadbalancer
* WebServerSubnets: Subnet where your ECS resides and can be reacheable from Loadbalancer

#### Service specifics

* Environment: Application Environment, for application to know which environment is it, and which appsettings to use
* ImageName: Docker Image
* ContainerPort: Port to map to
* HealthUrl: health checks, to know whether your service is healthy or not, and rotate if it's not

#### Service specifics




