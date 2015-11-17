include(RunCMake)

if(RunCMake_GENERATOR STREQUAL "Borland Makefiles")
  set(fs_delay 3)
else()
  set(fs_delay 1.125)
endif()

function(run_BuildDepends CASE)
  # Use a single build tree for a few tests without cleaning.
  set(RunCMake_TEST_BINARY_DIR ${RunCMake_BINARY_DIR}/${CASE}-build)
  set(RunCMake_TEST_NO_CLEAN 1)
  if(RunCMake_GENERATOR MATCHES "Make|Ninja")
    set(RunCMake_TEST_OPTIONS -DCMAKE_BUILD_TYPE=Debug)
  endif()
  file(REMOVE_RECURSE "${RunCMake_TEST_BINARY_DIR}")
  file(MAKE_DIRECTORY "${RunCMake_TEST_BINARY_DIR}")
  include(${RunCMake_SOURCE_DIR}/${CASE}.step1.cmake OPTIONAL)
  run_cmake(${CASE})
  set(RunCMake-check-file check.cmake)
  set(check_step 1)
  run_cmake_command(${CASE}-build1 ${CMAKE_COMMAND} --build . --config Debug)
  if(run_BuildDepends_skip_step_2)
    return()
  endif()
  execute_process(COMMAND ${CMAKE_COMMAND} -E sleep ${fs_delay}) # handle 1s resolution
  include(${RunCMake_SOURCE_DIR}/${CASE}.step2.cmake OPTIONAL)
  set(check_step 2)
  run_cmake_command(${CASE}-build2 ${CMAKE_COMMAND} --build . --config Debug)
endfunction()

run_BuildDepends(C-Exe)
if(NOT RunCMake_GENERATOR MATCHES "Visual Studio [67]|Xcode")
  if(RunCMake_GENERATOR MATCHES "Visual Studio 10")
    # VS 10 forgets to re-link when a manifest changes
    set(run_BuildDepends_skip_step_2 1)
  endif()
  run_BuildDepends(C-Exe-Manifest)
  unset(run_BuildDepends_skip_step_2)
endif()
