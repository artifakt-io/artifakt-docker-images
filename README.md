Artifakt Docker Images
======================================

Contains all runtimes officially supported by the Artifakt.io platform. All are freely available on [Artifakt - https://hub.docker.com/u/artifakt-io/](https://hub.docker.com/u/artifakt-io/).

Complete list of maintained runtimes:

Languages
 - PHP

Frameworks
 - Symfony

CMS
 - Wordpress
 - Drupal

Ecommerce
 - Magento2
 - Akeneo PIM

### Free public images

```
docker search artifakt-io
docker pull artifakt-io/magento2:2.4
```

### Build from Source

All images are publicly available on [Docker Hub](https://hub.docker.com/u/artifakt-io/). In case you want to build them locally, see sample commands below:

```
git clone https://github.com/artifakt-io/artifakt-docker-images/

cd artifakt-docker-images
```

To build all Docker images, just run the ```build.sh``` command at the top level:

```
./build.sh
```

To build a specific Docker image, use its name following the same folder name:

```
./build.sh --image=magento2
```

To build a specific version, just add the tag name to the previous build command

```
./build.sh --image=php --tag=7.4
```

In case a Dockerfile has been updated, this repo uses [Hadolint](https://github.com/hadolint/hadolint) as a linter.

To force validation on Dockerfile before building, add the following option:

```
./build.sh --image=php --tag=7.4 --lint=true
```

Remark: by design, if a Dockerfile fails linting, it will not be built


At anytime, just call the help with `./build.sh --help` for all the available options.



https://github.com/hadolint/hadolint

### Support

Feel free to open feedback and requests at https://github.com/artifakt-io/artifakt-docker-images/issues

