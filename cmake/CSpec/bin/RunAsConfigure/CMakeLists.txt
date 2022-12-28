cmake_minimum_required(VERSION 3.21)

project("Default Test Project from CSpec")

set(CSpecAssertionsIncludeDir "${CSPEC_INCLUDE_DIR}/Assertions")
include("${CSPEC_INCLUDE_DIR}/bin/RunAsConfigure/Helpers.cmake")

include("${CSPEC_FILE}")

if(NOT EXISTS DISABLE_EXPECT OR NOT DISABLE_EXPECT)
    include("${CSpecAssertionsIncludeDir}/Expect.cmake")
endif()

if(NOT EXISTS DEFAULT_ASSERTIONS OR DEFAULT_ASSERTIONS)
    include("${CSpecAssertionsIncludeDir}/DefaultAssertions.cmake")
endif()

foreach(fn ${CSPEC_SETUP_FNS})
    cmake_language(CALL "${fn}")
endforeach()

cmake_language(CALL "${CSPEC_TEST_FUNCTION}")

foreach(fn ${CSPEC_TEARDOWN_FNS})
    cmake_language(CALL "${fn}")
endforeach()
