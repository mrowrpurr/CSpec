include(CSpec)

# set(CMAKE_MESSAGE_LOG_LEVEL TRACE)
set(CSPEC_DEBUG_LEVEL STATUS)
set(CSPEC_DEBUG ON)
add_cspec_suite(FILES spec/HelloCSpec.cmake) # TODO auto-search test/ and spec/ folders
