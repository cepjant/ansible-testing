В плейбуках можно использовать фильтры из системы шаблонов Jinja2:

- hosts: all 
  gather_facts: no 
  vars: 
    numbers: [3, 2, 1, 3, 2]
  tasks: 
    - name: get min number 
      ansible.builtin.debug: msg={{ numbers | min }}
    - name: get max number 
      ansible.builtin.debug: msg{{ numbers | max }} 
    - name: get unique values
      ansible.builtin.debug: var={{ item }} 
      loop: "{{ numbers | unique }}"
    - name: get random value 
      ansible.builtin.debug: msg={{ ['a', 'b', 'c'] | random }} 


Как применяется в реальной жизни:

1. Найти сервер с самым большим количеством CPU
2. Найти сервер с наименьшим количеством оперативной памяти

Еще примеры:

- hosts: all
  gather_facts: no
  vars:
    path: /var/log/upstart/nginx.log
  tasks:
    - ansible.builtin.debug: msg={{ '192.0.2.1/24' | ipaddr('address') }}
    - ansible.builtin.debug: msg={{ 'test1' | hash('sha1') }}
    - ansible.builtin.debug: msg={{ path | basename }}
    - ansible.builtin.debug: msg={{ path | dirname }}
    - ansible.builtin.debug: msg={{ "~/Movies" | expanduser }}


- ipaddr позволяет извлекать из ip-адреса различные его части
- hash создает хэш, который затем может быть использован, например, в файлах конфигурации 
- basename и dirname работают с путями. С помощью них можно выделить имя файла и путь к директории
- expanduser раскрывать путь. ~/Movies для пользователя hexleet превратится в /home/hexlet/Movies

Другие популярные фильтры:

default - устанавливает значение по умолчанию для переменной, если она не определена 
map - преобразует каждый элемент в списке
json_query - позволяет запросить структуры JSON  с помощью специального запроса
regex_replace - заменяет текст, используя регулярные выражения 
 
