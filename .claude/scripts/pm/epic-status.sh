#!/bin/bash

echo "Получение статуса..."
echo ""
echo ""

epic_name="$1"

if [ -z "$epic_name" ]; then
  echo "❌ Пожалуйста, укажите название эпика"
  echo "Usage: /pm:epic-status <epic-name>"
  echo ""
  echo "Доступные эпики:"
  for dir in .claude/epics/*/; do
    [ -d "$dir" ] && echo "  • $(basename "$dir")"
  done
  exit 1
else
  # Show status for specific epic
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

  echo "📚 Статус эпика: $epic_name"
  echo "================================"
  echo ""

  # Extract metadata
  status=$(grep "^status:" "$epic_file" | head -1 | sed 's/^status: *//')
  progress=$(grep "^progress:" "$epic_file" | head -1 | sed 's/^progress: *//')
  github=$(grep "^github:" "$epic_file" | head -1 | sed 's/^github: *//')

  # Count tasks
  total=0
  open=0
  closed=0
  blocked=0

  # Use find to safely iterate over task files
  for task_file in "$epic_dir"/[0-9]*.md; do
    [ -f "$task_file" ] || continue
    ((total++))

    task_status=$(grep "^status:" "$task_file" | head -1 | sed 's/^status: *//')
    deps=$(grep "^depends_on:" "$task_file" | head -1 | sed 's/^depends_on: *\[//' | sed 's/\]//')

    if [ "$task_status" = "closed" ] || [ "$task_status" = "completed" ]; then
      ((closed++))
    elif [ -n "$deps" ] && [ "$deps" != "depends_on:" ]; then
      ((blocked++))
    else
      ((open++))
    fi
  done

  # Display progress bar
  if [ $total -gt 0 ]; then
    percent=$((closed * 100 / total))
    filled=$((percent * 20 / 100))
    empty=$((20 - filled))

    echo -n "Progress: ["
    [ $filled -gt 0 ] && printf '%0.s█' $(seq 1 $filled)
    [ $empty -gt 0 ] && printf '%0.s░' $(seq 1 $empty)
    echo "] $percent%"
  else
    echo "Прогресс: Задачи не созданы"
  fi

  echo ""
  echo "📊 Детализация:"
  echo "  Всего задач: $total"
  echo "  ✅ Завершено: $closed"
  echo "  🔄 Доступно: $open"
  echo "  ⏸️ Заблокировано: $blocked"

  [ -n "$github" ] && echo ""
  [ -n "$github" ] && echo "🔗 GitHub: $github"
fi

exit 0
