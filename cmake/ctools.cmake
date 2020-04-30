set(CTOOLS_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/ctools)
file(GLOB CTOOLS_SOURCES ${CTOOLS_INCLUDE_DIR}/*.cpp)
file(GLOB CTOOLS_HEADERS ${CTOOLS_INCLUDE_DIR}/*.h)
                 
add_library(ctools STATIC ${CTOOLS_SOURCES} ${CTOOLS_HEADERS})

add_definitions(-DVOLK)
add_definitions(-DIMGUI)

include_directories(
    ${CTOOLS_INCLUDE_DIR}
    ${Vulkan_INCLUDE_DIRS}
    ${GLFW_INCLUDE_DIR}
	${CMAKE_SOURCE_DIR}/3rdparty)
    
target_link_libraries(ctools
    ${Vulkan_LIBRARIES}
    ${GLFW_LIBRARIES})
    
set_target_properties(ctools PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(ctools PROPERTIES FOLDER 3rdparty)

set(CTOOLS_LIBRARIES ctools)

