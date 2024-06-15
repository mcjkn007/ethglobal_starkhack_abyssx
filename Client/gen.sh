#!/bin/bash
# 设置环境变量

LUBAN_DLL=./Tools/Luban/Luban.dll
CONF_ROOT=../Resource/DataTables
PROJECT_DIR=.

# 显示变量值
echo "LUBAN_DLL: $LUBAN_DLL"

cd .

# 执行 dotnet 命令
dotnet $LUBAN_DLL \
    -t client \
    -c cs-bin \
    -d bin \
    --conf $CONF_ROOT/luban.conf \
    -x outputCodeDir=Assets/GenerateDatas/Code \
    -x outputDataDir=Assets/GenerateDatas/Bytes \
    # -x pathValidator.rootDir=$WORKSPACE/Projects/Csharp_Unity_bin \
    # -x l10n.provider=default \
    # -x l10n.textFile.path=@$WORKSPACE/DataTables/Datas/l10n/texts.json \
    # -x l10n.textFile.keyFieldName=key

# 暂停脚本以查看输出（在 Bash 中等效于按任意键继续）
read -p "Press any key to continue..."
