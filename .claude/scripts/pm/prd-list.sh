# !/bin/bash
# Check if PRD directory exists
if [ ! -d ".claude/prds" ]; then
  echo "📁 Папка PRD не найдена. Создайте первый PRD с: /pm:prd-new <feature-name>"
  exit 0
fi

# Check for PRD files
if ! ls .claude/prds/*.md >/dev/null 2>&1; then
  echo "📁 PRD не найдены. Создайте первый PRD с: /pm:prd-new <feature-name>"
  exit 0
fi

# Initialize counters
backlog_count=0
in_progress_count=0
implemented_count=0
total_count=0

echo "Получение PRD..."
echo ""
echo ""


echo "📋 Список PRD"
echo "==========="
echo ""

# Display by status groups
echo "🔍 PRD в очереди:"
for file in .claude/prds/*.md; do
  [ -f "$file" ] || continue
  status=$(grep "^status:" "$file" | head -1 | sed 's/^status: *//')
  if [ "$status" = "backlog" ] || [ "$status" = "draft" ] || [ -z "$status" ]; then
    name=$(grep "^name:" "$file" | head -1 | sed 's/^name: *//')
    desc=$(grep "^description:" "$file" | head -1 | sed 's/^description: *//')
    [ -z "$name" ] && name=$(basename "$file" .md)
    [ -z "$desc" ] && desc="Нет описания"
    # echo "   📋 $name - $desc"
    echo "   📋 $file - $desc"
    ((backlog_count++))
  fi
  ((total_count++))
done
[ $backlog_count -eq 0 ] && echo "   (нет)"

echo ""
echo "🔄 PRD в работе:"
for file in .claude/prds/*.md; do
  [ -f "$file" ] || continue
  status=$(grep "^status:" "$file" | head -1 | sed 's/^status: *//')
  if [ "$status" = "in-progress" ] || [ "$status" = "active" ]; then
    name=$(grep "^name:" "$file" | head -1 | sed 's/^name: *//')
    desc=$(grep "^description:" "$file" | head -1 | sed 's/^description: *//')
    [ -z "$name" ] && name=$(basename "$file" .md)
    [ -z "$desc" ] && desc="Нет описания"
    # echo "   📋 $name - $desc"
    echo "   📋 $file - $desc"
    ((in_progress_count++))
  fi
done
[ $in_progress_count -eq 0 ] && echo "   (none)"

echo ""
echo "✅ Реализованные PRD:"
for file in .claude/prds/*.md; do
  [ -f "$file" ] || continue
  status=$(grep "^status:" "$file" | head -1 | sed 's/^status: *//')
  if [ "$status" = "implemented" ] || [ "$status" = "completed" ] || [ "$status" = "done" ]; then
    name=$(grep "^name:" "$file" | head -1 | sed 's/^name: *//')
    desc=$(grep "^description:" "$file" | head -1 | sed 's/^description: *//')
    [ -z "$name" ] && name=$(basename "$file" .md)
    [ -z "$desc" ] && desc="Нет описания"
    # echo "   📋 $name - $desc"
    echo "   📋 $file - $desc"
    ((implemented_count++))
  fi
done
[ $implemented_count -eq 0 ] && echo "   (none)"

# Display summary
echo ""
echo "📊 Сводка PRD"
echo "   Всего PRD: $total_count"
echo "   В очереди: $backlog_count"
echo "   В работе: $in_progress_count"
echo "   Реализовано: $implemented_count"

exit 0
