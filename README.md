# JSON to Typst Ebook

A JSON-to-Typst publishing engine for AI-generated ebooks, workbooks, slide decks, and visual content.

This project accepts structured content packages, validates them against the shared AI Flywheel content schemas, generates Typst source, and compiles them into PDF outputs with optional PNG page previews.

It is designed for workflows where one agent writes or structures the content, and this engine handles layout, pagination, visual composition, and export.

## Pipeline

```text
Content Agent
  -> ebook-layout.v1 JSON
  -> schema validation
  -> Typst generation
  -> Typst compile
  -> PDF + PNG previews

Content Agent
  -> slides-layout.v1 JSON
  -> schema validation
  -> Typst generation
  -> Typst compile
  -> PDF slides + PNG previews

Content Agent
  -> poster slide JSON
  -> image asset preparation
  -> Typst visual composition
  -> PDF poster + PNG preview
```

## Requirements

- Node.js 16.14+
- Typst CLI

```sh
typst --version
```

## Install

```sh
npm install
```

## Quick Start

```sh
npm run validate
npm run validate:slides
npm run build:example
npm run build:modern
npm run build:classic
npm run build:modern-classic
npm run build:slides
npm run validate:poster
npm run build:poster
```

Outputs:

- `dist/habit-design.pdf`
- `dist/habit-design-modern.pdf`
- `dist/habit-design-classic.pdf`
- `dist/habit-design-modern-classic.pdf`
- `dist/layout-as-code-slides.pdf`
- `dist/poster-design.pdf`
- `dist/pages/page-001.png`, etc.
- `dist/layout-as-code-slides-pages/slide-1.png`, etc.
- `dist/poster-design-pages/slide-1.png`

## CLI

```sh
ebook-layout validate examples/habit-design/content.json

ebook-layout build \
  --input examples/habit-design/content.json \
  --template habit-workbook \
  --output dist/habit-design.pdf \
  --preview dist/pages

ebook-layout validate-slides examples/layout-as-code-slides/content.json

ebook-layout build-slides \
  --input examples/layout-as-code-slides/content.json \
  --template quiet-power-slides \
  --output dist/layout-as-code-slides.pdf \
  --preview dist/layout-as-code-slides-pages

ebook-layout validate-slides examples/poster-design/content.json

ebook-layout build-slides \
  --input examples/poster-design/content.json \
  --template quiet-power-slides \
  --output dist/poster-design.pdf \
  --preview dist/poster-design-pages
```

Available templates:

- `habit-workbook`: clean practical workbook layout
- `modern-workbook`: contemporary editorial workbook layout with softer cards and teal accents
- `classic-textbook`: classic textbook layout with serif typography, generous margins, and simple rules
- `modern-classic-textbook`: white, spacious textbook layout with modern sans-serif typography
- `quiet-power-slides`: quiet 16:9 presentation layout for publishing infrastructure stories

Supported slide content includes hero slides, structured presentation slides, closing slides, and poster-style visual slides with full-bleed background images and text overlays.

## Content Contract

The upstream content agent must produce JSON matching:

```text
@mongmx/ai-flywheel-content-schemas/schemas/ebook-layout.v1.schema.json
@mongmx/ai-flywheel-content-schemas/schemas/slides-layout.v1.schema.json
```

The schemas live in the shared repository:

```text
https://github.com/mongmx/ai-flywheel-content-schemas
```

Minimal shape:

```json
{
  "schema_version": "ebook-layout.v1",
  "book": {
    "title": "Book Title",
    "description": "Short book description"
  },
  "layout": {
    "template": "habit-workbook",
    "theme": "navy-yellow",
    "page_size": "a4"
  },
  "chapters": []
}
```

Minimal slides shape:

```json
{
  "schema_version": "slides-layout.v1",
  "document_type": "slides",
  "deck": {
    "title": "Deck Title"
  },
  "layout": {
    "template": "quiet-power-slides",
    "theme": "quiet-power",
    "page_size": "16:9"
  },
  "slides": []
}
```

Poster-style visual content uses the same `slides-layout.v1` contract with `type: "poster"`:

```json
{
  "type": "poster",
  "title": "ดวงอาทิตย์",
  "background_image": "1000004194.jpg",
  "brand_kicker": "iKL",
  "brand_name": "STUDIO",
  "quote": "ดวงอาทิตย์\nต่อให้มันร้อนแรงแค่ไหน",
  "subtitle": "สุดท้ายมันก็มีวันที่ต้องดับ",
  "footer": "iKL Studio",
  "overlay": 58
}
```

Poster background images are resolved relative to the input JSON file and copied into the Typst work directory during build, so examples can keep images beside their `content.json`.

## Repository Layout

```text
src/
  cli.mjs
  generate-slides-typst.mjs
  generate-typst.mjs
  render.mjs
  validate.mjs
templates/
  habit-workbook/
  classic-textbook/
  modern-classic-textbook/
  modern-workbook/
  quiet-power-slides/
examples/
  habit-design/
  layout-as-code-slides/
  poster-design/
dist/
```

## Roadmap

- v0.1: one schema, one template, PDF and PNG output
- v0.2: multiple templates and themes
- v0.3: slide deck generation and poster-style visual content
- v0.4: better diagnostics and visual QA helpers
- v0.5: multilingual layout support
- v0.6: template plugin API
