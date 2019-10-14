# ProAutoVip
Dizayn VIP Embedded System Software v1.0

1. Physical Connection

1- DragonBoard 410C slot no 5 (UART0 TX), connected to the Level Converter LV1 slot.
2- DragonBoard 410C slot no 7 (UART0 RX), connected to the Level Converter LV2 slot. 
3- DragonBoard 410C slot no 35 (1.8V PWR), connected to the Level Converter LV slot.
4- DragonBoard 410C slot no 39 (GND), connected to the Level Converter GND slot.
5- Level Converter HV1 slot, connected to the Arduino UNO slot no 0 (RX).
6- Level Converter HV2 slot, connected to the Arduino UNO slot no 1 (TX).
7- Level Converter HV slot, connected to the Arduino UNO 5V power slot.
8- Level Converter GND slot, connected to the Arduino UNO GND slot.


2. Computer Connection
For the HEX handshake and monitoring, Arduino IDE software will be used;
https://www.arduino.cc/download_handler.php
1- Select the model of the Arduino (Arduino/Genuino Uno).
2- Select which port is using by the Arduino to connect the PC.
3- Open the Serial Port Screen (Ctrl+Shift+M).
4- Select the baud rate that will be used (115200).
5- Select the ‘New Line’ mode for the signals.
6- Signals can be sent by pressing the ‘Send’ button.
7- Enter the signal you are going to send.
8- The monitor that signals can be monitored.
Signal codes are in the file ‘proto.ini’ that is in the working directory of the software.
Hardware wake-up signal: Ax/42/1
Hardware sleep signal: Ax/42/0

3. Presetting

The feature diversity of the software inside the device is directly proportional to the feature diversity of the vehicle. It means how much diversity a vehicle has is how much diversity is accessible from the software. On/off state of these diversities is setting by the file ‘settings.ini’ that is in the working directory of the software.

An example part of the file Settings.ini,
These variables here, sets the on/off states of the diversities of the vehicle. Variables which got the value ‘true’ will be accessible by the user, but which got the value ‘false’ will be non-accessible.

At the same time, that ‘demo_mode’ variable that we can see at the line 29, makes the software work without the “wake-up” signal that comes from the vehicle. If ‘demo_mode’ variable, gets the value ‘true’, that means the software will not work without the vehicle is working.

4. Preparation of the Device

1- Boot the Live SD Card image to an SD Card.
2- Set the Board to the SD Boot mode.
3- Connect to the Board using SSH.
4- Copy the internal image to a removable disk.
5- Install the package that gives NTFS support ‘ntfs-3g’ to the Live SD Card image.
6- Create a directory and connect the removable disk to that directory using the command ‘mount’.
7- Restore the image that can be found inside the created directory to the internal storage of the device by using command ‘dd’.

Name of the Live SD Card image: 'external.img'

Linux Local Network Scan command (need to install nmap first)
nmap -sP 192.168.0.*

Linux Connection via SSH command (username and password: linaro)
ssh -l linaro 192.168.0.xx

Debian Unix and Gnome NTFS support-giving package: 'ntfs-3g'
sudo apt-get update
sudo apt-get install ntfs-3g

Internal image that is inside the USB: 'internal.img'

Linux directory creation command (directory name: usb)
mkdir usb

Linux scanning the connected disks command
sudo fdisk -l

Linux mounting a disk to a directory command
sudo mount /dev/sda1 usb

Linux enter inside a directory command
cd usb

Linux restoring with ‘dd’ command (disk: /dev/mmcblk0)
sudo dd if=internal.img of=/dev/mmcblk0 status=progress



5. Command Order

Order of the commands to prepare the board:
[Host-PC]nmap -sP 192.168.0.*
[Host-PC]ssh -l linaro 192.168.0.52
[Board-SSH]sudo apt-get update
[Board-SSH]sudo apt-get install ntfs-3g
[Board-SSH]mkdir usb
[Board-SSH]sudo fdisk -l
[Board-SSH]mount /dev/sda1 usb
[Board-SSH]cd usb
[Board-SSH]sudo dd if=internal.img of=/dev/mmcblk0 status=progress

If there is [Host-PC] before the command, the command should be executed on the host PC’s terminal.
If there is [Board-SSH] before the command, the command should be executed on the Board’s terminal using the SSH connection.
In the following commands, the IP address of the board is assumed as ‘192.168.0.52’.
In the following commands, the path of the removable disk in Unix system is assumed as ‘/dev/sda1’.
To use the commands they starting with ‘sudo apt-get’ in the lines 3 and 4, the board should be connected to the internet. 

6. Updating the Software Manually

If there is a ready ‘autovip_ls’ compiled, and wanted to be replaced with the original one, firstly copying ‘autovip_ls’ to a removable disk, secondly executing the following commands is needed:
[Board-SSH]cd
[Board-SSH]mkdir usb
[Board-SSH]sudo mount /dev/sda1
[Board-SSH]sudo service dizaynvip stop
[Board-SSH]sudo mv ./autovip/autovip_ls ./autovip/autovip_ls.bak
[Board-SSH]sudo cp ./usb/autovip_ls ./autovip/autovip_ls
[Board-SSH]sudo chmod +x ./autovip_ls
[Board-SSH]sudo umount /dev/sda1
[Board-SSH]sudo service dizaynvip start

All the following commands should be executed on the board’s terminal using the SSH connection.
In the following commands, the path of the removable disk in Unix system is assumed as ‘/dev/sda1’.
In the board, application is working by a service called ‘dizaynvip’, depends on the executable called ‘autovip_ls’ on the directory ‘/home/linaro/autovip’.
When a change will be made on the software or the software files, firstly the software should be stopped. We use the command on line 4 to do that.

7. Helping Commands

Linux Local Network Scan command (need to install nmap first)
nmap -sP 192.168.0.*

Linux Connection via SSH command (username and password: linaro)
ssh -l linaro 192.168.0.xx

Debian Unix and Gnome NTFS support-giving package: 'ntfs-3g'
sudo apt-get update
sudo apt-get install ntfs-3g

Linux directory creation command (directory name: usb)
mkdir usb

Linux scanning the connected disks command
sudo fdisk -l

Linux mounting a disk to a directory command
sudo mount /dev/sda1 usb

Linux enter inside a directory command
cd usb

Linux restoring with ‘dd’ command (disk: /dev/mmcblk0)
sudo dd if=internal.img of=/dev/mmcblk0 status=progress

Linux giving full permission to file (file: /home/linaro/file)
	sudo chmod +x /home/linaro/file

Linux receiving Super User permission
	sudo su

Linux printing status of all services
	sudo service –-status-all

Linux stopping/starting/restarting a service (service: dizaynvip)
	sudo service dizaynvip stop
	sudo service dizaynvip start
	sudo service dizaynvip restart
