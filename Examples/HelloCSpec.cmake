function(test_something)
    message("!!!!!!!!!! YOU CALLED THE test_something TEST FUNCTION!")
endfunction()

function(test_something_fail)
    message(SEND_ERROR "!!!!!!!!!!!! This failed!")
endfunction()

function(test_something_xxx)
    message("!!!!!!!!!!! YOU CALLED THE test_something_xxx TEST FUNCTION!")
endfunction()
