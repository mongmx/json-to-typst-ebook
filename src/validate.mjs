import { readFile } from 'node:fs/promises';
import Ajv2020 from 'ajv/dist/2020.js';

export async function loadJson(filePath) {
  return JSON.parse(await readFile(filePath, 'utf8'));
}

export async function validateFile(inputPath, schemaPath) {
  const [content, schema] = await Promise.all([
    loadJson(inputPath),
    loadJson(schemaPath)
  ]);
  const ajv = new Ajv2020({ allErrors: true, strict: false });
  const validate = ajv.compile(schema);
  const valid = validate(content);

  if (!valid) {
    const details = validate.errors
      .map((error) => {
        const location = error.instancePath || '/';
        return `${location} ${error.message}`;
      })
      .join('\n');
    throw new Error(`Content package failed validation:\n${details}`);
  }

  return content;
}
