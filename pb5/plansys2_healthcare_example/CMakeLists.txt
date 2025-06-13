cmake_minimum_required(VERSION 3.5)
project(plansys2_healthcare_example)


# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_action REQUIRED)
find_package(plansys2_msgs REQUIRED)
find_package(plansys2_executor REQUIRED)
# find_package(plansys2_domain_expert REQUIRED)
# find_package(plansys2_problem_expert REQUIRED)
# find_package(plansys2_planner REQUIRED)

set(CMAKE_CXX_STANDARD 17)

set(dependencies
    rclcpp
    rclcpp_action
    plansys2_msgs
    plansys2_executor
)


# Add the executables
add_executable(move_carrier_action_node src/move_carrier_action_node.cpp)
ament_target_dependencies(move_carrier_action_node ${dependencies})

add_executable(move_robot_action_node src/move_robot_action_node.cpp)
ament_target_dependencies(move_robot_action_node ${dependencies})

add_executable(fill_action_node src/fill_action_node.cpp)
ament_target_dependencies(fill_action_node ${dependencies})

add_executable(pick_up_action_node src/pick_up_action_node.cpp)
ament_target_dependencies(pick_up_action_node ${dependencies})

add_executable(drop_action_node src/drop_action_node.cpp)
ament_target_dependencies(drop_action_node ${dependencies})

add_executable(empty_action_node src/empty_action_node.cpp)
ament_target_dependencies(empty_action_node ${dependencies})

add_executable(take_patient_action_node src/take_patient_action_node.cpp)
ament_target_dependencies(take_patient_action_node ${dependencies})

add_executable(release_patient_action_node src/release_patient_action_node.cpp)
ament_target_dependencies(release_patient_action_node ${dependencies})

# Install
install(DIRECTORY launch pddl DESTINATION share/${PROJECT_NAME})

install(TARGETS
  move_carrier_action_node
  move_robot_action_node
  fill_action_node
  pick_up_action_node
  drop_action_node
  empty_action_node
  take_patient_action_node
  release_patient_action_node

  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION lib/${PROJECT_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()

  find_package(ament_cmake_gtest REQUIRED)
endif()

ament_export_dependencies(${dependencies})

ament_package() 