# TODO make these all macros for expect_fail to work!

function(ASSERT_TARGET target)
    if(NOT TARGET "${target}")
        expect_fail("Expected target '${target}' to exist")
    endif()
endfunction()

function(ASSERT_NOT_TARGET target)
    if(TARGET "${target}")
        expect_fail("Expected target '${target}' not to exist")
    endif()
endfunction()

# Rename these to something 'expect'-ish
function(__expect_be_target positive actual)
    if(positive)
        ASSERT_TARGET("${actual}")
    else()
        ASSERT_NOT_TARGET("${actual}")
    endif()
endfunction()
