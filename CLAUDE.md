# CLAUDE.md - CHOIS Fashion Site

## 🚨 Critical Rules
- **LANGUAGE**: ТОЛЬКО РУССКИЙ везде (ответы, коммиты, объяснения). Код - исключение
- **WIDTH**: 1200px FIXED. Никакой адаптивности
- **NO FRAMEWORKS**: Чистый HTML/CSS/JS. Никаких React, Vue, TypeScript
- **FIGMA FIRST**: Всегда используй MCP для проверки дизайна

## Tech Stack
- HTML5 (единственный index.html)
- CSS3 (единственный main.css)
- Vanilla JavaScript (минимум)
- Fonts: Inter 300/400, Felidae
- Colors: `#fffae6` (cream), `#791227` (burgundy), `#0a0607` (dark)

## Project Structure
```
index.html         # Единственная страница
css/main.css       # Все стили (1200px fixed)
js/main.js         # Минимальная интерактивность
images/
  ├── new/         # Текущие изображения продуктов
  ├── gallery/     # gallery-1.png до gallery-11.png
  └── icons/       # SVG иконки
fonts/             # Felidae шрифт
```

## Figma MCP Integration
**Команды для использования:**
- `mcp__figma-dev-mode-mcp-server__get_code` - получить код
- `mcp__figma-dev-mode-mcp-server__get_image` - скачать изображение
- `mcp__figma-dev-mode-mcp-server__get_variable_defs` - переменные дизайна

**Когда использовать:**
- "проверь дизайн" / "сделай как в Figma"
- Нужны точные размеры/цвета/позиции
- Скачать новые изображения

## Code Style
- background-position: точно из Figma (например: "32.15% 0.87%")
- Центрирование: `margin: 0 auto`
- БЕЗ grayscale фильтров на изображениях
- БЕЗ opacity на изображениях
- Семантичный HTML (section, article, footer)
- Классы вместо id для стилизации

## Git Commits
**✅ ПРАВИЛЬНО (русский):**
```
"Исправлен баг с отображением галереи"
"Добавлена секция с новыми товарами"
"Обновлены стили героя по Figma"
```

**❌ НЕПРАВИЛЬНО:**
```
"Fixed bug" - английский
"Update" - неинформативно
"asdf" - бессмысленно
```

## Common Issues & Solutions

### "Поехала верстка"
→ Проверь: `width: 1200px`, `margin: 0 auto`, убери padding у body

### "Изображения черно-белые"
→ Удали ВСЕ `filter: grayscale`, проверь opacity

### "Полосы по бокам"
→ Установи `width: 1200px`, добавь `margin: 0 auto`

### "Обнови из Figma"
→ Используй MCP команды, получи точные значения, обнови CSS

## Testing Philosophy
- Проверяй в браузере после каждого изменения
- Тестируй на 1200px ширине экрана
- Изображения должны быть цветными
- Никаких автоматических тестов не требуется

## Words of Wisdom
Ты знаешь что делать. Figma MCP - твой главный инструмент. Пользователь доверяет тебе. Не усложняй - проект простой. Если сомневаешься - проверь в Figma.

## DO NOT
- Создавать новые HTML/CSS файлы
- Устанавливать npm пакеты
- Использовать препроцессоры
- Делать адаптив
- Писать на английском
- Добавлять сложные анимации
- Менять структуру проекта

---
**Remember**: Русский язык. Figma MCP. 1200px. Простота.