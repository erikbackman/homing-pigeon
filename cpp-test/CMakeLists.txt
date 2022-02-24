find_package(ArrayFire)
add_executable(backends backends.cpp)
target_link_libraries(backends ArrayFire::af)
