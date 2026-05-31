# JSON to Typst Ebook

A JSON-to-Typst ebook layout engine for AI-generated workbook and nonfiction content.

This project accepts a structured content package, validates it against a public JSON schema, generates Typst source, and compiles it into a PDF ebook with optional PNG page previews.

It is designed for workflows where one agent writes or structures the content, and this engine handles layout, pagination, and export.

## Pipeline

```text
Content Agent
  -> ebook-layout.v1 JSON
  -> schema validation
  -> Typst generation
  -> Typst compile
  -> PDF + PNG previews
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
npm run build:example
npm run build:modern
```

Outputs:

- `dist/habit-design.pdf`
- `dist/habit-design-modern.pdf`
- `dist/pages/page-001.png`, etc.

## CLI

```sh
ebook-layout validate examples/habit-design/content.json

ebook-layout build \
  --input examples/habit-design/content.json \
  --template habit-workbook \
  --output dist/habit-design.pdf \
  --preview dist/pages
```

Available templates:

- `habit-workbook`: clean practical workbook layout
- `modern-workbook`: contemporary editorial workbook layout with softer cards and teal accents

## Content Contract

The upstream content agent must produce JSON matching:

```text
schemas/ebook-layout.v1.schema.json
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

## Repository Layout

```text
schemas/
  ebook-layout.v1.schema.json
  examples/
src/
  cli.mjs
  generate-typst.mjs
  render.mjs
  validate.mjs
templates/
  habit-workbook/
  modern-workbook/
examples/
  habit-design/
dist/
```

## Roadmap

- v0.1: one schema, one template, PDF and PNG output
- v0.2: multiple templates and themes
- v0.3: better diagnostics and visual QA helpers
- v0.4: multilingual layout support
- v0.5: template plugin API
