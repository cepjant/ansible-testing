Коллекции - формат распространения связанного набора плейбуков, ролей, модулей и плагинов. 

ansible.builtin - единственная встроенная прямо в ядро коллекция

список установленных коллекций можно посмотреть так:

ansible-galaxy collection list
# Не полный вывод

Collection                    Version
----------------------------- -------
amazon.aws                    2.1.0
ansible.netcommon             2.5.0
ansible.posix                 1.3.0
ansible.utils                 2.4.3
ansible.windows               1.9.0
cloud.common                  2.1.0
community.crypto              2.1.0
community.digitalocean        1.14.0
community.dns                 2.0.4
community.docker              2.1.1
community.general             4.3.0
community.google              1.0.0
community.grafana             1.3.0
community.kubernetes          2.0.1
community.mongodb             1.3.2
community.network             3.0.0


Принцип наименования как у ролей: неймспейс.имя_коллекции. Но есть и третье имя - используемый модель. 

Пример с коллекцией community.postgresql:

- hosts: all 
  tasks: 
    - name: Создание новой базы данных 
      community.postgresql.postgresql_db: 
        name: db_name 
   
    - name: Создание дампа базы данных 
      community.postgresql.postgresql_db: 
        name: db_name
        state: dump 
        target: /tmp/db_name.sql


Пример использования модуля для управления таблицами в существующей базе данных: 

- hosts: all
  tasks: 
    - name: Создание таблицы 
      community.postgresql.postgresql_table: 
        db: db_name
        name: table_name 


PostgreSQL поставляется вместе с Ansible, поэтому его можно использовать без усттановки. 
Если коллекция не входит в стандартную поставку, ее можно установить через ansible-galaxy: 

ansible-galaxy collection install nginxinc.nginx_core

--- 

#### Автоматичесакая установка

Поддерживается автоматическая установка так же, как и с ролями: 

requirements.yml: 

collections: 
  - name: geerlingguy.php_roles
    version: 0.9.3 

... 

ansible-galaxy install -r requirements.yml 



