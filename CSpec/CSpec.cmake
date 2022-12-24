set(CSpecModulePath "${CMAKE_CURRENT_LIST_FILE}")

function(__cpec_test_suite_begin)
    message("BEGINNING!")
endfunction()

function(__cpec_test_suite_end)
    message("END!")
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
__cpec_test_suite_begin()
@content@
__cpec_test_suite_end()
    ]=] temp_file_content @ONLY)
    file(WRITE "${temp_file}" "${temp_file_content}")
    add_custom_target(
        ${CSPEC_FILE}
        COMMAND "${CMAKE_COMMAND}" -P "${temp_file}"
    )
endfunction()
