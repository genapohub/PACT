#!/usr/bin/env bash
#
# PACT 一键初始化脚本
#
# 前置：PACT 已克隆到业务项目根目录的 .pact/ 下
#   git clone git@github.com:genapohub/PACT.git .pact
#
# 用法（在业务项目根目录执行）：
#   bash .pact/scripts/init.sh [项目名称]
#
# 做三件事：建 7 个目录 → 复制模板到对应位置 → 屏蔽 .pact/
#
set -euo pipefail

PACT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_NAME="${1:-$(basename "$PWD")}"

copy_if_absent() {
  local src="$1" dst="$2"
  if [ -e "$dst" ]; then
    echo "  跳过（已存在）: $dst"
  else
    cp "$src" "$dst"
    echo "  生成: $dst"
  fi
}

echo "PACT 初始化：$PROJECT_NAME"
echo "PACT 规范版本：$(git -C "$PACT_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)"
echo

echo "[1/3] 创建项目目录"
for d in 01-竞品分析 02-产品文档 03-品牌设计 04-UIUX设计 05-技术文档 06-项目编码 07-其他文档; do
  if [ -d "$d" ]; then
    echo "  跳过（已存在）: $d/"
  else
    mkdir "$d"
    echo "  创建: $d/"
  fi
done
echo

echo "[2/3] 复制模板（不覆盖已有文件）"
copy_if_absent "$PACT_DIR/templates/PACT项目说明模板.md" "PACT.md"
copy_if_absent "$PACT_DIR/templates/DESIGN.md模板.md" "DESIGN.md"
copy_if_absent "$PACT_DIR/templates/验收清单模板.md" "02-产品文档/验收清单_v1.0.md"
copy_if_absent "$PACT_DIR/templates/页面设计契约模板.md" "04-UIUX设计/页面设计契约_v1.0.md"
copy_if_absent "$PACT_DIR/templates/API接口契约模板.md" "05-技术文档/API接口契约_v1.0.md"
copy_if_absent "$PACT_DIR/templates/联调记录模板.md" "05-技术文档/联调记录.md"
echo

echo "[3/3] 屏蔽 .pact/（规范仓库不入业务仓库）"
if [ -f .gitignore ] && grep -qx ".pact/" .gitignore; then
  echo "  跳过（.gitignore 已含 .pact/）"
else
  printf "\n# PACT 规范仓库（本地引用，不入业务仓库）\n.pact/\n" >> .gitignore
  echo "  已写入 .gitignore"
fi
echo

cat <<'EOF'
初始化完成。下一步：

1. 打开 coding agent，把下面整段复制发送（替换尖括号内容）：
----------------------------------------------------------------
请先读取项目根目录下的 PACT.md。
本项目采用 PACT：产品 AI 契约化交付流程。
项目名称：<项目名>。项目背景：<一句话说明做什么、给谁用、核心目标>。
请先确认当前任务属于哪个阶段，再读取对应目录文件。
在没有更新需求契约、UIUX 契约或 API 契约前，不要直接修改代码。
----------------------------------------------------------------
   也可以使用 .pact/prompts/项目初始化提示词.md 里的完整冷启动提示词。

2. PACT 规范有更新时：git -C .pact pull
EOF
