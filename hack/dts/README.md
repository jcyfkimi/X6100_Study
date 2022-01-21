# Device Tree(DTS)

## What is device tree(dts)?

Basically, it's a data structure describing the hardware components, for more details, please refer to:

https://en.wikipedia.org/wiki/Devicetree


## What can we do with the device tree?

```
1. Knowing the details about the SoC
2. Knowing how many external devices are connected
3. Knowing the exact detail pin out for external devices
.....
```

## Where can we get the device tree?

We can get device tree blob(dtb) file from <ROOTFS>/boot/ as well as <ROOTFS>/usr/share/emmc_source/, dtb file is a binary file, however, we can not directly get information we want from this file, we need to decompile it by using "dtc" command. 
```
dtc -I dtb -O dts xxxx.dtb xxxx.dts
```
With the dts file, we can starting analysising.


## What can we found?

    1. The SoC, Allwinner R16, is a quad core ARM Cortex-A7 processor. 
    2. The display panel is from Jinglitai, model jlt4013a, which is a full IPS 3.97 inches 480*800 RGB display panel with ST7701S driver IC. It connected to the RGB interface as well as SPI interface for control. Detail link for reference:
            https://taizhou.1688.com/shop/m/offer/634669005434.html
            https://b2b.baidu.com/land?id=76b620be209740d1c77a356463e57c9f10
    3. A Keypad matrix connected directly to the GPIOs of the SoC
    4. 3 Rotary encoder also connected directly to the SoC via GPIO
    5. 1 RTC, NXP's PCF8563 connected to the i2c0 bus. 
    6. No external codec chip or ADC/DAC chip found, so suppose it's using the internal audio codec for spectrum and waterfull display. Most likely, via I/Q signal.

## Pin outs
### 1. Display panel
|Panel|SoC|Description|
|:----:|:----:|:----:|
|B0 - B5| PD2 - PD7| Blue Data Pin 0 -5|
|G0 - G5| PD10 - PD15| Green Data Pin 0 - 5|
|R0 - R5| PD18 - PD23| Red Data Pin 0 - 5|
|DCLK| PD24 | Dot clock for RGB interface|
|DE| PD25 | Data enable signal for RGB interface|
|HSYNC| PD26 | Horizontal(Line) sync signal for RGB interface|
|VSYNC| PD27 | Vertical(Frame) sync signal for RGB interface|
|/RESET| TBD | Reset signal|
|RS| TBD | Command/Data select signal|
|/CS| TBD | Chip Select signal|
|SCL| TBD | Serial interface clock|
|SDA| TBD | Serial interface data|

From the pin outs we can see it's only using 6 pins for R/G/B data. And also it seems did not using the Hardware SPI interface, just using GPIO. 

### 2. Rotory encoder
|Rotry|SoC|
|:----:|:----:|
|Rotry 1| PB2, PB3|
|Rotry 2| PB4, PB6|
|Rotry 3| PB5, PB7|

### 3. RTC
|RTC|I2C|SoC|
|:----:|:----:|:----:|
|PCF8563| I2C0 | PH2（SCK）, PH3（SDA） |

### 4. Keypad
## TBD

### 5. Audio Codec
## TBD


