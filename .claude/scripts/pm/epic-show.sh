#!/bin/bash

epic_name="$1"

if [ -z "$epic_name" ]; then
  echo "❌ Пожалуйста, укажите название эпика"
  echo "Usage: /pm:epic-show <epic-name>"
  exit 1
fi

echo "Получение эпика..."
echo ""
echo ""

epic_dir=".claude/epics/$epic_name"
epic_file="$epic_dir/epic.md"

if [ ! -f "$epic_file" ]; then
  echo "❌ Эпик не найден: $epic_name"
  echo ""
  echo "Доступные эпики:"
  for dir in .claude/epics/*/; do
    [ -d "$dir" ] && echo "  • $(basename "$dir")"
  done
  exit 1
fi

# Display epic details
echo "📚 Эпик: $epic_name"
echo "================================"
echo ""

# Extract metadata
status=$(grep "^status:" "$epic_file" | head -1 | sed 's/^status: *//')
progress=$(grep "^progress:" "$epic_file" | head -1 | sed 's/^progress: *//')
github=$(grep "^github:" "$epic_file" | head -1 | sed 's/^github: *//')
created=$(grep "^created:" "$epic_file" | head -1 | sed 's/^created: *//')

echo "📊 Метаданные:"
echo "  Статус: ${status:-планирование}"
echo "  Прогресс: ${progress:-0%}"
[ -n "$github" ] && echo "  GitHub: $github"
echo "  Создан: ${created:-неизвестно}"
echo ""

# Show tasks
echo "📝 Задачи:"
task_count=0
open_count=0
closed_count=0

for task_file in "$epic_dir"/[0-9]*.md; do
  [ -f "$task_file" ] || continue

  task_num=$(basename "$task_file" .md)
  task_name=$(grep "^name:" "$task_file" | head -1 | sed 's/^name: *//')
  task_status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//')
  parallel=$(grep "^parallel:" "$task_file" | head -1 | sed 's/^parallel: *//')

  if [ "$task_status" = "closed" ] || [ "$task_status" = "completed" ]; then
    echo "  ✅ #$task_num - $task_name"
    ((closed_count++))
  else
    echo "  ⬜ #$task_num - $task_name"
    [ "$parallel" = "true" ] && echo -n " (parallel)"
    ((open_count++))
  fi

  ((task_count++))
done

if [ $task_count -eq 0 ]; then
  echo "  Задачи ещё не созданы"
  echo "  Run: /pm:epic-decompose $epic_name"
fi

echo ""
echo "📈 Статистика:"
echo "  Всего задач: $task_count"
echo "  Открытых: $open_count"
echo "  Закрытых: $closed_count"
[ $task_count -gt 0 ] && echo "  Завершено: $((closed_count * 100 / task_count))%"

# Next actions
echo ""
echo "💡 Действия:"
[ $task_count -eq 0 ] && echo "  • Decompose into tasks: /pm:epic-decompose $epic_name"
[ -z "$github" ] && [ $task_count -gt 0 ] && echo "  • Sync to GitHub: /pm:epic-sync $epic_name"
[ -n "$github" ] && [ "$status" != "completed" ] && echo "  • Start work: /pm:epic-start $epic_name"

exit 0
