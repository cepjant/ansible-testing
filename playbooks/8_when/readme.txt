Условия

Позволяют выполнять команды при выполнении условий. 

Условия можно задавать в инструкции vars: 

- hosts: all
  vars: 
    epic: true 
  tasks:
    - ansible.builtin.shell: echo "This is epic"
      when: epic 
    - ansible.builtin.shell
      when: not epic

В циклах:

- hosts: all
  tasks: 
    - ansible.builtin.command: echo {{ item }} 
      loop: [0, 2, 4, 6, 8, 10]
      when: item > 5

