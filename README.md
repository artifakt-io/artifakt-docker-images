

# Artifakt Docker Images

Contains all officially supported runtimes supported by the Artifakt.io platform. All are freely available on [Artifakt - https://hub.docker.com/u/artifaktio](https://hub.docker.com/u/artifaktio).

## Currently maintained runtimes

### Languages
 - [artifaktio/php](https://hub.docker.com/r/artifaktio/php)

### Frameworks
 - [artifaktio/symfony](https://hub.docker.com/r/artifaktio/symfony)

### CMS
 - [artifaktio/wordpress](https://hub.docker.com/r/artifaktio/wordpress) 
 - [artifaktio/drupal](https://hub.docker.com/r/artifaktio/drupal) 

### Ecommerce
 - [artifaktio/magento](https://hub.docker.com/r/artifaktio/magento) 
 - [artifaktio/akeneo](https://hub.docker.com/r/artifaktio/akeneo) 


# About Artifakt.io

[Artifakt](https://artifakt.io/?utm_source=github) is a developer-focused platform to run applications in the cloud. It can deploy, monitor and alert any web-based application and can scale to any scenario.

Artifakt makes cloud operations easier, by abstracting away differences between cloud providers and exposing only the essentials. It keeps only the features that counts like region selection, database settings, storage needs, and scalability options. 

Developers and agencies from all over the world can rely on Artifakt to manage all the boilerplate of deployments: SSL, CDN, OS security, stack monitoring.

Of course we welcome [contributions](https://github.com/artifakt-io/artifakt-docker-images/blob/main/CONTRIBUTING.md), fixes, or updates, feel free to open pull requests, and we will be thrilled to answer as soon as possible.

Watch [the official blog](https://www.artifakt.io/blog) for Docker-related announcements.

# How to use our images

## Pull from public registry

```
docker search artifaktio
docker pull artifaktio/magento:2.4
```

## Build from Source

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

## Execution sample: run a web application

It's easy to launch code inside a container from pre-built Artifakt PHP image. Just paste the following command in a terminal pointing to the code source:

```console
docker run -d -p 8000:80 --name php_sample -v $PWD:/var/www/html artifakt-io/php:7.3-apache
```

After the application starts, navigate to `http://localhost:8000` in your web browser.

# Adding an image

* Fork this repository
* Create a folder at the root with the convention <image_name>/<tag>
* Write a Dockerfile inside this new folder
* Lint it with `hadolint`
* Submit a new pull request
* Upon successful review, we'll publish it on our official registry

# Image update policy

* We update the supported images within 12 hours of any updates to their base images (e.g. php:7-apache-buster, wordpress:5-php7.3-apache, etc.).

# Support and feedback

* [File an issue](https://github.com/artifakt-io/artifakt-docker-images/issues/new/choose)
* [Contact Artifakt Support](https://support.artifakt.io/)

# License
 
 TBD
