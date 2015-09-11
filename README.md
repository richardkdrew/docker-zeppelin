# Apache Zeppelin - Docker Image

For more information about Apache Zeppelin look [here] (https://zeppelin.incubator.apache.org/).

## Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/richardkdrew/zeppelin/) from public [Docker Hub Registry](https://registry.hub.docker.com/):

```sh
docker pull richardkdrew/zeppelin
```

OR

Build a local image from the Dockerfile source:

```sh
docker build -t richardkdrew/zeppelin github.com/richardkdrew/docker-zeppelin
```

## How to use this image

You can run a container from this image (in it's simplest form), where the data directory is internal to the container and you intend to use the built in version of Spark, using the following command;

```sh
docker run -d --name zeppelin -p 8080:8080 -p 8081:8081 richardkdrew/zeppelin
```

However, I would recommend externalising the notebook and logs directories (exposed by this image as volumes - _/usr/local/zeppelin/notebook_ and _/usr/local/zeppelin/logs_).

### How to use an external notebook and logs directories for Zeppelin

Using a folder on the host mounted as the notebook and logs directories volume with the following command;

```sh
docker run -d --name zeppelin -p 8080:8080 -p 8081:8081 -v /path-on-my-machine/zeppelin-notebook:/usr/local/zeppelin/notebook -v /path-on-my-machine/zeppelin-logs:/usr/local/zeppelin/logs richardkdrew/zeppelin
```

Where _/path-on-my-machine/zeppelin-notebook_ is the folder on the host and _/usr/local/zeppelin/notebook_ is the location in the container it is mapped to (see [Docker Volumes](https://docs.docker.com/userguide/dockervolumes/) for more info).

OR

Using a data-only container as the notebook and logs directories volume with the following command;

```sh
docker run -d --name zeppelin -p 8080:8080 -p 8081:8081 --volumes-from zeppelin-data richardkdrew/zeppelin
```

Where _zeppelin-data_ is the name of the data-only container. This assumes you have already set up a data-only container i.e.

```sh
docker run --name zeppelin-data -v /usr/local/zeppelin/notebook -v /usr/local/zeppelin/logs debian:jessie /bin/false