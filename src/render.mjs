import { cp, mkdir } from 'node:fs/promises';
import { basename, dirname, extname, join, resolve } from 'node:path';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { writeTypst } from './generate-typst.mjs';
import { writeSlidesTypst } from './generate-slides-typst.mjs';
import { validateFile } from './validate.mjs';
import { ebookSchemaPath, slidesSchemaPath } from './schema-paths.mjs';

const projectRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');

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
    if (slide.type !== 'poster' || !slide.background_image) continue;

    const sourcePath = resolve(dirname(inputPath), slide.background_image);
    const extension = extname(sourcePath) || extname(slide.background_image) || '.jpg';
    const baseName = basename(sourcePath, extension).replace(/[^a-z0-9]+/gi, '-').replace(/^-|-$/g, '') || 'image';
    const assetName = `${String(assetIndex).padStart(2, '0')}-${baseName}${extension}`;

    await mkdir(assetDir, { recursive: true });
    await cp(sourcePath, join(assetDir, assetName));
    slide.background_image = join('assets', assetName);
    assetIndex += 1;
  }
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
