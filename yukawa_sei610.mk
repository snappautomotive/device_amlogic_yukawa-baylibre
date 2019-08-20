# Inherit the full_base and device configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/amlogic/yukawa/yukawa-common.mk)

PRODUCT_NAME := yukawa_sei610
PRODUCT_DEVICE := yukawa_sei610
BOARD_KERNEL_DTB := device/amlogic/yukawa-kernel/meson-sm1-sei610.dtb
