Роли позволяют выделять повторяющиеся наборы задач в роли. Роли хранятся в каталоге (https://galaxy.ansible.com/ui/). 

Для работы с ролями нужно: 

1. Установить роль (например ansible-galaxy install nginxinc.nginx)

2. Подключить роль в плейбук. Обычно роли выполняются до блока tasks. 

Но этим можно управлять двумя способами:

2.1. pre_tasks: 

- hosts: all
  pre_tasks: # выполнение до ролей 
    - name: some task 
      ansible.builtin.shell: # делаем что-нибудь
  roles: 
    - role: nginxinc.nginx
    - role: # какая-нибудь другая роль
  tasks: # выполнение после ролей
    # список задач


2.1 import_rtole:

- hosts: all
  tasks: 
    - name: какая-то задача 
      ansible.builtin.shell: # делаем что-нибудь
     
    - name: ставим nginx через роль
      import_role: 
        name: nginxinc.nginx

    - name: какая-то задача
      ansible.builtin.shell: cat ... 


3. Конфигурация ролей. 

Роли стараются делать конфигурируемыми с помощью переменных. 
Эти переменные можно найти в директории defaults/ в репозитории роли. 

Пример NGINX: https://github.com/nginxinc/ansible-role-nginx/blob/main/defaults/main/main.yml

Переопределяются эти переменные через ключ vars: 

# roles
- hosts: all 
  roles: 
    - role: nginxinc.nginx
      vars: 
        nginx_debult_output: true 
        nginx_modules: 
          - geoip

# import_role
- hosts: all
  tasks: 
    - import_role: 
        name: nginxinc.nginx
      vars: 
        nginx_debulg_output: true
        nginx_modules: 
          - geoip


4. Автоматическая установка

Для автоматической установки роли используется файл requirements.yml, куда добавляется список нужных ролей:

roles: 
  # install a rle from ansible galaxy
  - name: geerlingguy.java
    version: 1.9.6

Затем выаполняется установка:

ansible-galaxy install -r requirements.yml


