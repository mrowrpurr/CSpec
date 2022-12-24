set(CSpecModulePath "${CMAKE_CURRENT_LIST_FILE}")

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
            RESULT_VARIABLE result
            OUTPUT_VARIABLE raw_stdout
            ERROR_VARIABLE  raw_stderr
        )
        if(${result} EQUAL 0)
            message("[PASS] ${RUN_TEST_FUNCTION_WRAPPER}")
        else()
            message("[FAIL] ${RUN_TEST_FUNCTION_WRAPPER}")
            if(NOT "${raw_stdout}" STREQUAL "")
                string(REGEX REPLACE "\n" ";" stdout_lines "${raw_stdout}")
                set(i 0)
                foreach(line ${stdout_lines})
                    if(NOT line MATCHES "^[ ]+$")
                        if(i EQUAL 0)
                            string(APPEND stdout "    ${line}")
                        else()
                            string(APPEND stdout "\n    ${line}")
                        endif()
                    endif()
                    math(EXPR i "${i}+1")
                endforeach()
                message("${stdout}")
            endif()
            if(NOT "${raw_stderr}" STREQUAL "")
                string(REGEX REPLACE "\n" ";" stderr_lines "${raw_stderr}")
                set(i 0)
                foreach(line ${stderr_lines})
                    if(NOT line MATCHES "^[ ]+$")
                        if(i EQUAL 0)
                            string(APPEND stderr "    ${line}")
                        else()
                            string(APPEND stderr "\n    ${line}")
                        endif()
                    endif()
                    math(EXPR i "${i}+1")
                endforeach()
                message("${stderr}")
            endif()
        endif()
    elseif(DEFINED RUN_TEST_FUNCTION)
        cmake_language(EVAL CODE "${RUN_TEST_FUNCTION}()")
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
    add_custom_target(${CSPEC_FILE})
    foreach(test_fn ${test_functions})
        add_custom_command(TARGET ${CSPEC_FILE} POST_BUILD COMMAND "${CMAKE_COMMAND}" -DRUN_TEST_FUNCTION_WRAPPER=${test_fn} -P "${temp_file}" VERBATIM)
    endforeach()
endfunction()
