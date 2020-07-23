# ohsam

### Welcome to this OhSam's App, it's a ECS Service works with many different Secret Information, and due to nature of the requirement, secrets are decided to be reside in infrastructure rather in repository

### It's super simple to run this, simply just use cloudformation, and fill in the parameter values, however, before running this template, there're some base dependencies is needed. Please run follow following templates in sequence.

1. logstore.template - provides stores for your base infrastructure e.g. flowlogs, billing, cloudtrails 
2. vpc.template - your logical virtual private cloud dedicated to you, private networking, CIDR block works with your network 
3. public-out-subnets.template

#### Parameters Explained

* VpcId: Please don't use the default VPC due to security reasons(public addresses), use the vpc.template

* 


