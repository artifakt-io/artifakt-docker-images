
<div align="center">


<h1>Artifakt Docker Images</h1>
<img src="./.github/logo.svg" alt="artifakt-logo" width="100"/>

**Base Docker images supported by Artifakt PaaS**


[![Build Docker Images](https://github.com/artifakt-io/artifakt-docker-images/actions/workflows/nightly.yml/badge.svg)][Build status]
[![Twitter handle][]][Twitter badge]

</div>

Contains all maintained runtimes supported by the Artifakt platform. All are freely available through our official registry at `registry.artifakt.io`

## Full list of available runtimes

### Languages
 - Java
   - 8 `docker pull registry.artifakt.io/java:8`
 - Node.js
   - 12.x `docker pull registry.artifakt.io/node:12`
   - 14.x `docker pull registry.artifakt.io/node:14`
 - PHP
   - 7.4 FPM `docker pull registry.artifakt.io/php:7.4-fpm`
   - 7.4 Apache `docker pull registry.artifakt.io/php:7.4-apache`
   - 7.3 FPM `docker pull registry.artifakt.io/php:7.3-fpm`
   - 7.3 Apache `docker pull registry.artifakt.io/php:7.3-apache`
   - 8.x FPM `docker pull registry.artifakt.io/php:8-fpm`
   - 8.x Apache `docker pull registry.artifakt.io/php:8-apache`
 - Python
   - 3.9 `docker pull registry.artifakt.io/python:3`

### Frameworks
 - Symfony
   - 4.4 Apache `docker pull registry.artifakt.io/symfony:4.4-apache`
   - 5.2 Apache `docker pull registry.artifakt.io/symfony:5.2-apache`
   - 5.2 FPM `docker pull registry.artifakt.io/symfony:5.2-fpm`

### CMS
 - Wordpress
   - 5 Apache `docker pull registry.artifakt.io/wordpress:5-apache`
 - Drupal
   - 8.9 Apache `docker pull registry.artifakt.io/drupal:8.9-apache`
   - 9.1 Apache `docker pull registry.artifakt.io/drupal:9.1-apache`

### Ecommerce
 - Magento
   - 2.4 `docker pull registry.artifakt.io/magento:2.4`
 - Akeneo
   - 4.0 Apache `docker pull registry.artifakt.io/akeneo:4-apache`
   - 5.0 Apache `docker pull registry.artifakt.io/akeneo:5-apache`

# About Artifakt

[Artifakt](https://artifakt.com/?utm_source=github) is a developer-focused platform to run applications on the cloud—it deploys, monitors, and alerts any web-based application and auto-scales.

Artifakt makes cloud operations easier by filtering out potential differences between cloud providers and presents you all the essential features—for example, region selection, database settings, storage needs, and scalability options. 

Developers and agencies from all over the world can rely on Artifakt to manage the boilerplates of deployment: SSL, CDN, OS security, stack monitoring, etc.

And of course, we are thrilled to welcome contributions, fixes, or updates, so feel free to open pull requests! We aim to respond as soon as possible.

Check out the [Artifakt Blog] (https://www.artifakt.com/blog) for all upcoming Docker-related (and not only!) announcements. 

# How to use our images

## Pull from public registry

```
docker pull registry.artifakt.io/magento:2.4-apache
```

## Build from Source

All images are publicly available, just use the `docker pull` command or `FROM` syntax in your Dockerfile.
In case you want to build them locally, see sample commands below:

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
./build.sh --image=magento
```

To build a specific version, just add the tag name to the previous build command

```
./build.sh --image=php --tag=7.4-apache
```

In case a Dockerfile has been updated, this repo uses [Hadolint](https://github.com/hadolint/hadolint) as a linter.

To force validation on Dockerfile before building, add the following option:

```
./build.sh --image=php --tag=7.4-apache --lint=true
```

Remark: by design, if a Dockerfile fails linting, it will not be built

At anytime, just call the help with `./build.sh --help` for all the available options.

## Execution sample: run a web application

It's easy to launch code inside a container from a pre-built Artifakt PHP image. Just paste the following command in a terminal pointing to the code source:

```console
docker run -d -p 8000:80 --name php_sample -v $PWD:/var/www/html registry.artifakt.io/php:7.4-apache
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

License
=========

artifakt-docker-images is licensed under the Apache License, Version 2.0. See
[LICENSE](https://github.com/artifakt-io/artifakt-docker-images/blob/main/LICENSE) for the full
license text.

[Build Status - Main]: https://github.com/artifakt-io/artifakt-docker-images/actions/workflows/nightly.yml/badge.svg?branch=main&event=push
[Build status]: https://github.com/artifakt-io/artifakt-docker-images/actions
[Twitter badge]: https://twitter.com/intent/follow?screen_name=artifakt_com
[Twitter handle]: https://img.shields.io/twitter/follow/artifakt_com.svg?style=social&label=Follow
