shell_array_test() {

  TEST_FOR_ARRAY_SUPPORT=("823")

  if [ "${TEST_FOR_ARRAY_SUPPORT[0]}" -eq 823 ] ; then
    return 0
  else
    return 1
  fi

}
shell_array_test
