#!/bin/bash
echo "Получение статуса..."
echo ""
echo ""

echo "📋 Следующие доступные задачи"
echo "=============================="
echo ""

# Find tasks that are open and have no dependencies or whose dependencies are closed
found=0

for epic_dir in .claude/epics/*/; do
  [ -d "$epic_dir" ] || continue
  epic_name=$(basename "$epic_dir")

  for task_file in "$epic_dir"[0-9]*.md; do
    [ -f "$task_file" ] || continue

    # Check if task is open
    status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//')
    [ "$status" != "open" ] && [ -n "$status" ] && continue

    # Check dependencies
    deps=$(grep "^depends_on:" "$task_file" | head -1 | sed 's/^depends_on: *\[//' | sed 's/\]//')

    # If no dependencies or empty, task is available
    if [ -z "$deps" ] || [ "$deps" = "depends_on:" ]; then
      task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
      task_num=$(basename "$task_file" .md)
      parallel=$(grep "^parallel:" "$task_file" | head -1 | sed 's/^parallel: *//')

      echo "✅ Готово: #$task_num - $task_name"
      echo "   Epic: $epic_name"
      [ "$parallel" = "true" ] && echo "   🔄 Можно выполнять параллельно"
      echo ""
      ((found++))
    fi
  done
done

if [ $found -eq 0 ]; then
  echo "Доступных задач не найдено."
  echo ""
  echo "💡 Предложения:"
  echo "  • Проверьте заблокированные задачи: /pm:blocked"
  echo "  • Посмотрите все задачи: /pm:epic-list"
fi

echo ""
echo "📊 Сводка: $found задач готовы к запуску"

exit 0
