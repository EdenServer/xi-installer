;NSIS Modern User Interface
;Written by Joost Verburg
;ZLIB License Copyright (c) 2018-2020 Eden Server

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "LogicLib.nsh"
  !include "FileFunc.nsh"
  !include "StrContains.nsh"

  !define MUI_ICON "installer.ico"
  !define MUI_LANGDLL_WINDOWTITLE "Installer"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "background.bmp"
  !define MUI_WELCOMEPAGE_TITLE "Installer"

  !define MUI_LICENSEPAGE_CHECKBOX

  !addplugindir "..\Release"
  !addplugindir "."

;--------------------------------
;General

  ;Name and file
  Name "XI Game"
  OutFile "Installer.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\PlayOnline"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\XIGAME" "InstallPath"

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages
Function DependenciesPage
  
  File /oname=$TEMP\VS2010.exe VS2010.exe
  ExecWait "$TEMP\VS2010.exe /install /passive /norestart"
  File /oname=$TEMP\VS2012.exe VS2012.exe
  ExecWait "$TEMP\VS2012.exe /install /passive /norestart"
  File /oname=$TEMP\VS2013.exe VS2013.exe
  ExecWait "$TEMP\VS2013.exe /install /passive /norestart"
  File /oname=$TEMP\VS2015.exe VS2015.exe
  ExecWait "$TEMP\VS2015.exe /install /passive /norestart"
  File /oname=$TEMP\dotNetFx40_Full_x86_x64.exe dotNetFx40_Full_x86_x64.exe
  ExecWait "$TEMP\dotNetFx40_Full_x86_x64.exe /install /passive /norestart"
  File /oname=$TEMP\dotNet45.exe dotNet45.exe
  ExecWait "$TEMP\dotNet45.exe /install /passive /norestart"
  nsExec::Exec "dism /online /Enable-Feature /FeatureName:DirectPlay /All"

FunctionEnd

; No need to compress twice!
SetCompress off

Function DependenciesLeave
  # Form validation here. Call Abort to go back to the page.
  # Use !insertmacro MUI_INSTALLOPTIONS_READ $Var "InstallOptionsFile.ini" ...
  # to get values.
FunctionEnd


  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "license.txt"
  Page Custom DependenciesPage DependenciesLeave
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  ;!insertmacro MUI_UNPAGE_WELCOME
  ;!insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "XIInstaller" XIInstaller
  AddSize 14000000
  SetOutPath "$INSTDIR"

  ;Add files
  File installer.ico


  DetailPrint "Extracting game files, please wait..."
  ${GetExePath} $R0 ;
  Nsis7z::ExtractWithDetails "$R0\data.pak" "Installing game files %s..."
  

  DetailPrint "Updating registry settings..."
  
  SetRegView 64

  ;Store installation folder
  WriteRegStr HKCU "Software\XIGAME" "InstallPath" "$INSTDIR"

  ;Register with Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\XIGAME" "DisplayName" "Uninstall XI"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\XIGAME" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\XIGAME" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\XIGAME" "InstallLocation" "$\"$INSTDIR$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\XIGAME" "DisplayIcon" "$\"$INSTDIR\installer.ico$\""

  ;Set registry values
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS" "CommonFilesFolder" "$PROGRAMFILES\Common Files\"
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\InstallFolder" "0001" "$INSTDIR\SquareEnix\FINAL FANTASY XI\"
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\InstallFolder" "0002" "$INSTDIR\SquareEnix\TetraMaster"
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\InstallFolder" "1000" "$INSTDIR\SquareEnix\PlayOnlineViewer"

  WriteRegStr HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\Interface" "0001" "130b5023"
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\Interface" "0002" "1304d3ed"
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\Interface" "1000" "1304d1e8"

  WriteRegBin HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\Product" "0001" 9741e0849e6dc5ec1220cd8c1ecd9649be988450ab9a402c58fbfb50fecae9f3bad2df087753f81d1f33e92a8e4a2faa04dff98ee20508a30fb501134eda95f3f029a5795fa83626a451c3008c52772a1ff31c0c7311d737b1f2f53375887d091a55611511ec3561d55f3a2f252171c73d2eeb09041b801bf03e3cf029869d844d0870d6453da92ee5e03acea1c93a8996abe96dddc6149b648ad02e37ab8767c61d252140618ffa22ac270845ff4419f57670816dd860827536055e29b11463260f64617e7b3c5df923688c664d38c15cfd5b967097cc2022a0135fba2df6589d4fe22e4db2e596903eb45c8a8f30780b29b30ec5e0295da24c6e9168a0590ab762f78359aa022b321feedf8d5e05da9eb59d59625389e5a8c63ba02623705b

  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0000" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0001" 0x00000640
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0002" 0x00000384
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0003" 0x00000640
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0004" 0x00000384
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0007" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0011" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0017" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0018" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0019" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0020" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0021" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0022" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0023" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0024" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0028" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0029" 0x0000000c
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0030" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0031" 0x3bc49ba6
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0032" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0033" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0034" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0035" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0036" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0037" 0x00000640
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0038" 0x00000384
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0039" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0040" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0041" 0x00000000
  WriteRegStr   HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0042" "$INSTDIR\SquareEnix\FINAL FANTASY XI"
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "0043" 0x00000000
  WriteRegBin   HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "bFirst" 00
  WriteRegStr   HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "padsin000" "8,9,13,12,10,0,1,3,2,15,-1,-1,14,-33,-33,32,32,-36,-36,35,35,6,7,5,4,11,-1"
  WriteRegStr   HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\FinalFantasyXI" "padmode000" "1,0,1,0,1,1"

  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer" "FirstBootPlayMovie" 0x00000000 
  WriteRegBin   HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer" "SPS000" 66c84962897d8dce4d64151db09a4ca4267c07c18b8df49c8f31a4b35a72f34cda1df301ee999021d69a2a941e91797e9b4d6d5db04a362a03ac41cdf89c6e50ed98531f457b017faa35eb0cd4cb0fea6d3852bfed8fa10351e83d64074178269644b322c6e21ef57a32b167199da82164facc60f1623623b8f8a3f3881a6d26bbd15e4dcf04012c1a91a50f2b942fa344644dac419e9aadb22489b813110830cf7a8b305ba06b8bdb8131bf2ab1f29e392f6bf43e47714d39fd00ed10369c647251aa6bc05fcf3c0210e71178ff0fe3df2548963e927f38c3bd205bed21ac6ed12fea4576c534b4bf3128c1d5fc4315f3580d03b21df18c30b11cf125f9132f980f9e7b1d8579f77a8eaf6d6426fc67e50d265f0e13a8bad5bad1bead511761c43e93b67e6428379c7a0c7ba2084db1458af16efa76a77f037484ba7e540e3e07b4f9f34df3d5b6b273174fa2f87ff2527472824fedd498385e3f48374ba7a317964db33826bd56bb5edf4acb3666d83b1accfdde4d0cb1b6a46733fca102d2d246a209d506d7c6869eeafe2dc9ed6ac9e9d64bf84d4f881db3e7425a061de002ab6043b448e9a2078c32517c6a1c9cefc8974f0d21fbcd3b80e08e0a85e915a6889912828a01cc41a8c0046fb033532b6f158ac05e45e33efdf3437643505a1839a303d7838f244f6a82e218947826d508c513a84e06906bd9677cc9226d19a350bef70802d40c7dccbbfe30f93482839f62f5b96a7ea3672e342e81598180f18c388e5615935ee097d0c880a635ab2068e093d6dfc420f49718d86b297dde1a224044311adbba93224182ef211becca81bdcfec40f80fd1a0fdef79ad744ee5329883af56497f8e6f7ed43d842573582afa93cf16cff1ca1d889a72dcdfae4f9a9956d2dfe1c7aabf514180f4f376fbb9d767da165028788aeceecfc775f440e78b3546c4fc162367c3b1ab027a25af51f97d7d11b71ac0988f712477c492775742b41069823320b3723855e5ce3d5c2dc7ae7fb409f5458c40bebe41eb23c39d99a7a09f037b06d881b1a8b4efdf2adfb96b8b9d4dcc51e3f2519a8244fbc5190ec701f73c85b9bab3e1a60d01bb0dd990f875a378aa375e302c1747f5fa99e36613740c76443af4a5d1956521830d82872d43124471af8e8b41984174404066c0cc62b1df99d6296b01496adc5a90e7241dab32ebc640dd19ff15bfd36675f45cfac7e1f0fae90f5664c5c3b4bcca4f730d24f68736e84bd7c50150571613bce014b29beb8282586931a8ceb76d7b5e2b3c3a965f35f84939162bf414cf053188bc7ae02b4a024b69c5bd3a3fa3d561a29498331841c5314a3466b194625a3f5d67e67265898c51fb6a2e62a87866364be2c3cec1389a528301e97e4ab05be3f55fc7498e559593eefff3785b4dc48217e2d1734e0d490ec0bae10b0212758567e64200e7e2b3c39ef302e666b2f4801546a3636805c9533e114b6a323d56133c88a369bda4ab8c203aff022063c816d94b504c2a393e719547a2488c5a16634abe247d292147eb4e794c6a2ce7f2478cedeb3618ce531be72abd9f63173e15cf65c7d21f44e4880b32ac2a9fb16c9378058a51e36c8bba70fdcfcb3e6b6d852f478b92a1c152a9caba215ecdc247008583e6018f3b5c61c1b10de9fe53fd68078ff2c91a57d795114a0863a81e81d5e2c024c30f99be4ec4b923776c5cbd7bd9ccde38f56b6c0180b0c9be4c1bc2307e612702e576b7990bd35fcc8251fa14e86348b8714a6ca8f1c50ae07337143c52120fd420a66a6f88cadd02e49dea36c716b3f845dc4d3fbd8db3baf966cdf68cc7875c3f881d09222cd8a9c099a91b0cf6274dc9d6d679f484d9a9597c106d172c663ce96ad8ba8efb697f6ff1ed074110869dae9159ec4d5a6f4570944db1c4baf0edb35b4e02ac1c4a81cc76d17dc69931120561550f9947b714a6a372e6daf434c08d5b2db1b2433edda30469585f12fc869c266f0cf30cc9f03bba79c9c5de6a99038158118ca4bfa029e6ee6de7d01058095175adb149fb6b520c9b1502d6bd1a220456d7536bce0cae334ce4afcd698c2dcf7c6c016cf7acf516c8193e1a0a0d75ce1f501ca53c40af5d8f5a9316739a8b577ffa2838fb83d9ac01870ec55d0f929f4adff94239a39645d931ac3733356f80f2a5fae14ff057fbaefaebf4ef1288c9e2d287fbb93c57599bb88490bd335911dd2c19ba4588fc1b4f30abdbf1bcb0305afa9670d8e198e0339a52989d3f6b25e44351754b92f66c379a93a84a85a07245d002764886c7e9f6c0249e2b3b00a4652dfb8d3b7972b6de7c1300fb8d01099d1b4bacf9cb59ddce92222f286a86c02425cb736e03c4aa0e032072853648bb2ad4e528db1be1818c5779cd8971a342f92a5c4bb933fed5635ff61589433932ea36ab61ac8720b9b2ae94f3655412d36386dd13bf55f6f49f057ace71f46de4f0a509bf7969569429134e8d9f6b42ed7bd861ba6d8ccad9f6e7bf8f8a22563edc23a448ab1ddb62338cf878a230c72aa6eb4f625cb40edc644739ebaef343c7b9473e3f1389280fc8122f5ba745d824bab71ea3eda0aaeb5224cfb27b89faa6a806e9159fc7e1f215ed5043

  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "FullScreen" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "Language" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "PlayAudio" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "PlayOpeningMovie" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "ResetSettings" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "SupportLanguage" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "UseGameController" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "WindowH" 0x000001e0
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "WindowW" 0x00000280
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "WindowX" 0x00000082
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings" "WindowY" 0x00000082

  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "AnchorDown" 0x00000034
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "AnchorLeft" 0x00000036
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "AnchorRight" 0x00000032
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "AnchorUp" 0x00000030
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "Cancel" 0x00000002
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "ChrCsrNext" 0x00000007
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "ChrCsrPrev" 0x00000006
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "ID" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "Menu" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "Navi" 0x00000003
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "Ok" 0x00000001
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "PageNext" 0x00000005
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\Settings\Controller" "PagePrev" 0x00000004

  WriteRegBin HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\PlayOnlineViewer\SystemInfo\QCheck" "LastMeasurementTime" ""

  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "B_00OK" 0x00000002
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "B_01CANCEL" 0x00000003
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "B_02PAGEDOWN" 0x00000005
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "B_03PAGEUP" 0x00000006
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "B_04CHAT" 0x00000009
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "B_05PLAYONLINE" 0x0000000a
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "B_06FRIENDLIST" 0x00000004
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "B_07MENU" 0x00000001
  WriteRegBin HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "JOYPADGUID" ""
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "JOYPADGUIDENABLE" 0x00000001
  WriteRegStr HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "LOADDIR" "$INSTDIR\PlayOnline\SquareEnix/TetraMaster/"
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "PAD" 0x00000000
  WriteRegDWORD HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS\SquareEnix\TetraMaster" "SOUND" 0x00000001

  DetailPrint "Registering libraries..."
  RegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXi.dll"
  RegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiMain.dll"
  RegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiResource.dll"
  RegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiVersions.dll"

  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\polhook.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\unicows.dll"
  
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\patchfiles\PlayOnlineViewer\viewer\com\app.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\patchfiles\PlayOnlineViewer\viewer\com\polcore.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\polcfg\sysinfo.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\util\unicows.dll"

  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\MSVCR71.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\polmvf.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\polmvfINT.dll"

  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\com\app.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\com\polcore.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\contents\PolContents.dll"
  RegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\contents\polcontentsINT.dll"

  RegDLL "$INSTDIR\SquareEnix\TetraMaster\TM.dll"

  ;Create uninstaller
  DetailPrint "Creating Uninstaller..."
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;create desktop shortcut
  DetailPrint "Building Shortcuts..."
  SetOutPath "$INSTDIR\Ashita\"
  CreateShortCut "$DESKTOP\Play XI.lnk" "$INSTDIR\Ashita\Ashita.exe" "" "$INSTDIR\installer.ico"

  ;create start menu shortcut
  createDirectory "$SMPROGRAMS\XIGAME"
  createShortCut "$SMPROGRAMS\XIGAME\Play XI.lnk" "$INSTDIR\Ashita\Ashita.exe" "" "$INSTDIR\installer.ico"
  createShortCut "$SMPROGRAMS\XIGAME\Uninstall XI.lnk" "$INSTDIR\Uninstall.exe"

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  SetOutPath "$INSTDIR"

  UnRegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXi.dll"
  UnRegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiMain.dll"
  UnRegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiResource.dll"
  UnRegDLL "$INSTDIR\SquareEnix\FINAL FANTASY XI\FFXiVersions.dll"

  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\polhook.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\unicows.dll"
  
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\patchfiles\PlayOnlineViewer\viewer\com\app.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\patchfiles\PlayOnlineViewer\viewer\com\polcore.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\polcfg\sysinfo.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\util\unicows.dll"

  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\MSVCR71.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\polmvf.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\ax\polmvfINT.dll"

  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\com\app.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\com\polcore.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\contents\PolContents.dll"
  UnRegDLL "$INSTDIR\SquareEnix\PlayOnlineViewer\viewer\contents\polcontentsINT.dll"

  UnRegDLL "$INSTDIR\SquareEnix\TetraMaster\TM.dll"


  RMDir /r "$INSTDIR\"
  Delete "$DESKTOP\Play XI.lnk"
  RMDir /r "$SMPROGRAMS\XIGAME"

  DeleteRegKey /ifempty HKCU "Software\XIINSTALLER"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\XIINSTALLER"
  DeleteRegKey HKLM "SOFTWARE\WOW6432Node\PlayOnlineUS"

SectionEnd