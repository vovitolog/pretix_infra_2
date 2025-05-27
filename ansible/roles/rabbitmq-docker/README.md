RabbitMQ Docker
=========

Данная роль предназначена для запуска RabbitMQ в Docker


Requirements
------------

На целевом хосте **должен быть предварительно установлен Docker**. Роль не устанавливает Docker автоматически.



Role Variables
--------------

| Переменная             | Описание             |
|------------------------|----------------------|
| `image`    | Наименование образа              |
| `container_name`  | Наименование контейнера   |
| `ports`    | Порты (формат "хост:контейнер")  |
| `env`      | Переменные окружения             |
| `data_dir` | Локальная директория для хранения данных |
| `restart_policy` | Политика рестарта          |

Dependencies
------------

Должна быть установлена коллекция
```bash
ansible-galaxy collection install community.docker
```

Example Playbook
----------------

Пример использования

```yml
---
- name: Устанавливам rabbit в Docker
  hosts: backend
  become: true
  vars_files:
    - user-docker.yml # Создайте этот файл рядом с playbook и определите переменные окружения 
  collections:
    - community.docker
  roles:
    - rabbitmq-docker
```


