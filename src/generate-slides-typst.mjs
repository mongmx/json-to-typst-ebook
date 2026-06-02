import { mkdir, writeFile } from 'node:fs/promises';
import path from 'node:path';

function q(value = '') {
  return JSON.stringify(String(value));
}

function array(values = []) {
  if (!values.length) return '()';
  return `(${values.map(q).join(', ')},)`;
}

function pairs(items = [], leftKey, rightKey) {
  if (!items.length) return '()';
  return `(${items.map((item) => `(${q(item[leftKey])}, ${q(item[rightKey])})`).join(', ')},)`;
}

function columns(values = []) {
  if (!values.length) return '()';
  return `(${values.map((column) => `(${q(column.label)}, ${array(column.items)})`).join(', ')},)`;
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

export function validateSlidesPackage(content) {
  assert(content && typeof content === 'object', 'Slides package must be an object.');
  assert(content.schema_version === 'slides-layout.v1', 'schema_version must be "slides-layout.v1".');
  assert(content.document_type === 'slides', 'document_type must be "slides".');
  assert(content.deck && typeof content.deck === 'object', 'deck is required.');
  assert(typeof content.deck.title === 'string' && content.deck.title.length, 'deck.title is required.');
  assert(Array.isArray(content.slides) && content.slides.length, 'slides must be a non-empty array.');
}

function renderSlide(slide) {
  switch (slide.type) {
    case 'poster':
      return `#slide-poster(` +
        `${q(slide.background_image)}, ` +
        `${q(slide.brand_kicker)}, ` +
        `${q(slide.brand_name)}, ` +
        `${q(slide.quote)}, ` +
        `${q(slide.subtitle)}, ` +
        `footer: ${q(slide.footer)}, ` +
        `overlay: ${slide.overlay ?? 62}%` +
      `)`;
    case 'hero':
      return `#slide-hero(${q(slide.kicker)}, ${q(slide.title)}, ${q(slide.subtitle)}, ${q(slide.footer)})`;
    case 'problem':
      return `#slide-headline-list(${q(slide.title)}, ${q(slide.headline)}, ${array(slide.items)}, tone: "alert")`;
    case 'shift':
      return `#slide-comparison(${q(slide.title)}, ${columns(slide.columns)})`;
    case 'definition':
      return `#slide-definition(${q(slide.title)}, ${q(slide.statement)}, ${array(slide.items)})`;
    case 'architecture':
      return `#slide-flow(${q(slide.title)}, ${array(slide.steps)}, caption: ${q(slide.caption)})`;
    case 'why':
      return `#slide-headline-list(${q(slide.title)}, ${q(slide.headline)}, ${array(slide.items)}, tone: "system")`;
    case 'evolution':
      return `#slide-timeline(${q(slide.title)}, ${pairs(slide.timeline, 'stage', 'description')})`;
    case 'factory':
      return `#slide-mapping(${q(slide.title)}, ${pairs(slide.mapping, 'concept', 'role')}, ${q(slide.statement)})`;
    case 'use_cases':
      return `#slide-grid-list(${q(slide.title)}, ${array(slide.items)})`;
    case 'pipeline':
      return `#slide-pipeline(${q(slide.title)}, ${array(slide.steps)})`;
    case 'vision':
      return `#slide-statement(${q(slide.title)}, ${q(slide.statement)}, footer: ${q(slide.footer)})`;
    case 'closing':
      return `#slide-closing(${q(slide.title)}, ${q(slide.subtitle)}, ${q(slide.cta)}, ${q(slide.url)})`;
    default:
      throw new Error(`Unsupported slide type: ${slide.type}`);
  }
}

export function generateSlidesTypst(slidesPackage) {
  validateSlidesPackage(slidesPackage);

  const source = [
    '#import "theme.typ": setup',
    '#import "components.typ": *',
    '',
    '#show: setup',
    '',
    slidesPackage.slides.map(renderSlide).join('\n#next-slide()\n\n')
  ].join('\n');

  return source;
}

export async function writeSlidesTypst(slidesPackage, outputFile) {
  await mkdir(path.dirname(outputFile), { recursive: true });
  await writeFile(outputFile, generateSlidesTypst(slidesPackage));
}
