from os import existsFile, existsDir, removeDir, getCurrentDir, setCurrentDir, execShellCmd, copyFileWithPermissions

##
## isInstalled
##
## This proc checks to see if we already have cjdns installed on
## our system.
##
proc isInstalled(): bool =
  return os.existsFile("/usr/local/bin/cjdroute")

##
## hasConfig
##
## This proc checks to see if we have a configuration file already
## on our system or not.
proc hasConfig(): bool =
  return os.existsFile("~/.cjdroute.conf")

##
## yes
##
## This proc asks whatever question we would like to ask the
## user currently. This is useful when finding out if they
## would like to update or not. No is default.
##
proc yes(question: string): bool =
  echo(question, " (y/N)")
  while true:
    case readLine(stdin)
    of "y", "Y", "yes", "Yes": return true
    else: return false

##
## generateConfig
##
## This proc generates a new configuration file.
##
proc generateConfig(): bool {.discardable.} =
  return os.execShellCmd("cjdroute --genconf > ~/.cjdroute.conf") == 0

##
## installCjdns
##
## This proc installs cjdns.
##
proc installCjdns(): bool {.discardable.} =
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

##
## isUpToDate
##
## TODO
##
## This proc checks to see if cjdns is up to date or not.
##
proc isUpToDate(): bool =
  # For now let's just return false until we do it.
  return false

# First let's check to see if it's installed or not. If it's
# already installed then we don't have to do some other
# stuff, and we can make it quicker for people to use
# this for other things besides installation.
let installed = isInstalled()

# Now if we don't have cjdns installed already, that means
# we have to install cjdns. Let's install cjdns!
if not installed:
  # First let's ask to make sure we want to install cjdns.
  if yes("It doesn't seem like cjdns is installed. Would you like to install cjdns?"):
    installCjdns()

# Now we check to see if we have a configuration file yet.
# If we don't, then lets ask if we want to generate one.
if installed and not hasConfig():
  # First let's ask to make sure they want to generate one.
  if yes("It looks like you don't have a configuration file. Would you like to generate one?"):
    generateConfig()
  else: echo "If you already have one, place it at ~/.cjdroute.conf"

# If we have gotten this far then cjdns is already installed.
# Now it's time to check if cjdns is up to date!
if installed and not isUpToDate():
  # First let's ask to make sure we want to update cjdns.
  if yes("It looks like there's a newer version of cjdns available! Would you like to update cjdns?"):
    installCjdns()
