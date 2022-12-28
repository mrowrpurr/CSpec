macro(ASSERT_TARGET target)
    if(NOT TARGET "${target}")
        expect_fail("Expected target '${target}' to exist")
    endif()
endmacro()

macro(ASSERT_NOT_TARGET target)
    if(TARGET "${target}")
        expect_fail("Expected target '${target}' not to exist")
    endif()
endmacro()

register_expect_matcher(be_target)
macro(__expect_be_target positive actual)
    if(${positive})
        ASSERT_TARGET("${actual}")
    else()
        ASSERT_NOT_TARGET("${actual}")
    endif()
endmacro()
