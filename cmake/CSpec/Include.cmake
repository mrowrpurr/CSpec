# This is what gets included in your CMakeLists.txt when you find_package(CSpec CONFIG REQUIRED)

function(add_cspec_suite)
    include("${CSpecModuleIncludes}/Discovery.cmake")

    __cspec_arg_parse(VALUES FILES SCOPE ARGS ${ARGN})

    if(NOT DEFINED ${arg_prefix}SCOPE)
        __cspec_get_var(${arg_prefix}SCOPE SCOPE DIRECTORY)
    endif()

    cspec_discover_tests(FILES ${${arg_prefix}FILES} SCOPE "${${arg_prefix}SCOPE}")
endfunction()