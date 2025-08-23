# Font Setup Instructions

## Required Fonts

### 1. Inter Font
- Weights needed: Light (300), Regular (400)
- Already linked via Google Fonts in index.html
- Fallback: sans-serif

### 2. Felidae Font
- Custom decorative font for titles
- Needs to be downloaded and added to this folder
- Used for section titles and product names
- Fallback: serif

## Installation

### For Inter (already set up):
```html
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400&display=swap" rel="stylesheet">
```

### For Felidae (custom font):
1. Download Felidae font files (.woff, .woff2)
2. Place them in this fonts/ directory
3. Add @font-face rule to style.css:

```css
@font-face {
    font-family: 'Felidae';
    src: url('../fonts/felidae.woff2') format('woff2'),
         url('../fonts/felidae.woff') format('woff');
    font-weight: normal;
    font-style: normal;
    font-display: swap;
}
```

## Font Usage in Design
- Hero title: Inter Light 252px
- Section titles: Felidae 53px
- Product titles: Felidae 54px
- Body text: Inter Regular 39px
- Product info: Inter Regular 29-34px
- Buttons: Inter Regular 48px