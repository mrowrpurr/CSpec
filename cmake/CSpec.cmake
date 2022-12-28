set(CSpecModuleIncludes "${CMAKE_CURRENT_LIST_FILE}")
get_filename_component(CSpecModuleIncludes "${CSpecModuleIncludes}" DIRECTORY)
string(APPEND CSpecModuleIncludes /CSpec)

# TODO: cspec_configure(X y Y z)
include("${CSpecModuleIncludes}/Common.cmake")
include("${CSpecModuleIncludes}/AddCSpecSuite.cmake")
