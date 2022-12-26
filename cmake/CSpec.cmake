# [Variables]

set(CSpecVersion 0.2.0)
set(CSpecModulePath "${CMAKE_CURRENT_LIST_FILE}")

if(NOT DEFINED CSPEC_DEBUG_LEVEL)
    set(CSPEC_DEBUG_LEVEL TRACE)
endif()

# [Helpers]

macro(__cspec_debug text)
    if(CSPEC_DEBUG)
        message(${CSPEC_DEBUG_LEVEL} "${text}")
    endif()
endmacro()

macro(__cspec_debug_fn)
     __cspec_debug("${CMAKE_CURRENT_FUNCTION}(${ARGV})")
endmacro()

macro(__cspec_arg_parse)
    cmake_parse_arguments(_cspec_arg_parse "" "" "FLAGS;VALUES;MULTI;ARGS" ${ARGN})
    __cspec_debug_fn(${_cspec_arg_parse_ARGS})
    cmake_parse_arguments("${CMAKE_CURRENT_FUNCTION}" "${_cspec_arg_parse_OPTIONS}" "${_cspec_arg_parse_VALUES}" "${_cspec_arg_parse_MULTI}" ${_cspec_arg_parse_ARGS})
    set(arg_prefix "${CMAKE_CURRENT_FUNCTION}_")
endmacro()

# function(__cspec_set_property)
#     __cspec_debug("__cspec_set_property(${ARGV})")
#     set(options)
#     set(oneValueArgs)
#     set(multiValueArgs FILES)
#     cmake_parse_arguments(PARSE_ARGV 0 __cspec_set_property_ARG "${options}" "${oneValueArgs}" "${multiValueArgs}")
# endfunction()

macro(__cspec_get_var out_varname cspec_varname)
    if(DEFINED CSPEC_${cspec_varname})
        set(${out_varname} ${CSPEC_${cspec_varname}})
    elseif(DEFINED ENV{CSPEC_${cspec_varname}})
        set(${out_varname} $ENV{CSPEC_${cspec_varname}})
    elseif(DEFINED CSPEC_DEFAULT_${cspec_varname})
        set(${out_varname} ${CSPEC_DEFAULT_${cspec_varname}})
    else()
        set(${out_varname} "")
    endif()
endmacro()

macro(__cspec_error text)
    message(FATAL_ERROR "[CSPEC ERROR]: ${text}")
endmacro()

# [Test Discovery]

function(cspec_test_discoverer)
    message("CALLED DEFAULT DISCOVERY FN! ${ARGV}")

    __cspec_arg_parse(VALUES FILES ARGS ${ARGN})

    foreach(file ${${arg_prefix}FILES})
        message("FILE: ${file}")
    endforeach()
endfunction()

# Responsibility of discoverer is to populate these properties (in the requested scope):
# - CMAKE_TEST_FUNCTIONS_<ID>=[.;.]
# - CMAKE_TEST_SETUP_FUNCTIONS_<ID>=[.;.]
# - CMAKE_TEST_TEARDOWN_FUNCTIONS_<ID>=[.;.]
# - CMAKE_FILE_SETUP_FUNCTIONS_<ID>=[.;.]
# - CMAKE_FILE_TEARDOWN_FUNCTIONS_<ID>=[.;.]
function(cspec_discover_tests)
    if(NOT DEFINED CSPEC_DEFAULT_DISCOVERER)
        set(CSPEC_DEFAULT_DISCOVERER cspec_test_discoverer)
    endif()

    __cspec_get_var(discovery_fn DISCOVERER)
    if(discovery_fn)
        message("DISCOVERER: ${discovery_fn}")
        cmake_language(CALL ${discovery_fn} ${ARGV})
    else()
        __cspec_error("No test discoverer found")
    endif()
endfunction()

# [Main Functions]

# hello, world!
function(add_cspec_suite)
    __cspec_arg_parse(VALUES FILES ARGS ${ARGN})

    cspec_discover_tests(FILES ${${arg_prefix}FILES})
endfunction()
