# ohsam

Welcome to OhSam's App, it has an AWS infrastructure (cloudformation) **app.template** contains an ECS Service works with different Secret pieces of information, and due to nature of the requirement, secrets are decided to reside in infrastructure rather in the repository

The public/secrets and database information best not be part of the repository, as it is a lot easier to expose these kinds of information rather than controlled by AWS IAM.

It's super simple to run this, simply just use AWS Cloudformation, and fill in the parameter values, however, before running this template, there are some base dependencies is needed. Please run follow the following templates in sequence.


1. logstore.template - Provides stores for your base infrastructure e.g. flowlogs, billing, cloudtrails
2. vpc.template - Your logical virtual private cloud dedicated to you, private networking, CIDR block works with your network 
3. public-out-subnets.template - Design to work with public-facing subnets/services such as NAT and ELB/ALBS.
4. nat-gateway-subnets.template - NAT, translating private IP addresses
5. nat-subnets.template
6. elb-subnets.template
7. ecs-base.template - ECS cluster, where your container hosted in a logical group
8. loadbalancer.template - Loadlbancer, direct traffic to your targets, servers

#### Note, it all can be automated from [bit.clouded](https://app.bitclouded.io/)

### Parameters Explained

#### Networks, foundations

* VpcId: **Please don't use the default VPC due to security reasons** (public addresses), use the one vpc.template
* EcsCluster: Name of EcsCluster
* ElbTargetSecGroup: SecurityGroup Where ElbSecGroup can communicate, obtained from VPC output
* ElbSecGroup: SecurityGroup for Loadbalancer
* WebServerSubnets: Subnet where your ECS resides and can be reacheable from Loadbalancer

#### Service specifics

* Environment: Application Environment, for application to know which environment is it, and which appsettings to use
* ImageName: Docker Image
* ContainerPort: Port to map to
* HealthUrl: health checks, to know whether your service is healthy or not, and rotate if it's not

#### Loadbalancer Targets, DNS

* GatewayCanonicalZoneId: Loadbalancer's HostedZone ID
* GatewayDnsName: A record of Loadbalancer
* GatewayName: /app/<Name Of Loadbalancer>
* HttpsListener: ARN of ListenerId
* ListenerPriority: any number that's not repeated on Listener Rule

### Resources Explained

* Stores: Where secret goes, both public keys go on S3 AppBucket, S3 it's more performant, especially client-side and also coupled, if OAuth Authentication is to happen, requesting for authentication
* Service: Service-specific resources, where ECS task, service, its associated IAM permission defined.
* Scalings and desired tasks: desired number of instance for service, and its alarms and scaling rules

### Manual Steps

* Upload Public key manually to S3
* Upload PGP private Key manually to PgpPrivateStore Parameter store.
* Upload SSH private Key manually to SshPrivateStore Parameter store.

### Integration

The App/Service itself can simply read the environment variables and be able to know where secrets located, with appropriate permissions set as part of the template


