setup: venv-prepare

venv-prepare:
	python3 -m venv env 
	env/bin/python -m pip install -r requirements.txt

ping_server:
	ansible all -i inventory.ini -m ping

start: ping_server
