include device/amlogic/yukawa/BoardConfigCommon.mk

TARGET_BOARD_INFO_FILE := device/amlogic/yukawa/sei610/board-info.txt

ifeq ($(TARGET_USE_AB_SLOT), true)
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10730078208
else
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12870221824
endif