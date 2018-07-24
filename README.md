# VpcSubnetIpMonitor

Lambda function to publish the IP Address availability in all VPC-based subnets as CloudWatch Metrics.

Built using [AWS Serverless Application Model](https://github.com/awslabs/serverless-application-model).

## Preface

In AWS, private IP addresses are used with Elastic Network Interfaces (ENIs) to provide local routing for EC2 Instances, ECS/Fargate containers, Lambda Functions, RDS/Redshift databases, and more. It's important to _right-size_ your subnets, but this is difficult to predict early in your application's lifecycle, and difficult to change later. Keeping track of IP address availability requires checking each subnet's `AvailableIpAddressCount` via a [DescribeSubnets API](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSubnets.html) call.

_VpcSubnetIpMonitor_ is a Lambda function that can be deployed in an AWS account that will call the [DescribeSubnets API](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSubnets.html) and output custom CloudWatch Metrics, with the `SubnetId` as a dimension.

### Metrics

* `AvailableIpAddressCount` - Quantity of IP Addresses Available
* `TotalIpAddressCount` - Quantity of Total IP Addresses in Subnet (based on CIDR size)
* `AvailableIpAddressPercent` - Percentage of Available to Total IP Addresses

## Deployment

**Deploy using CloudFormation:** [![Deploy to AWS](resources/deploy-to-aws.png)](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=VpcSubnetIpMonitor&templateURL=https://s3.amazonaws.com/VpcSubnetIpMonitor/template.json)

To deploy to AWS manually, see [Create Your Own Serverless Application : Packaging and Deployment](https://docs.aws.amazon.com/lambda/latest/dg/serverless-deploy-wt.html#serverless-deploy) using this repository.

Once the function is running and reporting metrics, you can [create CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) for each subnet that alert if a subnet starts to reach its maximum capacity.
