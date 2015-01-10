import httpclient, os, osproc, strutils

proc isInstalled(): bool =
  ## isInstalled
  ##
  ## This proc checks to see if we already have cjdns installed on
  ## our system.
  return os.existsFile("/usr/local/bin/cjdroute")

proc hasConfig(): bool =
  ## hasConfig
  ##
  ## This proc checks to see if we have a configuration file already
  ## on our system or not.
  return os.existsFile(os.getHomeDir() & ".cjdroute.conf")

proc yes(question: string): bool =
  ## yes
  ##
  ## This proc asks whatever question we would like to ask the
  ## user currently. This is useful when finding out if they
  ## would like to update or not. No is default.
  echo(question, " (y/N)")
  while true:
    case readLine(stdin)
    of "y", "Y", "yes", "Yes": return true
    else: return false

proc generateConfig(path: string = os.getHomeDir()): bool {.discardable.} =
  ## generateConfig
  ##
  ## This proc generates a new configuration file.
  return os.execShellCmd("cjdroute --genconf > " & path & ".cjdroute.conf") == 0

proc generateVanityConfig(): bool {.discardable.} =
  ## generateVanityConfig
  ##
  ## TODO
  ##
  ## This proc helps the user generate vanity configuration files
  return false

proc installCjdns(): bool {.discardable.} =
  ## installCjdns
  ##
  ## This proc installs cjdns.

  # Set the current directory to come back to later
  let pwd = os.getCurrentDir()

  # Set the current directory to a temporary one,
  # and if there's already a cjdns folder then we
  # delete it to make room for the new one.
  os.setCurrentDir("/tmp")
  if os.existsDir("cjdns"): os.removeDir("cjdns")

  # Clone cjdns
  var i = os.execShellCmd("git clone https://github.com/cjdelisle/cjdns.git")
  if i != 0: return false

  # Now we have cjdns downloaded in `/tmp/cjdns` so let's
  # change our current directory again.
  os.setCurrentDir("cjdns")

  # Now let's compile cjdns.
  i = os.execShellCmd("./do")
  if i != 0: return false

  # Now that it's compiled we can copy cjdroute to `/usr/local/bin/`
  os.copyFileWithPermissions("cjdroute", "/usr/local/bin/cjdroute")

  # Now that we're done here let's set our current dir back
  # and return true.
  os.setCurrentDir(pwd)
  return true

proc uninstallCjdns(): bool {.discardable.} =
  ## uninstallCjdns
  ##
  ## TODO
  ##
  ## This proc completely uninstalls cjdns.
  return false

proc isUpToDate(): bool =
  ## isUpToDate
  ##
  ## This proc checks to see if cjdns is up to date or not with
  ## the most recent protocol version.

  # First we have to figure out what the current protocol version is
  var v = httpclient.getContent("https://raw.githubusercontent.com/cjdelisle/cjdns/master/util/version/Version.h")
  v = strutils.split(v, "#define Version_CURRENT_PROTOCOL ")[1]
  v = strutils.split(v, "\n")[0]
  let version = strutils.parseInt(v)

  # Now that we know the current protocol version, we have to check
  # to see what protocol version we are currently running.
  var cv = osproc.execCmdEx("cjdroute --version")
  cv.output = strutils.split(cv.output, ": ")[1]
  cv.output = strutils.split(cv.output, "\n")[0]
  let current = strutils.parseInt(cv.output)

  # Now we return if we're up to date or not
  return current >= version

proc startCjdns(): bool {.discardable.} =
  ## startCjdns
  ##
  ## This proc starts cjdns!
  var i = os.execShellCmd("sudo cjdroute < " & os.getHomeDir() & ".cjdroute.conf")
  if i != 0: return false
  else: return true

proc stopCjdns(): bool {.discardable.} =
  ## stopCjdns
  ##
  ## This proc stops cjdns.
  var i = os.execShellCmd("sudo killall cjdroute")
  if i != 0: return false
  else: return true

proc addPeer(): bool {.discardable.} =
  ## addPeer
  ##
  ## TODO
  ##
  ## This proc helps the user to add a peer
  return false

proc removePeer(): bool {.discardable.} =
  ## removePeer
  ##
  ## TODO
  ##
  ## This proc helps the user delete a peer
  return false

proc next(): bool {.discardable.} =
  ## next
  ##
  ## This proc loops endlessly until the program is completed.
  while true:
    echo "What would you like to do?"
    echo "[1] Start cjdns"
    echo "[2] Stop cjdns"
    echo "[3] Restart cjdns"
    echo "[4] Reinstall cjdns"
    echo "[5] Uninstall cjdns - TODO"
    echo "[6] Generate a new random configuration file"
    echo "[7] Generate a new vanity configuration file - TODO"
    echo "[8] Add a peer - TODO"
    echo "[9] Remove a peer - TODO"
    echo "[0] Exit"
    case readLine(stdin)
    of "1":
      startCjdns()
    of "2":
      stopCjdns()
    of "3":
      stopCjdns()
      startCjdns()
    of "4":
      installCjdns()
    of "5":
      if yes("Are you sure? This will delete all files related to cjdns."):
        uninstallCjdns()
    of "6":
      if yes("Are you sure? This will overwrite your old configuration file."):
        if generateConfig(): echo "A configuration file has been generated!"
        else: echo "There was an error generating a configuration file!"
    of "7":
      if yes("Are you sure? This will overwrite your old configuration file."):
        generateVanityConfig()
    of "8": addPeer()
    of "9": removePeer()
    else: return false

proc main() =
  # First let's check to see if it's installed or not. If it's
  # already installed then we don't have to do some other
  # stuff, and we can make it quicker for people to use
  # this for other things besides installation.
  var installed = isInstalled()

  # Now if we don't have cjdns installed already, that means
  # we have to install cjdns. Let's install cjdns!
  if not installed:
    # First let's ask to make sure we want to install cjdns.
    if yes("It doesn't seem like cjdns is installed. Would you like to install cjdns?"):
      installCjdns()
      # Now let's check to see if cjdns installed properly.
      installed = isInstalled()

  # Now we check to see if we have a configuration file yet.
  # If we don't, then lets ask if we want to generate one.
  if installed and not hasConfig():
    # First let's ask to make sure they want to generate one.
    if yes("It looks like you don't have a configuration file. Would you like to generate one?"):
      if generateConfig(): echo "A configuration file has been generated!"
      else: echo "There was an error generating a configuration file!"
    else: echo "If you already have one, you can place it at " & os.getHomeDir() & ".cjdroute.conf"

  # If we have gotten this far then cjdns is already installed.
  # Now it's time to check if cjdns is up to date!
  if installed and not isUpToDate():
    # First let's ask to make sure we want to update cjdns.
    if yes("It looks like there's a newer version of cjdns available! Would you like to update cjdns?"):
      installCjdns()

  # Now that we've gotten all the preliminary stuff out of the
  # way we can run the question loop to see what the user
  # would like to do next.
  next()

# Run the main proc
main()
