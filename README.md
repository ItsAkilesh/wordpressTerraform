# wordpressTerraform

Terraform script to create a Wordpress and a MySQL instance on AWS EC2. Also creates security groups, pipelines, network interfaces. 

Firstly do:
`terraform init`
to initialize terraform in the folder
and to run:
`terraform apply`

The entire cloud infrastructure created by Terraform on AWS can be destroyed by:
`terraform destroy`

`Note: change AMI id, keyname to work`
