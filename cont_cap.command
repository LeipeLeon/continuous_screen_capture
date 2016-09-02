#! /usr/bin/env bash
# 
# SCREENCAPTURE(1)          BSD General Commands Manual         SCREENCAPTURE(1)
# 
# NAME
#      screencapture -- capture images from the screen and save them to a file or the clipboard
# 
# SYNOPSIS
#      screencapture [-SWCTMPcimswxto] file
# 
# DESCRIPTION
#      The screencapture utility is not very well documented to date.  A list of options follows.
# 
#      -c      Force screen capture to go to the clipboard.
# 
#      -C      Capture the cursor as well as the screen.  Only allowed in non-interactive modes.
# 
#      -i      Capture screen interactively, by selection or window.  The control key will cause the screen shot
#              to go to the clipboard.  The space key will toggle between mouse selection and window selection
#              modes.  The escape key will cancel the interactive screen shot.
# 
#      -m      Only capture the main monitor, undefined if -i is set.
# 
#      -M      Open the taken picture in a new Mail message.
# 
#      -o      In window capture mode, do not capture the shadow of the window.
# 
#      -P      Open the taken picture in a Preview window.
# 
#      -s      Only allow mouse selection mode.
# 
#      -S      In window capture mode, capture the screen instead of the window.
# 
#      -t      <format> Image format to create, default is png (other options include pdf, jpg, tiff and other
#              formats).
# 
#      -T      <seconds> Take the picture after a delay of <seconds>, default is 5.
# 
#      -w      Only allow window selection mode.
# 
#      -W      Start interaction in window selection mode.
# 
#      -x      Do not play sounds.
# 
#      -a      Do not capture attached windows.
# 
#      -r      Do not add screen dpi meta data to captured file.
# 
#      files   where to save the screen capture, 1 file per screen
# 
# BUGS
#      Better documentation is needed for this utility.
# 
# SECURITY CONSIDERATIONS
#      To capture screen content while logged in via ssh, you must launch screencapture in the same mach boot-
#      strap hierarchy as loginwindow:
# 
#      PID=pid of loginwindow
#      sudo launchctl bsexec $PID screencapture [options]
# 
# HISTORY
#      A screencapture utility first appeared in Mac OS X v10.2.
# 

i=0
prev=${i}
screen=1
while true ; do
  ((i++))
  screencapture -T 1 "capture_$i-0.png" "capture_$i-1.png"
  compare capture_${prev}-${screen}.png capture_${i}-${screen}.png -compose src -highlight-color black capture_dif_${prev}-${screen}.png
  std_dev=`identify -verbose -alpha off capture_dif_${prev}-${screen}.png | grep "standard deviation" | cut -c 27-33`
  echo "capture_dif_${prev}-${screen}.png:$std_dev"
  prev=$i
done

# prev=1
# while ((prev < 11)) ; do
#   echo "capture_dif_${prev}.png"
#   identify -verbose -alpha off capture_dif_${prev}.png | sed -n '/Histogram/q; /Colormap/q; /statistics:/,$ p'
#   ((prev++))
# done
