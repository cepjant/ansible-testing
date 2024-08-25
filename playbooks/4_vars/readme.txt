для определения переменных в playbook-ах:

- hosts: webservers
  vars: 
    var_name: value 


далее можно использовать в фигурных скобках: 

  tasks: 
    - name: {{ var_name }} 


использование ansible.builtin.template позволяет передать переменные в используемые в таске файлы:

  tasks: 
    - name: update nginx config
      ansible.builtin.template:
        src: templates/nginx.conf
        dest: "{{root_dir}}/nginx.conf"

В этом случае переменные, определенные в плейбуке будут переданы в файл templates/nginx.conf и отправлены на сервер
