;  Hype - The Time Quest Alternate Installer V0.0.5
;  Created 2014 Suicide Machine.
;  Based on a code of Triangle717's Lego Racer Alternative Installer.
;  <http://triangle717.wordpress.com/>
;  Contains source code from Grim Fandango Setup
;  Copyright (c) 2007-2008 Bgbennyboy
;  <http://quick.mixnmojo.com/>

; If any version below the specified version is used for compiling, 
; this error will be shown.
#if VER < EncodeVer(5,5,2)
  #error You must use Inno Setup 5.5.2 or newer to compile this script
#endif

#define MyAppInstallerName "Apocalyptica - Alternative Installer"
#define MyAppInstallerVersion "1.0.0"
#define MyAppName "Apocalyptica"
#define MyAppNameNoR "Apocalyptica"
#define MyAppVersion "1.0.0.0"
#define MyAppPublisher "Konami"
#define MyAppExeName "Apocalyptica.exe"

[Setup]
AppID={#MyAppInstallerName}{#MyAppInstallerVersion}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
VersionInfoVersion={#MyAppInstallerVersion}
AppPublisher={#MyAppPublisher}
AppCopyright=© 2003 {#MyAppPublisher}
LicenseFile=license.txt
; Start menu/screen and Desktop shortcuts
DefaultDirName={sd}\Games\{#MyAppNameNoR}
DefaultGroupName=Konami\{#MyAppNameNoR}
AllowNoIcons=yes
; Installer Graphics
SetupIconFile=info.ico
WizardImageFile=Sidebar.bmp
WizardSmallImageFile=Small-Image.bmp
WizardImageStretch=true
; Location of the compiled Exe
OutputDir=bin
OutputBaseFilename={#MyAppNameNoR} Alternate Installer {#MyAppInstallerVersion}
; Uninstallation stuff
UninstallFilesDir={app}
UninstallDisplayIcon={app}\info.ico
CreateUninstallRegKey=yes
UninstallDisplayName={#MyAppName}
; This is required so Inno can correctly report the installation size.
UninstallDisplaySize=1190511812
; Compression
Compression=lzma2/ultra64
SolidCompression=True
InternalCompressLevel=ultra
LZMAUseSeparateProcess=yes
; From top to bottom:
; Explicitly set Admin rights, no other languages, do not restart upon finish.
PrivilegesRequired=admin
ShowLanguageDialog=no
ShowUndisplayableLanguages=yes
RestartIfNeededByRun=no

[Languages]
Name: "English"; MessagesFile: "compiler:Default.isl"

[Messages]
BeveledLabel={#MyAppInstallerName} {#MyAppInstallerVersion}
; WelcomeLabel2=This will install [name] on your computer.%n%nIt is recommended that you close all other applications before continuing.
; DiskSpaceMBLabel is overridden because it reports an incorrect installation size.
; English.DiskSpaceMBLabel=At least 370 MB of free disk space is required.

[Types]
Name: "Full"; Description: "Full Installation"; Flags: iscustom  

[Components]
Name: "base"; Description: "Game assets (required)"; Types: Full; Flags: fixed; ExtraDiskSpaceRequired: 1190511812 
Name: "language"; Description: "Language files"; Types: Full;  Flags: fixed
Name: "language\english"; Description: "English"; Types: Full; Flags: exclusive
Name: "language\french"; Description: "French"; Flags: exclusive
Name: "language\german"; Description: "German"; Flags: exclusive
Name: "language\italian"; Description: "Italian"; Flags: exclusive
Name: "language\spanish"; Description: "Spanish"; Flags: exclusive

[Files]
Source: "info.ico"; DestDir: "{app}"; Flags: ignoreversion
; Root folder
Source: "{code:GetSourceDrive}Apocalyptica.exe"; DestDir: "{app}"; Flags: external ignoreversion
Source: "{code:GetSourceDrive}Readme.txt"; DestDir: "{app}"; Flags: external ignoreversion
Source: "{code:GetSourceDrive}glvideo.dll"; DestDir: "{app}"; Flags: external ignoreversion

; Game folders
Source: "{code:GetSourceDrive}Data\*"; DestDir: "{app}\data\"; Flags: external ignoreversion recursesubdirs
Source: "{code:GetSourceDrive}Data\*"; DestDir: "{app}\data\"; Flags: external ignoreversion recursesubdirs; BeforeInstall: RequestCD2

; Languages
Source: "{code:GetSourceDrive}Language\English\*"; DestDir: "{app}"; Flags: external ignoreversion recursesubdirs; Components: language\english
Source: "{code:GetSourceDrive}Language\French\*"; DestDir: "{app}"; Flags: external ignoreversion recursesubdirs; Components: language\french
Source: "{code:GetSourceDrive}Language\German\*"; DestDir: "{app}"; Flags: external ignoreversion recursesubdirs; Components: language\german
Source: "{code:GetSourceDrive}Language\Italian\*"; DestDir: "{app}"; Flags: external ignoreversion recursesubdirs; Components: language\italian
Source: "{code:GetSourceDrive}Language\Spanish\*"; DestDir: "{app}"; Flags: external ignoreversion recursesubdirs; Components: language\spanish

[Icons]
; First and last icons are created only if user choose not to use the videos, 
; else the normal ones are created.
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}";
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; IconFilename: "{app}\info.ico";
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Tasks]
; Create a desktop icon, run with administrator rights
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}";

[UninstallDelete]
Type: files; Name: "{app}\{#MyAppExeName}"

[Registry]
Root: "HKLM32"; Subkey: "Software\ExtremeFX\Apocalyptica"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Flags: uninsdeletevalue

[Code]
// Pascal script from Bgbennyboy to pull files off a CD, greatly trimmed up 
// and modified to support ANSI and Unicode Inno Setup by Triangle717.
var
	SourceDrive: string;

#include "FindDisc.iss"

function GetSourceDrive(Param: String): String;
begin
	Result:=SourceDrive;
end;

procedure InitializeWizard();
begin
	SourceDrive:=GetSourceCdDrive();
end;

procedure RequestCD2();
begin
  MsgBox('Please insert CD2 to a drive ' + GetSourceCdDrive() + '.'#13#10'Inserting wrong disc will result in an error!', mbInformation, MB_OK); //Cause I can't be bothered to write something more complex
end;