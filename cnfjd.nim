##
## checkInstalled
##
## TODO
##
## This proc checks to see if we already have cjdns installed on
## our system.
##
proc checkInstalled(): bool =
  # For now let's just return false until we do it.
  return false

##
## checkDependencies
##
## TODO
## 
## This proc checks to see if we have the necessary dependencies
## installed in order to use cnfjd and cjdns. If we do not then
## we give an error mesage and quit the program right here and 
## now.
##
proc checkDependencies(): bool {.discardable.} =
  # For now let's just return true until we do it.
  return true

##
## installCjdns
##
## TODO
##
## This proc installs cjdns.
##
proc installCjdns(): bool {.discardable.} =
  # For now let's just return true until we do it.
  return true

##
## checkIfUpTodate
##
## TODO
##
## This proc checks to see if cjdns is up to date or not.
##
proc checkIfUpTodate(): bool =
  # For now let's just return true until we do it.
  return true

##
## yes
##
## This proc asks whatever question we would like to ask the
## user currently. This is useful when finding out if they
## would like to update or not.
##
proc yes(question: string): bool =
  echo(question, " (y/n)")
  while true:
    case readLine(stdin)
    of "y", "Y", "yes", "Yes": return true
    of "n", "N", "no", "No": return false
    else: echo("Please be clear: yes or no")

# First let's check to see if it's installed or not. If it's
# already installed then we don't have to do some other
# stuff, and we can make it quicker for people to use
# this for other things besides installation.
let installed = checkInstalled()

# First we check to see if we have the necessary dependencies
# installed. We only do this check if cjdns is not currently
# installed.
if not installed: checkDependencies()

# Now if we don't have cjdns installed already, and we've
# gotten this far then that means we have the necessary
# dependencies to install cjdns. Let's install cjdns!
if not installed: installCjdns()
