; Mahf Firmware CPU Driver - Inno Setup Script
; Copyright (c) 2024 Mahf Corporation

#define MyAppName "Mahf Firmware CPU Driver"
#define MyAppVersion "3.0.2"
#define MyAppPublisher "Mahf Corporation"
#define MyAppURL "https://www.mahfcorp.com/"
#define MyAppExeName "MahfControlPanel.exe"

[Setup]
AppId={{8F9D7A5B-3C2E-4B1F-9A6D-E4C5B7A8D9F0}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

DefaultDirName={autopf}\Mahf\CPU Driver
DefaultGroupName=Mahf CPU Driver
AllowNoIcons=yes

LicenseFile=LICENSE.txt
OutputDir=Output
OutputBaseFilename=MahfCPUSetup_{#MyAppVersion}

Compression=lzma
SolidCompression=yes
WizardStyle=modern

PrivilegesRequired=admin
MinVersion=10.0.19044

ArchitecturesAllowed=x64 arm64
ArchitecturesInstallIn64BitMode=x64 arm64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; === Driver ===
Source: "Driver\mahf_core.sys"; DestDir: "{sys}\drivers"; Flags: ignoreversion
Source: "Driver\mahf_cpu.inf";  DestDir: "{app}\Driver"; Flags: ignoreversion
Source: "Driver\mahf_cpu.cat";  DestDir: "{app}\Driver"; Flags: ignoreversion

; === App ===
Source: "Bin\MahfControlPanel.exe"; DestDir: "{app}"; Flags: ignoreversion

; === Docs ===
Source: "README.md";  DestDir: "{app}"; Flags: ignoreversion isreadme
Source: "LICENSE.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
; === Driver Service ===
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\MahfCPU"; Flags: uninsdeletekey
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\MahfCPU"; ValueType: string; ValueName: "ImagePath"; ValueData: "\SystemRoot\System32\drivers\mahf_core.sys"
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\MahfCPU"; ValueType: dword; ValueName: "Type"; ValueData: 1
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\MahfCPU"; ValueType: dword; ValueName: "Start"; ValueData: 2
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\MahfCPU"; ValueType: dword; ValueName: "ErrorControl"; ValueData: 1

; === Driver Parameters ===
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\MahfCPU\Parameters"; ValueType: dword; ValueName: "PerformanceMode"; ValueData: 1
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\MahfCPU\Parameters"; ValueType: dword; ValueName: "ThermalThreshold"; ValueData: 85
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\MahfCPU\Parameters"; ValueType: dword; ValueName: "PowerLimit"; ValueData: 65

; === App Info ===
Root: HKLM; Subkey: "SOFTWARE\Mahf\CPU"; Flags: uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Mahf\CPU"; ValueType: string; ValueName: "Version"; ValueData: "{#MyAppVersion}"
Root: HKLM; Subkey: "SOFTWARE\Mahf\CPU"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"

[Run]
; === Install Driver ===
Filename: "{sys}\pnputil.exe"; \
Parameters: "/add-driver ""{app}\Driver\mahf_cpu.inf"" /install"; \
StatusMsg: "Installing Mahf CPU Driver..."; \
Flags: runhidden waituntilterminated

; === Create Service ===
Filename: "{sys}\sc.exe"; \
Parameters: "create MahfCPU binPath= ""{sys}\drivers\mahf_core.sys"" start= auto DisplayName= ""Mahf CPU Driver"""; \
Flags: runhidden waituntilterminated

; === Start Service ===
Filename: "{sys}\sc.exe"; \
Parameters: "start MahfCPU"; \
Flags: runhidden waituntilterminated

; === Launch App ===
Filename: "{app}\{#MyAppExeName}"; \
Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; \
Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{sys}\sc.exe"; Parameters: "stop MahfCPU";   Flags: runhidden waituntilterminated
Filename: "{sys}\sc.exe"; Parameters: "delete MahfCPU"; Flags: runhidden waituntilterminated
Filename: "{sys}\pnputil.exe"; Parameters: "/delete-driver mahf_cpu.inf /uninstall /force"; Flags: runhidden waituntilterminated

[Code]
function InitializeSetup(): Boolean;
var
  V: TWindowsVersion;
begin
  Result := True;
  GetWindowsVersionEx(V);

  if (V.Major < 10) or ((V.Major = 10) and (V.Build < 19044)) then
  begin
    MsgBox(
      'This driver requires Windows 10 21H2 (Build 19044+) or later.'+#13#10+
      'Your system is not supported.',
      mbCriticalError, MB_OK
    );
    Result := False;
  end;
end;
