Устройство ролей

Создание новой роли.

ansible-galaxy role init role_name 

Если планируется эту роль добавлять на гитхабе и публиковать в Ansible Galaxy, выполнять эту команду можно в любом месте. 
Но если планируется использовать эту роль без публикации в Galaxy, то ее необходимо разместить в директории roles в корне проекта, где запускается Ansible. 

Команда ansible-galaxy role init role_name создаст структуру файлов:

tree role_name
role_name
├── README.md
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml

Обяательными являются только meta/main.yml and tasks/main.yml

Остальные появляются в зависимости от обстоятельств. Вот их предназначени:

- defaults: содержит значения переменных по умолчанию. Эти значения могут быть изменены во время использования роли в плейбуке. 
- files: содержатся необходимые файлы, которые нужны роли
- handlers: обработчики, которые могут быть использованы ролью
- meta: содержит метаданные роли. Лицензия, информация о платформе и многое другое
- tasks: задачи роли, которые выполняются во время ее запуска
- templates: шаблоны роли 
- tests: тесты роли 
- vars: переменные роли 
- README.md - описание 



Пример метаданных:

# meta/main.yml
galaxy_info:
  author: your name
  description: your role description
  company: your company (optional)
  license: license (GPL-2.0-or-later, MIT, etc)
  min_ansible_version: 2.1

  # Provide a list of supported platforms, and for each platform a list of versions.
  # If you don't wish to enumerate all versions for a particular platform, use 'all'.
  # To view available platforms and versions (or releases), visit:
  # https://galaxy.ansible.com/api/v1/platforms/
  #
  # platforms:
  # - name: Fedora
  #   versions:
  #   - all
  #   - 25

  galaxy_tags: []
    # List tags for your role here, one per line. A tag is a keyword that describes
    # and categorizes the role. Users find roles by searching for tags. Be sure to
    # remove the '[]' above, if you add tags to this list.

dependencies: []
  # List your role dependencies here, one per line. Be sure to remove the '[]' above,
  # if you add dependencies to this list.

-- 


tasks/main.yml содержит список задач. Если их слишком много, можно разбить на разные файлы (один из подходов - разбить файлы для разных платформ). Пример:

Пример файла tasks/main.yml:

# role_name/tasks/main.yml
- name: Install the correct web server for RHEL
  import_tasks: redhat.yml
  when: ansible_facts['os_family']|lower == 'redhat'

- name: Install the correct web server for Debian
  import_tasks: debian.yml
  when: ansible_facts['os_family']|lower == 'debian'

# role_name/tasks/redhat.yml
- ansible.builtin.yum:
    name: "httpd"
    state: present

# roles/example/tasks/debian.yml
- ansible.builtin.apt:
    name: "apache2"
    state: present


Если задачам нужны обработчики, то они добавляются в директорию handlers/main.yml. Ansible автоматически их найдет и подключит.

--- 

Переменные роли. 

Для перменных есть два варианта:

1. директория defaults 
2. директория vars

В vars хранятся перменные, которые нужны роли для ее работы, но пользователю про них знать не нужно. 
В defaults храним переменные, котороые пользователь может или должен задать для при использовании этой роли. 


Пример роли nginxinc.nginx

# ansible-role-nginx/vars/main.yml

# Supported NGINX Open Source distributions
# https://nginx.org/en/docs/install.html
nginx_supported_distributions:
  almalinux:
    name: AlmaLinux
    versions: [8, 9]
    architectures: [x86_64, aarch64, s390x]
  alpine:
    name: Alpine Linux
    versions: [3.15, 3.16, 3.17, 3.18]
    architectures: [x86_64, aarch64]

# ansible-role-nginx/defaults/main.yml

nginx_type: opensource
nginx_install_source_build_tools: true
nginx_install_source_pcre: false
nginx_install_source_openssl: true
nginx_install_source_zlib: false


