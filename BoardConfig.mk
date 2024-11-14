#
# Product-specific compile-time definitions.
#
# The generic product target doesn't have any hardware-specific pieces.
# Primary Arch
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a53

# Secondary Arch
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# 64 bit mediadrmserver
TARGET_ENABLE_MEDIADRM_64 := true

# Puts odex files on system_other, as well as causing dex files not to get
# stripped from APKs.
BOARD_USES_SYSTEM_OTHER_ODEX := true

TARGET_BOARD_PLATFORM := yukawa
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_DEV_BOARD)
TARGET_BOARD_INFO_FILE := device/amlogic/yukawa/board-info/board-info-$(TARGET_DEV_BOARD).txt

# Vulkan
BOARD_INSTALL_VULKAN := true

# OpenCL
BOARD_INSTALL_OPENCL := true

# BT configs
BOARD_HAVE_BLUETOOTH := true

# generic wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true

# Treble
PRODUCT_FULL_TREBLE := true
BOARD_VNDK_VERSION := current

# AVB
ifeq ($(TARGET_AVB_ENABLE), true)
BOARD_AVB_ENABLE := true
else
BOARD_AVB_ENABLE := false
endif

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false

BOARD_USES_RECOVERY_AS_BOOT := true
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    system \
    vendor

ifeq ($(TARGET_AVB_ENABLE), true)
AB_OTA_PARTITIONS += vbmeta
endif
BOARD_BOOTIMAGE_PARTITION_SIZE := $(shell echo $$(( 64 * 1024 * 1024 )))
BOARD_DTBOIMG_PARTITION_SIZE := $(shell echo $$(( 8 * 1024 * 1024 ))) # 8 MiB
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Super partition
TARGET_USE_DYNAMIC_PARTITIONS := true
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_PARTITION_GROUPS := db_dynamic_partitions
BOARD_DB_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor
BOARD_SUPER_PARTITION_SIZE := $(shell echo $$(( 4096 * 1024 * 1024 )))
BOARD_DB_DYNAMIC_PARTITIONS_SIZE := $(shell echo $$(( $(BOARD_SUPER_PARTITION_SIZE)/2 - (10 * 1024 * 1024) )))  # Reserve 10M for DAP metadata

# Creates metadata partition mount point under root for
# the devices with metadata parition
BOARD_USES_METADATA_PARTITION := true

# Userdata partition
TARGET_COPY_OUT_DATA := data
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_USERDATAIMAGE_PARTITION_SIZE :=  $(shell echo $$(( 3072 * 1024 * 1024 )))
TARGET_USERIMAGES_SPARSE_F2FS_DISABLED ?= false

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
ifeq ($(TARGET_AVB_ENABLE), true)
TARGET_RECOVERY_FSTAB := device/amlogic/yukawa/fstab.yukawa.avb.ab
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 2
else
TARGET_RECOVERY_FSTAB := device/amlogic/yukawa/fstab.yukawa
endif

BOARD_KERNEL_OFFSET      := 0x1080000
BOARD_KERNEL_TAGS_OFFSET := 0x1000000
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_MKBOOTIMG_ARGS     := --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_BOOT_HEADER_VERSION := 2
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# Pass unsigned dtbo image (generated by build/tasks/dtimages.mk) to Android
# build system for AVB signing
DTBO_UNSIGNED := dtbo-unsigned.img
# $(PRODUCT_OUT) hasn't been defined yet, so use "=" instead of ":="
# so that it is resolved later
BOARD_PREBUILT_DTBOIMAGE = $(PRODUCT_OUT)/$(DTBO_UNSIGNED)


BOARD_KERNEL_CMDLINE += no_console_suspend console=ttyAML0,115200 earlycon
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/ffe07000.mmc 
BOARD_KERNEL_CMDLINE += init=/init
BOARD_KERNEL_CMDLINE += firmware_class.path=/vendor/firmware
BOARD_KERNEL_CMDLINE += androidboot.hardware=yukawa
ifneq ($(TARGET_SELINUX_ENFORCE), true)
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
endif
ifeq ($(TARGET_BUILTIN_EDID), true)
BOARD_KERNEL_CMDLINE += drm.edid_firmware=edid/1920x1080.bin
endif
ifneq ($(TARGET_SENSOR_MEZZANINE),)
BOARD_KERNEL_CMDLINE += overlay_mgr.overlay_dt_entry=hardware_cfg_$(TARGET_SENSOR_MEZZANINE)
endif
ifneq ($(TARGET_MEM_SIZE),)
BOARD_KERNEL_CMDLINE += mem=$(TARGET_MEM_SIZE)
endif

ifneq ($(TARGET_KERNEL_CFG),)
BOARD_KERNEL_CMDLINE += $(TARGET_KERNEL_CFG)
endif

BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_ALSA_AUDIO := true

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := build/make/target/board/mainline_arm64/bluetooth

BOARD_VENDOR_SEPOLICY_DIRS += \
        device/amlogic/yukawa/sepolicy

# USB Hal
BOARD_SEPOLICY_DIRS += \
        hardware/amlogic/yukawa/usb/1.2/sepolicy

DEVICE_MANIFEST_FILE += device/amlogic/yukawa/manifest.xml

DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/amlogic/yukawa/framework_compatibility_matrix.xml
ifneq ($(TARGET_USE_TABLET_LAUNCHER), true)
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/amlogic/yukawa/tv_framework_compatibility_matrix.xml
endif

ifneq ($(TARGET_SENSOR_MEZZANINE),)
DEVICE_MANIFEST_FILE += device/amlogic/yukawa/sensorhal/manifest.xml
endif

# Generate an APEX image for experiment b/119800099.
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Disable Jack build system due deprecated status (https://source.android.com/source/jack)
ANDROID_COMPILE_WITH_JACK ?= false

# Enable system property split for Treble
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Include stats logging code in LMKD
TARGET_LMKD_STATS_LOG := true
