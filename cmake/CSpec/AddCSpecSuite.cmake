# This is what gets included in your CMakeLists.txt when you find_package(CSpec CONFIG REQUIRED)

function(add_cspec_suite)
    __cspec_arg_parse(VALUES SCOPE MULTI FILES ARGS ${ARGN})

    if(NOT DEFINED ${arg_prefix}SCOPE)
        __cspec_get_var(${arg_prefix}SCOPE SCOPE DIRECTORY)
    endif()

    if("${${arg_prefix}FILES}" STREQUAL "")
        set(${arg_prefix}FILES "${${arg_prefix}UNPARSED_ARGUMENTS}")
    endif()

    if("${${arg_prefix}FILES}" STREQUAL "")
        message(WARNING "No spec files provided to add_cspec_suite")
    endif()

    # Built-in discoverer
    include("${CSpecModuleIncludes}/Discoverers/Default.cmake")

    include("${CSpecModuleIncludes}/Discovery.cmake")
    cspec_discover_tests(FILES ${${arg_prefix}FILES} SCOPE "${${arg_prefix}SCOPE}")

    # Built-in runners
    include("${CSpecModuleIncludes}/Runners/CTest.cmake")
    include("${CSpecModuleIncludes}/Runners/Immediate.cmake")
    include("${CSpecModuleIncludes}/Runners/Target.cmake")

    include("${CSpecModuleIncludes}/Runner.cmake")
    cspec_configure_runners(SCOPE "${${arg_prefix}SCOPE}")
endfunction()
