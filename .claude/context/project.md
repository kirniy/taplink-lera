# Project Context: CHOIS Fashion Brand Website

## Overview
CHOIS - российский бренд капсульных коллекций нижнего белья и одежды для дома. Статичный сайт-витрина с фиксированной шириной 1200px.

## Tech Stack
- **Frontend**: Vanilla HTML5, CSS3, JavaScript (минимальный)
- **Fonts**: Inter (300, 400), Felidae (custom)
- **Colors**: 
  - Cream: `#fffae6`
  - Burgundy: `#791227`
  - Dark: `#0a0607`
- **Layout**: Fixed 1200px width, NO responsive design
- **Build**: Static files only, no frameworks

## Project Structure
```
taplink/
├── index.html           # Единственная HTML страница
├── css/
│   └── main.css        # Все стили (1200px fixed)
├── js/
│   └── main.js         # Минимальная интерактивность
├── images/
│   ├── new/           # Текущие изображения продуктов
│   ├── gallery/       # gallery-1.png до gallery-11.png
│   └── icons/         # SVG иконки
├── fonts/             # Felidae шрифт
└── .claude/           # CCPM система управления проектами
    ├── commands/      # PM команды
    ├── scripts/pm/    # Скрипты PM (русифицированы)
    ├── epics/         # Эпики проектов
    └── prds/          # Product Requirement Documents
```

## Key Features
1. **Hero Section**: Главный баннер с фоновым изображением
2. **Product Catalog**: Карточки товаров с изображениями и ценами
3. **Gallery**: Галерея изображений продуктов
4. **Fixed Layout**: 1200px ширина, центрирование через margin: 0 auto

## Design System
- **Typography**: Inter для основного текста, Felidae для заголовков
- **Spacing**: Consistent padding/margins
- **Images**: Цветные, без grayscale фильтров
- **Positioning**: Точные значения из Figma (например: "32.15% 0.87%")

## Development Rules
1. **ЯЗЫК**: Весь интерфейс и коммиты на русском
2. **NO FRAMEWORKS**: Только чистый HTML/CSS/JS
3. **FIGMA FIRST**: Всегда проверять дизайн через MCP
4. **FIXED WIDTH**: 1200px без адаптивности
5. **NO DUPLICATION**: Переиспользовать существующий код
6. **SIMPLE SOLUTIONS**: Избегать overengineering

## PM System (CCPM)
Полностью русифицированная система управления проектами:
- `/pm:help` - Справка по командам
- `/pm:status` - Статус проекта
- `/pm:next` - Следующие задачи
- Все сообщения и интерфейс на русском языке

## Git Workflow
- Регулярные коммиты на русском языке
- Структура: "Действие + что изменено"
- Пример: "Исправлен баг с отображением галереи"

## Current State
- Базовая структура сайта готова
- PM система интегрирована и русифицирована
- Настроены permissions для MCP tools
- Готов к дальнейшей разработке функционала

## Important Notes
- Пользователь - новичок, требуется обучение
- Напоминать про коммиты после изменений
- Объяснять действия простым языком
- Использовать sub-agents для оптимизации контекста

## MCP Integration
Available MCP servers:
- `figma-dev-mode-mcp-server` - для работы с дизайном
- `mcp-sequentialthinking-tools` - для сложного анализа
- Другие инструменты через permissions в settings.local.json