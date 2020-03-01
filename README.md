## **XI Installer by Scott Lassen & John McClelland**

### Development Setup
1. Download and include the full (not web) Visual Studio 2010, 2012, 2013, 2015 and 2017 runtime installers. Rename them VSxxxx.exe as appropriate (Ex. VS2010.exe for the Visual C++ Redistributable for Visual Studio 2010 x86). Links are included in the next section.
2. Download Microsoft .NET Framework 4 and name `dotNetFx40_Full_x86_x64.exe`.
3. Download Microsoft .NET Framework 4.5. and name `dotNet45.exe`.
4. Download and install [NSIS](https://nsis.sourceforge.io/Download).
5. Download the [NSIS 7z plugin](https://nsis.sourceforge.io/Nsis7z_plug-in#Download).
5. Drop the downloaded `/Plugins/x86-ansi/nsis7z.dll` into the `/Program Files (x86)/NSIS/Plugins/x86-ansi` directory.

### Development Depencency Resource Links
| Resource  | Download |
| :-------- | :------- |
| Visual C++ Redistributable for Visual Studio 2010 x86 | https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe |
| Visual C++ Redistributable for Visual Studio 2012 x86 | https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe |
| Visual C++ Redistributable for Visual Studio 2013 x86 | http://download.microsoft.com/download/0/5/6/056DCDA9-D667-4E27-8001-8A0C6971D6B1/vcredist_x86.exe |
| Visual C++ Redistributable for Visual Studio 2015 x86 | https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe |
| Visual C++ Redistributable for Visual Studio 2017 x86 | https://download.microsoft.com/download/1/F/E/1FEBBDB2-ADED-4E14-9063-39FB17E88444/vc_redist.x86.exe |
| Microsoft .NET Framework 4 | https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe |
| Microsoft .NET Framework 4.5.2 | https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe |

### Development
* Update registry entries. You will need to collect registry entries which may be outdated in the future or have been changed if you have an old install of FFXI on an archived hard drive. Registry entries can be updated in `Script.nsi`. Search for `;Register with Windows` and update that section with the appropriate values from your retail install.
* Add a background. You'll need to add a background image for the installer with the .bmp format. This should be named `background.bmp`. Place this in the root folder of the project. (The same folder you find `Script.nsi`).
* Add an icon. You'll need to add an icon for the installer with the .ico format. This should be named `installer.ico`. Place this in the root folder of the project. (The same folder you find `Script.nsi`).
* Add a license. You'll need to add a text file for the installer with the .txt format. You can include anything you want to display to the user that they must accept before continuing through the setup process. This could be anything from disclaimers to rules. This should be named `license.txt`. Place this in the root folder of the project. (The same folder you find `Script.nsi`).
* Include data to be bundled with the installer. This will be the entire content of what is moved to the install directory the user chooses. It should include any data to play the game, and optionally, bootloaders or programs to use with the game. This should be compressed with a program like 7z into a archive named `data.pak`. Place this in the root folder of the project. (The same folder you find `Script.nsi`).
* Right click `Script.nsi` and then click "Compile NSIS Script" and then click "Test Installer" to see if it works.

### How to install
1. Ensure you have both the `installer.exe` and `data.pak` files.
2. Double click the installer.exe file and follow on screen instructions. Do not skip or cancel the automatic installation of dependencies.
3. Finally, reboot your PC and you should be good to go!

### Disclaimer
We are not affiliated, associated, authorized, endorsed by, or in any way officially connected with Square Enix, Final Fantasy, FFXI, or any of its subsidiaries. All FFXI content and images copyright 2002-2020 SQUARE ENIX CO., LTD. FINAL FANTASY is a registered trademark of Square Enix Co., Ltd.

### License

Copyright (c) 2018-2020 Eden Server

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software 
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
