#! /bin/bash -e
# Save this file as /etc/sbin/thinkpad-dock.sh

# NB: you will need to modify the username and tweak the xrandr
# commands to suit your setup.

# wait for the dock state to change
sleep 1 

username=jgould

#export IFS=$"\n"

if [[ "$ACTION" == "add" ]] ; then
  DOCKED=1
  logger -t DOCKING "Detected condition: docked"
elif [[ "$ACTION" == "remove" ]] ; then
  DOCKED=0
  logger -t DOCKING "Detected condition: un-docked"
#else
#  logger -t DOCKING "Detected condition: unknown"
#  echo Please set env var \$ACTION to 'add' or 'remove'
#  exit 1
fi

# invoke from XSetup with NO_KDM_REBOOT otherwise you'll end up in a KDM reboot loop
NO_KDM_REBOOT=0
for p in $*; do
  case "$p" in
  "NO_KDM_REBOOT") NO_KDM_REBOOT=1 ;;
  "SWITCH_TO_LOCAL") DOCKED=0 ;;
  esac
done

function switch_to_local {
  export DISPLAY=:0
  #export XAUTHORITY=$(find /var/run/kdm -name "A${DISPLAY}-*")
  #export XAUTHORITY=/var/run/lightdm/sflaniga/xauthority
  logger -t DOCKING "Switching off HDMI2/3 and switching on LVDS1"
  su $username -c ' /usr/bin/xrandr  --output HDMI-1 --off --output HDMI-2 --off --output HDMI-3 --off --output VGA-1  --off  --output LVDS-1 --auto '
}

function switch_to_external {
  export DISPLAY=:0
  #export XAUTHORITY=/var/run/lightdm/sflaniga/xauthority
  #export XAUTHORITY=$(find /var/run/kdm -name "A${DISPLAY}-*")

  # The Display port on the docking station is on HDMI2 - let's use it and turn off local display
  logger -t DOCKING "Switching off LVDS1 and switching on HDMI2/3"

  su $username -c ' /usr/bin/xrandr --output LVDS-1 --off --output HDMI-1 --off --output HDMI-3 --auto --primary --output HDMI-2 --auto --left-of HDMI-3 '
}

case "$DOCKED" in
  "0")
    #undocked event
    switch_to_local :0 ;;
  "1")
    #docked event
    switch_to_external :0 ;;
esac
