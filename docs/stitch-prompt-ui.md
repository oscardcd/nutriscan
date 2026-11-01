# Prompt para Stitch — UI de la app de estado nutricional por imágenes

**Archivo analizado:** `/Users/oscarcorrea/development/projects/universidad/redes/planning-peso-por-imagenes.md`
**Generado:** 2026-11-01
**Uso:** pegar el bloque de abajo en Stitch (texto en inglés = mejores resultados). El alcance de UI sale de las secciones 4, 5 y 12 del planning: 4 bandas OMS, confianza de medición, disclaimer, historial y 100% on-device.

---

## Prompt (copiar desde aquí)

```text
Design a mobile app UI (390x844, iOS/Android, Flutter-ready) for "NutriScan" — an on-device body-composition SCREENING app for adults (18+). It estimates BMI band from guided photos: UNDERWEIGHT / NORMAL / OVERWEIGHT / OBESE. Tone: clinical-calm wellness tool, NOT a medical device. Never imply diagnosis.

VISUAL DIRECTION
- Clean, trustworthy, generous whitespace, soft medical-tech feel.
- Palette: deep teal #0F5B5B (primary), soft mint #E6F4F1 (surfaces), warm sand #F7F5F0 (background), amber #E8A33D (caution), rose #C4573F (high alert), slate #1F2933 (text).
- Typography: Inter / SF Pro. Large numerals for BMI. 8pt spacing scale, 16px radius cards, subtle shadows, no gradients or glassmorphism.
- Full dark mode variant. Accessible contrast, min 44px tap targets, dynamic type support.
- Bottom nav: Home · History · Profile.

SCREENS

1) Welcome / Consent
Hero illustration of a simple body silhouette being outlined by a scan frame. Headline "Know your range, not a number." 3 short value bullets (on-device, no photos uploaded, screening only). Primary CTA "Start assessment". Secondary "Read how it works". Prominent consent card: checkbox "I understand this is a screening tool, not a medical diagnosis" + "I consent to on-device body photo processing".

2) Profile setup (single scroll form)
Fields: height (cm, stepper + numeric), sex (segmented: female / male / prefer not to say), age (number), units toggle (metric/imperial). Inline helper text: "Height is required — it sets the scale for every measurement." CTA "Continue".

3) Guided capture
Full-bleed live camera view with a translucent body-shaped mask overlay and corner brackets. Top bar with close X. Bottom sheet of live hints as small pill chips with icons: "Full body in frame", "Stand 2m away", "Plain background", "Remove bulky clothing". A posture indicator that turns from amber to teal when aligned. Shutter button (large circle) + gallery icon. Secondary toggle "Add side view (recommended)". Small privacy line: "Photos stay on this device".

4) Analyzing
Same camera frame blurred, centered scanning ring animation, step list with checkmarks: Detecting silhouette → Reading posture → Computing indices. Text "About 3 seconds". Cancel link.

5) Low-confidence result
Amber outline card with icon. Headline "We couldn't measure reliably". List of likely causes as chips: poor lighting / partial body / loose clothing. CTA "Retake photo", secondary "Continue anyway (low confidence)".

6) Result — primary screen
Top: large band chip, color-coded, e.g. "OVERWEIGHT" with a thin 4-segment scale bar showing where the estimate falls across the bands. Center: huge estimated BMI number "27.4" with range "±1.8 (estimated)" and a confidence meter labeled HIGH / MEDIUM / LOW.
Below: a small card of anthropometric indices with labels and values: waist-to-height, body roundness, relative fat mass — each with a one-line plain-language explanation.
Then "What this means" paragraph (2–3 lines, non-alarming, mentions muscle mass limitation).
Disclaimer banner (light rose tint): "Screening estimate only. Not a diagnosis. Consult a healthcare professional."
Actions: "See history", "Save to history" (primary), share icon. Sticky footer.

7) History
Header "Your progress". Line chart of estimated BMI over time with shaded confidence band, range selector (3m / 6m / 1y). List of entries: date, band chip, BMI value, confidence dot. Empty state: friendly illustration + "No assessments yet". Swipe-to-delete affordance hint.

8) History detail
Read-only record: photo thumbnail placeholder (masked/private icon), date, band, BMI ± range, confidence, indices table, "Delete this record" destructive link.

9) Profile & settings
Sections: Personal data (height, sex, age — editable rows), Preferences (units, dark mode, reminders), Privacy (On-device processing: ON locked, "Delete all data", "Export data"), About & disclaimer (medical disclaimer full text link, app version). Header card with a neutral avatar.

10) Disclaimer modal
Full-screen sheet, plain language, 4 short paragraphs: what the app does, what it cannot do, why false low results are treated conservatively, when to see a professional. Button "I understand".

Include realistic Spanish UI copy in a second variant of every screen (labels like "Sobrepeso", "IMC estimado", "Confianza alta", "No es un diagnóstico"). Use placeholder data only, no fake medical claims.
```

## Notas

- Stitch solo maqueta: no incluye motor de ML, índices ni cálculo de IMC real.
- Pantallas alineadas a: consentimiento (dato sensible), captura guiada, baja confianza, resultado con IC + disclaimer, historial longitudinal (sección 4 del planning).
- Fuera de alcance por diseño: niños/adolescentes, modo clínico, diagnóstico.
