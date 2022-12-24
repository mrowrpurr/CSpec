function(setup)
    message("This is setup!")
endfunction()

function(test_should_pass)
    message("Hooray!")
endfunction()

function(test_should_fail)
    message(FATAL_ERROR "Kaboom!")
endfunction()
