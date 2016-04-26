Example minimal CDC project with simple at parsing.


The base for this code is from:
http://stm32f4-discovery.com

# Problem descrition
Creating a CDC USB device on STM32 MCUs results in creating actually in a USB device with
- `bInterfaceSubClass` = 0x02
- `bInterfaceProtocol` = 0x01

If the USB-CDC device returnes following configuration descriptor:
![Wireshark frame capture](wireshark_cdc.png)


