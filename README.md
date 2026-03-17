# Alumni Connect Terraform

Terraform IaC to run `alumni-connect-backend` along with the database.

### Current plan

1. VPC+igw
2. 3 subnets management, backend and database (public (has NAT gateway), private, private)
3. 3 EC2s in each 1 subnet (bastion, backend and database) (only bastion has public IP and can be reached from the internet)
4. security groups to allow communication
5. route tables
6. ssh key setups
7. aws load balancer on backend ec2 port
