# Parent project does not export its library target, so this CML implicitly
# depends on being added from it, i.e. the testing is done only from the build
# tree and is not feasible from an install location

project(tilapia_for_redditTests LANGUAGES CXX)

# ---- Tests ----

add_executable(tilapia_for_reddit_test source/tilapia_for_reddit_test.cpp)
target_link_libraries(tilapia_for_reddit_test PRIVATE tilapia_for_reddit_lib)
target_compile_features(tilapia_for_reddit_test PRIVATE cxx_std_17)

add_test(NAME tilapia_for_reddit_test COMMAND tilapia_for_reddit_test)

# ---- End-of-file commands ----

add_folders(Test)
