::取得管理员权限
@echo off
cd /d "%~dp0"
cacls.exe "%SystemDrive%\System Volume Information" >nul 2>nul
if %errorlevel%==0 goto Admin
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
echo Set RequestUAC = CreateObject^("Shell.Application"^)>"%temp%\getadmin.vbs"
echo RequestUAC.ShellExecute "%~s0","","","runas",1 >>"%temp%\getadmin.vbs"
::让Wscript执行WScript.Quit来结束进程，不然进程里会一直有脚本解释器在运行;
echo WScript.Quit >>"%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" /f
if exist "%temp%\getadmin.vbs" del /f /q "%temp%\getadmin.vbs"
exit

:Admin

::添加本地变量
call :setLocalEnv


set softwaveName="Adobe Substance 3D Painter.exe"
echo 接下来将会结束正在工作的%softwaveName%进程,请注意保存文件后,继续执行下一步
PAUSE
echo 确定清楚啦!
PAUSE
echo 我们接下来即将执行!
PAUSE

echo 正在结束进程
taskkill /f /im %softwaveName% 2>nul
call :waitTime

::获取当前路径
cd %~dp0
set currentDir=%~dp0
echo 当前执行路径为 %currentDir%
::获取目标目录
call :getTargetDir

::删除指定的文件
call :delFiles

::将我们自己的模板文件复制进指定的目录
call :doCopy

PAUSE
EXIT

:getTargetDir
::获取我的文档路径
@for /f "tokens=2,*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do (
set user_doc=%%j
)
set targetDir=%user_doc%\Adobe\Adobe Substance 3D Painter\assets
echo 目标目录为 %targetDir%
goto :blank

:doCopy
::copy
copy "%currentDir%\templates\%shaderName%" "%dirTemplate%\%shaderName%"
copy "%currentDir%\export-presets\%exportName%" "%dirExportPresets%\%exportName%"
echo 文件复制结束
goto :blank

:delFiles
::执行文件检查
set dirTemplate=%targetDir%\templates
set dirExportPresets=%targetDir%\export-presets
set "shaderName=mihayo_look.spt"
set "exportName=Mihayo Look.spexp"
call :checkDir

if exist "%dirTemplate%\%shaderName%" (
::del
echo "%dirTemplate%" 存在文件 "%shaderName%"
del /s /q /f "%dirTemplate%\%shaderName%"
) else (
echo "%dirTemplate%"下不存在目标文件
)
if exist "%dirExportPresets%\%exportName%" (
::del
echo "%dirExportPresets%" 存在文件 "%exportName%"
del /s /q /f "%dirExportPresets%\%exportName%"
) else (
echo "%dirExportPresets%"下不存在目标文件
)
echo 文件检查结束
goto :blank

:checkDir
if not exist "%dirTemplate%" MKDIR "%dirTemplate%"
if not exist "%dirExportPresets%" MKDIR "%dirExportPresets%"
goto :blank

:setLocalEnv
::设置本地变量,避免无法读取到系统路径
set path=%SystemRoot%;%path%
set path=%SystemRoot%\system32;%path%
goto :blank

:waitTime
timeout /nobreak /t 3 >nul
goto :blank

:blank


