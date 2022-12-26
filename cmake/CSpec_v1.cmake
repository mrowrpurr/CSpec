set(CSpecVersion 0.0.1)
cmake_policy(SET CMP0057 NEW) # IN_LIST support
cmake_policy(SET CMP0011 NEW) # This appears when enabling 57
set(CSpecModulePath "${CMAKE_CURRENT_LIST_FILE}")

function(__cspec_pretty_print_output raw_output)
    if(NOT "${raw_output}" STREQUAL "")
        string(REGEX REPLACE "\n" ";" output_lines "${raw_output}")
        set(i 0)
        foreach(line ${output_lines})
            if(NOT line MATCHES "^[ ]+$")
                if(i EQUAL 0)
                    string(APPEND output "    ${line}")
                else()
                    string(APPEND output "\n    ${line}")
                endif()
            endif()
            math(EXPR i "${i}+1")
        endforeach()
        message("${output}")
    endif()
endfunction()

function(__cpec_test_suite_end)
    if(LIST_TEST_FUNCTIONS)
        get_property(cmds GLOBAL PROPERTY COMMANDS)
        foreach(cmd ${cmds})
            if(cmd MATCHES ^test_)
                message("${cmd}")
            endif()
        endforeach()
    elseif(DEFINED RUN_TEST_FUNCTION_WRAPPER)
        execute_process(
            COMMAND "${CMAKE_COMMAND}" -DRUN_TEST_FUNCTION=${RUN_TEST_FUNCTION_WRAPPER} -P "${CMAKE_CURRENT_LIST_FILE}"
            RESULT_VARIABLE result OUTPUT_VARIABLE raw_stdout ERROR_VARIABLE  raw_stderr
        )
        if(${result} EQUAL 0)
            message("[PASS] ${RUN_TEST_FUNCTION_WRAPPER}")
            # TODO: add_cspec_suite(SomeSpecs VERBOSE)
            # __cspec_pretty_print_output("${raw_stdout}")
            # __cspec_pretty_print_output("${raw_stderr}")
        else()
            message("[FAIL] ${RUN_TEST_FUNCTION_WRAPPER}")
            __cspec_pretty_print_output("${raw_stdout}")
            __cspec_pretty_print_output("${raw_stderr}")
        endif()
    elseif(DEFINED RUN_TEST_FUNCTION)
        get_property(cmds GLOBAL PROPERTY COMMANDS)
        if("setup" IN_LIST cmds)
            setup()
        endif()
        cmake_language(EVAL CODE "${RUN_TEST_FUNCTION}()")
        if("teardown" IN_LIST cmds)
            teardown()
        endif()
    endif()
endfunction()

function(add_cspec_suite CSPEC_FILE)
    file(REAL_PATH "${CMAKE_CURRENT_SOURCE_DIR}" current_path)
    string(SHA1 temp_folder_hash "${current_path}")
    set(temp_folder "$ENV{TEMP}/cspec/${temp_folder_hash}")
    set(temp_file "${temp_folder}/${CSPEC_FILE}.cmake")
    file(READ "${CSPEC_FILE}.cmake" content)
    file(REAL_PATH "${CSpecModulePath}" cspec_module_path)
    string(CONFIGURE [=[
include("@cspec_module_path@") 
@content@
__cpec_test_suite_end()
    ]=] temp_file_content @ONLY)
    file(WRITE "${temp_file}" "${temp_file_content}")
    execute_process(COMMAND "${CMAKE_COMMAND}" -DLIST_TEST_FUNCTIONS=ON -P "${temp_file}" ERROR_VARIABLE raw_output)
    string(STRIP "${raw_output}" output)
    separate_arguments(test_functions WINDOWS_COMMAND "${output}")

    # add_custom_target(${CSPEC_FILE}) # We make an assumption that CSPEC_FILE is a valid target name, it could be "foo/bar/baz.cmake" (FIXME)
    # foreach(test_fn ${test_functions})
    #     add_custom_command(TARGET ${CSPEC_FILE} POST_BUILD COMMAND "${CMAKE_COMMAND}" -DRUN_TEST_FUNCTION_WRAPPER=${test_fn} -P "${temp_file}" VERBATIM)
    # endforeach()

    enable_testing()
    foreach(test_fn ${test_functions})
        message("ADD TEST ${CSPEC_FILE}_${test_fn}")
        add_test(${CSPEC_FILE}_${test_fn} "${CMAKE_COMMAND}" -DRUN_TEST_FUNCTION_WRAPPER=${test_fn} -P "${temp_file}")
    endforeach()
endfunction()
