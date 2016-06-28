cmake_minimum_required(VERSION 2.8.3)
project(tinyspline_catkin)

SET(CMAKE_CXX_FLAGS "-Werror -Wall -Wextra -Wfloat-equal -std=c++11 -Wno-uninitialized  -Wno-unused-parameter -Wno-missing-field-initializers -Wno-ignored-qualifiers ${CMAKE_CXX_FLAGS}")

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin_simple REQUIRED)
catkin_simple()

include(ExternalProject)
file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/include/tinyspline)

#-DCMAKE_INSTALL_PREFIX=${CATKIN_DEVEL_PREFIX}
ExternalProject_Add(tinyspline_src
        GIT_REPOSITORY https://github.com/retuxx/tinyspline.git
        UPDATE_COMMAND ""
        CONFIGURE_COMMAND cd ../tinyspline_src && mkdir -p build && cd build && cmake ../
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_PREFIX=${CATKIN_DEVEL_PREFIX}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
        BUILD_COMMAND cd ../tinyspline_src/build && make -j8
        BUILD_ALWAYS 1
        INSTALL_COMMAND cd ../tinyspline_src/build/library/ &&
        cp -r libtinyspline.so ${CATKIN_DEVEL_PREFIX}/lib/ &&
        cp libtinysplinecpp.so ${CATKIN_DEVEL_PREFIX}/lib/ &&
        cd ../.. &&
        cd library &&
        cp -r tinyspline.h ${CATKIN_DEVEL_PREFIX}/include/tinyspline/ &&
        cp tinysplinecpp.h ${CATKIN_DEVEL_PREFIX}/include/tinyspline/ &&
        cp debugging.h ${CATKIN_DEVEL_PREFIX}/include/tinyspline/
        )

## System dependencies are found with CMake's conventions
# find_package(Boost REQUIRED COMPONENTS system)

cs_add_library(${PROJECT_NAME} src/dependency_tracker.cc)

add_dependencies(${PROJECT_NAME} tinyspline_src)

#FIND_LIBRARY(tinysplinecpp_LIBRARIES libtinysplinecpp.a /home/ragdoll/catkin_ws/devel/lib)
target_link_libraries(${PROJECT_NAME} ${CATKIN_DEVEL_PREFIX}/lib/libtinysplinecpp${CMAKE_SHARED_LIBRARY_SUFFIX}
        )

cs_install()

cs_export(INCLUDE_DIRS ${CATKIN_DEVEL_PREFIX}/include
        CFG_EXTRAS tinyspline_catkin-extras.cmake)