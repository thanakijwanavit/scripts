#export
export DISPLAY=:0
#login
loginctl unlock-session
#unlock gui lock screen
DISPLAY=:0 gnome-screensaver-command -d
