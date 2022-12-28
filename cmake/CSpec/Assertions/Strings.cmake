macro(ASSERT_STRING_CONTAINS text substring)
    block()
        string(FIND "${text}" "${substring}" index)
        if(index EQUAL -1)
            expect_fail("Expected string to contain substring, but it was not found.\nSubstring: '${substring}'\nString: '${text}'")
        endif()
    endblock()
endmacro()

macro(ASSERT_NOT_STRING_CONTAINS text substring)
    block()
        string(FIND "${text}" "${subscript}" index)
        if(NOT index EQUAL -1)
            expect_fail("Expected string not to contain substring, but it was found at index ${index}.\nSubstring: '${substring}'\nString: '${text}'")
        endif()
    endblock()
endmacro()

register_expect_matcher(contain_text)
macro(__expect_contain_text positive text substring)
    if(${positive})
        ASSERT_STRING_CONTAINS("${text}" "${substring}")
    else()
        ASSERT_NOT_STRING_CONTAINS("${text}" "${substring}")
    endif()
endmacro()
