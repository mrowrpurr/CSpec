set(CSpecModulePath "${CMAKE_CURRENT_LIST_FILE}")
get_filename_component(CSpecModuleIncludes "${CSpecModulePath}" DIRECTORY)
string(APPEND CSpecModuleIncludes /CSpec)

include("${CSpecModuleIncludes}/Common.cmake")
include("${CSpecModuleIncludes}/AddCSpecSuite.cmake")
