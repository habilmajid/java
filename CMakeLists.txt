cmake_minimum_required(VERSION 3.16)
project(ZanzibarSmartSchoolSystem VERSION 1.0.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Threads REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(SQLite3 REQUIRED)
find_package(PostgreSQL QUIET)

add_executable(school_server
  src/main.cpp
  src/database.cpp
  src/json_impl.cpp
)
target_include_directories(school_server PRIVATE src)
target_compile_definitions(school_server PRIVATE BOOST_ERROR_CODE_HEADER_ONLY BOOST_JSON_NO_LIB)
target_link_libraries(school_server PRIVATE Threads::Threads OpenSSL::Crypto SQLite::SQLite3)
if(PostgreSQL_FOUND)
  target_compile_definitions(school_server PRIVATE HAVE_POSTGRESQL=1)
  target_link_libraries(school_server PRIVATE PostgreSQL::PostgreSQL)
  message(STATUS "PostgreSQL enabled (for Neon/hosted deployments)")
else()
  message(STATUS "PostgreSQL not available; SQLite local mode only")
endif()
if(MSVC)
  target_compile_options(school_server PRIVATE /W4)
else()
  target_compile_options(school_server PRIVATE -Wall -Wextra -Wpedantic)
endif()
if(WIN32)
  target_link_libraries(school_server PRIVATE ws2_32)
endif()
