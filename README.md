# lynx-tcec

[Lynx](https://github.com/lynx-chess/Lynx) configuration files for [Top Chess Engine Championship (TCEC)](https://tcec-chess.com).

* `update.sh` builds latest Lynx dev version ([HEAD of main branch](https://github.com/lynx-chess/Lynx/tree/main)).

  If `LYNX_VERSION` is set, it uses that _git object_ instead (tags, branches and commits are supported).
* `update-nobuild.sh` downloads the latest Lynx released version ([Lynx releases](https://github.com/lynx-chess/Lynx/releases/latest)).

  If `LYNX_VERSION` is set, it uses the GitHub release linked to that tag instead.

## Building Lynx using Docker

Compile the latest dev version (aka just testing the script):

```bash
docker run --rm -it $(docker build -q .)
```

Compile the latest dev version and extract the output outside of the container:

```bash
docker run --rm -it -v ${PWD}:/home/tcec $(docker build -q .)
```

Download the latest released version (aka just testing the script)::

```bash
docker run --rm -it --entrypoint "/home/tcec/update-nobuild.sh" $(docker build -q .)
```

Download the latest released version and extract the output outside of the container:

```bash
docker run --rm -it -v ${PWD}:/home/tcec --entrypoint "/home/tcec/update-nobuild.sh" $(docker build -q .)
```

## Debugging

```bash
docker run --rm -it -v ${PWD}:/home/tcec --entrypoint bash $(docker build -q .)
```
