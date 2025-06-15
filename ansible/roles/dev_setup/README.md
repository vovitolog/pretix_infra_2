# Role to install pretix infrastructure components

## Applying role

`ansible-playbook playbooks/setup_dev_instance.yml -i inventory.yml --ask-vault-pass`

**vault pass** 
`yc lockbox payload get --id e6q6d9lutr1hfhp5o1vp --jq '.entries[].text_value'`

## Role's tasks:

- Install and configure PostgreSQL  
  Default Postgres role

- Install and configure Redis  
Default Redis role

- Install and configure RabbitMQ  
Default RabbitMQ role

- Install wildcard SSL certificate  
Install wildcard certificate from YCloud Certificate Manager to instance  
Currently dev instance without proxy used

- Install and configure Nginx  
Default Nginx role without certificate obtain