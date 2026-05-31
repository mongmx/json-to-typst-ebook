#!/usr/bin/env node
import { resolve } from 'node:path';
import { validateFile } from './validate.mjs';
import { buildBook } from './render.mjs';

function parseArgs(argv) {
  const positional = [];
  const flags = new Map();

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];
    if (arg.startsWith('--')) {
      flags.set(arg.slice(2), argv[index + 1]);
      index += 1;
    } else {
      positional.push(arg);
    }
  }

  return { positional, flags };
}

function usage() {
  console.log(`Usage:
  ebook-layout validate <content.json>
  ebook-layout build --input <content.json> --output <book.pdf> [--preview <pages-dir>] [--template habit-workbook]`);
}

const { positional, flags } = parseArgs(process.argv.slice(2));
const command = positional[0];

try {
  if (command === 'validate') {
    const input = positional[1];
    if (!input) {
      usage();
      process.exit(1);
    }

    await validateFile(resolve(input), resolve('schemas/ebook-layout.v1.schema.json'));
    console.log('Content package is valid.');
  } else if (command === 'build') {
    const input = flags.get('input');
    if (!input) {
      usage();
      process.exit(1);
    }

    await buildBook({
      input,
      output: flags.get('output') || 'dist/book.pdf',
      preview: flags.get('preview'),
      template: flags.get('template') || 'habit-workbook'
    });
  } else {
    usage();
    process.exit(command ? 1 : 0);
  }
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
