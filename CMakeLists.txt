cmake_minimum_required(VERSION 3.16)

include(cmake/prelude.cmake)
option(ANDROID "Build for Android" OFF)

project(
    tilapia_for_reddit 
    VERSION 0.0.1
    DESCRIPTION "A Kirigami app for browsing reddit."
    HOMEPAGE_URL "https://github.com/Diesel-Hadez/Tilapia-For-Reddit"
    LANGUAGES CXX
)

set(KF_MIN_VERSION "5.106.0")
set(QT_MIN_VERSION "5.15.8")

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)

# ---- Include libraries ----
find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Test Gui QuickControls2 Widgets)
find_package(KF5 ${KF_MIN_VERSION} REQUIRED COMPONENTS Kirigami2)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

# ---- Declare library ----

add_library(
    tilapia_for_reddit_lib OBJECT
    source/lib.cpp
)

target_include_directories(
    tilapia_for_reddit_lib ${warning_guard}
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source>"
)

target_compile_features(tilapia_for_reddit_lib PUBLIC cxx_std_17)

# ---- Declare executable ----

add_executable(tilapia_for_reddit_exe source/main.cpp source/CommentItem.cpp source/CommentItem.hpp source/CommentTreeModel.cpp source/CommentTreeModel.hpp source/CommentFetcher.hpp source/CommentFetcher.cpp source/resources.qrc)
add_executable(tilapia_for_reddit::exe ALIAS tilapia_for_reddit_exe)

set_property(TARGET tilapia_for_reddit_exe PROPERTY OUTPUT_NAME tilapia_for_reddit)

target_compile_features(tilapia_for_reddit_exe PRIVATE cxx_std_17)

target_link_libraries(tilapia_for_reddit_exe PRIVATE tilapia_for_reddit_lib Qt5::Quick Qt5::Qml Qt5::Gui Qt5::QuickControls2 Qt5::Widgets KF5::Kirigami2)

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
  include(cmake/install-rules.cmake)
endif()

# ---- Developer mode ----

if(NOT tilapia_for_reddit_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
      AUTHOR_WARNING
      "Developer mode is intended for developers of tilapia_for_reddit"
  )
endif()

include(cmake/dev-mode.cmake)
