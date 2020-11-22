# Ticker

unofficial OS agnostic botfile downloader for the game [planetarion](http://www.planetarion.com/) wrote in Nim.

## Usage

Download the latest release from the [releases](https://github.com/Um9i/ticker/releases) page and run. 

It will get the current ticks botfiles and continue to run in the background where upon every hour it runs again to get the latest tick.

## But i have missing botfiles?

You can run Ticker with the optional `--catchup` parameter.

```sh
./Ticker --catchup 1
```

this will get all botfiles from tick 1 until the current.
