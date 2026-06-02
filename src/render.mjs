import { cp, mkdir, writeFile } from 'node:fs/promises';
import { basename, dirname, extname, join, resolve } from 'node:path';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { writeTypst } from './generate-typst.mjs';
import { writeSlidesTypst } from './generate-slides-typst.mjs';
import { validateFile } from './validate.mjs';
import { ebookSchemaPath, slidesSchemaPath } from './schema-paths.mjs';

const projectRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const imageExtensions = new Set(['.jpg', '.jpeg', '.png', '.webp']);

function run(command, args) {
  return new Promise((resolvePromise, reject) => {
    const child = spawn(command, args, { stdio: 'inherit' });
    child.on('close', (code) => {
      if (code === 0) resolvePromise();
      else reject(new Error(`${command} exited with code ${code}`));
    });
  });
}

async function prepareSlideAssets(content, inputPath, workdirPath) {
  const assetDir = join(workdirPath, 'assets');
  let assetIndex = 1;

  for (const slide of content.slides || []) {
    if (slide.type !== 'poster') continue;

    const source = await preparePosterImageSource(slide, inputPath);
    if (!source) continue;

    const extension = source.extension;
    const baseName = source.baseName.replace(/[^a-z0-9]+/gi, '-').replace(/^-|-$/g, '') || 'image';
    const assetName = `${String(assetIndex).padStart(2, '0')}-${baseName}${extension}`;

    await mkdir(assetDir, { recursive: true });
    if (source.type === 'url') {
      await downloadImage(source.url, join(assetDir, assetName));
    } else {
      await cp(source.path, join(assetDir, assetName));
    }
    slide.background_image = join('assets', assetName);
    assetIndex += 1;
  }
}

async function preparePosterImageSource(slide, inputPath) {
  if (slide.background_image_url) {
    const url = parseImageUrl(slide.background_image_url);
    return {
      type: 'url',
      url,
      extension: imageExtension(url.pathname),
      baseName: basename(url.pathname, extname(url.pathname)) || 'remote-image'
    };
  }

  if (!slide.background_image) return null;

  const sourcePath = resolve(dirname(inputPath), slide.background_image);
  return {
    type: 'file',
    path: sourcePath,
    extension: imageExtension(sourcePath),
    baseName: basename(sourcePath, extname(sourcePath))
  };
}

function parseImageUrl(value) {
  const url = new URL(value);
  if (url.protocol !== 'https:') {
    throw new Error(`background_image_url must use https: ${value}`);
  }
  return url;
}

function imageExtension(value) {
  const extension = extname(value).toLowerCase();
  if (!imageExtensions.has(extension)) {
    throw new Error(`Background image must use one of: ${Array.from(imageExtensions).join(', ')}`);
  }
  return extension;
}

async function downloadImage(url, outputPath) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Failed to download background image: ${url} (${response.status} ${response.statusText})`);
  }

  const contentType = response.headers.get('content-type') || '';
  if (contentType && !contentType.startsWith('image/')) {
    throw new Error(`background_image_url did not return an image content type: ${contentType}`);
  }

  const bytes = Buffer.from(await response.arrayBuffer());
  await writeFile(outputPath, bytes);
}

function formatNumber(value) {
  return Number(value.toFixed(4)).toString();
}

function safeTypstLength(value, fallback) {
  if (typeof value !== 'string') return fallback;
  return /^[0-9]+(?:\.[0-9]+)?(?:pt|mm|cm|in)$/.test(value) ? value : fallback;
}

function slidePageSize(content) {
  const output = content.output || {};

  if (Number.isFinite(output.width_px) && Number.isFinite(output.height_px)) {
    const dpi = Number.isFinite(output.dpi) && output.dpi > 0 ? output.dpi : 144;
    return {
      width: `${formatNumber(output.width_px / dpi)}in`,
      height: `${formatNumber(output.height_px / dpi)}in`
    };
  }

  return {
    width: safeTypstLength(content.layout?.width, '13.333in'),
    height: safeTypstLength(content.layout?.height, '7.5in')
  };
}

async function writeSlidesConfig(content, outputFile) {
  const { width, height } = slidePageSize(content);
  const source = [
    `#let page-width = ${width}`,
    `#let page-height = ${height}`,
    ''
  ].join('\n');

  await writeFile(outputFile, source);
}

export async function buildBook({
  input,
  output = 'dist/book.pdf',
  preview,
  template = 'habit-workbook',
  schema = ebookSchemaPath,
  workdir = 'dist/.work'
}) {
  const inputPath = resolve(input);
  const outputPath = resolve(output);
  const schemaPath = resolve(schema);
  const workdirPath = resolve(workdir);
  const templatePath = resolve(projectRoot, 'templates', template);
  const content = await validateFile(inputPath, schemaPath);

  await mkdir(workdirPath, { recursive: true });
  await cp(join(templatePath, 'theme.typ'), join(workdirPath, 'theme.typ'));
  await cp(join(templatePath, 'components.typ'), join(workdirPath, 'components.typ'));
  await writeTypst(content, join(workdirPath, 'book.typ'));
  await mkdir(dirname(outputPath), { recursive: true });
  await run('typst', ['compile', join(workdirPath, 'book.typ'), outputPath]);

  if (preview) {
    const previewPath = resolve(preview);
    await mkdir(previewPath, { recursive: true });
    await run('typst', ['compile', join(workdirPath, 'book.typ'), join(previewPath, 'page-{n}.png')]);
  }
}

export async function buildSlides({
  input,
  output = 'dist/slides.pdf',
  preview,
  template = 'quiet-power-slides',
  schema = slidesSchemaPath,
  workdir = 'dist/.work-slides'
}) {
  const inputPath = resolve(input);
  const outputPath = resolve(output);
  const schemaPath = resolve(schema);
  const workdirPath = resolve(workdir);
  const templatePath = resolve(projectRoot, 'templates', template);
  const content = await validateFile(inputPath, schemaPath);

  await mkdir(workdirPath, { recursive: true });
  await prepareSlideAssets(content, inputPath, workdirPath);
  await writeSlidesConfig(content, join(workdirPath, 'config.typ'));
  await cp(join(templatePath, 'theme.typ'), join(workdirPath, 'theme.typ'));
  await cp(join(templatePath, 'components.typ'), join(workdirPath, 'components.typ'));
  await writeSlidesTypst(content, join(workdirPath, 'slides.typ'));
  await mkdir(dirname(outputPath), { recursive: true });
  await run('typst', ['compile', join(workdirPath, 'slides.typ'), outputPath]);

  if (preview) {
    const previewPath = resolve(preview);
    await mkdir(previewPath, { recursive: true });
    await run('typst', ['compile', join(workdirPath, 'slides.typ'), join(previewPath, 'slide-{n}.png')]);
  }
}
