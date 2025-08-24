#!/bin/bash
echo "Получение статуса..."
echo ""
echo ""

echo "🔄 Работа в процессе"
echo "========================"
echo ""

# Check for active work in updates directories
found=0

if [ -d ".claude/epics" ]; then
  for updates_dir in .claude/epics/*/updates/*/; do
    [ -d "$updates_dir" ] || continue

    issue_num=$(basename "$updates_dir")
    epic_name=$(basename $(dirname $(dirname "$updates_dir")))

    if [ -f "$updates_dir/progress.md" ]; then
      completion=$(grep "^completion:" "$updates_dir/progress.md" | head -1 | sed 's/^completion: *//')
      [ -z "$completion" ] && completion="0%"

      # Get task name from the task file
      task_file=".claude/epics/$epic_name/$issue_num.md"
      if [ -f "$task_file" ]; then
        task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
      else
        task_name="Неизвестная задача"
      fi

      echo "📝 Issue #$issue_num - $task_name"
      echo "   Epic: $epic_name"
      echo "   Прогресс: $completion завершено"

      # Check for recent updates
      if [ -f "$updates_dir/progress.md" ]; then
        last_update=$(grep "^last_sync:" "$updates_dir/progress.md" | head -1 | sed 's/^last_sync: *//')
        [ -n "$last_update" ] && echo "   Последнее обновление: $last_update"
      fi

      echo ""
      ((found++))
    fi
  done
fi

# Also check for in-progress epics
echo "📚 Активные эпики:"
for epic_dir in .claude/epics/*/; do
  [ -d "$epic_dir" ] || continue
  [ -f "$epic_dir/epic.md" ] || continue

  status=$(grep "^status:" "$epic_dir/epic.md" | head -1 | sed 's/^status: *//')
  if [ "$status" = "in-progress" ] || [ "$status" = "active" ]; then
    epic_name=$(grep "^name:" "$epic_dir/epic.md" | head -1 | sed 's/^name: *//')
    progress=$(grep "^progress:" "$epic_dir/epic.md" | head -1 | sed 's/^progress: *//')
    [ -z "$epic_name" ] && epic_name=$(basename "$epic_dir")
    [ -z "$progress" ] && progress="0%"

    echo "   • $epic_name - $progress завершено"
  fi
done

echo ""
if [ $found -eq 0 ]; then
  echo "Активные элементы работы не найдены."
  echo ""
  echo "💡 Начните работу с: /pm:next"
else
  echo "📊 Всего активных элементов: $found"
fi

exit 0
