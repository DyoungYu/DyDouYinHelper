export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 12345

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DyDouYinHelper
DyDouYinHelper_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
