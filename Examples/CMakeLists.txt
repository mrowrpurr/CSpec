include(CSpec)

# set(CMAKE_MESSAGE_LOG_LEVEL TRACE)
set(CSPEC_DEBUG_LEVEL STATUS)
set(CSPEC_DEBUG ON)
set(CSPEC_RUNNERS cspec_runner_immediate)
add_cspec_suite(SCOPE GLOBAL FILES spec/HelloCSpec.cmake spec/AnotherSpec.cmake) # TODO auto-search test/ and spec/ folders
