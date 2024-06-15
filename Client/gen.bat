@echo off
rem 设置环境变量

set LUBAN_DLL=.\Tools\Luban\Luban.dll
set CONF_ROOT=.\DataTables
set PROJECT_DIR=.

rem 显示变量值
echo LUBAN_DLL: %LUBAN_DLL%

cd .

rem 执行 dotnet 命令
dotnet %LUBAN_DLL% ^
    -t client ^
    -c cs-bin ^
    -d bin ^
    --conf %CONF_ROOT%\luban.conf ^
    -x outputCodeDir=Assets\GenerateDatas\Code ^
    -x outputDataDir=Assets\GenerateDatas\Bytes
rem -x pathValidator.rootDir=%WORKSPACE%\Projects\Csharp_Unity_bin ^
rem -x l10n.provider=default ^
rem -x l10n.textFile.path=@%WORKSPACE%\DataTables\Datas\l10n\texts.json ^
rem -x l10n.textFile.keyFieldName=key

rem 暂停脚本以查看输出（在 Windows 中等效于按任意键继续）
pause