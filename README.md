# X6100 Stury

This project is created for the study of Xiegu X6100 QRP Full Mode SDR HF Transceiver based on the firmware upgrade images, X6100 should be the first ARM Linux based HF Transceiver in the world, it's pretty interesting. 

So why I'm study with the firmware upgrade images, not from the official GPL release? It's a shame that for now, or maybe forever? Xiegu does not want obey the GPL license and release the correct GPL source code. So....

Actually, for those HAMs that already bought the X6100, I will suggest you keep pushing Xiegu or your reseller about the GPL release, it's your right to do that. Maybe we can create a new "Openwrt" project which all started with the GPL release of WRT54G router from Linksys for entire HAM radio world....

OK, no more talkings, let's get our hands dirty. 

### NOTES: ASSUME YOU ALREADY GOT BASIC KNOWHOWS ABOUT EMBEDDED LINUX, HARDWARE, REVERSE ENGINEERING AND SOME OTHER TECHS THAT REQUIRED WHEN YOU'RE CHECKING THIS REPO, THIS IS NOT A STEP BY STEP TURTORIAL. IF YOU GOT SOMETHING YOU DON'T UNDERSTAND, JUST USING GOOGLE. THANKS.

## Where to start?

It's all starting from the firmware upgrade image, it contains lots of useful information that we need. You can get the firmware upgrade package from Xiegu directly, or from your reseller. 

Some links for reference:

https://radioddity.s3.amazonaws.com/Xiegu_X6100_Firmware_Upgrade_20211207.zip

https://xiegu.eu/downloads/

## How to start?


Inside the firmware upgrade package, there will be a .img file, this is our target, extract everything by using "binwalk".

## What we're interested at?
```
1. /etc/shadow or /etc/passwd, most likely, you can crack root password with those files.
2. /boot/*.dtb, can be decompiled to dts file, which describes hardware
3. scripts under /etc/init.d/, initial scripts
4. Device specific applications, such like UI.
.......
```


## Disclaimer
AS SAID IN THE BEGINNING, THIS REPO IS CREATED FOR THE STUDY OF XIEGU X6100 DEVICE DUE TO XIEGU DOES NOT FOLLOWING THE GPL LICENSE AND RELEASE THE GPL CODE, AND THIS REPO AND SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE DESIGN OR SOFTWARE OR THE USE OR OTHER DEALINGS IN THE DESIGN OR SOFTWARE.
