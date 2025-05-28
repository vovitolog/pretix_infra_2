RabbitMQ
=========

Данная роль предназначена для MVP установки RabbitMQ на хост


Role Variables
--------------

| Переменная             | Описание                                        |
|------------------------|-------------------------------------------------|
| `rabbitmq_admin`       | Логин администратора RabbitMQ                  |
| `rabbitmq_admin_pass`  | Пароль администратора RabbitMQ                 |
| `rabbitmq_keys`        | Список ключей для подписи репозитория          |
| `rabbitmq_repos`       | Список репозиториев, которые нужно добавить    |
| `rabbitmq_repo_filename` | Имя файла, в который сохраняются репозитории |

Dependencies
------------

Должна быть установлена коллекция
```bash
ansible-galaxy collection install community.rabbitmq
```

Example Playbook
----------------

Пример использования

```yml
---
- name: Устанавливам rabbit
  hosts: backend
  become: true
  vars_files:
    - user.yml # Создайте файл рядом с Playbook и укажите новое значение переменных rabbitmq_admin и rabbitmq_admin_pass
  collections:
    - community.rabbit
  roles:
    - rabbitmq
```


