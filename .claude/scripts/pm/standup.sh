#!/bin/bash

echo "📅 Ежедневная планёрка - $(date '+%Y-%m-%d')"
echo "================================"
echo ""

today=$(date '+%Y-%m-%d')

echo "Получение статуса..."
echo ""
echo ""

echo "📝 Сегодняшняя активность:"
echo "======================="
echo ""

# Find files modified today
recent_files=$(find .claude -name "*.md" -mtime -1 2>/dev/null)

if [ -n "$recent_files" ]; then
  # Count by type
  prd_count=$(echo "$recent_files" | grep -c "/prds/" || echo 0)
  epic_count=$(echo "$recent_files" | grep -c "/epic.md" || echo 0)
  task_count=$(echo "$recent_files" | grep -c "/[0-9]*.md" || echo 0)
  update_count=$(echo "$recent_files" | grep -c "/updates/" || echo 0)

  [ $prd_count -gt 0 ] && echo "  • Изменено $prd_count PRD"
  [ $epic_count -gt 0 ] && echo "  • Обновлено $epic_count эпиков"
  [ $task_count -gt 0 ] && echo "  • Выполнялось $task_count задач"
  [ $update_count -gt 0 ] && echo "  • Опубликовано $update_count обновлений прогресса"
else
  echo "  Сегодня никакой активности не зафиксировано"
fi

echo ""
echo "🔄 Текущая работа:"
# Show active work items
for updates_dir in .claude/epics/*/updates/*/; do
  [ -d "$updates_dir" ] || continue
  if [ -f "$updates_dir/progress.md" ]; then
    issue_num=$(basename "$updates_dir")
    epic_name=$(basename $(dirname $(dirname "$updates_dir")))
    completion=$(grep "^completion:" "$updates_dir/progress.md" | head -1 | sed 's/^completion: *//')
    echo "  • Задача #$issue_num ($epic_name) - ${completion:-0%} завершено"
  fi
done

echo ""
echo "⏭️ Следующие доступные задачи:"
# Show top 3 available tasks
count=0
for epic_dir in .claude/epics/*/; do
  [ -d "$epic_dir" ] || continue
  for task_file in "$epic_dir"[0-9]*.md; do
    [ -f "$task_file" ] || continue
    status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//')
    [ "$status" != "open" ] && [ -n "$status" ] && continue

    deps=$(grep "^depends_on:" "$task_file" | head -1 | sed 's/^depends_on: *\[//' | sed 's/\]//')
    if [ -z "$deps" ] || [ "$deps" = "depends_on:" ]; then
      task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
      task_num=$(basename "$task_file" .md)
      echo "  • #$task_num - $task_name"
      ((count++))
      [ $count -ge 3 ] && break 2
    fi
  done
done

echo ""
echo "📊 Краткая статистика:"
total_tasks=$(find .claude/epics -name "[0-9]*.md" 2>/dev/null | wc -l)
open_tasks=$(find .claude/epics -name "[0-9]*.md" -exec grep -l "^status: *open" {} \; 2>/dev/null | wc -l)
closed_tasks=$(find .claude/epics -name "[0-9]*.md" -exec grep -l "^status: *closed" {} \; 2>/dev/null | wc -l)
echo "  Задачи: $open_tasks открытых, $closed_tasks закрытых, $total_tasks всего"

exit 0
