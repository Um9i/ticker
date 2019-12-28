import algorithm
import os
import strutils
import strformat
import submodules/botfile
import times


proc missingTicks(dir: string, fromtick: int): seq[int] {.discardable.} =
  # Provides a sequence of ticks we don't have locally
  var ticks: seq[int]
  var missing: seq[int]
  for kind, path in walkDir(dir):
    ticks.add(parseInt(path.splitPath()[1]))
  ticks.sort(system.cmp[int], Ascending)
  for i in countup(fromtick, ticks[ticks.high]):
    if i in ticks:
      discard
    else:
      missing.add(i)
  missing


proc tick(url: string) {.discardable.} =
  # Downloads botfiles from a remote dir/url
  let botfiles = [
    "alliance_listing.txt",
    "galaxy_listing.txt",
    "planet_listing.txt",
    "user_feed.txt"
  ]
  for botfile in botfiles:
    getBotfile(url & botfile)


proc catchup(url: string, fromtick: int) {.discardable.} =
  # Make sure we have the latest tick
  tick("https://game.planetarion.com/botfiles/")
  for tick in missingTicks("botfiles", fromtick):
    tick(fmt"{url}{tick}/")


when isMainModule:
  # if catchup param supplied get missing ticks
  if paramCount() > 0:
    if paramStr(1) == "--catchup":
      catchup("https://dumps.dfwtk.com/", parseInt(paramStr(2)))
    else:
      discard
  else:
    # check every 10 seconds if we should tick
    while true:
      let minute = getTime().format("mm")
      if minute == "01":
        tick("https://game.planetarion.com/botfiles/")
        # sleep for 59 minutes as we already ticked this hour
        sleep(3540000)
      sleep(10000)
