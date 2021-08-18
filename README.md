
<div align="center">

<h1>Artifakt Docker Images</h1>
<img src="./.github/logo.png" alt="artifakt-logo" width="100"/>

**Base Docker images supported by Artifakt PaaS**

[![Build Docker Images](https://github.com/artifakt-io/artifakt-docker-images/actions/workflows/nightly.yml/badge.svg)][Build status]
[![Twitter handle][]][Twitter badge]

</div>

Contains all maintained runtimes supported by the Artifakt platform. All are freely available through our official registry at `registry.artifakt.io`

## Full list of available runtimes

| Runtime    | Version     | Base Image           | Demo App                                                                            | Build status                                                                         | Image Size
|------------|-------------|----------------------|-------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| Akeneo     | 4.0 Apache  | `akeneo:4.0-apache`  |[artifakt-io/base-akeneo](https://github.com/artifakt-io/base-akeneo/tree/4.0)       | ![akeneo:4.0-apache](https://img.shields.io/badge/akeneo_4.0-passing-green)          | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Akeneo     | 5.0 Apache  | `akeneo:5.0-apache`  |[artifakt-io/base-akeneo](https://github.com/artifakt-io/base-akeneo/tree/5.0)       | ![akeneo:5.0-apache](https://img.shields.io/badge/akeneo_5.0-passing-green)          | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Drupal     | 9.2 Apache  | `drupal:9.2-apache`  |[artifakt-io/base-drupal](https://github.com/artifakt-io/base-drupal/tree/9.2)       | ![drupal:9.2-apache](https://img.shields.io/badge/drupal_9.2-passing-green)          | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Java       | 8           | `java:8`             |[artifakt-io/base-java](https://github.com/artifakt-io/base-java)                    | ![Java 8](https://img.shields.io/badge/java_8-passing-green)                         | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Magento    | 2.4         | `magento:2.4-apache` |[artifakt-io/base-magento](https://github.com/artifakt-io/base-magento/tree/2.4)     | ![magento:2.4](https://img.shields.io/badge/magento_2.4-passing-green)               | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Node.js    | 12          | `node:12`            |[artifakt-io/base-nodejs](https://github.com/artifakt-io/base-nodejs)                | ![Node.js 12](https://img.shields.io/badge/nodejs_12-passing-green)                  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Node.js    | 14          | `node:14`            |[artifakt-io/base-nodejs](https://github.com/artifakt-io/base-nodejs)                | ![Node.js 14](https://img.shields.io/badge/nodejs_14-passing-green)                  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| PHP        | 7.3 Apache  | `php:7.3-apache`     |[artifakt-io/base-php](https://github.com/artifakt-io/base-php/tree/7.3)             | ![PHP 7.3](https://img.shields.io/badge/php_7.3_apache-passing-green)                | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| PHP        | 7.4 Apache  | `php:7.4-apache`     |[artifakt-io/base-php](https://github.com/artifakt-io/base-php/tree/7.4)             | ![PHP 7.4](https://img.shields.io/badge/php_7.4_apache-passing-green)                | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| PHP        | 8.0 Apache  | `php:8.0-apache`     |[artifakt-io/base-php](https://github.com/artifakt-io/base-php/tree/8.0)             | ![PHP 8.0](https://img.shields.io/badge/php_8.0_apache-passing-green)                | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Python     | 3.9         | `python:3.9`         |[artifakt-io/base-python](https://github.com/artifakt-io/base-python)                | ![python:3.9](https://img.shields.io/badge/python_3.9-passing-green)                 | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Ruby       | 2.7         | `ruby:2.7`           |[artifakt-io/base-ruby](https://github.com/artifakt-io/base-ruby)                    | ![ruby:2.7](https://img.shields.io/badge/ruby_2.7-passing-green)                     | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Sylius     | 1.10 Apache | `sylius:1.10-apache` |[artifakt-io/base-sylius](https://github.com/artifakt-io/base-sylius/tree/1.10)      | ![sylius:1.10-apache](https://img.shields.io/badge/sylius_1.10_apache-passing-green) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Symfony    | 4.4 Apache  | `symfony:4.4-apache` |[artifakt-io/base-symfony](https://github.com/artifakt-io/base-symfony/tree/4.4)     | ![symfony:4.4-apache](https://img.shields.io/badge/symfony_4.4_apache-passing-green) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Symfony    | 5.3 Apache  | `symfony:5.3-apache` |[artifakt-io/base-symfony](https://github.com/artifakt-io/base-symfony/tree/5.3)     | ![symfony:5.3-apache](https://img.shields.io/badge/symfony_5.3_apache-passing-green) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |
| Wordpress  | 5 Apache    | `wordpress:5-apache` |[artifakt-io/base-wordpress](https://github.com/artifakt-io/base-wordpress/tree/5.7) | ![wordpress:5-apache](https://img.shields.io/badge/wordpress_5_apache-passing-green) | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/library/php/8.0) |


# About Artifakt

[Artifakt](https://artifakt.com/?utm_source=github) is a developer-focused platform to run applications on the cloud—it deploys, monitors, and alerts any web-based application and auto-scales.

Artifakt makes cloud operations easier by filtering out potential differences between cloud providers and presents you all the essential features—for example, region selection, database settings, storage needs, and scalability options. 

Developers and agencies from all over the world can rely on Artifakt to manage the boilerplates of deployment: SSL, CDN, OS security, stack monitoring, etc.

And of course, we are thrilled to welcome contributions, fixes, or updates, so feel free to open pull requests! We aim to respond as soon as possible.

Check out the [Artifakt Blog](https://www.artifakt.com/blog) for all upcoming Docker-related (and not only!) announcements. 

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

To build all tags for a specific Docker image, use its name following the same folder name:

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

Upon successful build, the resulting image can be further assessed using using [Google's container-structure-test](https://github.com/GoogleContainerTools/container-structure-test) tool, with the following command:

```
./build.sh --image=php --tag=7.4-apache --lint=true --test=true
```

Remark #1: by design, if a Dockerfile fails linting, it will not be built
Remark #2: structure tests will look for a `test.yaml` next to the tested Dockerfile

At anytime, just call the help with `./build.sh --help` for all the available options.

## Execution sample: run a web application

It's easy to launch code inside a container from a pre-built Artifakt PHP image. Just paste the following command in a terminal pointing to the code source:

```console
docker run -d -p 8000:80 --name php_sample -v $PWD:/var/www/html registry.artifakt.io/php:7.4-apache
```

After the application starts, navigate to `http://localhost:8000` in your web browser.

# Adding an image

* Fork this repository
* Create a folder at the root with the convention `<image_name>/<tag>`
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
