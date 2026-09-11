# Moon-EGUI Design System & Token Specifications

<p>
  <a href="DESIGN_SYSTEM.md">English</a> · <a href="DESIGN_SYSTEM_zh.md">简体中文</a>
</p>

> Visual hierarchy, design tokens, color scales, spatial rhythm, typography, and interactive state definitions for `moon-egui`.

---

## 1. Design Aesthetics & Visual Identity

`moon-egui` adopts a refined, modern **Studio Light (Porcelain / Studio Light)** design language inspired by precision industrial instruments, mechanical tactile craft, and modern CAD workstations:
- **Pristine Porcelain Surfaces & Micro-Elevation**: Crisp light porcelain surfaces (`#F8FAFC` ~ `#FFFFFF`) paired with subtle multi-tier elevation drop shadows for deep optical separation.
- **High-Contrast Semantic Accents**: Cobalt Blue (`#2563EB`) as primary interactive indicators, focus rings, and selection highlights.
- **Mechanical Tactile Haptics**: Core controls feature a distinct 1.5px mechanical press stroke (Chiclet keys, milled grooves) eliminating floaty, flat impressions.
- **Optical Ergonomics**: Text utilizes deep titanium charcoal (`#0F172A`), strictly satisfying WCAG AA legibility criteria.

---

## 2. Color Palettes & Design Tokens

The library ships a single palette (Studio Light porcelain), defined in
`src/color/color.mbt`. **Widgets must not hard-code colour values** - they read
tokens; the `theme design tokens` case in `color_wbtest.mbt` pins the key values
so the palette cannot drift.

> Two palettes used to coexist: a dark token set in `color.mbt` read only by
> `window()` / `tooltip()` / `progress_bar()`, and light values written inline
> across the widgets. On 2026-09-11 they were merged into one light token set:
> widget rendering is unchanged (every token is value-identical to the literal it
> replaced), while windows and progress bars became light. A dark theme is not
> implemented; it would need a second token set.

### 2.1 Token Reference

| Token Name | Hex / RGBA | Role / Usage |
| :--- | :--- | :--- |
| **Surfaces** | | |
| `BG_APP` | `#F8FAFC` | Canvas / page backdrop |
| `BG_WINDOW` | `#FFFFFF` | Floating window, card, and popup background |
| `BG_SURFACE` | `#F1F5F9` | Window headers, recessed grooves, badge rest state |
| `BG_SUBTLE` | `#F8FAFC` | Hover wash and row highlight |
| `BG_HOVER` | `#F8FAFC` | Semantic alias for hover (same value as `BG_SUBTLE`) |
| `BG_ACTIVE` | `#E2E8F0` | Pressed state, deeper recess |
| `BG_INVERSE` | `#1A1B23` | Inverted overlays: tooltips (pair with `TEXT_INVERSE`) |
| **Borders** | | |
| `BORDER_MUTED` | `#E2E8F0` | Inner hairline dividers and control grooves |
| `BORDER_DEFAULT` | `#CBD5E1` | Default control outline |
| `BORDER_STRONG` | `#94A3B8` | Pressed / disabled outline |
| `BORDER_FOCUS` | `#2563EB` | Keyboard focus ring |
| **Text** | | |
| `TEXT_PRIMARY` | `#0F172A` | Main titles, labels, button text |
| `TEXT_STRONG` | `#1E293B` | Emphasised text in pressed states |
| `TEXT_BODY` | `#334155` | Body copy |
| `TEXT_SECONDARY` | `#475569` | Secondary descriptions |
| `TEXT_MUTED` | `#64748B` | Helper text and badge labels |
| `TEXT_DISABLED` | `#94A3B8` | Placeholders and inactive states |
| `TEXT_INVERSE` | `#FFFFFF` | Text on inverted overlays and accent fills |
| **Accent** | | |
| `ACCENT_PRIMARY` | `#2563EB` | Primary blue: main buttons, active fills, slider progress |
| `ACCENT_HOVER` | `#3B82F6` | Hover state on accent elements |
| `ACCENT_PRESSED` | `#1D4ED8` | Pressed state on accent elements |
| `ACCENT_DEEP` | `#1E3A8A` | Accent outline under load |
| `ACCENT_SOFT` | `rgba(37,99,235,45)` | Translucent accent wash: focus rings, selection glow |
| `ACCENT_HIGHLIGHT` | `rgba(255,255,255,60)` | Translucent highlight over accent fills |
| `SHADOW` | `rgba(15,23,42,18)` | Elevation shadow under floating surfaces |
| **Semantic** | | |
| `SUCCESS` | `#22C55E` | Green telemetry indicator, positive toggles |
| `WARNING` | `#F59E0B` | Cautions, high frame-time warnings |
| `DANGER` | `#EF4444` | Errors, close actions, destructive operations |

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
- **Global Menu Bar Height**: `28.0 px` (Full-width viewport edge strip)
- **Menu Item Height**: `24.0 px` (Includes 4px shortcut badge)

### 3.2 Corner Radii Tokens
- **`RADIUS_NONE`**: `0.0 px` (sharp corners for top menu bars)
- **`RADIUS_SM`**: `4.0 px` (buttons, checkboxes, text fields, menu items)
- **`RADIUS_MD`**: `6.0 px` (cards, floating dropdown popup cards)
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
| **Monospace / Code**| `12.0 px` | Mono (500) | `16.0 px` | Numerical telemetry, hex codes, shortcut badges |

---

## 5. Interactive State Machine

### 5.1 Core Widget State Transitions

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

### 5.2 Dropdown Popup & Hover-to-Switch Flow

The global application menu bar implements desktop-grade bistable switching:

```
[All Closed] ──(Click any Menu Header)──► [Opened: Menu A]
                                                 │
       ┌─────────────────────────────────────────┴─────────────────────────────────────────┐
       │                                         │                                         │
[Outside Click / Item Selected]        [Pointer Hovers Adjacent Menu B]              [Click Menu A Again]
       │                                         │                                         │
       ▼                                         ▼                                         ▼
 [Back to Closed]                       [Switch to Opened: Menu B]                    [Dismiss to Closed]
```
- **Foreground Layer Isolation**: Dropdown popup cards render on an isolated `Foreground Layer` with shadow elevation and porcelain background.
- **Occlusion Blocking**: While open, `block_hover` intercepts pointer events from penetrating to underlying canvas widgets.
