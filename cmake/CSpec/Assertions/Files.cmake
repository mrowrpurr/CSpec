macro(ASSERT_FILE_EXISTS path)
    if(NOT EXISTS "${path}")
        expect_fail("Expected file to exist, but it was not found: '${path}'")
    endif()
endmacro()

macro(ASSERT_NOT_FILE_EXISTS path)
    if(EXISTS "${path}")
        expect_fail("Expected file not to exist, but it was found: '${path}'")
    endif()
endmacro()

register_expect_matcher(be_a_file)
macro(__expect_be_a_file positive path)
    if(${positive})
        ASSERT_FILE_EXISTS("${path}")
    else()
        ASSERT_NOT_FILE_EXISTS("${path}")
    endif()
endmacro()
