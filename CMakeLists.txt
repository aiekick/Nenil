cmake_minimum_required(VERSION 2.8)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0012 NEW)
cmake_policy(SET CMP0023 NEW)

set(PROJECT Nenil)

enable_language(C CXX)

project(${PROJECT} CXX)

find_package(Vulkan REQUIRED)
include(cmake/3rdparty.cmake)

## some defines for debug mode
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D_DEBUG")
add_definitions(-DPROJECT_PATH="${CMAKE_SOURCE_DIR}")

if(UNIX)
    if(APPLE)
        add_definitions(-DAPPLE)
    else()
        add_definitions(-DLINUX)
    endif()
    add_definitions(-DUNIX)
elseif(WIN32)
    add_definitions(-DWIN32)
	if(MINGW)
		add_definitions(-DMINGW32)
	endif()
    set(DIRENT_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/dirent/include)
    include_directories(${DIRENT_INCLUDE_DIR})
endif()

if(MSVC)
    # Ignore 4055 for glad
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /IGNORE:4055")
    add_definitions(-D_USE_MATH_DEFINES)
    add_definitions(-DMSVC)
else ()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic -std=c++11")
endif ()

add_definitions(${GLFW_DEFINITIONS})
add_definitions(-DCUSTOM_IMGUIFILEDIALOG_CONFIG="../../../CustomImGuiFileDialogConfig.h")

file(GLOB MAIN ${CMAKE_SOURCE_DIR}/*.cpp)
file(GLOB SRC 
		${CMAKE_SOURCE_DIR}/src/*.cpp 
		${CMAKE_SOURCE_DIR}/src/*.h) 
file(GLOB IMGUIIMPL
		${CMAKE_SOURCE_DIR}/src/ImguiImpl/*.cpp 
		${CMAKE_SOURCE_DIR}/src/ImguiImpl/*.h)
file(GLOB RES
		${CMAKE_SOURCE_DIR}/src/Res/*.cpp 
		${CMAKE_SOURCE_DIR}/src/Res/*.h)
source_group(main FILES ${MAIN})
source_group(src FILES ${SRC})
source_group(src\\ImguiImpl FILES ${IMGUIIMPL})
source_group(src\\Res FILES ${RES})


if (APPLE)
	##set(ICON icon.icns)
	##set_source_files_properties(icon.icns PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
endif()

add_executable(${PROJECT}
		MACOSX_BUNDLE
		##${ICON}
		${MAIN} 
		${SRC} 
		${IMGUIIMPL} 
		${RES} 
)

if (APPLE)
	set_target_properties(${PROJECT}
			PROPERTIES
			OUTPUT_NAME "${PROJECT}_Osx"
			MACOSX_BUNDLE_EXECUTABLE_NAME "${PROJECT}_Osx"
			MACOSX_BUNDLE_BUNDLE_NAME "${PROJECT}_Osx"
			FOLDER "${PROJECT}_Osx"
			##RESOURCE icon.icns
			MACOSX_BUNDLE_SHORT_VERSION_STRING "0.5"
			MACOSX_BUNDLE_LONG_VERSION_STRING "Beta 0.5"
			##MACOSX_BUNDLE_ICON_FILE icon.icns
			MACOSX_BUNDLE_INFO_PLIST "${CMAKE_SOURCE_DIR}/MacOSXBundleInfo.plist.in")
elseif(WIN32)
	if (MINGW)
		set_target_properties(${PROJECT} PROPERTIES	OUTPUT_NAME "${PROJECT}_Mingw32_Win32")
	elseif (CYGWIN)
		set_target_properties(${PROJECT} PROPERTIES	OUTPUT_NAME "${PROJECT}_Cygwin_Win32")
	elseif(MSVC)
		set_target_properties(${PROJECT} PROPERTIES	OUTPUT_NAME "${PROJECT}_Msvc_Win32")
	endif()
elseif(UNIX)
	set_target_properties(${PROJECT} PROPERTIES	OUTPUT_NAME "${PROJECT}_Linux")
endif()

set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}")
install(TARGETS ${PROJECT} DESTINATION ${CMAKE_INSTALL_PREFIX})

include_directories(
		src
        ${PLOG_INCLUDE_DIR}
        ${Vulkan_INCLUDE_DIRS}
        ${GLFW_INCLUDE_DIR}
        ${GLAD_INCLUDE_DIR}
        ${IMGUI_INCLUDE_DIR}
		${CTOOLS_INCLUDE_DIR}
		${TINYXML2_INCLUDE_DIR}
		${IMGUIFILEDIALOG_INCLUDE_DIR}
)

target_link_libraries(${PROJECT} PRIVATE
        ${Vulkan_LIBRARIES}
        ${GLFW_LIBRARIES}
        ${GLAD_LIBRARIES}
        ${IMGUI_LIBRARIES}
        ${CTOOLS_LIBRARIES}
		${TINYXML2_LIBRARIES}
		${IMGUIFILEDIALOG_LIBRARIES}
)
