#!/bin/bash

echo "Инициализация..."
echo ""
echo ""

echo " ██████╗ ██████╗██████╗ ███╗   ███╗"
echo "██╔════╝██╔════╝██╔══██╗████╗ ████║"
echo "██║     ██║     ██████╔╝██╔████╔██║"
echo "╚██████╗╚██████╗██║     ██║ ╚═╝ ██║"
echo " ╚═════╝ ╚═════╝╚═╝     ╚═╝     ╚═╝"

echo "┌─────────────────────────────────┐"
echo "│ Claude Code Project Management  │"
echo "│ by https://x.com/aroussi        │"
echo "└─────────────────────────────────┘"
echo "https://github.com/automazeio/ccpm"
echo ""
echo ""

echo "🚀 Инициализация системы PM Claude Code"
echo "=============================================="
echo ""

# Check for required tools
echo "🔍 Проверка зависимостей..."

# Check gh CLI
if command -v gh &> /dev/null; then
  echo "  ✅ GitHub CLI (gh) установлен"
else
  echo "  ❌ GitHub CLI (gh) не найден"
  echo ""
  echo "  Установка gh..."
  if command -v brew &> /dev/null; then
    brew install gh
  elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install gh
  else
    echo "  Пожалуйста, установите GitHub CLI вручную: https://cli.github.com/"
    exit 1
  fi
fi

# Check gh auth status
echo ""
echo "🔐 Проверка авторизации GitHub..."
if gh auth status &> /dev/null; then
  echo "  ✅ GitHub авторизован"
else
  echo "  ⚠️ GitHub не авторизован"
  echo "  Running: gh auth login"
  gh auth login
fi

# Check for gh-sub-issue extension
echo ""
echo "📦 Проверка расширений gh..."
if gh extension list | grep -q "yahsan2/gh-sub-issue"; then
  echo "  ✅ Расширение gh-sub-issue установлено"
else
  echo "  📥 Установка расширения gh-sub-issue..."
  gh extension install yahsan2/gh-sub-issue
fi

# Create directory structure
echo ""
echo "📁 Создание структуры папок..."
mkdir -p .claude/prds
mkdir -p .claude/epics
mkdir -p .claude/rules
mkdir -p .claude/agents
mkdir -p .claude/scripts/pm
echo "  ✅ Папки созданы"

# Copy scripts if in main repo
if [ -d "scripts/pm" ] && [ ! "$(pwd)" = *"/.claude"* ]; then
  echo ""
  echo "📝 Копирование скриптов PM..."
  cp -r scripts/pm/* .claude/scripts/pm/
  chmod +x .claude/scripts/pm/*.sh
  echo "  ✅ Скрипты скопированы и сделаны исполняемыми"
fi

# Check for git
echo ""
echo "🔗 Проверка конфигурации Git..."
if git rev-parse --git-dir > /dev/null 2>&1; then
  echo "  ✅ Репозиторий Git обнаружен"

  # Check remote
  if git remote -v | grep -q origin; then
    remote_url=$(git remote get-url origin)
    echo "  ✅ Удалённый репозиторий настроен: $remote_url"
  else
    echo "  ⚠️ Удалённый репозиторий не настроен"
    echo "  Add with: git remote add origin <url>"
  fi
else
  echo "  ⚠️ Не является git репозиторием"
  echo "  Initialize with: git init"
fi

# Create CLAUDE.md if it doesn't exist
if [ ! -f "CLAUDE.md" ]; then
  echo ""
  echo "📄 Создание CLAUDE.md..."
  cat > CLAUDE.md << 'EOF'
# CLAUDE.md

> Think carefully and implement the most concise solution that changes as little code as possible.

## Project-Specific Instructions

Add your project-specific instructions here.

## Testing

Always run tests before committing:
- `npm test` or equivalent for your stack

## Code Style

Follow existing patterns in the codebase.
EOF
  echo "  ✅ CLAUDE.md создан"
fi

# Summary
echo ""
echo "✅ Инициализация завершена!"
echo "=========================="
echo ""
echo "📊 Статус системы:"
gh --version | head -1
echo "  Расширения: $(gh extension list | wc -l) установлено"
echo "  Авторизация: $(gh auth status 2>&1 | grep -o 'Logged in to [^ ]*' || echo 'Не авторизован')"
echo ""
echo "🎯 Следующие шаги:"
echo "  1. Create your first PRD: /pm:prd-new <feature-name>"
echo "  2. View help: /pm:help"
echo "  3. Check status: /pm:status"
echo ""
echo "📚 Документация: README.md"

exit 0
