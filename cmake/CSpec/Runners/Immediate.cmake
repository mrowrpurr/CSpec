# Immediately run all the tests! As part of the CMake generation. Fast feedback :)
function(cspec_runner_immediate)
    __cspec_arg_parse(VALUES SCOPE ARGS ${ARGN})
    get_property(test_files ${${arg_prefix}SCOPE} PROPERTY CSPEC_TEST_FILES)

    set(cmake_folder "$ENV{TEMP}/CSpec/CMakeBuildFolderForSpecRuns")
    if(NOT IS_DIRECTORY "${cmake_folder}")
        file(MAKE_DIRECTORY "${cmake_folder}")
    endif()
    file(COPY "${CSpecModuleIncludes}/bin/RunAsConfigure/CMakeLists.txt" DESTINATION "${cmake_folder}")

    set(passed_count 0)
    set(failed_count 0)
    foreach(file_path ${test_files})
        string(SHA1 file_id "${file_path}")
        get_property(test_fns ${${arg_prefix}SCOPE} PROPERTY CSPEC_TEST_FUNCTIONS_${file_id})
        get_property(skip_test_fns ${${arg_prefix}SCOPE} PROPERTY CSPEC_SKIP_TEST_FUNCTIONS_${file_id})
        get_property(setup_fns ${${arg_prefix}SCOPE} PROPERTY CSPEC_TEST_SETUP_FUNCTIONS_${file_id})
        get_property(teardown_fns ${${arg_prefix}SCOPE} PROPERTY CSPEC_TEST_TEARDOWN_FUNCTIONS_${file_id})

        # TODO: file setup/teardown
        # get_property(file_setup_fns ${${arg_prefix}SCOPE} PROPERTY CSPEC_TEST_FILE_SETUP_FUNCTIONS_${file_id})
        # get_property(file_teardown_fns ${${arg_prefix}SCOPE} PROPERTY CSPEC_TEST_FILE_TEARDOWN_FUNCTIONS_${file_id})

        get_filename_component(test_filename "${file_path}" NAME_WLE)

        if(test_fns)
            __cspec_output("\n${test_filename} (${test_fn_count} tests)")
        else()
            __cspec_output("\n${test_filename} (No tests)")
        endif()

        foreach(skipped_test_fn ${skip_test_fns})
            __cspec_output("    [SKIP] ${skipped_test_fn}")
        endforeach()

        foreach(test_fn ${test_fns})

            execute_process(COMMAND "${CMAKE_COMMAND}" "-DCSPEC_INCLUDE_DIR=${CSpecModuleIncludes}" "-DCSPEC_FILE=${file_path}" "-DCSPEC_TEST_FUNCTION=${test_fn}" "-DCSPEC_SETUP_FNS=${setup_fns}" "-DCSPEC_TEARDOWN_FNS=${teardown_fns}" "." WORKING_DIRECTORY "${cmake_folder}" OUTPUT_VARIABLE stdout ERROR_VARIABLE stderr RESULT_VARIABLE result)

            if(result EQUAL 0)
                math(EXPR passed_count "${passed_count}+1")
                __cspec_output("    [PASS] ${test_fn}")
                if(CSPEC_VERBOSE)
                    if(stdout)
                        __cspec_pretty_print_output("${stdout}")
                    endif()
                    if(stderr)
                        __cspec_pretty_print_output("${stderr}")
                    endif()
                endif()
            else()
                math(EXPR failed_count "${failed_count}+1")
                __cspec_output("    [FAIL] ${test_fn}")
                if(stdout)
                    __cspec_pretty_print_output("${stdout}")
                endif()
                if(stderr)
                    __cspec_pretty_print_output("${stderr}")
                endif()
            endif()
        endforeach()
    endforeach()

    if(failed_count GREATER 0)
        __cspec_output("\nTests Failed! ${passed_count} passed, ${failed_count} failed.\n")
    elseif(passed_count GREATER 0)
        __cspec_output("\nTests Passed! ${passed_count} passed.\n")
    else()
        __cspec_output("\nNo tests run\n")
    endif()
endfunction()