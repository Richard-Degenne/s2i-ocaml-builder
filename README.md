s2i-ocaml-builder
=================

This is a first attempt at dockerizing OCaml application using [Openshift's source-to-image](https://github.com/openshift/source-to-image) tool.

## Disclaimer

This tool is far from being usable at all. However, I hope to make it better and better by improving my understanding of Docker and of OCaml packaging and building processes.

## Requirements

Building the `s2i-ocaml-builder` requires [Docker](https://www.docker.com/).

Using `s2i-ocaml-builder` to build application images requires `s2i`. Refer to s2i [installation instructions](https://github.com/openshift/source-to-image#installation).

## Installation

### Building `s2i-ocaml-builder`

Clone this repository and `cd` into it.

    $ git clone https://github.com/Richard-Degenne/s2i-ocaml-builder
    $ cd s2i-ocaml-builder

Then, build the `s2i-ocaml-builder` image with

    $ docker build -t s2i-ocaml-builder .

### Building an application image

*This exemple uses a very simple [echo server](https://github.com/Richard-Degenne/echo-server). Feel free to follow along by cloning it.*

The image uses the OPAM metadata to build the application. Make sure your project has a valid OPAM file.

To build the application image, run the following

    $ s2i build . s2i-ocaml-builder echo-server:test -e PACKAGE_NAME=echo-server

- `echo-server:test` is the name/tag of the image that will be produced.
- `PACKAGE_NAME` is an environment variable sent to the builder image. It is necessary for it to locate the OPAM file.

The only condition for the container to start properly is to have OPAM install an executable named `run` that will start your application.

#### Running an application image

To run the built application, spawn a container using the target image and publish needed port(s).

    $ docker run -d -p5000:5000 echo-server

### Further documentation

S2I's default documentation is available in [S2I_README.md](S2I_README.md).

## Todo list

### Reduce the application image size

The resulting image is **fat**. This is because the whole build environment is embedded in it.

In a compiled language such as OCaml, it is primordial that the build environment is different form the run environment. However, this doesn't seem to be a trivial use-case for `s2i`, so I'll leave it for later.

### Make the running process more generic

Imposing an executable name on the developer's side is a hassle. Find a way to make this more generic, maybe using a `Procfile` of some sort.

Besides, I believe it makes it impossible to give the run command parameters.

### Reduce logging

For the time being, all commands outputs the default flow of information to `stdout`, which isn't very relevant in an non-interactive context such as here.

On the other hand, concise logs will help troubleshooting and will make the whole thing look better.

### Improve build workflow

I'm very unfamiliar with OCaml build toolchains. I think there might a far better way of handling the build of the application. See [s2i/bin/assemble](s2i/bin/assemble).


