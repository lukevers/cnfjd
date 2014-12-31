# cnfjd

## About

The program cnfjd is a command line interface to install/update [cjdns](https://github.com/cjdelisle/cjdns) without having to lift a finger. _Disclaimer: you may have to lift a few fingers._

## Installing

Currently you can only install from source.

### Install From Source

If you don't already have [Nim](http://nim-lang.org/) installed, be sure to [install Nim](http://nim-lang.org/download.html) on your system. 

```bash
git clone https://github.com/lukevers/cnfjd.git
cd cnfjd
```

#### Compiling

You can't compile and run cnfjd without Nim installed. It has to be installed with OpenSSL in order to check for updates, so `-d:ssl` must be included when compiling cnfjd.

```bash
nim c -d:ssl cnfjd.nim
```

#### Installing

Place the cnfjd binary anywhere in your `$PATH`. For example:

```bash
cp cnfjd /usr/local/bin/cnfjd
```

## Usage

Just running the `cnfjd` command.

## License

See [LICENSE](LICENSE.md) for the full license details.
