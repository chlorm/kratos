if [ -n "$DISPLAY" ] ; then
  # find installed DE's
  export PREFERED_DESKENV
  exec DE
fi