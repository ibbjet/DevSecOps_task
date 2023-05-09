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

# localstack 
LocalStack is a tool that gives you a local AWS cloud stack so you can test and build cloud applications without having to use real AWS services. It can be used to simulate AWS services on your local machine, making it easier to test and fix your code.

For the written code to work with LocalStack, we would first need to install and run LocalStack on your local machine. Once LocalStack is running, you would need to set the right AWS environment variables, like AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, so that our Terraform code can talk to LocalStack instead of the real AWS services.

We would also have to change the Terraform code so that it uses LocalStack resources instead of the real AWS resources. For instance, we could use the localstack_dynamodb_table resource type instead of the aws_dynamodb_table resource type and set the endpoint parameter to the correct URL for LocalStack.


# variables.tf
This code sets up variables for Terraform that will be used to set up the creation of an AWS DynamoDB table. 

Here's what each variable means:

'table_name' is the name of the table in DynamoDB. The "parsley" value is used by default.
- "access_key" is the AWS access key that will be used to log in. Since the default value is an empty string, Terraform will authenticate using the default AWS credentials chain.
- "secret_key" is the AWS secret key that will be used to sign in. Since the default value is an empty string, Terraform will authenticate using the default AWS credentials chain.
- "region" means the area of AWS where the resources will be set up. "us-east-1" is the default value.
'hash_key' is the DynamoDB table's hash key. "Parsley-1" is what it is set to by default.
'range_key' is the DynamoDB table's range key. "Parsley-2" is what it is set to by default.
'readonly_group_name' is the name of the IAM group for the DynamoDB table that can only be read. The value "product_managers" is set as the default.
'readwrite_group_name' is the name of the IAM group for the DynamoDB table that can read and write. The default value is "developers".

The code for Terraform can use these variables to set up and manage the DynamoDB table. The 'description' field for each variable gives a short explanation of what the variable is used for. The 'type' field tells you what kind of data the variable holds, and the 'default' field gives the variable a default value if none is given.

# terraform.tfvars
The code declares and sets the values of three variables: access_key, secret_key, and region.

"mock_access_key" is put into "access_key." This variable is probably the AWS access key that is needed to log in and get to the account's resources.

"mock_secret_key" is put in the "secret_key" field. This variable is probably the AWS secret key that is needed to log in and get to the account's resources.

The string "us-east-1" is put in the "region" field. This variable probably shows the AWS region in which the resources will be set up. AWS has many regions, and each region is a different part of the world where AWS's services are hosted.

## Note
To keep the terraform.tfvars file from being checked into source control and shared publicly, we need to add it to our.gitignore file or store it in a safe place, like a password manager or an encrypted file.

When we work as a team, we can use a tool like HashiCorp Vault to store and manage the access keys in a safe way. Vault can make temporary credentials that change automatically and can log audits and control who has access.

We can keep our access keys safe and follow best practices for managing sensitive information in Terraform by using variables and secure storage methods like Vault. For this take-home message, it's clear because there's no real danger here.



## Note 
this is only for POC, and that in a production setting, you would use terraform.tfvars files are kept safe and never checked into source control or shared with other people.


# provider.tf
This Terraform code tells the infrastructure code what version and configuration of the AWS provider it needs. Then, it sets up the settings for the 'aws' provider by defining a provider block for it. 

The 'access_key,''secret_key,' and'region' parameters are set by declaring variables elsewhere in the code. Parameters like'skip_credentials_validation,''skip_metadata_api_check,' and'skip_requesting_account_id' are used to turn off provider functionality in certain situations. The endpoint for the DynamoDB API is set in the 'endpoints' block, which in this case is 'http://localhost:4566'. 

With this code, a local development and testing environment is set up with a fake AWS service endpoint running on localhost.

# dynamodb.tf
This Terraform code creates a DynamoDB table, an AWS KMS key for encryption, and a policy for accessing the DynamoDB table. It also makes two AWS Identity and Access Management (IAM) groups called "developers" and "product_managers" with policies for read-write and read-only access to the DynamoDB table, respectively.

The following settings are used to make the DynamoDB table:
"Parsley" is the name.
- "PAY_PER_REQUEST" is the billing mode (no need to set up read and write capacity units).
- "Parsley-1" is the key to the partition (string data type).
- The sort key is "Parsley-2" (a number)
- Encryption on the server side with an AWS KMS key managed by the customer
- Recovery from a point in time is possible

For the DynamoDB table to automatically grow or shrink, the code sets up an AWS App Autoscaling target and policy:
The maximum number of write capacity units is set to 10 and the minimum number is set to 1.
- The policy uses a predefined metric specification of DynamoDBWriteCapacityUtilization to set a target utilization of 70% for the write capacity units.
- Finally, the code sets up IAM policies so that both the "developers" and "product_managers" groups can access the DynamoDB table with the right permissions.
