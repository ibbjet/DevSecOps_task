# parsley_task
Parsley DevOps Homework

Requirements
Use https://github.com/localstack/localstack to emulate an AWS environment.
Use Terraform to create a DynamoDB table named “parsley” that has two keys named
“Parsley-1” and “Parsley-2”. Parsley-1 will always be a string and Parsley-2 will always
be a number.
The DynamoDB table should allow one user with read/write access to both keys and
one user with read-only access to Parsley-2. The read/write user is a developer type.
The read-only user is a product manager type. The users should be managed by IAM to
the maximum extent possible.
Imagine that this is a small part of our Terraform code base that will need to delegate
privileges to other services besides DynamoDB and you are the first person to
represent IAM resources with Terraform.

Using localstack.
