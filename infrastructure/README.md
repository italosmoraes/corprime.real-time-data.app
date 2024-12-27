# Infrastructure - Real Time Data App

Terraform based

1. Have aws cli configured

https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions

2. install terraform

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

3. ensure the account id value is present in the env

```
export TF_VAR_aws_account_id=$AWS_ACCOUNT_ID
```

4. apply tf changes
   `terraform apply`
