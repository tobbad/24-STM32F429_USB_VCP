
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
SIZE=arm-none-eabi-size
PROJ_NAME=firmware
OBJECTS=obj
OUTPATH=build

CFLAGS  = -O2
CFLAGS += -Wall
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DSTM32F429xx
CFLAGS += -DSTM32F4xx
CFLAGS += -mlittle-endian
CFLAGS += -mthumb
CFLAGS += -mthumb-interwork
CFLAGS += -march=armv7e-m
CFLAGS += -mcpu=cortex-m4
CFLAGS += -mfloat-abi=hard
CFLAGS += -mfpu=fpv4-sp-d16
CFLAGS += -DSTM32F429_439xx
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DSTM32F4XX
CFLAGS += -D__ASSEMBLY__
CFLAGS += -DKEIL_IDE
CFLAGS += -DTM_DISCO_STM32F429_DISCOVERY
CFLAGS += -DUSE_USB_OTG_HS


STM_LINKERSCRIPT = STM32F429-Discovery.ld
LINKFLAG = -T$(STM_LINKERSCRIPT) --specs="/usr/lib/arm-none-eabi/newlib/armv7e-m/fpu/rdimon.specs" 

#
# Include folders
#
INCLUDS += -I./User
INCLUDS += -I../TM
INCLUDS += -I../00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/inc
INCLUDS += -I../00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src
INCLUDS += -I../00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Device/ST/STM32F4xx/Include
INCLUDS += -I../00-STM32F429_LIBRARIES
INCLUDS += -I../00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Include
INCLUDS += -I../00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Device/ST/STM32F4xx/Source/Templates/arm
INCLUDS += -I../00-STM32F429_LIBRARIES/usb_cdc_device
INCLUDS += -I../00-HAL_DRIVERS/STM32F4xx_HAL_Driver/Inc/Legacy
STARTUP_SRCS = \
	00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Device/ST/STM32F4xx/Source/Templates/arm/startup_stm32f40_41xxx.s \
	00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Device/ST/STM32F4xx/Source/Templates/arm/startup_stm32f401xx.s \
	00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Device/ST/STM32F4xx/Source/Templates/arm/startup_stm32f411xe.s \
	00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Device/ST/STM32F4xx/Source/Templates/arm/startup_stm32f429_439xx.s
STARTUP_OBJS = $(STARTUP_SRCS:.c=.o)

STD_PERIPH_DRIVERS_SRCS = \
	00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src/misc.c \
	00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c
STD_PERIPH_DRIVERS_OBJS = $(STD_PERIPH_DRIVERS_SRCS:.c=.o)

TM_SRCS = \
	00-STM32F429_LIBRARIES/tm_stm32f4_delay.c \
	00-STM32F429_LIBRARIES/tm_stm32f4_disco.c \
	00-STM32F429_LIBRARIES/tm_stm32f4_usb_vcp.c \
	00-STM32F429_LIBRARIES/tm_stm32f4_gpio.c
TM_OBJS = $(TM_SRCS:.c=.o)

USER_SRCS = \
	./User/main.c \
	./User/stm32f4xx_it.c \
	./User/system_stm32f4xx.c
USER_OBJS = $(USER_SRCS:.c=.o)

USB_CDC_DEVICE_SRCS = \
	00-STM32F429_LIBRARIES/usb_cdc_device/usb_bsp.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usb_core.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usb_dcd.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usb_dcd_int.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usbd_cdc_core.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usbd_cdc_vcp.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usbd_core.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usbd_desc.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usbd_ioreq.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usbd_req.c \
	00-STM32F429_LIBRARIES/usb_cdc_device/usbd_usr.c
USB_CDC_DEVICE_OBJS = $(USB_CDC_DEVICE_SRCS:.c=.o)

vpath %.c ..

###################################################

.PHONY: proj dir_tree

all:  dir_tree proj
	@echo $(OBJS)

dir_tree:
	mkdir -p $(OBJECTS)
	mkdir -p $(OUTPATH)

proj: $(OUTPATH)/$(PROJ_NAME).elf
	$(SIZE) $(OUTPATH)/$(PROJ_NAME).elf

.c.o:
	$(CC) $(CFLAGS) $(INCLUDS) -c  -o $(OBJECTS)/$(notdir $@) $<

.s.o:
	$(CC) $(CFLAGS) $(INCLUDS) -c  -o $(OBJECTS)/$(notdir $@) $<

clean:
	find . -name \*.o -type f -delete
	find . -name \*.a -type f -delete
	find . -name \*.lst -type f -delete
	rm -f $(OUTPATH)/$(PROJ_NAME).elf
	rm -f $(OUTPATH)/$(PROJ_NAME).hex
	rm -f $(OUTPATH)/$(PROJ_NAME).bin

$(OBJECTS)/libStartup.a : $(STARTUP_OBJS)
	ar rvs $(OBJECTS)/libStartup.a $(OBJECTS)/*.o
 
$(OBJECTS)/libStd_Periph_Drivers.a : $(STD_PERIPH_DRIVERS_OBJS)
	ar rvs $(OBJECTS)/libStd_Periph_Drivers.a $(OBJECTS)/*.o
 
$(OBJECTS)/libTm.a : $(TM_OBJS)
	ar rvs $(OBJECTS)/libTm.a $(OBJECTS)/*.o
 
$(OBJECTS)/libUser.a : $(USER_OBJS)
	ar rvs $(OBJECTS)/libUser.a $(OBJECTS)/*.o
 
$(OBJECTS)/libUsbCdcDevice.a : $(USB_CDC_DEVICE_OBJS)
	ar rvs $(OBJECTS)/libUsbCdcDevice.a $(OBJECTS)/*.o
 
$(OUTPATH)/$(PROJ_NAME).elf: $(OBJECTS)/libStartup.a $(OBJECTS)/libStd_Periph_Drivers.a $(OBJECTS)/libTm.a $(OBJECTS)/libUser.a $(OBJECTS)/libUsbCdcDevice.a startup_stm32f429xx.S
	$(CC) $(CFLAGS) $(LINKFLAG) $(OBJECTS)/*.o startup_stm32f429xx.S -o $(OUTPATH)/$(PROJ_NAME).elf
	$(OBJCOPY) -O ihex $(OUTPATH)/$(PROJ_NAME).elf $(OUTPATH)/$(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(OUTPATH)/$(PROJ_NAME).elf $(OUTPATH)/$(PROJ_NAME).bin
