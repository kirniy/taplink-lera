#!/bin/bash

echo "Загрузка статуса..."
echo ""
echo ""


echo "📊 Статус проекта"
echo "================"
echo ""

echo "📄 PRDs:"
if [ -d ".claude/prds" ]; then
  total=$(ls .claude/prds/*.md 2>/dev/null | wc -l)
  echo "  Всего: $total"
else
  echo "  PRD не найдено"
fi

echo ""
echo "📚 Эпики:"
if [ -d ".claude/epics" ]; then
  total=$(ls -d .claude/epics/*/ 2>/dev/null | wc -l)
  echo "  Всего: $total"
else
  echo "  Эпиков не найдено"
fi

echo ""
echo "📝 Задачи:"
if [ -d ".claude/epics" ]; then
  total=$(find .claude/epics -name "[0-9]*.md" 2>/dev/null | wc -l)
  open=$(find .claude/epics -name "[0-9]*.md" -exec grep -l "^status: *open" {} \; 2>/dev/null | wc -l)
  closed=$(find .claude/epics -name "[0-9]*.md" -exec grep -l "^status: *closed" {} \; 2>/dev/null | wc -l)
  echo "  Открыто: $open"
  echo "  Закрыто: $closed"
  echo "  Всего: $total"
else
  echo "  Задач не найдено"
fi

exit 0
