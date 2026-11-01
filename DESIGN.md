---
name: NutriScan
colors:
  surface: '#f7f9ff'
  surface-dim: '#d1dbe8'
  surface-bright: '#f7f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#edf4ff'
  surface-container: '#e4effd'
  surface-container-high: '#dfe9f7'
  surface-container-highest: '#d9e3f1'
  on-surface: '#121d26'
  on-surface-variant: '#3f4948'
  inverse-surface: '#27313c'
  inverse-on-surface: '#e8f2ff'
  outline: '#6f7978'
  outline-variant: '#bfc8c8'
  surface-tint: '#236868'
  primary: '#004242'
  on-primary: '#ffffff'
  primary-container: '#0f5b5b'
  on-primary-container: '#8fd0d0'
  inverse-primary: '#90d2d1'
  secondary: '#54615f'
  on-secondary: '#ffffff'
  secondary-container: '#d7e5e2'
  on-secondary-container: '#5a6765'
  tertiary: '#533400'
  on-tertiary: '#ffffff'
  tertiary-container: '#724900'
  on-tertiary-container: '#ffb750'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#aceeee'
  primary-fixed-dim: '#90d2d1'
  on-primary-fixed: '#002020'
  on-primary-fixed-variant: '#004f50'
  secondary-fixed: '#d7e5e2'
  secondary-fixed-dim: '#bcc9c7'
  on-secondary-fixed: '#121e1c'
  on-secondary-fixed-variant: '#3d4947'
  tertiary-fixed: '#ffddb5'
  tertiary-fixed-dim: '#ffb956'
  on-tertiary-fixed: '#2a1800'
  on-tertiary-fixed-variant: '#643f00'
  background: '#f7f9ff'
  on-background: '#121d26'
  surface-variant: '#d9e3f1'
typography:
  metric-display:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 52px
    letterSpacing: -0.03em
  metric-display-mobile:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  caption:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  margin: 1.25rem
  margin-mobile: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system delivers a clinical-calm, trustworthy interface engineered for on-device body-composition screening and preventative wellness analysis. Balancing diagnostic authority with compassionate care, the aesthetic rejects intimidating medical software paradigms in favor of a clean, structured, and reassuring experience. The system is designed primarily for native mobile viewports, serving health-conscious individuals and preventative healthcare practitioners who demand precise biometric data without visual alarmism.

The design philosophy relies on modern medical minimalism:
- **Quiet Precision:** Utilitarian clarity derived from rigorous typographic structure, high-contrast numeric callouts, and generous whitespace.
- **Supportive Tone:** Grounded natural warmth through subtle sand backgrounds and soft mint surfaces, avoiding cold, sterile hospital whites.
- **Diagnostic Restraint:** Color is deployed strictly as functional data visualization rather than decorative embellishment. Metric alerts use measured tonal indicators rather than saturated shock colors.
- **Bilingual Functional Clarity:** Structural hierarchy and copy components accommodate equivalent cognitive clarity across both English and Spanish diagnostic phrasing.

## Colors

The palette establishes an immediate atmosphere of clinical trust and emotional equilibrium. The primary Deep Teal (`#0F5B5B`) anchors primary interactions, major headers, and verified diagnostic confirmations. The secondary Soft Mint (`#E6F4F1`) acts as a supportive tint for diagnostic badges, active selection surfaces, and metric callout containers. 

### Canvas & Surfaces
- **Canvas / Root Background:** Warm Sand (`#F7F5F0`) provides an organic, non-clinical base that eliminates screen glare during daily check-ins.
- **Container / Surface:** Pure White (`#FFFFFF`) isolates diagnostic modules, metrics, and forms from the canvas.
- **Subtle Stroke:** Neutral Slate Outline (`#E2E8F0`) frames cards and inputs with hairline precision.

### Neutral Typographic Tones
- **Text Primary:** Deep Slate (`#1F2933`) ensures maximum contrast and WCAG AAA compliance across primary metrics and labels.
- **Text Secondary / Muted:** Muted Slate (`#5B6B7A`) denotes units of measurement, timestamps, and secondary contextual guidance.

### Diagnostic & Metric Classification
Biometric status and BMI classifications rely on dedicated chromatic bands:
- **Underweight Band:** Clinical Blue (`#3B82F6`)
- **Optimal / Normal Band:** Medical Emerald (`#10B981`)
- **Caution / Overweight Band:** Diagnostic Amber (`#E8A33D`)
- **Critical Alert / Obese / Disclaimer:** Calibrated Rose (`#C4573F`)

## Typography

The typography is built entirely on `Inter` to leverage its high x-height, neutral aperture, and engineered tabular figures. Because biometric screening demands instantaneous, error-free comprehension, numeric values use tabular numerals (`tnum`) to prevent visual drift during real-time data inputs and sensor calculations.

- **Metric Display Roles:** Large-format numerals (`metric-display`) are reserved strictly for primary biometric outcomes such as Body Mass Index, body fat percentages, and skeletal muscle mass. Units (`kg/m²`, `%`, `kg`) are paired directly alongside the baseline at `headline-sm` or `label-lg` sizing in Muted Slate.
- **Hierarchy Rules:** Section titles use sentence case for maximum readability in both English and Spanish (e.g., "Composición corporal" / "Body composition"). Uppercase formatting is restricted exclusively to short micro-labels (`label-md` and `caption`) such as `STATUS`, `ESTADO`, or `BMI RANGE`.

## Layout & Spacing

This design system uses an explicit 8pt baseline grid system (0.5rem base) with a secondary 4pt half-step (0.25rem) reserved for micro-spacing between related numeric tokens and unit indicators. 

### Grid & Margins
- **Mobile Viewports (<600px):** Single-column stack with 16px (`1rem`) outer canvas margins and 12px (`0.75rem`) gutters between side-by-side metric tiles. All touch targets strictly maintain a minimum tap dimension of 44x44 points.
- **Tablet / Expanded Viewports (>=600px):** 6-column fluid grid with 20px (`1.25rem`) outer canvas margins and 16px (`1rem`) gutters. Diagnostic panels may span 3 or 6 columns.

### Vertical Rhythm
- Metric groupings and input pairs maintain `space-sm` (8px) internal gaps.
- Distinct card sections, data tables, and input groups preserve `space-md` (16px) separation.
- Major anatomical or diagnostic modules are separated by `space-lg` (24px) or `space-xl` (32px) to prevent cognitive overload.

## Elevation & Depth

Visual hierarchy avoids stark layering, skeuomorphism, and heavy dropshadows. Depth is established through subtle tonal containment and ultra-soft ambient shadowing that replicates physical clinical lab cards placed under diffuse lighting.

### Elevation Levels
- **Level 0 (Flat / Canvas):** Used for the root Warm Sand background (`#F7F5F0`). No elevation.
- **Level 1 (Card / Resting Surface):** Used for White cards (`#FFFFFF`). Defined by a structural border (`1px solid #E2E8F0`) paired with a faint ambient shadow: `0px 2px 8px -2px rgba(31, 41, 51, 0.04)`.
- **Level 2 (Interactive Floating / Active Scanning):** Used for active input tiles, elevated summary sheets, and scanning overlays. Defined by `0px 6px 16px -4px rgba(15, 91, 91, 0.08)` combined with a `1px solid #E2E8F0` border.
- **Level 3 (Modal / Diagnostic Drawers):** Floating sheets and clinical disclaimers. Defined by `0px 12px 28px -6px rgba(31, 41, 51, 0.12)`.

Glassmorphic blurs and chromatic dropshadows are forbidden to ensure clean legibility and prevent visual distraction during critical biometric readouts.

## Shapes

The design system standardizes on a roundedness level of `2`. Geometry balances organic human warmth with clinical discipline:

- **Base Radius (0.5rem / 8px):** Form fields, action buttons, segmented controls, and individual interactive chips.
- **Container Radius (1rem / 16px):** Metric overview cards, biometric reading containers, scan viewports, and modal dialogs.
- **Pill Radius (Full Circle / 9999px):** Biometric category badges (e.g., `Normal / Normal`, `Caution / Precaución`), progress indicator caps, and toggle indicators.

## Components

### Buttons
- **Primary Action:** Solid Deep Teal (`#0F5B5B`) background, Pure White text, 8px border radius, 48px height (surpassing the 44px tap threshold). Typography: `label-lg`.
- **Secondary Action:** Soft Mint (`#E6F4F1`) background with Deep Teal text and an optional subtle border (`1px solid rgba(15, 91, 91, 0.12)`).
- **Destructive / Reset:** Transparent background with Calibrated Rose (`#C4573F`) text and subtle Rose border on active state.

### Cards & Diagnostic Panels
Cards utilize Pure White (`#FFFFFF`) surfaces with a 16px border radius, `1px solid #E2E8F0` stroke, and Level 1 elevation. Internal padding is locked to `space-lg` (24px) for desktop/tablet and `space-md` (16px) for mobile. Metric summary cards feature an inline status chip in the upper-right corner aligned directly with the metric title.

### Chips & Badges
Chips represent BMI tiers and diagnostic labels. They feature a full pill shape (`rounded-full`), 6px vertical padding, 12px horizontal padding, and `label-md` typography.
- **Normal / Saludable:** Emerald background (`#10B981` at 12% opacity) with Emerald text (`#047857`).
- **Overweight / Sobrepeso:** Amber background (`#E8A33D` at 14% opacity) with Amber text (`#B45309`).
- **Alert / Obesidad:** Rose background (`#C4573F` at 12% opacity) with Rose text (`#991B1B`).

### Form Input Fields
Inputs require a minimum height of 48px, 8px border radius, Pure White background, and `1px solid #E2E8F0` resting border. 
- **Focus State:** `1.5px solid #0F5B5B` with an ambient ring: `0 0 0 3px rgba(15, 91, 91, 0.1)`.
- **Unit Affix:** Numeric inputs feature right-aligned unit text (`kg`, `cm`, `lbs`) set in `label-md` Muted Slate (`#5B6B7A`).

### Biometric Range Gauge
A segmented horizontal bar component (8px height, 4px border radius) depicting the 4 BMI bands (Blue, Emerald, Amber, Rose) with proportional widths. The active user coordinate is plotted via a 16px circular marker with a Deep Teal outer ring and a white core.

### Medical Disclaimers
A dedicated notice container built on a Warm Sand variant surface (`#EFECE6`) with a 12px border radius, 12px padding, and 2px left border in Muted Slate. Copy is formatted in `caption` or `body-md` emphasizing preventative context (e.g., "Screening estimate only. Consult a physician for diagnostic evaluation." / "Estimación de tamizaje. Consulte a un médico para evaluación diagnóstica.").