#!/bin/bash

echo "Проверка системы PM..."
echo ""
echo ""

echo "🔍 Проверка системы PM"
echo "======================="
echo ""

errors=0
warnings=0

# Check directory structure
echo "📁 Структура папок:"
[ -d ".claude" ] && echo "  ✅ Папка .claude существует" || { echo "  ❌ Папка .claude отсутствует"; ((errors++)); }
[ -d ".claude/prds" ] && echo "  ✅ Папка PRDs существует" || echo "  ⚠️ Папка PRDs отсутствует"
[ -d ".claude/epics" ] && echo "  ✅ Папка Epics существует" || echo "  ⚠️ Папка Epics отсутствует"
[ -d ".claude/rules" ] && echo "  ✅ Папка Rules существует" || echo "  ⚠️ Папка Rules отсутствует"
echo ""

# Check for orphaned files
echo "🗂️ Целостность данных:"

# Check epics have epic.md files
for epic_dir in .claude/epics/*/; do
  [ -d "$epic_dir" ] || continue
  if [ ! -f "$epic_dir/epic.md" ]; then
    echo "  ⚠️ Отсутствует epic.md в $(basename "$epic_dir")"
    ((warnings++))
  fi
done

# Check for tasks without epics
orphaned=$(find .claude -name "[0-9]*.md" -not -path ".claude/epics/*/*" 2>/dev/null | wc -l)
[ $orphaned -gt 0 ] && echo "  ⚠️ Найдено $orphaned осиротевших файлов задач" && ((warnings++))

# Check for broken references
echo ""
echo "🔗 Проверка ссылок:"

for task_file in .claude/epics/*/[0-9]*.md; do
  [ -f "$task_file" ] || continue

  deps=$(grep "^depends_on:" "$task_file" | head -1 | sed 's/^depends_on: *\[//' | sed 's/\]//' | sed 's/,/ /g')
  if [ -n "$deps" ] && [ "$deps" != "depends_on:" ]; then
    epic_dir=$(dirname "$task_file")
    for dep in $deps; do
      if [ ! -f "$epic_dir/$dep.md" ]; then
        echo "  ⚠️ Задача $(basename "$task_file" .md) ссылается на отсутствующую задачу: $dep"
        ((warnings++))
      fi
    done
  fi
done

[ $warnings -eq 0 ] && [ $errors -eq 0 ] && echo "  ✅ Все ссылки действительны"

# Check frontmatter
echo ""
echo "📝 Проверка frontmatter:"
invalid=0

for file in $(find .claude -name "*.md" -path "*/epics/*" -o -path "*/prds/*" 2>/dev/null); do
  if ! grep -q "^---" "$file"; then
    echo "  ⚠️ Отсутствует frontmatter: $(basename "$file")"
    ((invalid++))
  fi
done

[ $invalid -eq 0 ] && echo "  ✅ Во всех файлах есть frontmatter"

# Summary
echo ""
echo "📊 Сводка проверки:"
echo "  Ошибки: $errors"
echo "  Предупреждения: $warnings"
echo "  Неверные файлы: $invalid"

if [ $errors -eq 0 ] && [ $warnings -eq 0 ] && [ $invalid -eq 0 ]; then
  echo ""
  echo "✅ Система здорова!"
else
  echo ""
  echo "💡 Запустите /pm:clean для автоматического исправления некоторых проблем"
fi

exit 0
