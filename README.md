# ohsam

Welcome to OhSam'sApp, it has an AWS infrastructure (cloudformation) **store.template** contains secretsmanagers for 4 different logical secrets and an IAM managed policies for IAM role or user to use. Only secretsmanager were considered at the momemt, for consistency reasons also it works with other AWS resources e.g injecting into RDS, and key rotations

### Prerequisites

OS - Linux ( Ubuntu Recommended )

pip3 
``` apt-get install python3-pip ```

aws 1.18 
``` apt-get pip --upgrade awscli ```

awslocal
``` apt-get install awscli-local ```

docker, docker-compose


### Instructions

Clone this repo, and in deploy.sh, fill in the variables, and have the pgp key and ssh key in the root location, then simply run ./deploy.sh script, it should generate a set of secerets in your local environment with help from localstack.
