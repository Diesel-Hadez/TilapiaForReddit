install(
    TARGETS tilapia_for_reddit_exe
    RUNTIME COMPONENT tilapia_for_reddit_Runtime
)

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
