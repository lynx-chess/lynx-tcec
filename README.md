# lynx-tcec

[Lynx](https://github.com/lynx-chess/Lynx) configuration files for [Top Chess Engine Championship (TCEC)](https://tcec-chess.com).

## Building Lynx

Compile latest version of its `main` branch:

```bash
docker run --rm -it -v ${PWD}:/home/tcec $(docker build -q .)
```

Download the latest released version:

```bash
docker run --rm -it -v ${PWD}:/home/tcec --entrypoint "/home/tcec/update-nobuild.sh" $(docker build -q .)
```

## Debugging

```bash
docker run --rm -it -v ${PWD}:/home/tcec --entrypoint bash $(docker build -q .)
```
