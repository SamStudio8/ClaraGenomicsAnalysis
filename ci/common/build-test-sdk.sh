#
# Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.
#

CMAKE_BUILD_GPU=""
LOCAL_BUILD_ROOT=$1
CMAKE_OPTS=$2
BUILD_THREADS=$3
GPU_TEST=$4

cd ${LOCAL_BUILD_ROOT}
export LOCAL_BUILD_DIR=${LOCAL_BUILD_ROOT}/build

# Use CMake-based build procedure
mkdir --parents ${LOCAL_BUILD_DIR}
cd ${LOCAL_BUILD_DIR}

# configure
cmake $CMAKE_COMMON_VARIABLES ${CMAKE_BUILD_GPU} -Dcga_enable_tests=ON -Dcga_enable_benchmarks=ON -DCMAKE_INSTALL_PREFIX=${LOCAL_BUILD_DIR}/install ..
# Format files
make check-format
# build
make -j${BUILD_THREADS} VERBOSE=1 all docs install

if [ "$GPU_TEST" == '1' ]; then
  logger "GPU config..."
  nvidia-smi

  logger "Running ClaraGenomicsAnalysis unit tests..."
  #run-parts -v ${LOCAL_BUILD_DIR}/install/tests
  find ${LOCAL_BUILD_DIR}/install/tests -type f -exec {} \;

  logger "Running ClaraGenomicsAnalysis benchmarks..."
  ${LOCAL_BUILD_DIR}/install/benchmarks/cudapoa/multibatch
  ${LOCAL_BUILD_DIR}/install/benchmarks/cudaaligner/singlealignment
fi

