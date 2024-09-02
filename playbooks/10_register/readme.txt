## Регистрация результата 


ключ `register` позволяет записать результат вывода задачи в новую переменную.


- hosts: all
  gather_facts: no 
  tasks: 
    - ansible.builtin.shell: ls /Users
      register: home_dirs
    - name: add home dirs to cron 
      ansible.builtin.cron: 
        name: "backup_dirs"
        minute: "0"
        hour: "5,2"
        job: "backup /home/{{ item }}"
      with_items: home_dirs.stdout_lines
    - ansible.builtin.debug: 
        var: home_dirs.stdout_lines


В данном примере home_dirs - это хеш, внутри которого содержится информация о таске. Чтобы посмотреть его содержимое, можно воспользоваться командой debug: 

- hosts: all 
  gather_facts: no 
  tasks: 
    - ansible.builtin.shell: ls /Users
      register: home_dirs
    
    - name: print home_dirs variable
      ansible.builtin.debug:
        var: home_dirs


Результат выполнения команды:

ansible-playbook playbook.yml -i inventory.ini
TASK: [print home_dirs variable] ****************
ok: [localhost] => {
    "var": {
        "home_dirs": {
            "changed": true,
            "cmd": "ls /Users",
            "delta": "0:00:00.011196",
            "end": "2020-08-11 15:20:12.739441",
            "failed": false,
            "rc": 0,
            "start": "2020-08-11 15:20:12.728245",
            "stderr": "",
            "stderr_lines": [],
            "stdout": "Guest\nShared\nkirill"
            "stdout_lines": [
                "Guest",
                "Shared",
                "kirill"
            ]
        }
    }
}


stdout представлен в двух вариантах: строка и список (stdout_lines). Список можно использоваться для итерации по нему при выполеннии задачи. 

---

Вот пример выполнения команды по условию успешности выполнения другой команды:

- hosts: all
  gather_facts: no
  tasks: 
    - ansible.builtin.command: 'false'
      register: result
      ignore_errors: yes   # важно, чтобы ansible не прекратил выполнение при exit-code != 0
    - ansible.builtin.command: echo 'ehu'
      when: not iltinresult.failes
    - ansible.builtin.command: uptime
      when: result.failed

Здесь вызывается функция false. Функция возвращает не нулевой статус, поэтому плейбук должен завершиться ошибкой и не выполняться дальше. 
Ключ ignore_errors подавляет ошибку. 

Дальше выполняется одна из команд, зависящих от условия выполнения false. 

