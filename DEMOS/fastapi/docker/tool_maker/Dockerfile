# Use an official Python runtime as a parent image
FROM python:3.11-bookworm

# Set environment variables that assist with keeping the filesystem clear of
# Python bytecode files and with ensuring that Python output is sent straight
# to the terminal without being buffered first.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Update base system
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev; \
    apt-get upgrade -y; \
    rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /app
COPY ./src .
COPY ./pyproject.toml .
COPY ./pyproject.toml ./pyproject.lock.toml


ENV POETRY_VERSION=1.2.0
ENV POETRY_HOME=/opt/poetry

# Install Poetry
RUN mkdir -p /opt/poetry; \
    curl -sSL https://install.python-poetry.org | python3 - ; \
    ln -s /opt/poetry/bin/poetry /usr/local/bin ; \
    poetry config virtualenvs.create false

# Allow installing dev dependencies to run tests
ARG DEBUG_MODE=false
ENV DEBUG_MODE=${DEBUG_MODE}

WORKDIR /app

RUN if [ "${DEBUG_MODE}" = "true" ] ; then \
        poetry install --no-root --no-interaction --no-ansi; \
    else \
        poetry install --no-root --only main  --no-interaction --no-ansi; \
    fi

# Create a user to run the app and change ownership of the app partition
# to allow the user to access it
RUN useradd -m -d /home/agent -s /bin/bash agent; \
    usermod -a -G agent agent; \
    chown -R root:agent /app; \
    chown -R root:agent /opt; \
    chmod -R gu+rwx /app; \
    chmod -R gu+rx /opt

# Expose the port that Jupyter Notebook runs on
ARG JUPYTER_HOST=0.0.0.0
ENV JUPYTER_HOST=${JUPYTER_HOST}
ARG JUPYTER_PORT=8888
ENV JUPYTER_PORT=${JUPYTER_PORT}
EXPOSE ${JUPYTER_PORT}

# Change user to agent
USER agent

# Confiugre poetry completions and install the agent kernel for Jupyter
RUN poetry completions bash >> /home/agent/.bash_completion; \
    echo "source /home/agent/.bash_completion" >> /home/agent/.bashrc; \
    python -m ipykernel install --user --name=agent

WORKDIR /app
ENTRYPOINT ["./scripts/run.sh"]
