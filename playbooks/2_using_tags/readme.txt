Использование тегов для группировки задач и последующего выполнения или исключения (skip) отдельных групп:

ansible-playbook playbook.yml -i inventory.ini -t packages -- выполняет таски с тегом packages
ansible-playbook --check playbook.yml -i inventory.ini -t packages -- проверяет возможность изменений этих задач и правильность playbook файла
ansible-playbook playbook.yml -i inventory.ini --skip-tags users -- пропускает задачи с тегом users

