
<div align="center">

<h1>Artifakt Docker Images</h1>
<img src="./.github/logo.png" alt="artifakt-logo" width="100"/>

**Base Docker images supported by Artifakt PaaS**

[![Build Docker Images](https://github.com/artifakt-io/artifakt-docker-images/actions/workflows/nightly.yml/badge.svg)][Build status]
[![Twitter handle][]][Twitter badge]

</div>

Contains all maintained runtimes supported by the Artifakt platform. All are freely available through our official registry at `registry.artifakt.io`

## Full list of available runtimes

| Runtime    | Version     | Base Image           | Demo App                                                                            | Build status                                                                      | Image Size
|------------|-------------|----------------------|-------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| Akeneo     | 4.0 Apache  | `akeneo:4.0-apache`  |[artifakt-io/base-akeneo](https://github.com/artifakt-io/base-akeneo/tree/4.0)       | ![akeneo:4.0-apache](https://res.cloudinary.com/artifakt/akeneo_4.0-status.svg)   | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/akeneo_4.0-size.svg)  |
| Akeneo     | 5.0 Apache  | `akeneo:5.0-apache`  |[artifakt-io/base-akeneo](https://github.com/artifakt-io/base-akeneo/tree/5.0)       | ![akeneo:5.0-apache](https://res.cloudinary.com/artifakt/akeneo_5.0-status.svg)   | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/akeneo_5.0-size.svg)  |
| Angular    | 12          | `angular:12`         |[artifakt-io/base-angular](https://github.com/artifakt-io/base-angular)              | ![angular:12](https://res.cloudinary.com/artifakt/angular_12-status.svg)          | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/angular_12-size.svg)  |
| Drupal     | 9.2 Apache  | `drupal:9.2-apache`  |[artifakt-io/base-drupal](https://github.com/artifakt-io/base-drupal/tree/9.2)       | ![drupal:9.2-apache](https://res.cloudinary.com/artifakt/drupal_9.2-status.svg)   | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/drupal_9.2-size.svg)  |
| Golang     | 1.16        | `golang:1.16`        |[artifakt-io/base-golang](https://github.com/artifakt-io/base-golang)                | ![golang:1.16](https://res.cloudinary.com/artifakt/golang_1.16-status.svg)        | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/golang_1.16-size.svg) |
| Java       | 8           | `java:8`             |[artifakt-io/base-java](https://github.com/artifakt-io/base-java)                    | ![Java 8](https://res.cloudinary.com/artifakt/java_8-status.svg)                  | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/java_8-size.svg)      |
| Magento    | 2.4         | `magento:2.4-apache` |[artifakt-io/base-magento](https://github.com/artifakt-io/base-magento/tree/2.4)     | ![magento:2.4](https://res.cloudinary.com/artifakt/magento_2.4-status.svg)        | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/magento_2.4-size.svg) |
| Node.js    | 12          | `node:12`            |[artifakt-io/base-nodejs](https://github.com/artifakt-io/base-nodejs)                | ![Node.js 12](https://res.cloudinary.com/artifakt/nodejs_12-status.svg)           | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/nodejs_12-size.svg)   |
| Node.js    | 14          | `node:14`            |[artifakt-io/base-nodejs](https://github.com/artifakt-io/base-nodejs)                | ![Node.js 14](https://res.cloudinary.com/artifakt/nodejs_14-status.svg)           | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/nodejs_14-size.svg)   |
| Nuxtjs     | 2.15        | `nuxtjs:2.15`        |[artifakt-io/base-nuxtjs](https://github.com/artifakt-io/base-nuxtjs)                | ![Nuxtjs 2.15](https://res.cloudinary.com/artifakt/nuxtjs_2.15-status.svg)        | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/nuxtjs_2.15-size.svg) |
| PHP        | 7.3 Apache  | `php:7.3-apache`     |[artifakt-io/base-php](https://github.com/artifakt-io/base-php/tree/7.3)             | ![PHP 7.3](https://res.cloudinary.com/artifakt/php_7.3-status.svg)                | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/php_7.3-size.svg)     |
| PHP        | 7.4 Apache  | `php:7.4-apache`     |[artifakt-io/base-php](https://github.com/artifakt-io/base-php/tree/7.4)             | ![PHP 7.4](https://res.cloudinary.com/artifakt/php_7.4-status.svg)                | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/php_7.4-size.svg)     |
| PHP        | 8.0 Apache  | `php:8.0-apache`     |[artifakt-io/base-php](https://github.com/artifakt-io/base-php/tree/8.0)             | ![PHP 8.0](https://res.cloudinary.com/artifakt/php_8.0-status.svg)                | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/php_8.0-size.svg)     |
| Python     | 3.9         | `python:3.9`         |[artifakt-io/base-python](https://github.com/artifakt-io/base-python)                | ![python:3.9](https://res.cloudinary.com/artifakt/python_3.9-status.svg)          | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/python_3.9-size.svg)  |
| Ruby       | 2.7         | `ruby:2.7`           |[artifakt-io/base-ruby](https://github.com/artifakt-io/base-ruby)                    | ![ruby:2.7](https://res.cloudinary.com/artifakt/ruby_2.7-status.svg)              | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/ruby_2.7-size.svg)    |
| Sylius     | 1.10 Apache | `sylius:1.10-apache` |[artifakt-io/base-sylius](https://github.com/artifakt-io/base-sylius/tree/1.10)      | ![sylius:1.10-apache](https://res.cloudinary.com/artifakt/sylius_1.10-status.svg) | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/sylius_1.10-size.svg) |
| Symfony    | 4.4 Apache  | `symfony:4.4-apache` |[artifakt-io/base-symfony](https://github.com/artifakt-io/base-symfony/tree/4.4)     | ![symfony:4.4-apache](https://res.cloudinary.com/artifakt/symfony_4.4-status.svg) | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/symfony_4.4-size.svg) |
| Symfony    | 5.3 Apache  | `symfony:5.3-apache` |[artifakt-io/base-symfony](https://github.com/artifakt-io/base-symfony/tree/5.3)     | ![symfony:5.3-apache](https://res.cloudinary.com/artifakt/symfony_5.3-status.svg) | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/symfony_5.3-size.svg) |
| VueJs      | 3           | `vuejs:3`            |[artifakt-io/base-vuejs](https://github.com/artifakt-io/base-vuejs)                  | ![wordpress:vuejs](https://res.cloudinary.com/artifakt/vuejs_3-status.svg)        | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/vuejs_3-size.svg)     |
| Wordpress  | 5 Apache    | `wordpress:5-apache` |[artifakt-io/base-wordpress](https://github.com/artifakt-io/base-wordpress/tree/5.7) | ![wordpress:5-apache](https://res.cloudinary.com/artifakt/wordpress_5-status.svg) | ![Docker Image Size (tag)](https://res.cloudinary.com/artifakt/wordpress_5-size.svg) |

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
