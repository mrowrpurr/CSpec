get_filename_component(CSpecAssertionsIncludeDir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
string(APPEND CSpecAssertionsIncludeDir "/Assertions")

function(include_assertion assertion)
    set(assertion_path "${CSpecAssertionsIncludeDir}/${assertion}")
    if(NOT assertion_path MATCHES .cmake$)
        string(APPEND assertion_path ".cmake")
    endif()
    if(EXISTS "${assertion_path}")
        include("${assertion_path}")
    else()
        message(FATAL_ERROR "Assertion not found: ${assertion} (${assertion_path})")
    endif()
endfunction()

include("${CSPEC_FILE}")

if(NOT EXISTS DISABLE_EXPECT OR NOT DISABLE_EXPECT)
    include("${CSpecAssertionsIncludeDir}/Expect.cmake")
endif()
if(NOT EXISTS DEFAULT_ASSERTIONS OR DEFAULT_ASSERTIONS)
    include("${CSpecAssertionsIncludeDir}/DefaultAssertions.cmake")
endif()

foreach(setup_fn ${CSPEC_SETUP_FNS})
    # ...
endforeach()
cmake_language(CALL ${CSPEC_TEST_FUNCTION})
foreach(teardown_fn ${CSPEC_TEARDOWN_FNS})
    # ...
endforeach()