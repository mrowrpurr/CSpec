cmake_minimum_required(VERSION 3.21)

project(CSpec)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

include(GNUInstallDirs)

configure_file(cmake/Config.cmake.in ${PROJECT_NAME}Config.cmake @ONLY)

install(
    FILES
    cmake/CSpec.cmake
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake"
)

add_subdirectory(Examples)
