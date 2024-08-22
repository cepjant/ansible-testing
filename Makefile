VENV=env
IMAGE_NAME=fake-remote-server
FIRST_CONTAINER_NAME=fake-remote-server-container_1
SECOND_CONTAINER_NAME=fake-remote-server-container_2
FIRST_SSH_PORT=2222
SECOND_SSH_PORT=2223
HTTP_PORT=8080

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
	@echo "Running first Docker container..."
	@if [ -z "$$(docker ps -q -f name=$(FIRST_CONTAINER_NAME))" ]; then \
		if [ -n "$$(docker ps -aq -f status=exited -f name=$(FIRST_CONTAINER_NAME))" ]; then \
			docker rm $(FIRST_CONTAINER_NAME); \
		fi; \
		docker run -d --name $(FIRST_CONTAINER_NAME) -p $(HTTP_PORT):80 -p $(FIRST_SSH_PORT):22 $(IMAGE_NAME); \
	else \
		echo "Docker container $(FIRST_CONTAINER_NAME) is already running, skipping run."; \
	fi
	
	@echo "Running second Docker container..."
	@if [ -z "$$(docker ps -q -f name=$(SECOND_CONTAINER_NAME))" ]; then \
		if [ -n "$$(docker ps -aq -f status=exited -f name=$(SECOND_CONTAINER_NAME))" ]; then \
			docker rm $(SECOND_CONTAINER_NAME); \
		fi; \
		docker run -d --name $(SECOND_CONTAINER_NAME) -p $(SECOND_SSH_PORT):22 $(IMAGE_NAME); \
	else \
		echo "Docker container $(SECOND_CONTAINER_NAME) is already running, skipping run."; \
	fi

docker-setup: docker-build docker-run

ping_server:
	@$(VENV)/bin/ansible all -i inventory.ini -m ping

start: setup ping_server
