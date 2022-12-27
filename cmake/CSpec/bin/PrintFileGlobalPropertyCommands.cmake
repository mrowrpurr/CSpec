include("${CSPEC_FILE}")
get_property(__global_commands_property GLOBAL PROPERTY COMMANDS)
message(STATUS "${__global_commands_property}")
