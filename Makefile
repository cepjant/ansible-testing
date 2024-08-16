VENV=env
IMAGE_NAME=fake-remote-server
CONTAINER_NAME=fake-remote-server-container
SSH_PORT=2222

# Задачи и зависимости
setup: venv-prepare docker-setup

venv-prepare:
	@echo "Creating virtual environment and installing dependencies..."
	@if [ ! -d "$(VENV)" ]; then \
		sudo apt update; \
		sudo apt install python3-venv; \
		python3 -m venv $(VENV); \
		$(VENV)/bin/pip install -r requirements.txt; \
	fi

docker-build:
	@echo "Building Docker image..."
	@if [ -z "$$(docker images -q $(IMAGE_NAME))" ]; then \
		docker build -t $(IMAGE_NAME) .; \
	else \
		echo "Docker image $(IMAGE_NAME) already exists, skipping build."; \
	fi

docker-run:
	@echo "Running Docker container..."
	@if [ -z "$$(docker ps -q -f name=$(CONTAINER_NAME))" ]; then \
		if [ -n "$$(docker ps -aq -f status=exited -f name=$(CONTAINER_NAME))" ]; then \
			docker rm $(CONTAINER_NAME); \
		fi; \
		docker run -d --name $(CONTAINER_NAME) -p $(SSH_PORT):22 $(IMAGE_NAME); \
	else \
		echo "Docker container $(CONTAINER_NAME) is already running, skipping run."; \
	fi

docker-setup: docker-build docker-run

ping_server:
	@$(VENV)/bin/ansible all -i inventory.ini -m ping

start: setup ping_server
