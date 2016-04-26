Example minimal CDC project with simple at parsing.


The base for this code is from:
http://stm32f4-discovery.com

# Problem description
Creating a CDC USB device on STM32 MCUs results in creating actually in a USB device with
- `bInterfaceSubClass` = 0x02
- `bInterfaceProtocol` = 0x01

If the USB-CDC device returnes following configuration descriptor:
![Wireshark frame capture](wireshark_cdc.png)

But my Linux-PC no detects a V250 compatible modem on `/dev/ACM0` and tries to get information from it. The V250 modem interface defintition can be downloaded from:

https://www.itu.int/rec/T-REC-V.250/en

In this standard there are mandatory answers to certain AT command defined. As my simple STM32 code does not react to these answers it always takes about 10s till I can open an terminal on this serial device.

The example code for CDC in STMs example folder is a simle Hack which works - put does not fullfill the claimed standard.

There are now 2 possible solutions:

1. Implement a minimal AT command parser and return proper V250 compatible answers.
2. Findout how FTDI is doing it> But they use a propriatary protocol for their USB-RS232 devices.

This code may help in the implementation of a solution.
