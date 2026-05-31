import { mkdir, writeFile } from 'node:fs/promises';
import path from 'node:path';

const categoryTints = {
  business: 'blue-soft',
  money: 'green-soft',
  health: 'red-soft',
  relationships: 'purple-soft',
  work: 'blue-soft',
  career: 'blue-soft',
  learning: 'purple-soft',
  default: 'blue-soft'
};

const categoryLabels = {
  business: 'B',
  money: '$',
  health: '+',
  relationships: 'R',
  work: 'W',
  career: 'C',
  learning: 'L',
  default: '*'
};

function q(value = '') {
  return JSON.stringify(String(value));
}

function key(value = '') {
  return String(value).toLowerCase().replace(/[^a-z]+/g, '');
}

function array(values = []) {
  if (!values.length) return '()';
  return `(${values.map(q).join(', ')},)`;
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function validateContentPackage(content) {
  assert(content && typeof content === 'object', 'Content package must be an object.');
  assert(content.schema_version === 'ebook-layout.v1', 'schema_version must be "ebook-layout.v1".');
  assert(content.book && typeof content.book === 'object', 'book is required.');
  assert(typeof content.book.title === 'string' && content.book.title.length, 'book.title is required.');
  assert(typeof content.book.description === 'string' && content.book.description.length, 'book.description is required.');
  assert(Array.isArray(content.chapters) && content.chapters.length, 'chapters must be a non-empty array.');

  for (const chapter of content.chapters) {
    assert(typeof chapter.id === 'string' && chapter.id.length, 'chapter.id is required.');
    assert(Number.isInteger(chapter.order), `chapter.order must be an integer for ${chapter.id}.`);
    assert(typeof chapter.slug === 'string' && chapter.slug.length, `chapter.slug is required for ${chapter.id}.`);
    assert(typeof chapter.title === 'string' && chapter.title.length, `chapter.title is required for ${chapter.id}.`);
    assert(chapter.sections && typeof chapter.sections === 'object', `chapter.sections is required for ${chapter.id}.`);

    for (const sectionName of ['hook', 'concept']) {
      assert(Array.isArray(chapter.sections[sectionName]?.blocks), `${chapter.id}.sections.${sectionName}.blocks is required.`);
    }

    assert(Array.isArray(chapter.sections.examples), `${chapter.id}.sections.examples must be an array.`);
    assert(Array.isArray(chapter.sections.drills), `${chapter.id}.sections.drills must be an array.`);

    for (const drill of chapter.sections.drills) {
      assert(Number.isInteger(drill.number), `${chapter.id} drill.number must be an integer.`);
      assert(typeof drill.title === 'string' && drill.title.length, `${chapter.id} drill.title is required.`);
      assert(Array.isArray(drill.blocks), `${chapter.id} drill.blocks must be an array.`);
    }
  }
}

function paragraphTexts(blocks = []) {
  return blocks
    .filter((block) => block.type === 'paragraph' && typeof block.text === 'string')
    .map((block) => block.text);
}

function blockContent(blocks = [], size = '9.8pt') {
  const pieces = [];

  for (const block of blocks) {
    if (block.type === 'paragraph' && block.text) {
      pieces.push(`#para-stack((${q(block.text)},), size: ${size})`);
    }

    if (block.type === 'unordered_list') {
      pieces.push(`#bullet-stack(${array(block.items)}, size: ${size})`);
    }

    if (block.type === 'ordered_list') {
      pieces.push(`#ordered-stack(${array(block.items)}, size: ${size})`);
    }
  }

  return pieces.length ? pieces.join('\n') : '[]';
}

function splitList(items = []) {
  const midpoint = Math.ceil(items.length / 2);
  return [items.slice(0, midpoint), items.slice(midpoint)];
}

function drillParts(drill) {
  const blocks = drill.blocks.filter((block) => block.type !== 'paragraph' || block.text);
  const listBlocks = blocks.filter((block) => block.type === 'unordered_list' || block.type === 'ordered_list');
  const paragraphs = blocks.filter((block) => block.type === 'paragraph' && block.text !== 'Examples:');
  const foundPromptIndex = paragraphs.findIndex(
    (block) => block.text.includes('?') || block.text.startsWith('"')
  );
  const promptIndex = foundPromptIndex >= 0 ? foundPromptIndex : Math.min(1, paragraphs.length - 1);
  const introIndex = promptIndex > 0 && /(answer|ask|question|write|list|complete)/i.test(paragraphs[promptIndex - 1].text)
    ? promptIndex - 1
    : -1;
  const leadEnd = introIndex >= 0 ? introIndex : promptIndex;
  const lead = paragraphs.slice(0, leadEnd).map((block) => block.text);
  const prompt = [
    ...(introIndex >= 0 ? [paragraphs[introIndex].text] : []),
    paragraphs[promptIndex]?.text || paragraphs[0]?.text || drill.title
  ];
  const afterPrompt = paragraphs.slice(promptIndex + 1).map((block) => block.text);
  const note = afterPrompt.length > 3 ? afterPrompt.at(-1) : null;
  const rows = note ? afterPrompt.slice(0, -1) : afterPrompt;
  const exampleBlock = listBlocks[0] || { items: [] };
  const [left, right] = splitList(exampleBlock.items || []);

  return {
    lead,
    prompt,
    examplesLeft: left,
    examplesRight: right,
    rows: rows.length ? rows : (listBlocks[1]?.items || []).slice(0, 4),
    note
  };
}

function renderChapter(chapter) {
  const number = String(chapter.order).padStart(2, '0');
  const toolTexts = paragraphTexts(chapter.sections.concept.blocks);
  const intro = toolTexts.slice(3, 5);
  const quote = toolTexts[5] ? [toolTexts[5]] : toolTexts.slice(-2, -1);
  const insight = toolTexts[6] ? [toolTexts[6]] : toolTexts.slice(-1);

  const examples = chapter.sections.examples.map((example) => {
    const categoryKey = key(example.category);
    const tint = categoryTints[categoryKey] || categoryTints.default;
    const label = categoryLabels[categoryKey] || categoryLabels.default;
    return [
      `#example-card(${q(example.category)}, ${q(label)}, ${tint})[`,
      blockContent(example.blocks, '8.3pt'),
      ']'
    ].join('\n');
  }).join('\n#v(4.5mm)\n');

  const drills = chapter.sections.drills.map((drill) => {
    const parts = drillParts(drill);
    const rows = parts.rows.slice(0, 4).map((row, index) => {
      const labels = ['P', '@', 'V', '+'];
      return `#write-row(${q(labels[index] || '+')}, ${q(row)})`;
    }).join('\n');

    return [
      `#drill-page(`,
      `  ${q(String(drill.number))},`,
      `  ${q(drill.title)},`,
      `  para-stack(${array(parts.lead)}, size: 9.3pt),`,
      `  para-stack(${array(parts.prompt)}, size: 10.2pt),`,
      `  examples-strip(`,
      `    bullet-stack(${array(parts.examplesLeft)}, size: 8.8pt),`,
      `    bullet-stack(${array(parts.examplesRight)}, size: 8.8pt),`,
      `  ),`,
      `  [${rows}],`,
      parts.note ? `  note: ${q(parts.note)},` : '',
      `)`,
      `#next-page()`
    ].filter(Boolean).join('\n');
  }).join('\n\n');

  const reflectionPrompts = chapter.sections.reflection?.prompts || [
    'What did I learn from this drill?',
    'Which causes are most common in my life?',
    'What will I do differently?'
  ];
  const reflectionClosing = chapter.sections.reflection?.closing || 'Small prevention today creates big freedom tomorrow.';

  return [
    `#chapter-opener(`,
    `  ${q(number)},`,
    `  ${q(chapter.title)},`,
    `  para-stack(${array(paragraphTexts(chapter.sections.hook.blocks))}, size: 10.5pt),`,
    `  para-stack(${array(toolTexts.slice(0, 3))}, size: 9.8pt),`,
    `)`,
    `#next-page()`,
    '',
    `#callout-page(`,
    `  ${q(number)},`,
    `  ${q(chapter.title)},`,
    `  para-stack(${array(intro)}, size: 10.5pt),`,
    `  para-stack(${array(quote)}, size: 11pt),`,
    `  para-stack(${array(insight)}, size: 11pt),`,
    `)`,
    `#next-page()`,
    '',
    `#examples-page[`,
    examples,
    `]`,
    `#next-page()`,
    '',
    drills,
    '',
    `#reflection-page(`,
    `  (${reflectionPrompts.map((prompt) => `[${prompt}]`).join(', ')},),`,
    `  [${reflectionClosing}],`,
    `)`
  ].join('\n');
}

export { validateContentPackage };

export function generateTypst(contentPackage) {
  validateContentPackage(contentPackage);

  const tocEntries = contentPackage.chapters.map((chapter) => [
  String(chapter.order).padStart(2, '0'),
  chapter.title
]);

const source = [
  '#import "theme.typ": setup, blue-soft, green-soft, red-soft, purple-soft',
  '#import "components.typ": *',
  '',
  '#show: setup',
  '',
  '#cover()',
  '#next-page()',
  '',
  `#toc-page(${JSON.stringify(tocEntries).replaceAll('[', '(').replaceAll(']', ')')})`,
  '#next-page()',
  '',
  contentPackage.chapters.map(renderChapter).join('\n#next-page()\n\n')
].join('\n');

  return source;
}

export async function writeTypst(contentPackage, outputFile) {
  await mkdir(path.dirname(outputFile), { recursive: true });
  await writeFile(outputFile, generateTypst(contentPackage));
}
