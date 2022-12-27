# Responsibility of discoverer is to populate these properties (in the requested scope):
# - CSPEC_TEST_FILES=[...]
# - CSPEC_TEST_FUNCTIONS_<ID>=[.;.]
# - CSPEC_SKIP_TEST_FUNCTIONS_<ID>=[.;.]
# - CSPEC_TEST_SETUP_FUNCTIONS_<ID>=[.;.]
# - CSPEC_TEST_TEARDOWN_FUNCTIONS_<ID>=[.;.]
# - CSPEC_FILE_SETUP_FUNCTIONS_<ID>=[.;.]
# - CSPEC_FILE_TEARDOWN_FUNCTIONS_<ID>=[.;.]
function(cspec_discover_tests)
    __cspec_get_var(discovery_fn DISCOVERER "cspec_test_discoverer")
    cmake_language(CALL ${discovery_fn} ${ARGV})
endfunction()
