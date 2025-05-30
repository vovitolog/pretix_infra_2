# Инфраструктура для проекта Pretix

Этот репозиторий описывает начальную конфигурацию инфраструктуры как кода (IaC) для проекта **Pretix** — системы продажи билетов на мероприятия. Мы используем **Infrastructure as Code (IaC)** для автоматизации создания и настройки серверов в **Yandex Cloud**.

> **Внимание!** В текущей версии не учтены разбивка по контейнерам, использование Kubernetes, вынос Pretix-worker в отдельные контейнеры и другие потенциальные улучшения. Эти аспекты могут быть добавлены в будущем.

## Обзор проекта

**Pretix** — веб-приложение для управления продажей билетов. Мы разворачиваем инфраструктуру в **Yandex Cloud** с использованием следующих инструментов:

- **Terraform**: Создаёт серверы и сети (не в фокусе этой задачи).
- **Ansible**: Устанавливает и настраивает сервисы (NGINX, PostgreSQL, Prometheus и др.).
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
  Ansible: Устанавливает NGINX, Docker, Alloy, Node Exporter; загружает образ Pretix, настраивает конфигурацию NGINX.
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
  Ansible: Устанавливает PostgreSQL, Redis, Alloy, Node Exporter, PostgreSQL Exporter; настраивает базы и подключения.
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
  Ansible: Устанавливает Prometheus, Grafana, AlertManager, Loki, Alloy, Node Exporter; настраивает дашборды и алерты.
```

## Текущие плейбуки Ansible проекта Pretix

Ниже приведены актуальные плейбуки Ansible, использующие модульный подход для настройки серверов в проекте Pretix, включая общий плейбук для выполнения всех настроек.

### Playbook: `all-install.yml` *(В РАЗРАБОТКЕ)*
Этот плейбук включает все остальные плейбуки для последовательной настройки всех сервисов на инстансах.

```
---
- name: Install and configure all services for Pretix
  hosts: all
  become: yes
  tasks:
    - name: Include PostgreSQL setup playbook
      ansible.builtin.include: setup_postgres.yml
```

**Объяснение**:
- Плейбук применяется к группе `all`, так как каждый включённый плейбук таргетирует свою группу хостов (`frontend`, `backend`, `monitoring`).
- Директива `ansible.builtin.include` вызывает указанные плейбуки в логическом порядке: сначала фронтенд (NGINX, pretix), затем бэкенд (PostgreSQL, Redis), затем мониторинг и логирование.
- Используется `become: yes` для выполнения задач с правами root.
- Позволяет выполнить все настройки одной командой, сохраняя модульность.

### Playbook: `setup_postgres.yml`
Этот плейбук настраивает PostgreSQL на инстансе 2 (Backend).

```yml!
# >>> /ansible/playbooks/setup_postgresql.yml

- hosts: backend
  roles:
    - role: postgres
      vars:
        # By default, all variables are set correctly and do not require changes. You can change them if necessary
        # postgres_version: "17.5"                # PostgreSQL image tag
        # postgres_port: "5532"                   # Default port: 5432
        # postgres_data_dir: "/opt/postgres/data" # Persistent data directory
        # postgres_container_name: "postgres"     # Default container name
        # postgres_db: "pretix"                   # Default database name
        # postgres_user: "pretix"                 # Default database user
        # postgres_password: "*****"              # Default password for database user
        # container_network: "backend"            # Default network for container
```

**Объяснение**:
- Плейбук применяется к группе `backend`.
- Роль `postgres` (из `/roles/postgres`) устанавливает PostgreSQL и настраивает доступ.
- Задачи создают базу `pretix` и пользователя `pretix`.
- Пароль хранится в переменной по умолчанию `postgres_password` (зашифрованный с помощью **ansible-vault**).

### Playbook: `setup_monitoring_stack.yml`
Этот плейбук настраивает **Prometheus + AlertManager + Grafana** на инстансе 3 (Monitoring & Logging).

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
- Роль `monitoring_stack` устанавливает **Prometheus** + **AlertManager** + **Grafana**.
- Плейбук сразу сконфигурирован на связь **Prometheus** с **AlertManager** и настроен один алерт на доступность контейнера **Grafana** с роутом в телеграмм-канал.

## Компоненты инфраструктуры

Инфраструктура включает:

1. **Сети**:
   - **VPC**: Изолирует серверы.
   - **Подсети**: Публичные (NGINX, Grafana) и приватные (базы данных).
   - **NAT**: Обеспечивает доступ в интернет.
   - **Балансировщик нагрузки**: Для масштабирования в будущем.

2. **Мониторинг и логирование**:
   - **Prometheus**: Собирает метрики (включая контейнеры через cAdvisor).
   - **Экспортеры**: Node Exporter (системные метрики: CPU, память, диск), PostgreSQL Exporter (метрики базы данных) и другие экспортеры.
   - **Grafana**: Визуализирует метрики и логи.
   - **AlertManager**: Отправляет уведомления.
   - **Alloy**: Собирает логи.
   - **Loki**: Хранит логи.

## Структура директорий

```
pretix-infra/
├── /terraform                    # Конфигурации для создания инфраструктуры с помощью Terraform
│   ├── cloud-init.tpl            # Шаблон для автоматической настройки ВМ через cloud-init
│   ├── main.tf                   # Основные ресурсы: ВМ, сети, хранилища и т.д.
│   ├── outputs.tf                # Выходные переменные: IP, URL, ID и прочее
│   ├── provider.tf               # Настройка провайдера
│   ├── variables.tf              # Объявление входных переменных
│   ├── terraform.tfvars          # Значения переменных для разворачивания инфраструктуры
│   ├── terraform.tfstate         # Состояние инфраструктуры (генерируется автоматически)
│   └── terraform.tfstate.backup  # Резервная копия состояния
│
├── /ansible               # Конфигурации для настройки серверов через Ansible
│   ├── /playbooks         # Playbook-файлы — сценарии развертывания сервисов
│   ├── /roles             # Роли Ansible — модульные части конфигурации (например, PostgreSQL, Nginx)
│   ├── inventory.yml      # Инвентарный файл — список хостов и групп серверов
│   ├── ansible.cfg        # Конфигурационный файл Ansible
│   └── requirements.yml   # Файл с указанием зависимостей: роли из Ansible Galaxy или коллекции
│
├── /ci-cd                 # Автоматизация процессов CI/CD
│   ├── .gitlab-ci.yml     # Pipeline-конфигурация для GitLab CI
│   └── /scripts           # Вспомогательные скрипты для автоматизации этапов пайплайна
│
├── README.md              # Документация проекта: описание, как использовать, зависимости, примеры
└── .gitignore             # Список файлов и директорий, исключённых из git (например, .tfstate, .env и т.д.)
```

### Описание структуры директорий

#### `/terraform`
Содержит код для создания инфраструктуры в **Yandex Cloud** с помощью Terraform.

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
  - **Состав роли** (например, `postgres`, `monitoring_stack`):  
    - **`defaults/main/main.yml`**: Переменные по умолчанию с низким приоритетом (например, параметры сервиса).  
    - **`defaults/main/secret.yml`**: Шифрованные переменные по умолчанию с низким приоритетом (например, пароли и токены).  
    - **`files/`**: Статичные файлы, копируемые на сервер (например, SSL-сертификаты).  
    - **`handlers/main.yml`**: Хэндлеры для перезагрузки сервисов (например, перезапуск NGINX).  
    - **`meta/main.yml`**: Метаданные роли (автор, зависимости, поддерживаемые платформы).  
    - **`tasks/main.yml`**: Основные шаги для настройки сервиса (установка, конфигурация, запуск).  
    - **`templates/`**: Шаблоны конфигураций (например, `nginx.conf.j2`).  
    - **`tests/`**: Тесты для проверки роли.  
    - **`vars/main.yml`**: Переменные, специфичные для роли (например, порт сервиса).  
  - Роли: `nginx`, `docker`, `postgres`, `redis`, `grafana`, `loki`, `alloy`, `node_exporter`, `postgres_exporter`.  

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

Процесс настройки и развертывания включает подготовку, создание ресурсов, настройку серверов.

### 1. Подготовка

- Установите инструменты:
  - **Terraform**: Скачайте с [официального сайта](https://www.terraform.io/downloads.html).
  - **Ansible**: Установите через `pip install ansible` или по [инструкции](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
- Получите API-токен для Yandex Cloud: [инструкция](https://cloud.yandex.com/docs/iam/operations/iam-token/create).
- Создайте SSH-ключи для доступа к серверам.
- Склонируйте репозиторий:
```
git clone https://gitlab.pretix.devops-factory.com/pretix/pretix-infra.git
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

Ansible настраивает сервисы на инстансе. Можно запустить все настройки одной командой через `all-install.yml` или выполнить плейбуки по отдельности.

- Перейдите в папку Ansible:
```
cd ansible
```
- Запустите все настройки одной командой *(в разработке)* и введите пароль ansible-vault:
```
ansible-playbook playbooks/all-install.yml --ask-vault-pass
```
- Альтернативно, запустите плейбуки по отдельности и введите пароль ansible-vault:
```
ansible-playbook playbooks/setup_nginx.yml --ask-vault-pass
ansible-playbook playbooks/setup_postgres.yml --ask-vault-pass
ansible-playbook playbooks/setup_monitoring_stack.yml --ask-vault-pass
ansible-playbook playbooks/setup_logging_stack.yml --ask-vault-pass
```

## Гайд по шифрованию секретов через `ansible-vault`

1. Разделите ваш файл `defaults/main.yml` на два и поместите в директорию:
* `defaults/main/main.yml`
* `defaults/main/secret.yml`
2. Перенесите чувствительные данные (пароли, токены) в файл `defaults/main/secret.yml`
3. Файл `defaults/main/secret.yml` зашифруйте с помощью пароля (общий пароль находится в **Yandex.Cloud** -> **LockBox**) через `ansible-vault`:
```
ansible-vault encrypt roles/monitoring_stack/defaults/main/secret.yml
```
4. При запуске плейбука через `ansible-playbook` добавьте ключ `--ask-vault-pass` и введите пароль, иначе плейбук не запустится:
```
ansible-playbook playbooks/monitoring_stack.yml --ask-vault-pass
```
5. Для изменения содержимого можно расшифровать файл секретов *(не рекомендуется)*:
```
ansible-vault decrypt roles/monitoring_stack/defaults/main/secret.yml
```
6. Изменение секрета без его расшифровки через пароль:
```
ansible-vault edit roles/monitoring_stack/defaults/main/secret.yml
```