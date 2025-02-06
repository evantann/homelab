## Instance Profile
1. Navigate to IAM in the search bar
2. In the menu, select 'Roles'
3. Click on 'Create role'
4. Select 'AWS service' under 'Trusted entity type'
5. Select 'EC2' under 'Use case' then click on 'Next'
6. Search and select 'AmazonS3ReadOnlyAccess' and 'AmazonSSMManagedInstanceCore' then click 'Next'
8. Provide a name for your role
9. Click 'Create role'

## Networking

#### VPC
1. Navigate to VPC in the search bar
2. Click on 'Create VPC'
3. Assign a name tag
4. Under 'IPv4 CIDR', enter a range of 10.0.0.0/16 (largest subnet mask)
5. Click 'Create VPC'   

#### Subnet
1. In the menu, select 'Subnets'
2. Select 'Create subnet'
3. Under VPC ID, select the VPC you just created
4. Create 6 subnets - 2 public web tier, 2 private app tier, 2 private database tier
    * Assign each subnet a descriptive name (ex. Public-Web-Subnet-AZ-1, Private-App-Subnet-AZ-2, Private-DB-Subnet-AZ-1)
    * Select an availability zone, ensuring that each AZ contains 1 of each public, app, and database tiers
    * Set the CIDR range starting from 10.0.0.0/24 to 10.0.5.0/24, incrementing the third octet by 1 each time
5. Select one of the public subnets
6. Click on 'Actions' then 'Edit subnet settings'
7. Under 'Auto-assign IP settings', select 'Enable auto-assign public IPv4 address'
8. Click 'Save'
9. Repeat steps 5-8 to assign a public IP for the other public subnet

#### Internet Gateway
1. In the menu, select 'Intenet gateways'
2. Select 'Create internet gateway'
3. Give a name tag that is associated with the VPC
4. Select 'Create internet gatway'
5. Under 'Actions', select 'Attach to VPC'
6. Select the VPC
7. Click on 'Attach internet gateway'

#### NAT Gateway
1. In the menu, select 'NAT gateways'
2. Select 'Create NAT gateway'
3. Provide the NAT Gateway a name that associates it with an AZ (ex. NAT-AZ-1)
4. Select the public subnet that corresponds with the name you assigned
5. Select 'Allocate Elastic IP'
6. Click on 'Create NAT gateway'
7. Repeat this process twice but provision it to exist in the other AZ

#### Route Table
_Create a Route Table_
1. In the menu, select 'Route tables'
2. Select 'Create route table'
3. Provide the route table a name (ex. Public-Route-Table, ex. Private-Route-Table-AZ-1)
4. Select the VPC
5. Click on 'Create route table'

_Allow public subnets internet access_

6. Under the 'Routes' column, select 'Edit routes'
7. Select 'Add route'
8. Under 'Destination', enter 0.0.0.0/0
9. Under 'Target', enter 'Internet Gateway' then select the internet gateway you just created
10. Select 'Save changes'
11. Under the 'Subnet associations' column, find 'Explicit subnet associations' and click on 'Edit subnet associations'
12. Select the two public-facing subnets
13. Click on 'Save associations

_Allow private subnets internet access. Create a route table for each private app tier and go to its edit associations page._

14. Under 'Destination', enter 0.0.0.0/0
15. Under 'Target', choose the NAT gateway of the corresponding AZ
16. Click on 'Save changes'

## Security Groups

_Internal-Facing Load Balancer_
1. In the menu, click on 'Security groups'
2. Click on 'Create security group'
3. Provide a name (ex. Public-Facing-LB-SG)
4. Select the VPC 
5. Under 'Inbound rules', select 'HTTP' in the 'Type' dropdown and '0.0.0.0/0' as the 'Source'
6. Select 'Create security group'

_Web Tier_
1. Repeat steps 1-4 above
2. Under 'Inbound rules', select 'HTTP' in the 'Type' dropdown and select the external load balancer security group as the 'Source'

_Internal Load Balancer_
1. Repeat steps 1-4 above
2. Under 'Inbound rules', select 'HTTP' in the 'Type' dropdown and select the web tier security group as the 'Source'

_Private App Tier_
1. Repeat steps 1-4 above
2. Under 'Inbound rules', select 'Custom TCP' in the 'Type' dropdown and enter '5000' in the 'Port range' field
3. Select the internal load balancer security group as the 'Source'

_Database Tier_
1. Repeat steps 1-4 above
2. Under 'Inbound rules', select 'MYSQL/Aurora' in the 'Type' dropdown and select the private instance security group as the 'Source'

## Database Tier Deployment
_Create Subnet Group_
1. In the search bar, navigate to RDS
2. In the menu, select 'Subnet groups'
3. Click on 'Create DB subnet group'
4. Provide a name that corresponds with the VPC
5. Provide a description and select the VPC
6. Under 'Availability Zones', select the two AZs you are using
7. Under 'Subnets', select the two database subnets
8. Click on 'Create'

_Create RDS Instance_

9. In the menu, click on 'Databases'
10. Select 'Create database'
11. Select 'Standard Create'
12. Select 'MySQL' as the Engine type
13. Select 'Free tier' under 'Templates'
14. Under 'Credentials management', select 'Self managed' then make a 'Master password' and confirm
15. Under 'Connectivity' select the VPC and subnet group
16. Under the 'Existing VPC security groups dropdown', choose the database security group
17. Click on 'Create database'


## App Tier Deployment

_Launch Instance_
1. In the search bar, navigate to EC2
2. In the menu, select 'Instances'
3. Select 'Launch instances'
4. Provide a name (ex. myWebServer)
5. Select 'Amazon Linux' as the image
6. Under 'Key pair (login)', select 'Proceed without a key pair'
7. Under 'Network settings', select the VPC and one of the private subnets
8. Under 'Common security groups', select the private instance security group
9. Under 'Advanced details' and 'IAM instance profile', select the EC2 role you created earlier
10. Click on 'Launch instance'

_Configure Instance_

11. In the menu, select 'Instances'
12. Select the instance you just provisioned then click on 'Connect'
13. Under 'Session Manage', click 'Connect'
14. In the terminal, enter:\
`sudo -su ec2-user`\
`sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm`\
`sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022`\
`sudo yum install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm -y`\
`sudo yum install mysql-community-client -y`
1. mysql -h <host_name> -u admin -p and enter password
2. run the commands in schema.sql 
3. exit
4. touch .env
5. sudo yum install docker -y
6. sudo systemctl start docker
7. docker pull image
8. docker run --name=backend -d -p 5000:5000 --env-file .env backend

_Create an AMI_

15. Select the instance you just created and click on 'Actions'
16. Under 'Image and templates', click on 'Create image'
17. Provide a name (ex. appTierImage)
18. Click on 'Create image'

_Create Target Group_

19. Under 'Choose a target type', select 'Instances'
20. Under 'Target group name', provide a name (ex. AppTierTargetGroup)
21. Under 'Protocol:Port', select 'HTTP' and enter '5000' as the port
22. Under 'VPC', select the VPC
23. Under 'Health checks', set the path to an endpoing in the code
24. Click 'Next' and 'Create target group'

_Create Internal Load Balancer_

25. In the menu, select 'Load Balancers'
26. Click on 'Create load balancer'
27. Under 'Application Load Balancer' click 'Create'
28. Under 'Load balancer name', provide a name (ex. app-tier-internal-lb)
29. Under 'Scheme', select 'Internal'
30. Under 'Network mapping', select the VPC
31. Under 'Mappings', select both subnets and select the private app subnets
32. Under 'Security groups', select the internal load balancer security group
33. Under 'Listeners and routing' and 'Default action', select the target group
34. Click 'Create load balancer'

_Define Launch Template_ 

35. In the menu, click on 'Launch Templates'
36. Provide a name (ex. app-tier-launch-template)
37. Under 'Application and OS Images' and 'My AMIs', select the AMI you just created
38. Under 'Instance type', select the 'Free tier eligible' instance
39. Under 'Security groups', select the private instance security group
40. Under 'Advanced details' and 'IAM instance profile', select the EC2 role
41. Under 'User data', enter:
    `#!/bin/bash`
    `sudo docker start backend`
41. Click on 'Create launch template'

_Create Auto Scaling Group_

42. In the menu, select 'Auto Scaling Groups'
43. Click on 'Create Auto Scaling group'
44. Provide a name (ex. app-tier-ASG)
45. Under 'Launch template', select the launch template you just created
46. Click 'Next'
47. Select the VPC and both the private subnets
48. Click 'Next'
49. Select 'Attach to an existing load balancer'
50. Under 'Existing load balancer target groups', select the target group
51. Click 'Next'
52. Under 'Desired capacity', 'Min desired capacity', and 'Max desired capacity', set all their values to 2
53. Click 'Next'
54. Click 'Next' again
55. Click 'Next' once more
56. Click 'Create Auto Scaling group'

## Web Tier Deployment
_Launch Instance_
1. Follow the instructions in the 'Launch instance' section under the app tier deployment setup, substituting options using the respective web tier security group and public subnet.
2. Under 'Auto-assign public IP', click on 'Enable'

_Configure Instance_
1. Follow the instructions in the respective section above
sudo yum update
sudo yum install docker -y
sudo systemctl start docker
sudo docker pull evantann/frontend
sudo docker run --name=frontend -d -p 80:80 evantann/frontend

_Create an AMI_
1. Follow the instructions in the respective section above

_Create Target Group_
1. Follow the instructions in the respective section above
2. Set the protocol to 'HTTP' and keep '80' as the port
3. Set the health check path to the root path '/'

_Create External Load Balancer_
1. Follow the instructions in the respective section above
2. Under 'Scheme', keep the selection 'Internet-facing'
3. In the appropriate fields select the public subnets, external load balancer security group, and web tier target group

_Define Launch Template_

1. Follow the instructions in the respective section above
2. Choose the appropriate web tier AMI and security group
3. Under 'User data', enter:
    `#!/bin/bash`
    `sudo docker start frontend`

_Create Auto Scaling Group_
1. Follow the instructions in the respective section above
2. Choose the appropriate launch template, web subnets, extneral load balancer, and web tier target group

# Terraform

aws s3api create-bucket \
    --bucket 3tier-backend-state-bucket \
    --region us-west-2 \
    --create-bucket-configuration LocationConstraint=us-west-2

aws dynamodb create-table \
    --table-name remote-backend \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=Artist,KeyType=HASH