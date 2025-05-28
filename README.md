test
# Инфраструктура для проекта Pretix

Этот репозиторий описывает начальную конфигурацию инфраструктуры как кода (IaC) для проекта **Pretix** — системы продажи билетов на мероприятия. Мы используем **Infrastructure as Code (IaC)** для автоматизации создания и настройки серверов в **Yandex Cloud**.

> **Внимание!** В текущей версии не учтены разбивка по контейнерам, использование Kubernetes, вынос Pretix-worker в отдельные контейнеры и другие потенциальные улучшения. Эти аспекты могут быть добавлены в будущем.

## Обзор проекта

**Pretix** — веб-приложение для управления продажей билетов. Мы разворачиваем инфраструктуру в **Yandex Cloud** с использованием следующих инструментов:

- **Terraform**: Создаёт серверы и сети (не в фокусе этой задачи).
- **Ansible**: Устанавливает и настраивает сервисы (NGINX, PostgreSQL, Prometheus и др.) с использованием коллекций.
- **GitLab**: Хранит код и автоматизирует развертывание (CI/CD).
- **Yandex Cloud**: Облачная платформа для серверов.
- **Мониторинг**: 
  - **Prometheus**: Собирает метрики, включая контейнеры через cAdvisor.
  - **Экспортеры**: Node Exporter (системные метрики: CPU, память, диск), PostgreSQL Exporter (метрики базы данных).
  - **Grafana**: Визуализирует метрики и логи.
  - **AlertManager**: Отправляет уведомления.
- **Логирование**: Alloy (сбор логов), Loki (хранение логов), Grafana (просмотр логов).
- **Веб-сервер**: NGINX для обработки запросов.
- **Контейнеры**: Docker для запуска Pretix.

## Вычислительные ресурсы

Используются **три виртуальные машины** (инстансы) в Yandex Cloud, на которых настраиваются сервисы через Ansible.

### Список инстансов:

```
Инстанс 1 (Frontend):
  Сервисы:
    - NGINX: Обрабатывает веб-запросы и перенаправляет их к Pretix.
    - Docker (Pretix): Запускает приложение Pretix в контейнерах.
    - Alloy: Собирает логи с этого инстанса.
    - Node Exporter: Собирает системные метрики для Prometheus.
  Сеть: Публичный IP для доступа пользователей к Pretix.
  Terraform: Создаёт инстанс с публичным IP и доступом к интернету.
  Ansible: Устанавливает NGINX, Docker, Alloy, Node Exporter с использованием коллекций; загружает образ Pretix, настраивает конфигурацию NGINX.
```

```
Инстанс 2 (Backend):
  Сервисы:
    - PostgreSQL: Хранит данные о билетах, мероприятиях и пользователях.
    - Redis: Кэширует данные для ускорения работы Pretix.
    - Alloy: Собирает логи с этого инстанса.
    - Node Exporter: Собирает системные метрики для Prometheus.
    - PostgreSQL Exporter: Собирает метрики базы данных для Prometheus.
  Сеть: Приватная подсеть для безопасности (без публичного IP).
  Terraform: Создаёт инстанс в приватной подсети.
  Ansible: Устанавливает PostgreSQL, Redis, Alloy, Node Exporter, PostgreSQL Exporter с использованием коллекций; настраивает базы и подключения.
```

```
Инстанс 3 (Monitoring & Logging):
  Сервисы:
    - Prometheus: Собирает метрики (например, метрики контейнеров через cAdvisor).
    - Grafana: Показывает графики метрик и логов.
    - AlertManager: Отправляет уведомления о сбоях (например, в Telegram).
    - Loki: Хранит логи.
    - Alloy: Собирает логи с этого инстанса.
    - Node Exporter: Собирает системные метрики для Prometheus.
  Сеть: Публичный IP для доступа к Grafana через браузер (или VPN для внутренней сети).
  Terraform: Создаёт инстанс с публичным IP или в приватной подсети.
  Ansible: Устанавливает Prometheus, Grafana, AlertManager, Loki, Alloy, Node Exporter с использованием коллекций; настраивает дашборды и алерты.
```

## Примеры плейбуков Ansible

Ниже приведены примеры плейбуков Ansible, использующих модульный подход с коллекциями для настройки серверов в проекте Pretix, включая общий плейбук для выполнения всех настроек.

### Плейбук: all-install.yml
Этот плейбук включает все остальные плейбуки для последовательной настройки всех сервисов на инстансе.

```
---
- name: Install and configure all services for Pretix
  hosts: all
  become: yes
  tasks:
    - name: Include NGINX setup playbook
      ansible.builtin.include: setup_nginx.yml

    - name: Include Docker setup playbook
      ansible.builtin.include: setup_docker.yml

    - name: Include PostgreSQL setup playbook
      ansible.builtin.include: setup_postgres.yml

    - name: Include Redis setup playbook
      ansible.builtin.include: setup_redis.yml

    - name: Include monitoring setup playbook
      ansible.builtin.include: setup_monitoring.yml

    - name: Include logging setup playbook
      ansible.builtin.include: setup_logging.yml
```

**Объяснение**:
- Плейбук применяется к группе `all`, так как каждый включённый плейбук таргетирует свою группу хостов (`frontend`, `backend`, `monitoring`).
- Директива `ansible.builtin.include` вызывает указанные плейбуки в логическом порядке: сначала фронтенд (NGINX, Docker), затем бэкенд (PostgreSQL, Redis), затем мониторинг и логирование.
- Используется `become: yes` для выполнения задач с правами root.
- Позволяет выполнить все настройки одной командой, сохраняя модульность.

### Плейбук: setup_postgres.yml
Это пример плейбука, который настраивает PostgreSQL на инстансе 2 (Backend), используя коллекцию `community.postgresql`.

```
---
- name: Configure PostgreSQL on Backend VM
  hosts: backend
  become: yes
  collections:
    - community.postgresql
  roles:
    - postgres

  tasks:
    - name: Create Pretix database
      postgresql_db:
        name: pretix
        state: present
      become_user: postgres

    - name: Create Pretix user
      postgresql_user:
        name: pretix_user
        password: "{{ pretix_db_password }}"
        db: pretix
        priv: ALL
        state: present
      become_user: postgres
```

**Объяснение**:
- Плейбук применяется к группе `backend`.
- Коллекция `community.postgresql` предоставляет модули для управления PostgreSQL.
- Роль `postgres` (из `/roles/postgres`) устанавливает PostgreSQL и настраивает доступ.
- Задачи создают базу `pretix` и пользователя `pretix_user` с правами.
- Пароль хранится в переменной `pretix_db_password` (в vault или `vars`).
- PostgreSQL Exporter настраивается отдельной ролью `postgres_exporter`.

### Плейбук: setup_monitoring.yml
Это пример плейбука, который настраивает Prometheus и Node Exporter на инстансе 3 (Monitoring & Logging), используя коллекцию `prometheus.prometheus`.

```
---
- name: Configure monitoring on Monitoring VM
  hosts: monitoring
  become: yes
  collections:
    - prometheus.prometheus
  roles:
    - prometheus
    - node_exporter

  tasks:
    - name: Configure Prometheus scrape targets
      prometheus_scrape_config:
        file: /etc/prometheus/prometheus.yml
        scrape_configs:
          - job_name: 'node'
            static_configs:
              - targets: ['localhost:9100']
          - job_name: 'postgres'
            static_configs:
              - targets: ['backend:9187']
      notify: Reload Prometheus
```

**Объяснение**:
- Плейбук применяется к группе `monitoring`.
- Коллекция `prometheus.prometheus` предоставляет модули для Prometheus и экспортеров.
- Роли `prometheus` и `node_exporter` (из коллекции `prometheus.prometheus`) устанавливают Prometheus и Node Exporter.
- Задача настраивает конфигурацию Prometheus для сбора метрик с Node Exporter (порт 9100) и PostgreSQL Exporter (порт 9187 на `backend`).
- При изменении конфигурации вызывается хэндлер `Reload Prometheus`, определённый в коллекции, для перезагрузки сервиса.

## Компоненты инфраструктуры

Инфраструктура включает:

1. **Сети**:
   - **VPC**: Изолирует серверы.
   - **Подсети**: Публичные (NGINX, Grafana) и приватные (базы данных).
   - **NAT**: Обеспечивает доступ в интернет.
   - **Балансировщик нагрузки**: Для масштабирования в будущем.

2. **Мониторинг и логирование**:
   - **Prometheus**: Собирает метрики (включая контейнеры через cAdvisor).
   - **Экспортеры**: Node Exporter (системные метрики: CPU, память, диск), PostgreSQL Exporter (метрики базы данных).
   - **Grafana**: Визуализирует метрики и логи.
   - **AlertManager**: Отправляет уведомления.
   - **Alloy**: Собирает логи.
   - **Loki**: Хранит логи.

## Структура директорий

Проект организован для понятности и масштабируемости:

```
/pretix-infra
├── /terraform             # Конфигурации для создания инфраструктуры
├── /ansible               # Конфигурации для настройки серверов
│   ├── /playbooks         # Сценарии для настройки сервисов
│   ├── /roles             # Инструкции для настройки сервисов
│   ├── inventory.yml      # Список серверов
│   ├── ansible.cfg        # Настройки Ansible
│   └── requirements.yml   # Коллекции и роли из Ansible Galaxy
├── /ci-cd                 # Автоматизация развертывания
│   ├── .gitlab-ci.yml     # Пайплайн для GitLab
│   └── /scripts           # Скрипты для CI/CD
├──  README.md             # Этот файл, описание инфраструктуры как кода
└── .gitignore             # Игнорируемые файлы
```

### Описание структуры директорий

#### `/terraform`
Содержит код для создания инфраструктуры в **Yandex Cloud** с помощью Terraform. Не рассматривается подробно, так как не является основной задачей.

#### `/ansible`
Содержит код для настройки сервисов на серверах с помощью Ansible.

- **`/playbooks`**  
  Сценарии для настройки сервисов на инстансах.  
  - `all-install.yml`: Включает все плейбуки для полной настройки инфраструктуры.  
  - `setup_nginx.yml`: Устанавливает NGINX на инстансе 1 (Frontend).  
  - `setup_docker.yml`: Устанавливает Docker и запускает Pretix на инстансе 1.  
  - `setup_postgres.yml`: Устанавливает PostgreSQL на инстансе 2 (Backend).  
  - `setup_redis.yml`: Устанавливает Redis в Docker на инстансе 2.  
  - `setup_monitoring.yml`: Настраивает Prometheus, Grafana, AlertManager, Node Exporter на инстансе 3.  
  - `setup_logging.yml`: Настраивает Alloy и Loki на инстансе 1, 2, 3.

- **`/roles`**  
  Инструкции для настройки каждого сервиса, включая экспортеры. Каждая роль — набор шагов для установки и настройки, созданный с помощью `ansible-galaxy init`.  
  - **Состав роли** (например, `nginx`, `node_exporter`):  
    - **`defaults/main.yml`**: Переменные по умолчанию с низким приоритетом (например, параметры сервиса).  
    - **`files/`**: Статичные файлы, копируемые на сервер (например, SSL-сертификаты).  
    - **`handlers/main.yml`**: Хэндлеры для перезагрузки сервисов (например, перезапуск NGINX).  
    - **`meta/main.yml`**: Метаданные роли (автор, зависимости, поддерживаемые платформы).  
    - **`tasks/main.yml`**: Основные шаги для настройки сервиса (установка, конфигурация, запуск).  
    - **`templates/`**: Шаблоны конфигураций (например, `nginx.conf.j2`).  
    - **`tests/`**: Тесты для проверки роли.  
    - **`vars/main.yml`**: Переменные, специфичные для роли (например, порт сервиса).  
  - Роли: `nginx`, `docker`, `postgres`, `redis`, `grafana`, `loki`, `alloy`, `node_exporter`, `postgres_exporter`.  
  - Роль `prometheus` берётся из коллекции `prometheus.prometheus`, а не создаётся локально. Её хэндлеры, такие как `Reload Prometheus`, находятся в каталоге коллекции (например, `~/.ansible/collections/ansible_collections/prometheus/prometheus/roles/prometheus/handlers`).

- **`inventory.yml`**  
  Список серверов (IP-адреса, группы) для Ansible.

- **`ansible.cfg`**  
  Настройки Ansible (например, путь к `inventory.yml` или SSH-пользователь).

- **`requirements.yml`**  
  Список коллекций и ролей из **Ansible Galaxy**. Пример:

```
---
collections:
  - name: community.general
  - name: community.postgresql
  - name: community.docker
  - name: prometheus.prometheus
```

#### `/ci-cd`
Содержит настройки для автоматизации развертывания через GitLab CI/CD.

- **`.gitlab-ci.yml`**  
  Пайплайн, запускающий Terraform и Ansible.

- **`/scripts`**  
  Скрипты для упрощения команд (например, `deploy_terraform.sh`, `run_ansible.sh`).

#### `README.md`
Общее описание проекта.

#### `.gitignore`
Игнорирует временные файлы и секреты (например, `.tfstate`, SSH-ключи).

## Развертывание инфраструктуры

Процесс настройки и развертывания включает подготовку, создание ресурсов, настройку серверов и автоматизацию через CI/CD.

### 1. Подготовка

- Установите инструменты:
  - **Terraform**: Скачайте с [официального сайта](https://www.terraform.io/downloads.html).
  - **Ansible**: Установите через `pip install ansible` или по [инструкции](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
- Получите API-токен для Yandex Cloud: [инструкция](https://cloud.yandex.com/docs/iam/operations/iam-token/create).
- Создайте SSH-ключи для доступа к серверам.
- Склонируйте репозиторий:
```
git clone <URL-репозитория>
cd pretix-infra
```

### 2. Развертывание вычислительных ресурсов (Terraform)

Terraform создаёт виртуальные машины и сети в Yandex Cloud.

- Перейдите в папку продакшн:
```
cd terraform/environments/prod
```
- Инициализируйте Terraform:
```
terraform init
```
- Проверьте план:
```
terraform plan
```
- Создайте инфраструктуру:
```
terraform apply
```

### 3. Настройка серверов (Ansible)

Ansible настраивает сервисы на инстансе, используя коллекции. Можно запустить все настройки одной командой через `all-install.yml` или выполнить плейбуки по отдельности.

- Перейдите в папку Ansible:
```
cd ansible
```
- Установите коллекции и роли:
```
ansible-galaxy install -r requirements.yml
```
- Запустите все настройки одной командой:
```
ansible-playbook -i inventory.yml playbooks/all-install.yml
```
- Альтернативно, запустите плейбуки по отдельности:
```
ansible-playbook -i inventory.yml playbooks/setup_nginx.yml
ansible-playbook -i inventory.yml playbooks/setup_docker.yml
ansible-playbook -i inventory.yml playbooks/setup_postgres.yml
ansible-playbook -i inventory.yml playbooks/setup_redis.yml
ansible-playbook -i inventory.yml playbooks/setup_monitoring.yml
ansible-playbook -i inventory.yml playbooks/setup_logging.yml
```

### 4. Настройка CI/CD

- Загрузите код в GitLab.
- Настройте секреты (API-токен Yandex Cloud, SSH-ключи) в **GitLab Settings -> CI/CD -> Variables**.
- Пайплайн в `.gitlab-ci.yml` автоматически выполнит Terraform и Ansible.

