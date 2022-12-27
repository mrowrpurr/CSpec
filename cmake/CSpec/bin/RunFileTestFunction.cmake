include("${CSPEC_FILE}")
foreach(setup_fn ${CSPEC_SETUP_FNS})
    # ...
endforeach()
cmake_language(CALL ${CSPEC_TEST_FUNCTION})
foreach(teardown_fn ${CSPEC_TEARDOWN_FNS})
    # ...
endforeach()