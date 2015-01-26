# cnfjd

## About

The program cnfjd is a command line interface to install/update/start/stop [cjdns](https://github.com/cjdelisle/cjdns) without having to lift a finger. _Disclaimer: you may have to lift a few fingers._

## Why?

Why not? I like to keep programs updated and running, but I don't like manually doing it.

## Installing

You can either install from source, or download the latest binary from GitHub.

### Download Binary

| OS X | Linux x86_64 |
|------|--------------|
| [Latest](https://github.com/lukevers/cnfjd/releases/download/v0.3.1/cnfjd-Mac-OS-X-10.10.zip) | [Latest](https://github.com/lukevers/cnfjd/releases/download/v0.3.1/cnfjd-Linux-x86_64.zip) |

### Install From Source

If you don't already have [Nim](http://nim-lang.org/) installed, be sure to [install Nim](http://nim-lang.org/download.html) on your system. 

```bash
git clone https://github.com/lukevers/cnfjd.git
cd cnfjd
```

#### Compiling

```bash
make
```

#### Installing

```bash
make install
```

## Usage

Just run the `cnfjd` command. The program is interactive, and currently has the following menu:

```
What would you like to do?
[1] Start cjdns
[2] Stop cjdns
[3] Restart cjdns
[4] Reinstall cjdns
[5] Uninstall cjdns
[6] Generate a new random configuration file
[7] Generate a new vanity configuration file
[8] Add a peer - TODO
[9] Remove a peer - TODO
[0] Exit
```

Although it says to exit the program type `0`, any key that's not `1...9` will exit the program.

## License

See [LICENSE](LICENSE.md) for the full license details.
