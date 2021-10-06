ifeq ($(TARGET_USE_PANFROST), true)
# mesa driver selection
PRODUCT_SOONG_NAMESPACES += external/mesa3d
BOARD_GPU_DRIVERS := panfrost kmsro

# OpenGL driver
PRODUCT_PACKAGES += \
	libGLES_mesa

# Composer HAL for minigbm + minigbm gralloc0:
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    hwcomposer.drm_minigbm \
    gralloc.minigbm

# Composer passthrough HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=minigbm \
    ro.hardware.hwcomposer=drm_minigbm

# Display
PRODUCT_PACKAGES += \
    android.hardware.drm@1.3-service.clearkey \
    android.hardware.drm@1.3-service.widevine

else
# OpenGL driver
PRODUCT_PACKAGES +=  libGLES_mali

# Vulkan
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:vendor/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:vendor/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:vendor/etc/permissions/android.hardware.vulkan.level.xml

PRODUCT_PACKAGES +=  vulkan.yukawa.so

# Hardware Composer HAL
#
PRODUCT_PACKAGES += \
    hwcomposer.drm_meson \
    android.hardware.drm-service.widevine \
    android.hardware.drm-service.clearkey

PRODUCT_PACKAGES += \
    gralloc.yukawa \
    android.hardware.graphics.composer@2.2-impl \
    android.hardware.graphics.composer@2.2-service \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl-2.1

endif

PRODUCT_PACKAGES +=  libGLES_android
