cmake_minimum_required(VERSION 3.16)

project(QtQMLDemo VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia)

qt_add_executable(QtQMLDemo
    main.cpp
    appcontroller.cpp
    appcontroller.h
)

qt_add_qml_module(QtQMLDemo
    URI QtQMLDemo
    VERSION 1.0
    QML_FILES main.qml
)

target_link_libraries(QtQMLDemo PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Multimedia
)

# Platform-specific settings
if(WIN32)
    set_target_properties(QtQMLDemo PROPERTIES WIN32_EXECUTABLE TRUE)
elseif(APPLE)
    set_target_properties(QtQMLDemo PROPERTIES MACOSX_BUNDLE TRUE)
endif()

install(TARGETS QtQMLDemo
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)