VENV=env

setup: venv-prepare docker-run

venv-prepare:
	@echo "Creating virtual environment and installing dependencies..."
	@if [ ! -d "$(VENV)" ]; then \
		sudo apt update; \
		sudo apt install python3-venv; \
		python3 -m venv $(VENV); \
		$(VENV)/bin/pip install -r requirements.txt; \
	fi

docker-run:
	@echo "Running Docker containers..."
	@docker-compose up -d

ping_server:
	@$(VENV)/bin/ansible all -i inventory.ini -m ping

start: setup ping_server
