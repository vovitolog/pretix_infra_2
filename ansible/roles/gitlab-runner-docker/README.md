GitLab Runner Docker
=========

Данная роль предназначена для запуска GitLab Runner в Docker


Requirements
------------

На целевом хосте **должен быть предварительно установлен Docker**. Роль не устанавливает Docker автоматически.



Role Variables
--------------

| Переменная             | Описание                   | Default
|------------------------|----------------------------|------------------------------
| `image`                | Наименование образа        | gitlab-runner               |
| `container_name`       | Наименование контейнера    | gitlab/gitlab-runner:latest |
| `gitlab_url`           | url GitLab                 | https://gitlab.example.com  |
| `gitlab_runner_token`  | token для GitLab Runner    | your_token_gitlab_runner    |
| `restart_policy`       | Политика рестарта          | unless-stopped              |

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
- name: Устанавливам gitlab runner
  hosts: gitlabrunner
  become: true
  vars_files:
    - vars-runner.yml # Создайте файл рядом с playbook и определите переменные окружения
  roles:
    - gitlab-runner-docker
```


