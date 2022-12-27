# Responsibility: setup whatever needs to be done to run the tests, e.g. create build targets (or run immediately!)
function(cspec_configure_runners)
    __cspec_get_var(runner_fns RUNNERS "cspec_runner_target")
    foreach(runner_fn ${runner_fns})
        cmake_language(CALL ${runner_fn} ${ARGV})
    endforeach()
endfunction()
