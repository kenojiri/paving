# AWS pavement for Concourse multi-AZ deployment without creating any IAM resources

![](diagram.png)

## Prerequisites

- AWS API access
  one of followings:
  - AWS EC2 instance with IAM instance profile that has enough privileges
- 1 Hosted Zone on AWS Route 53

### mandatory privileges

Follow [these instructions](https://docs.pivotal.io/ops-manager/2-9/aws/prepare-env-terraform.html)
to create an IAM instance profile that is needed to run the terraform templates.

The above instructions specify manual steps for creating the IAM instance profile. If you have the `aws` cli, you can follow these steps:

```console
$ export AWS_IAM_INSTANCE_PROFILE_NAME="REPLACE-ME"

$ export AWS_IAM_ASSUME_ROLE_POLICY_DOCUMENT=/tmp/assume-role-policy-document.json

$ echo '{
  "Version": "2012-10-17",
  "Statement": [
    { 
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}' > $AWS_IAM_ASSUME_ROLE_POLICY_DOCUMENT

$ aws iam create-role --role-name $AWS_IAM_INSTANCE_PROFILE_NAME \
  --assume-role-policy-document file://$AWS_IAM_ASSUME_ROLE_POLICY_DOCUMENT

$ aws iam create-instance-profile \
  --instance-profile-name $AWS_IAM_INSTANCE_PROFILE_NAME

$ aws iam add-role-to-instance-profile \
  --instance-profile-name $AWS_IAM_INSTANCE_PROFILE_NAME \
  --role-name $AWS_IAM_INSTANCE_PROFILE_NAME

$ export AWS_IAM_POLICY_DOCUMENT=/tmp/policy-document.json

$ echo '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "IAMPermissions",
      "Effect": "Allow",
      "Action": [
        "iam:GetInstanceProfile",
        "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2Permissions",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateVpc",
        "ec2:CreateTransitGateway",
        "ec2:CreateTags",
        "ec2:DescribeVpcs",
        "ec2:DescribeTransitGateways",
        "ec2:DescribeVpcAttribute",
        "ec2:DeleteVpc",
        "ec2:DeleteTransitGateway",
        "ec2:ModifyVpcAttribute",
        "ec2:CreateSubnet",
        "ec2:CreateSecurityGroup",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteSubnet",
        "ec2:DeleteSecurityGroup",
        "ec2:CreateTransitGatewayVpcAttachment",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:DescribeTransitGatewayVpcAttachments",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:GetTransitGatewayRouteTableAssociations",
        "ec2:GetTransitGatewayRouteTablePropagations",
        "ec2:DeleteTransitGatewayVpcAttachment",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:CreateVpcEndpoint",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribePrefixLists",
        "ec2:DeleteVpcEndpoints",
        "ec2:ModifyTransitGateway",
        "ec2:DescribeTags",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:ModifyTargetGroupAttributes",
        "elasticloadbalancing:DescribeTargetGroupAttributes",
        "elasticloadbalancing:DescribeTags",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DeleteListener"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Route53Permissions",
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:GetHostedZone",
        "route53:ListTagsForResource",
        "route53:ChangeResourceRecordSets",
        "route53:GetChange",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3Permissions",
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:ListBucket",
        "s3:GetBucketPolicy",
        "s3:GetBucketAcl",
        "s3:GetBucketCors",
        "s3:GetBucketWebsite",
        "s3:GetBucketVersioning",
        "s3:GetAccelerateConfiguration",
        "s3:GetBucketRequestPayment",
        "s3:GetBucketLogging",
        "s3:GetLifecycleConfiguration",
        "s3:GetReplicationConfiguration",
        "s3:GetEncryptionConfiguration",
        "s3:GetBucketObjectLockConfiguration",
        "s3:GetBucketTagging",
        "s3:DeleteBucket",
        "s3:PutBucketVersioning"
      ],
      "Resource": "*"
    },
    {
      "Sid": "RDSPermissions",
      "Effect": "Allow",
      "Action": [
        "rds:CreateDBSubnetGroup",
        "rds:AddTagsToResource",
        "rds:DescribeDBSubnetGroups",
        "rds:ListTagsForResource",
        "rds:DeleteDBSubnetGroup",
        "rds:CreateDBInstance",
        "rds:DescribeDBInstances",
        "rds:DeleteDBInstance",
        "rds:ModifyDBInstance"
      ],
      "Resource": "*"
    }
  ]
}' > $AWS_IAM_POLICY_DOCUMENT

$ aws iam put-role-policy \
  --role-name $AWS_IAM_INSTANCE_PROFILE_NAME \
  --policy-name $AWS_IAM_INSTANCE_PROFILE_NAME \
  --policy-document file://$AWS_IAM_POLICY_DOCUMENT
```
