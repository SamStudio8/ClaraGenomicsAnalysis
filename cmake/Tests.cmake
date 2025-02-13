#
# Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.
#

cmake_minimum_required(VERSION 3.10.2)


#Cmake macro to initialzie ctest.
enable_testing()

get_property(enable_tests GLOBAL PROPERTY enable_tests)
function(cga_add_tests NAME SOURCES LIBS)
    # Add test executable
    if (enable_tests)
        add_executable(${NAME} ${SOURCES})

        # Link gtest to tests binary
        target_link_libraries(${NAME}
            ${LIBS}
            gtest)
        # Install to tests location
        install(TARGETS ${NAME}
            DESTINATION tests)
    endif()
endfunction(cga_add_tests)
