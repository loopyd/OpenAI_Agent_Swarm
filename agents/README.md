# Hierarchical Autonomous Agent Swarm (HAAS)
## Agent Grand Central Infrastructure (AGCI)

HAAS Grand Central is responsible for the containerized orchestration of 
providing automation to the process of creating agent swarms.  It utilizes docker to containerize and modularize this project into its individual components.

## Getting started

To get started, you'll need the Docker Engine / Docker Desktop client set up on your host machine.

> You can find docker installation instructions at:
>
> [Docker Docs -- Installation Instructions](https://docs.docker.com/engine/install/)

Once you've got docker setup, you can proceed with running:

```bash
docker-compose -up -d
```

from the ``./agnets`` directory of the repository.

## TODOS:

Because this project is still in an experimental state, there are A LOT of TODOs.

 1. Implement other images (agent builder, agent functions, etc.)
    here.  I'm not sure what they are yet according to the collective, so 
    so I'm leaving them out of this commit for now.

2.  Redis and postgres was mentioned in David's most recent video, because 
    I don't want to overburden with the details of the redis/postgres
    service implementation and how agents will talk to each other through
    FastAPI with a message queue and routing keys -- I'm leaving that
    implementation out of this commit.

## Additional tools

This AGCI solution uses the following additional tools/projects:

| Component | Reason for usage | Link
| --- | --- | --- |
| ``poetry`` | Python and package version management | [Info](https://python-poetry.org/)
| ``autoflake`` | Code cleanup and standarization | [Info](https://github.com/PyCQA/autoflake)
| ``black`` | Fix coding conventions e | [Info](https://black.readthedocs.io/en/stable/index.html)
| ``isort`` | Additional code cleanup and standarization | [Info](https://pycqa.github.io/isort/)

If you'd like access to any of these projects' documentation, navigate by using the links in the table.