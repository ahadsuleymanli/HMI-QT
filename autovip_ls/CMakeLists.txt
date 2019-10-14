cmake_minimum_required(VERSION 3.2.4)

project(autovip_ls LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE UI_FILES *.ui)
file(GLOB_RECURSE CODE_FILES *.cpp)
file(GLOB_RECURSE HEADER_FILES *.h)


find_package(Qt5 COMPONENTS Core Quick WebSockets SerialPort Multimedia Test REQUIRED)

find_package(Qt5LinguistTools)
FILE(GLOB TS_FILES "${CMAKE_CURRENT_SOURCE_DIR}/translator/*.ts")
QT5_create_translation(QM_FILES ${CODE_FILES} ${TS_FILES})

message("Architecture : ${TARGET_ARCH}")
message("Config : ${TARGET_ARCH}")
message("Generator    : ${CMAKE_GENERATOR}")
message("Generator Platform    : ${CMAKE_GENERATOR_PLATFORM}")

if( TARGET_ARCH STREQUAL "linux_x86_64")
    add_definitions(-DPLATFORM=LIN_X86_64)
    add_definitions(-DBAUDRATE=115200)
    add_definitions(-DPORTNAME=ttyS0)
    add_definitions(-DLIN_X86_64)
elseif( TARGET_ARCH STREQUAL "linux_armv8")
    add_definitions(-DPLATFORM=LIN_ARM64)
    add_definitions(-DBAUDRATE=115200)
    add_definitions(-DPORTNAME=ttyMSM1)
    add_definitions(-DLIN_X86_64)
    set(link_dirs  "/home/ckurdu/bin/linaro/sysroot/lib/aarch64-linux-gnu/")
    link_directories(${link_dir})
endif()


add_executable(${PROJECT_NAME} ${HEADER_FILES} ${CODE_FILES} ${UI_FILES} "qml.qrc" ${CODE_FILES})
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick Qt5::WebSockets Qt5::SerialPort Qt5::Multimedia Qt5::Test )

