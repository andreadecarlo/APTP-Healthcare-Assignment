import os

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node

def generate_launch_description():
    # Get the launch directory
    bringup_dir = get_package_share_directory('plansys2_healthcare_pb5')
    domain_file = os.path.join(bringup_dir, 'pddl', 'domain.pddl')

    namespace = LaunchConfiguration('namespace')

    # Create our own launch description
    ld = LaunchDescription()

    # Declare the launch options
    ld.add_action(DeclareLaunchArgument('domain_file', default_value=domain_file))

    declare_namespace_cmd = DeclareLaunchArgument(
        'namespace',
        default_value='',
        description='Namespace')
    
    ld.add_action(declare_namespace_cmd)

    # Launch plansys2_bringup
    plansys2_bringup_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(os.path.join(
            get_package_share_directory('plansys2_bringup'),
            'launch',
            'plansys2_bringup_launch_monolithic.py')),
        launch_arguments={
            'model_file': bringup_dir + '/pddl/domain.pddl',
            'namespace': namespace
        }.items())

    ld.add_action(plansys2_bringup_launch)

    # Launch action executor nodes
    ld.add_action(
        Node(
            package='plansys2_healthcare_pb5',
            executable='move_robot_action_node',
            name='move_robot_action_node',
            namespace=namespace,
            output='screen',
            parameters=[]))

    ld.add_action(
        Node(
            package='plansys2_healthcare_pb5',
            executable='fill_action_node',
            name='fill_action_node',
            namespace=namespace,
            output='screen',
            parameters=[]))

    ld.add_action(
        Node(
            package='plansys2_healthcare_pb5',
            executable='pick_up_action_node',
            name='pick_up_action_node',
            namespace=namespace,
            output='screen',
            parameters=[]))

    ld.add_action(
        Node(
            package='plansys2_healthcare_pb5',
            executable='drop_action_node',
            name='drop_action_node',
            namespace=namespace,
            output='screen',
            parameters=[]))

    ld.add_action(
        Node(
            package='plansys2_healthcare_pb5',
            executable='empty_action_node',
            name='empty_action_node',
            namespace=namespace,
            output='screen',
            parameters=[]))

    ld.add_action(
        Node(
            package='plansys2_healthcare_pb5',
            executable='take_patient_action_node',
            name='take_patient_action_node',
            namespace=namespace,
            output='screen',
            parameters=[]))

    ld.add_action(
        Node(
            package='plansys2_healthcare_pb5',
            executable='release_patient_action_node',
            name='release_patient_action_node',
            namespace=namespace,
            output='screen',
            parameters=[]))

    return ld
