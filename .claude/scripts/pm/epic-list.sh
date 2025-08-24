#!/bin/bash
echo "Получение эпиков..."
echo ""
echo ""

[ ! -d ".claude/epics" ] && echo "📁 Папка эпиков не найдена. Создайте первый эпик: /pm:prd-parse <feature-name>" && exit 0
[ -z "$(ls -d .claude/epics/*/ 2>/dev/null)" ] && echo "📁 Эпики не найдены. Создайте первый эпик: /pm:prd-parse <feature-name>" && exit 0

echo "📚 Эпики проекта"
echo "================"
echo ""

# Initialize arrays to store epics by status
planning_epics=""
in_progress_epics=""
completed_epics=""

# Process all epics
for dir in .claude/epics/*/; do
  [ -d "$dir" ] || continue
  [ -f "$dir/epic.md" ] || continue

  # Extract metadata
  n=$(grep "^name:" "$dir/epic.md" | head -1 | sed 's/^name: *//')
  s=$(grep "^status:" "$dir/epic.md" | head -1 | sed 's/^status: *//' | tr '[:upper:]' '[:lower:]')
  p=$(grep "^progress:" "$dir/epic.md" | head -1 | sed 's/^progress: *//')
  g=$(grep "^github:" "$dir/epic.md" | head -1 | sed 's/^github: *//')

  # Defaults
  [ -z "$n" ] && n=$(basename "$dir")
  [ -z "$p" ] && p="0%"

  # Count tasks
  t=$(ls "$dir"[0-9]*.md 2>/dev/null | wc -l)

  # Format output with GitHub issue number if available
  if [ -n "$g" ]; then
    i=$(echo "$g" | grep -o '/[0-9]*$' | tr -d '/')
    entry="   📋 ${dir}epic.md (#$i) - $p complete ($t tasks)"
  else
    entry="   📋 ${dir}epic.md - $p complete ($t tasks)"
  fi

  # Categorize by status (handle various status values)
  case "$s" in
    planning|draft|"")
      planning_epics="${planning_epics}${entry}\n"
      ;;
    in-progress|in_progress|active|started)
      in_progress_epics="${in_progress_epics}${entry}\n"
      ;;
    completed|complete|done|closed|finished)
      completed_epics="${completed_epics}${entry}\n"
      ;;
    *)
      # Default to planning for unknown statuses
      planning_epics="${planning_epics}${entry}\n"
      ;;
  esac
done

# Display categorized epics
echo "📝 Планирование:"
if [ -n "$planning_epics" ]; then
  echo -e "$planning_epics" | sed '/^$/d'
else
  echo "   (нет)"
fi

echo ""
echo "🚀 В работе:"
if [ -n "$in_progress_epics" ]; then
  echo -e "$in_progress_epics" | sed '/^$/d'
else
  echo "   (нет)"
fi

echo ""
echo "✅ Завершено:"
if [ -n "$completed_epics" ]; then
  echo -e "$completed_epics" | sed '/^$/d'
else
  echo "   (нет)"
fi

# Summary
echo ""
echo "📊 Сводка"
total=$(ls -d .claude/epics/*/ 2>/dev/null | wc -l)
tasks=$(find .claude/epics -name "[0-9]*.md" 2>/dev/null | wc -l)
echo "   Всего эпиков: $total"
echo "   Всего задач: $tasks"

exit 0
