# Multi-state terraform guide

## Overview 

Each environment has its own terraform state and its own catalog which contains terraform code that describes infsrastructure state of the environemnt
- mvp (For MVP setup, is not currently publicly accessible or shared)
- dev (For development environment, shared within team via YC S3 backend)
- prod (For production environment, shared within team via YC S3 backend)
- common (For resources that are accessible within each (mvp, dev, prod) environment, shared within team via YC S3 backend)
- s3-tfstate-backend (describes YC S3 backend, itself is shared via GitLab's terraform state storage)\
  Please, withhold from unnecessary and uncalled s3-tfstate-backend actions


## How to initialize each terraform environment on your machine

1. Create authorized key for a service account with `admin` role. In our case we have `pretixsvc`

```bash
yc iam key create --service-account-name pretixsvc --output authorized_key.json --description "Authorized key for $USER"
```

If you are not using `pretixsvc` and use service account of your own, please let me know or add the SA to the bucket users yourself ([code](./s3-tfstate-backend/iam.tf))

File named `authorized_key.json` is added to `.gitignore` within `terraform` folder

2. Create static access key, for accessing Yandex S3, for a serive account with at least `storage.uploader` privilege role. In our case we can still use `pretixvc`

```bash
yc iam access-key create --service-account-name pretixsvc
```

For pipeline and other automatization tools there was additional service account created `tfstate-s3-uploader-compute-editor`, use it inside pipelines or other tools to access the S3 terraform backend storage.

Save credentials in a `~/.aws/credentials` file, as described in the following script:

```bash
mkdir -p ~/.aws
cat <<EOF >> ~/.aws/credentials
[s3-tfstate-user]
aws_access_key_id = ${ACCESS_KEY_ID}
aws_secret_access_key = ${SECRET_ACCESS_KEY}
EOF
```

3. Go to dev, prod or common environment and try to

```bash
terraform init
```

For `s3-tfstate-backend` see [README](./s3-tfstate-backend/README.md)

## Service accounts

Service accounts that have permissions to access backend:
* pretixvc
* tfstate-s3-uploader-compute-editor

## Services that cannot be described in terraform in a normal way

* Cloud Postbox (cannot be managed in YC CLI also, AWS CLI is needed)
* Yandex DB (YDB) (**document** type tables cannot be created or managed by terraform provider or YC CLI)
