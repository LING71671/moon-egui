# Moon-EGUI Design System & Token Specifications

<p>
  <a href="DESIGN_SYSTEM.md">English</a> · <a href="DESIGN_SYSTEM_zh.md">简体中文</a>
</p>

> Visual hierarchy, design tokens, color scales, spatial rhythm, typography, and interactive state definitions for `moon-egui`.

---

## 1. Design Aesthetics & Visual Identity

`moon-egui` adopts a modern, premium **Low-Saturation Dark Industrial** design language inspired by tools like Linear, Raycast, and Unreal Engine:
- **Clean Surfaces**: Dark charcoal backgrounds with subtle surface-layer elevation.
- **Vibrant Semantic Accents**: Crisp electric blue/cyan accents for primary focus and interactive indicators.
- **Balanced Radius**: Subtle, modern micro-radii (4px - 8px) avoiding cartoonish curves.
- **Optical Ergonomics**: High contrast text ratios meeting WCAG AA standards.

---

## 2. Color Palettes & Design Tokens

### 2.1 Dark Mode Palette (Default)

| Token Name | Hex Code | RGB | Role / Usage |
| :--- | :--- | :--- | :--- |
| `BG_APP` | `#111116` | `(17, 17, 22)` | Canvas main application background |
| `BG_WINDOW` | `#1A1B23` | `(26, 27, 35)` | Floating window background |
| `BG_SURFACE` | `#232530` | `(35, 37, 48)` | Panel, card, and input field background |
| `BG_HOVER` | `#2D303E` | `(45, 48, 62)` | Hover state on widgets and list items |
| `BG_ACTIVE` | `#393D4F` | `(57, 61, 79)` | Pressed / active state on buttons and sliders |
| `BORDER_MUTED` | `#2E303D` | `(46, 48, 61)` | Subtle inner dividers, window borders |
| `BORDER_FOCUS` | `#5C617B` | `(92, 97, 123)` | Focused / active window outline |
| `TEXT_PRIMARY` | `#EEEEF2` | `(238, 238, 242)` | Main titles, labels, button text |
| `TEXT_MUTED` | `#9497A8` | `(148, 151, 168)` | Descriptions, placeholders, inactive states |
| `ACCENT_PRIMARY` | `#4E75FF` | `(78, 117, 255)` | Primary call-to-actions, active toggle fill |
| `ACCENT_HOVER` | `#6689FF` | `(102, 137, 255)` | Hover state on primary interactive elements |
| `SUCCESS` | `#22C55E` | `(34, 197, 94)` | Green telemetry indicator, positive toggles |
| `WARNING` | `#F59E0B` | `(245, 158, 11)` | Cautions, high frame-time warnings |
| `DANGER` | `#EF4444` | `(239, 68, 68)` | Errors, close buttons, destructive actions |

---

### 2.2 Light Mode Palette

| Token Name | Hex Code | RGB | Role / Usage |
| :--- | :--- | :--- | :--- |
| `BG_APP` | `#F4F5F8` | `(244, 245, 248)` | Canvas light backdrop |
| `BG_WINDOW` | `#FFFFFF` | `(255, 255, 255)` | Floating window background |
| `BG_SURFACE` | `#EBEDF2` | `(235, 237, 242)` | Input fields, card backgrounds |
| `BG_HOVER` | `#DFE2E8` | `(223, 226, 232)` | Hover state |
| `BORDER_MUTED` | `#D1D5DF` | `(209, 213, 223)` | Borders and dividers |
| `TEXT_PRIMARY` | `#1A1D24` | `(26, 29, 36)` | Main dark text |
| `TEXT_MUTED` | `#646B7A` | `(100, 107, 122)` | Secondary labels |
| `ACCENT_PRIMARY` | `#335CFF` | `(51, 92, 255)` | Primary button and slider track fill |

---

## 3. Spatial Rhythm & Sizing Tokens

```
Spacing Scale (Base Unit: 4px):
  • Space_XS  = 4.0 px   (tight intra-widget gap, e.g. checkbox box to label)
  • Space_SM  = 8.0 px   (standard vertical stack gap between controls)
  • Space_MD  = 12.0 px  (window inner padding, section separations)
  • Space_LG  = 16.0 px  (major group separator)
  • Space_XL  = 24.0 px  (window to window margin)
```

### 3.1 Control Heights & Touch Targets
- **Button Height**: `28.0 px` (Standard compact desktop height)
- **Input / Slider Height**: `26.0 px`
- **Title Bar Height**: `32.0 px` (Allows comfortable drag hit-testing)
- **Menu Bar Height**: `28.0 px`

### 3.2 Corner Radii Tokens
- **`RADIUS_NONE`**: `0.0 px` (sharp corners for menu bars)
- **`RADIUS_SM`**: `4.0 px` (buttons, checkboxes, text fields)
- **`RADIUS_MD`**: `6.0 px` (cards, floating popups)
- **`RADIUS_LG`**: `8.0 px` (floating window corners)
- **`RADIUS_PILL`**: `999.0 px` (toggle switches, status badges)

---

## 4. Typography Scale

Fonts are mapped via the Canvas 2D font stack (defaulting to system UI fonts: `Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`):

| Type Role | Font Size | Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Heading 1** | `18.0 px` | Bold (600) | `24.0 px` | Window titles, major sections |
| **Heading 2** | `15.0 px` | Semi-bold (600) | `20.0 px` | Subheadings, card titles |
| **Body / Label** | `13.0 px` | Regular (400) | `18.0 px` | Standard widget labels, buttons |
| **Caption / Small**| `11.0 px` | Regular (400) | `14.0 px` | Tooltips, sparkline legends, captions |
| **Monospace / Code**| `12.0 px` | Mono (500) | `16.0 px` | Numerical telemetry, hex codes |

---

## 5. Interactive State Machine

Every interactive control undergoes a deterministic visual state transition:

```
[Default / Idle] 
       │
       ├─► [Pointer Enters AABB] ────► [Hovered State] (Surface lightens + subtle border highlight)
       │                                     │
       │                                     ├─► [Pointer Down] ────► [Active / Pressed State] (Inset shadow / accent fill)
       │                                     │                              │
       │                                     │                              ├─► [Released inside] ──► Trigger Action (`clicked = true`)
       │                                     │                              └─► [Released outside] ─► Cancel Action
       │
       └─► [Disabled == true] ───────► [Disabled State] (50% opacity, pointer events discarded)
```
