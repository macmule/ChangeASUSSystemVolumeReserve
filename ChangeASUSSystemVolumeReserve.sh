#!/bin/sh
####################################################################################################
#
# More information:  http://macmule.com/2014/01/03/apple-software-update-server-updates-stuck-waiting
#
# GitRepo: https://github.com/macmule/ChangeASUSSystemVolumeReserve/
#
# License: http://macmule.com/license/
#
####################################################################################################

# HARDCODED VALUES ARE SET HERE

# Volume Reserve Percent

reservePercent=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "claunchAgentHour"
if [ "$4" != "" ] && [ "$reservePercent" == "" ];then
    reservePercent=$4
fi

####################################################################################################

# Error if either variable $4 is empty
if [ "$reservePercent" == "" ]; then
        echo "Error:  No value was specified for the reservePercent variable..."
        exit 1
fi        

####################################################################################################

# Unload com.apple.swupdate.sync.plist
sudo launchctl unload -w /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.host.plist
echo "Unloaded /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.host.plist..."

# Change the Volume Reserve Percent
sudo defaults write ~/Desktop/swupd.plist systemVolumeReserve -int $reservePercent
echo "Set systemVolumeReserve value to $reservePercent%..."

sudo chown root:_softwareupdate ~/Desktop/swupd.plist
sudo chmod 755 ~/Desktop/swupd.plist
echo "Corrected permissions on Library/Server/Software Update/Config/swupd.plist..."

# Reload com.apple.swupdate.sync.plist
sudo launchctl load -w /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.host.plist
echo "Reloaded /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.host.plist..."
