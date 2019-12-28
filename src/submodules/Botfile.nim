import httpClient
import os
import strformat
import strutils

type
  Botfile = object
    url: string
    content: string
    name: string
    tick: int


proc getName(url: string): string =
  #[
    Splits a url on the "/" char and returns the last value in the seq
    which will be the file name of the Botfile.
  ]#
  url.split("/")[len(url.split("/"))-1]


proc getTick(content: string): int =
  #[
    Splits the content of the botfile on newlines returning the 4th line
    which is also split on the space with the resulting tick converted
    to an integer value.
  ]#
  parseInt(content.split("\n")[3].split(" ")[1])


proc saveBotfile(botfile: Botfile): Botfile {.discardable.} =
  # Saves a botfile locally in a hierarchical structure based on the tick.
  var dir = joinPath("botfiles", intToStr(botfile.tick))
  if not existsDir(dir):
    createDir(dir)
  if not existsFile(joinPath(dir, botfile.name)):
    writeFile(joinPath(dir, botfile.name), botfile.content)
    echo fmt"Botfile {botfile.url} saved"
  else:
    echo fmt"Botfile {botfile.tick} {botfile.name} already exists"


proc getBotfile*(url: string): Botfile {.discardable.} =
  var client = newHttpClient()
  try:
    echo fmt"Getting Botfile from {url}"
    let content = client.getContent(url)
    saveBotfile(Botfile(url: url, content: content, name: getName(url),
      tick: getTick(content)))
  except HttpRequestError:
    echo "Getting Failed"
    discard
