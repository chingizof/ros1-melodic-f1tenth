# CMake generated Testfile for 
# Source directory: /home/sdc/sandbox/f1tenth_ws/src/realsense-ros/realsense2_description
# Build directory: /home/sdc/sandbox/f1tenth_ws/build/realsense2_description
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(_ctest_realsense2_description_nosetests_tests "/home/sdc/sandbox/f1tenth_ws/build/realsense2_description/catkin_generated/env_cached.sh" "/usr/bin/python2" "/opt/ros/melodic/share/catkin/cmake/test/run_tests.py" "/home/sdc/sandbox/f1tenth_ws/build/realsense2_description/test_results/realsense2_description/nosetests-tests.xml" "--return-code" "\"/usr/bin/cmake\" -E make_directory /home/sdc/sandbox/f1tenth_ws/build/realsense2_description/test_results/realsense2_description" "/usr/bin/nosetests-2.7 -P --process-timeout=60 --where=/home/sdc/sandbox/f1tenth_ws/src/realsense-ros/realsense2_description/tests --with-xunit --xunit-file=/home/sdc/sandbox/f1tenth_ws/build/realsense2_description/test_results/realsense2_description/nosetests-tests.xml")
subdirs("gtest")
