::ȡ�ù���ԱȨ��
@echo off
cd /d "%~dp0"
cacls.exe "%SystemDrive%\System Volume Information" >nul 2>nul
if %errorlevel%==0 goto Admin
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
echo Set RequestUAC = CreateObject^("Shell.Application"^)>"%temp%\getadmin.vbs"
echo RequestUAC.ShellExecute "%~s0","","","runas",1 >>"%temp%\getadmin.vbs"
::��Wscriptִ��WScript.Quit���������̣���Ȼ�������һֱ�нű�������������;
echo WScript.Quit >>"%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" /f
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
exit

:Admin

::��ӱ��ر���
call :setLocalEnv


set softwaveName="Adobe Substance 3D Painter.exe"
echo ����������������ڹ�����%softwaveName%����,��ע�Ᵽ���ļ���,����ִ����һ��
PAUSE
echo ȷ�������!
PAUSE
echo ���ǽ���������ִ��!
PAUSE

echo ���ڽ�������
taskkill /f /im %softwaveName% 2>nul
call :waitTime

::��ȡ��ǰ·��
cd %~dp0
set currentDir=%~dp0
echo ��ǰִ��·��Ϊ %currentDir%
::��ȡĿ��Ŀ¼
call :getTargetDir

::ɾ��ָ�����ļ�
call :delFiles

::�������Լ���ģ���ļ����ƽ�ָ����Ŀ¼
call :doCopy

PAUSE
EXIT

:getTargetDir
::��ȡ�ҵ��ĵ�·��
@for /f "tokens=2,*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do (
set user_doc=%%j
)
set targetDir=%user_doc%\Adobe\Adobe Substance 3D Painter\assets
echo Ŀ��Ŀ¼Ϊ %targetDir%
goto :blank

:doCopy
::copy
copy "%currentDir%\templates\%shaderName%" "%dirTemplate%\%shaderName%"
copy "%currentDir%\export-presets\%exportName%" "%dirExportPresets%\%exportName%"
echo �ļ����ƽ���
goto :blank

:delFiles
::ִ���ļ����
set dirTemplate=%targetDir%\templates
set dirExportPresets=%targetDir%\export-presets
set "shaderName=mihayo_look.spt"
set "exportName=Mihayo Look.spexp"
call :checkDir

if exist "%dirTemplate%\%shaderName%" (
::del
echo "%dirTemplate%" �����ļ� "%shaderName%"
del /s /q /f "%dirTemplate%\%shaderName%"
) else (
echo "%dirTemplate%"�²�����Ŀ���ļ�
)
if exist "%dirExportPresets%\%exportName%" (
::del
echo "%dirExportPresets%" �����ļ� "%exportName%"
del /s /q /f "%dirExportPresets%\%exportName%"
) else (
echo "%dirExportPresets%"�²�����Ŀ���ļ�
)
echo �ļ�������
goto :blank

:checkDir
if not exist "%dirTemplate%" MKDIR "%dirTemplate%"
if not exist "%dirExportPresets%" MKDIR "%dirExportPresets%"
goto :blank

:setLocalEnv
::���ñ��ر���,�����޷���ȡ��ϵͳ·��
set path=%SystemRoot%;%path%
set path=%SystemRoot%\system32;%path%
goto :blank

:waitTime
timeout /nobreak /t 3 >nul
goto :blank

:blank


