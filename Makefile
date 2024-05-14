# The SDK and iOS version to target. This is specifying the iOS 14.4 SDK and minimum build target as iOS 13.0
TARGET = iphone:14.5:16.1
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	ARCHS = arm64 arm64e
else
	ARCHS = arm64
endif

INSTALL_TARGET_PROCESSES = Transform

include $(THEOS)/makefiles/common.mk
XCODEPROJ_NAME = Transform
Transform_XCODE_SCHEME = Transform
Transform_CODESIGN_FLAGS = -StransformEntitlement.xml

include $(THEOS_MAKE_PATH)/xcodeproj.mk
