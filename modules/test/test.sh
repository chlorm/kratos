
test_module() {
	test_sub_module() {
		echo "hksdfhjk"
	}
	test_sub_module
}

# Test true/false
function test_st {
	local TEST=false
	if [ "${1}" == 'test' ] ; then
		TEST=true
	fi

	if "${TEST}" ; then
		echo "hjskhsdfhjk"
	fi
}

function test_ord {

	vol

  test2

}

function test2 {

  err.error "test kasdhjf"

}
