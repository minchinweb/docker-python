# Personal Python Base Container

This is my personal base container for Docker, now with Python! Maybe you'll
find it helpful too...

[![Docker Pulls](https://img.shields.io/docker/pulls/minchinweb/python.svg?style=popout)](https://hub.docker.com/r/minchinweb/python)
[![Size & Layers](https://images.microbadger.com/badges/image/minchinweb/python.svg)](https://microbadger.com/images/minchinweb/python)
[![GitHub issues](https://img.shields.io/github/issues-raw/minchinweb/docker-python.svg?style=popout)](https://github.com/MinchinWeb/docker-python/issues)
<!--
![MicroBadger Layers](https://img.shields.io/microbadger/layers/layers/minchinweb/python.svg?style=plastic)
![MicroBadger Size](https://img.shields.io/microbadger/image-size/image-size/minchinweb/python.svg?style=plastic)
-->

## How to Use This

The container will probably not be used directly, but rather as a for building
other (Docker) containers on. To do that, specify this as your base image (in
your `Dockerfile`):

    FROM minchinweb/python

    # ... and the rest

**This packages Python 3.7.**

You also probably want to set the UID and GID (*User ID* number and *Group ID*
number). This can be done through the environmental variables `PUID` and `GUID`
(either the `-e` option at the command line, or the `environment` key in your
*docker-compose.yaml* file).

There is also a folders at `/app`, `/config`, `/defaults` that are owned by the
user. The idea is to have your application use this `/config` volume for all
its persist-able data, and do this by mounting this as a volume outside of your
container (either the `-v` option at the command line, or the `volumes` key in
your *docker-compose.yaml* file). `/app` is a logical location for the Python
program you are trying to run.

## Why I Created This

or, *What Problems is This Trying to Solve?*

After solving the issues with user permissions and PID 1 with my [base
container](https://github.com/MinchinWeb/docker-base), I wanted to keep those
solutions in place for my Python Docker images.

The first thing I tried was to install Python 3.7 using `apt`. While there is a
`python3.7` package that will happily install, there is [no corresponding apt
package for
`pip`](https://bugs.launchpad.net/ubuntu/+source/python3-defaults/+bug/1800723)
(which is needed to install other Python libraries).

Next I tried to compile Python from source myself. This seemed to work, but it
took over an hour. This didn't seem to the most desirable solution.

Finally, I realized I could "borrow" a pre-compiled version of Python from the
official image via a "multi-stage build", using the official image as my "build
stage". This seems to work, the build time is much better, although a few extra
tweaks were needed.

## Personal Additions and Notes

- add various tags as per [label-schema.org](http://label-schema.org/rc1/)
- the locale is set (by my base image) to Canadian English
- `pip` doesn't cache downloaded packages

## Prior Art

This builds on [my base image](https://github.com/MinchinWeb/docker-base).

This also wouldn't work without the [official Python
image](https://hub.docker.com/_/python).

## Known Issues

- Currently, only the tagging on Docker Hub isn't as complete as I'd like.
- additional `apt` packages may be needed to support building C extensions with
  `pip` or to allow pre-compiled wheels to work.
