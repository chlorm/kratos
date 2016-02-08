asdf() {

  PathHasBinErr 'asdff'
}

spin() {

  local -a marks=( '/' '-' '\' '|' ' ' )

  while [[ 1 ]] ; do
    printf '%s\r' "${marks[i++ % ${#marks[@]}]}"
    sleep 0.2
  done

}
