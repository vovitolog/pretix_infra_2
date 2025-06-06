# S3 as terraform state backend

To use this terraform code AWS CLI **must** be installed in order to perform functions related to YDB document tables

As of yandex terraform provider v0.142.0 it is not supported creation YDB Document tables, but only Row-based\
As of YC CLI v0.149.0 you can only create YDB database, but not table\
You can resort to AWS CLI to create YDB Document-based table, as described in [documentation](https://yandex.cloud/en/docs/ydb/docapi/tools/aws-cli/create-table)

To initialize on your machine run:

```bash
terraform init \
    -backend-config="username=<GITLAB_USERNAME>" \
    -backend-config="password=<GITLAB_ACCESS_TOKEN>"
```
