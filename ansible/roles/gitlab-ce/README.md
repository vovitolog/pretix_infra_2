GitLab
=========

Данная роль предназначена для установки GitLab self hosted


Role Variables
--------------

| Переменная             | Описание               | Default
|------------------------|------------------------|------------------------------
| `gitlab_root_password` | Пароль администратора  | strongpassword              |
| `gitlab_root_email`    | e-mail администратора  | gitlab_admin@example.com    |
| `external_url`         | Доменное имя GitLab    | https://gitlab.example.com  |


Example Playbook
----------------

Пример использования

```yml
---
- name: Устанавливам gitlab
  hosts: gitlab
  become: true
  vars_files:
    - vars.yml # Создайте файл со значениями переменных gitlab_root_password, gitlab_root_email и external_url
  roles:
    - gitlab-ce
```


