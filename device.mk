PRODUCT_SOONG_NAMESPACES += device/amlogic/yukawa

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)/Image.lz4
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES +=  $(LOCAL_KERNEL):kernel

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

# Enable userspace reboot
$(call inherit-product, $(SRC_TARGET_DIR)/product/userspace_reboot.mk)

# Enable Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/android_t_baseline.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := gz

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

DEVICE_PACKAGE_OVERLAYS := device/amlogic/yukawa/overlay
ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
# Setup tablet build
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
PRODUCT_CHARACTERISTICS := tablet
else
# Setup TV Build
USE_OEM_TV_APP := true
$(call inherit-product, device/google/atv/products/atv_base.mk)
PRODUCT_CHARACTERISTICS := tv
PRODUCT_AAPT_PREF_CONFIG := tvdpi
PRODUCT_IS_ATV := true
endif

# A/B support
PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_engine_sideload \
    update_verifier \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

# The following modules are included in debuggable builds only.
PRODUCT_PACKAGES_DEBUG += \
    bootctl \
    update_engine_client \
    SystemUpdaterSample

# Userdata Checkpointing OTA GC
PRODUCT_PACKAGES += \
	checkpoint_gc

# Boot control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service \
    bootctrl.default

# Dynamic partitions
PRODUCT_BUILD_SUPER_PARTITION := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

PRODUCT_PACKAGES += \
	android.hardware.fastboot@1.0 \
	android.hardware.fastboot@1.0-impl-mock \
	fastbootd


ifeq ($(TARGET_AVB_ENABLE), true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.yukawa.avb.ab:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.yukawa \
    $(LOCAL_PATH)/fstab.yukawa.avb.ab:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.yukawa \
    $(LOCAL_PATH)/fstab.yukawa.avb.ab:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.yukawa
else
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.yukawa.ab:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.yukawa \
    $(LOCAL_PATH)/fstab.yukawa.ab:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.yukawa \
    $(LOCAL_PATH)/fstab.yukawa.ab:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/etc/fstab.yukawa
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.yukawa.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.yukawa.rc \
    $(LOCAL_PATH)/init.yukawa.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.yukawa.usb.rc \
    $(LOCAL_PATH)/init.recovery.hardware.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.yukawa.rc \
    $(LOCAL_PATH)/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# BT and Wifi FW
PRODUCT_PACKAGES += \
    yukawa_brcmfmac4359-sdio.bin \
    yukawa_brcmfmac4359-sdio.txt \
    yukawa_brcmfmac4359_vim3l_bin \
    yukawa_brcmfmac4359_vim3l_txt


ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
# Use Launcher3QuickStep
PRODUCT_PACKAGES += Launcher3QuickStep
else
# CEC
PRODUCT_PACKAGES += \
    android.hardware.tv.cec@1.0-impl \
    android.hardware.tv.cec@1.0-service \
    hdmi_cec.yukawa

PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=4 \
    ro.hdmi.cec_device_types=playback_device \
    persist.sys.hdmi.keep_awake=false

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml

# TV Specific Packages
PRODUCT_PACKAGES += \
    LiveTv \
    google-tv-pairing-protocol \
    LeanbackSampleApp \
    tv_input.default \
    com.android.media.tv.remoteprovider \
    InputDevices

# Fallback IME and Home apps
PRODUCT_PACKAGES += \
    LeanbackIME \
    TvSampleLeanbackLauncher

ifeq ($(TARGET_PRODUCT), yukawa_gms)
PRODUCT_PACKAGES += \
    TvProvision \
    TVLauncherNoGms \
    TVRecommendationsNoGms
endif
endif

# Bluetooth
PRODUCT_PACKAGES += android.hardware.bluetooth-service.default

# Wifi
PRODUCT_PACKAGES += libwpa_client wpa_supplicant hostapd wificond wpa_cli
PRODUCT_PROPERTY_OVERRIDES += wifi.interface=wlan0 \
                              wifi.supplicant_scan_interval=15

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf

# Build default bluetooth a2dp and usb audio HALs
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio@2.0-impl \
    audio.usb.default \
    audio.primary.yukawa \
    audio.r_submix.default \
    audio.bluetooth.default \
    tinyplay \
    tinycap \
    tinymix \
    tinypcminfo \
    cplay

# Video
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/binaries/video_firmware/g12a_h264.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/g12a_h264.bin \
    $(LOCAL_PATH)/binaries/video_firmware/g12a_hevc_mmu.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/g12a_hevc_mmu.bin \
    $(LOCAL_PATH)/binaries/video_firmware/g12a_vp9.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/g12a_vp9.bin \
    $(LOCAL_PATH)/binaries/video_firmware/gxl_mpeg4_5.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/gxl_mpeg4_5.bin \
    $(LOCAL_PATH)/binaries/video_firmware/gxl_mpeg12.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/gxl_mpeg12.bin \
    $(LOCAL_PATH)/binaries/video_firmware/gxl_mjpeg.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/gxl_mjpeg.bin \
    $(LOCAL_PATH)/binaries/video_firmware/sm1_hevc_mmu.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/sm1_hevc_mmu.bin \
    $(LOCAL_PATH)/binaries/video_firmware/sm1_vp9_mmu.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/sm1_vp9_mmu.bin

PRODUCT_PACKAGES += \
    android.hardware.audio.service \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.soundtrigger@2.3-impl

# audio policy configuration
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml 

PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/hal/audio/mixer_paths_hdmi_only.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    device/amlogic/yukawa/hal/audio/audio_policy_configuration_hdmi_only.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
DEVICE_PACKAGE_OVERLAYS += \
    device/amlogic/yukawa/hal/audio/overlay_hdmi_only
TARGET_USE_HDMI_AUDIO ?= true

# Graphics #
#
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=320

PRODUCT_PACKAGES +=  libGLES_mali
PRODUCT_PACKAGES +=  libGLES_android

# Vulkan
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:vendor/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:vendor/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:vendor/etc/permissions/android.hardware.vulkan.level.xml

PRODUCT_PACKAGES +=  vulkan.yukawa.so


PRODUCT_PACKAGES += \
    gralloc.yukawa \
    android.hardware.graphics.composer@2.2-impl \
    android.hardware.graphics.composer@2.2-service \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl-2.1

# Hardware Composer HAL
#
PRODUCT_PACKAGES += \
    hwcomposer.drm_meson

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.hwcomposer=drm_meson \
    ro.hardware.egl=mali \
    ro.hardware.vulkan=yukawa

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=yukawa

# DRM Service
PRODUCT_PACKAGES += \
    android.hardware.drm-service.widevine \
    android.hardware.drm@latest-service.clearkey

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/input/Generic.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl

# PowerHAL
PRODUCT_PACKAGES += \
    android.hardware.power-service.example

# PowerStats HAL
PRODUCT_PACKAGES += \
    android.hardware.power.stats-service.example

# Health: Install default binderized implementation to vendor.
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl-cuttlefish \
    android.hardware.health@2.1-service

# Sensor HAL
ifneq ($(TARGET_SENSOR_MEZZANINE),)
TARGET_USES_NANOHUB_SENSORHAL := true
NANOHUB_SENSORHAL_LID_STATE_ENABLED := true
NANOHUB_SENSORHAL_SENSORLIST := $(LOCAL_PATH)/sensorhal/sensorlist_$(TARGET_SENSOR_MEZZANINE).cpp
NANOHUB_SENSORHAL_DIRECT_REPORT_ENABLED := true
NANOHUB_SENSORHAL_DYNAMIC_SENSOR_EXT_ENABLED := true

PRODUCT_PACKAGES += \
    context_hub.default \
    sensors.yukawa \
    android.hardware.sensors@1.0-service \
    android.hardware.sensors@1.0-impl \
    android.hardware.contexthub@1.2-service \
    android.hardware.contexthub@1.2-impl

# Nanohub tools
PRODUCT_PACKAGES += stm32_flash nanoapp_cmd nanotool

PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/init.common.nanohub.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.nanohub.rc

# Copy sensors config file(s)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

# Argonkey VL53L0X proximity driver is not available yet. So we are going to copy conf file for neonkey only
ifeq ($(TARGET_SENSOR_MEZZANINE),neonkey)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml
endif
endif

# Software Gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software

PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.2-service.generic

PRODUCT_COPY_FILES +=  \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

PRODUCT_COPY_FILES += \
    hardware/amlogic/yukawa/usb/1.2/init.gadgethal.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.gadgethal.sh

PRODUCT_COPY_FILES +=  \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.software.cts.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.cts.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml

# Copy media codecs config file
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \
    device/amlogic/yukawa/media_xml/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Enable USB Camera
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-external-service
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/hal/camera/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

PRODUCT_COPY_FILES +=  \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \

# Include Virtualization APEX
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# Bootloaders binaries
PRODUCT_COPY_FILES +=  \
    device/amlogic/yukawa/bootloader/u-boot_k$(TARGET_DEV_BOARD)_ab.bin:$(TARGET_OUT)/u-boot_k$(TARGET_DEV_BOARD)_ab.bin

