#!/usr/bin/env ruby

# get the project name from the command line
project_name = ARGV[0]

# create the top-level directory
Dir.mkdir(project_name)
Dir.chdir(project_name)

# create the include and src directories
Dir.mkdir("include")
Dir.mkdir("src")

# create a CMakeLists.txt in the top-level directory
File.write("CMakeLists.txt", <<~END
  cmake_minimum_required(VERSION 3.5)
  project(#{project_name} LANGUAGES CXX)

  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)

  add_subdirectory(src)

  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
END
)

# create a CMakeLists.txt in the src directory
Dir.chdir("src")
File.write("CMakeLists.txt", <<~END
  add_library(#{project_name}_lib src_file.cpp)
  target_compile_options(#{project_name}_lib PRIVATE -Wall -Wextra -Wpedantic -Werror -std=c++17)
  target_include_directories(#{project_name}_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include)

  add_executable(#{project_name} main.cpp)
  target_link_libraries(#{project_name} PRIVATE #{project_name}_lib)
END
)

# create a test directory and an empty README.md file inside it
Dir.mkdir("../test")
File.write("../test/README.md", "")

# create a basic main.cpp file in the src directory
File.write("main.cpp", <<~END
  #include <iostream>

  int main() {
      std::cout << "Hello, world!" << std::endl;
      return 0;
  }
END
)

# create a README.md file
File.write("README.md", <<~END
  # #{project_name}

  TODO: Write a project description
END
)

