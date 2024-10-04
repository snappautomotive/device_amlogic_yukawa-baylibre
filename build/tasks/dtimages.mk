# Use this file to generate dtb.img and dtbo.img instead of using
# BOARD_PREBUILT_DTBIMAGE_DIR. We need to keep dtb and dtbo files at the fixed
# positions in images, so that bootloader can rely on their indexes in the
# image. As dtbo.img must be signed with AVB tool, we generate intermediate
# dtbo.img, and the resulting $(PRODUCT_OUT)/dtbo.img will be created with
# Android build system, by exploiting BOARD_PREBUILT_DTBOIMAGE variable.

ifneq ($(filter yukawa%, $(TARGET_DEVICE)),)

MKDTIMG := system/libufdt/utils/src/mkdtboimg.py
DTBIMAGE := $(PRODUCT_OUT)/dtb.img
DTBOIMAGE := $(PRODUCT_OUT)/$(DTBO_UNSIGNED)

# Please keep this list fixed: add new files in the end of the list
DTB_FILES := \
	$(LOCAL_DTB)/meson-g12a-sei510.dtb \
	$(LOCAL_DTB)/meson-sm1-sei610.dtb \
	$(LOCAL_DTB)/meson-sm1-khadas-vim3l.dtb \
	$(LOCAL_DTB)/meson-g12b-a311d-khadas-vim3.dtb

$(DTBIMAGE): $(DTB_FILES)
	cat $^ > $@

include $(CLEAR_VARS)
LOCAL_MODULE := dtbimage
LOCAL_LICENSE_KINDS := legacy_restricted
LOCAL_LICENSE_CONDITIONS := restricted
LOCAL_ADDITIONAL_DEPENDENCIES := $(DTBIMAGE)
include $(BUILD_PHONY_PACKAGE)

droidcore: dtbimage

$(call dist-for-goals, dist_files, $(DTBOIMAGE))

endif
