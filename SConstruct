
env_options = {
    "CC"    : "arm-none-eabi-gcc",
    "CXX"   : "arm-none-eabi-g++",
    "LD"    : "arm-none-eabi-ld",
    "AR"    : "arm-none-eabi-ar",
    "AS"    : "arm-none-eabi-as",
    "STRIP" : "arm-none-eabi-strip",
    "COPY"  : "arm-none-eabi-objcopy"
}
envRelease = Environment(**env_options)
envDebug = Environment(**env_options)

trgtfolder = 'Debug'
binProd = 'firmware'
binBaseName = '/'.join((trgtfolder, binProd))

VariantDir(trgtfolder, '.', duplicate=0)

CFLAGS  = ("-g",)
CFLAGS += ( '-Wall',)
CFLAGS += ( '-DUSE_STDPERIPH_DRIVER',)
CFLAGS += ( '-DSTM32F429xx',)
CFLAGS += ( '-DSTM32F4xx',)
CFLAGS += ( '-mlittle-endian',)
CFLAGS += ( '-mthumb',)
CFLAGS += ( '-mthumb-interwork',)
CFLAGS += ( '-march=armv7e-m',)
CFLAGS += ( '-mcpu=cortex-m4',)
CFLAGS += ( '-mfloat-abi=hard',)
CFLAGS += ( '-mfpu=fpv4-sp-d16',)
CFLAGS += ( '-DSTM32F429_439xx',)
CFLAGS += ( '-DUSE_STDPERIPH_DRIVER',)
CFLAGS += ( '-DSTM32F4XX',)
CFLAGS += ( '-D__ASSEMBLY__',)
CFLAGS += ( '-DKEIL_IDE',)
CFLAGS += ( '-DTM_DISCO_STM32F429_DISCOVERY',)
CFLAGS += ( '-DUSE_USB_OTG_HS',)
CFLAGS += ( '-std=c11',)

CPPPATH = ()
CPPPATH += ('./User', )
CPPPATH += ('./TM', )
CPPPATH += ('./00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/inc', )
CPPPATH += ('./00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src', )
CPPPATH += ('./00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Device/ST/STM32F4xx/Include', )
CPPPATH += ('./00-STM32F429_LIBRARIES', )
CPPPATH += ('./00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Include', )
CPPPATH += ('./00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/CMSIS/Device/ST/STM32F4xx/Source/Templates/arm', )
CPPPATH += ('./00-STM32F429_LIBRARIES/usb_cdc_device', )
CPPPATH += ('./00-HAL_DRIVERS/STM32F4xx_HAL_Driver/Inc/Legacy', )

LINKFLAGS = ( "-TSTM32F429-Discovery.ld" , '--specs="/usr/lib/arm-none-eabi/newlib/armv7e-m/fpu/rdimon.specs"' )

libStd_Periph_Drivers  = (trgtfolder + '/00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src/misc.c',)
libStd_Periph_Drivers += (trgtfolder + '/00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c',)
libStd_Periph_Drivers += (trgtfolder + '/00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c',)
libStd_Periph_Drivers += (trgtfolder + '/00-STM32F4xx_STANDARD_PERIPHERAL_DRIVERS/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c',)
envRelease.StaticLibrary(trgtfolder + '/Std_Periph_Drivers', source=libStd_Periph_Drivers, CFLAGS=CFLAGS, CPPPATH=CPPPATH, variant_dir=trgtfolder)

libTm  = (trgtfolder + '/00-STM32F429_LIBRARIES/tm_stm32f4_delay.c',)
libTm += (trgtfolder + '/00-STM32F429_LIBRARIES/tm_stm32f4_disco.c',)
libTm += (trgtfolder + '/00-STM32F429_LIBRARIES/tm_stm32f4_usb_vcp.c',)
libTm += (trgtfolder + '/00-STM32F429_LIBRARIES/tm_stm32f4_gpio.c',)
envRelease.StaticLibrary(trgtfolder + '/Tm', source=libTm, CFLAGS=CFLAGS, CPPPATH=CPPPATH, variant_dir=trgtfolder)

libUser  = (trgtfolder + '/User/main.c',)
libUser += (trgtfolder + '/User/stm32f4xx_it.c',)
libUser += (trgtfolder + '/User/system_stm32f4xx.c',)
libUser += (trgtfolder + '/startup_stm32f429xx.S',)

libUsbCdcDevice  = (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usb_bsp.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usb_core.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usb_dcd.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usb_dcd_int.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usbd_cdc_core.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usbd_cdc_vcp.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usbd_core.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usbd_desc.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usbd_ioreq.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usbd_req.c',)
libUsbCdcDevice += (trgtfolder + '/00-STM32F429_LIBRARIES/usb_cdc_device/usbd_usr.c',)
envRelease.StaticLibrary(trgtfolder + '/UsbCdcDevice', source=libUsbCdcDevice, CFLAGS=CFLAGS, CPPPATH=CPPPATH, variant_dir=trgtfolder)

envRelease.Program(binBaseName + '.elf', source=libUser, LIBS=['Tm', 'UsbCdcDevice', 'Std_Periph_Drivers'], LIBPATH=trgtfolder, CPPPATH = CPPPATH, LINKFLAGS = LINKFLAGS+CFLAGS, CFLAGS=CFLAGS)
envRelease.Command(binBaseName + '.hex', binBaseName + '.elf', 'arm-none-eabi-objcopy -j .text -j .data -O ihex $SOURCE $TARGET')
envRelease.Command(binBaseName + '.bin', binBaseName + '.elf', 'arm-none-eabi-objcopy -O binary $SOURCE $TARGET')
envRelease.Command(None , binBaseName + '.elf', 'arm-none-eabi-size $SOURCE ')