# JSON to Typst Ebook

A JSON-to-Typst publishing layout engine for AI-generated workbook, nonfiction, and slide content.

This project accepts a structured content package, validates it against a public JSON schema, generates Typst source, and compiles it into PDF outputs with optional PNG page previews.

It is designed for workflows where one agent writes or structures the content, and this engine handles layout, pagination, and export.

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
```

Outputs:

- `dist/habit-design.pdf`
- `dist/habit-design-modern.pdf`
- `dist/habit-design-classic.pdf`
- `dist/habit-design-modern-classic.pdf`
- `dist/layout-as-code-slides.pdf`
- `dist/pages/page-001.png`, etc.

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
```

Available templates:

- `habit-workbook`: clean practical workbook layout
- `modern-workbook`: contemporary editorial workbook layout with softer cards and teal accents
- `classic-textbook`: classic textbook layout with serif typography, generous margins, and simple rules
- `modern-classic-textbook`: white, spacious textbook layout with modern sans-serif typography
- `quiet-power-slides`: quiet 16:9 presentation layout for publishing infrastructure stories

## Content Contract

The upstream content agent must produce JSON matching:

```text
schemas/ebook-layout.v1.schema.json
schemas/slides-layout.v1.schema.json
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

## Repository Layout

```text
schemas/
  ebook-layout.v1.schema.json
  slides-layout.v1.schema.json
  examples/
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
dist/
```

## Roadmap

- v0.1: one schema, one template, PDF and PNG output
- v0.2: multiple templates and themes
- v0.3: better diagnostics and visual QA helpers
- v0.4: multilingual layout support
- v0.5: template plugin API
