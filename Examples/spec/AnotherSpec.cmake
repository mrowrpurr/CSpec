function(setup)
    set(SomeVar "Sharing this with test!" PARENT_SCOPE)
    message("I run before the test")
endfunction()

function(teardown)
    message("I run after the test")
endfunction()

function(test_should_pass)
    message(STATUS "You called: test_something (and SomeVar is '${SomeVar}')")
endfunction()

function(test_should_fail)
    message(FATAL_ERROR "This should be a failure message!")
endfunction()
