#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

xsetroot -cursor_name left_ptr

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

echo XHC | sudo tee /proc/acpi/wakeup

xrandr --setprovideroutputsource modesetting NVIDIA-0 
xrandr --auto

gpu-offload

wal -R -n
hsetroot -solid "#e5d5d3"
setkb.py

blueman-applet &
sxhkd &
urxvt &
picom &
xbindkeys &
wal-set &
polylaunch &
mpd &
exec 2bwm
