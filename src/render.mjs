import { cp, mkdir } from 'node:fs/promises';
import { dirname, join, resolve } from 'node:path';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { writeTypst } from './generate-typst.mjs';
import { validateFile } from './validate.mjs';

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

export async function buildBook({
  input,
  output = 'dist/book.pdf',
  preview,
  template = 'habit-workbook',
  schema = 'schemas/ebook-layout.v1.schema.json',
  workdir = 'dist/.work'
}) {
  const inputPath = resolve(input);
  const outputPath = resolve(output);
  const schemaPath = resolve(projectRoot, schema);
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
