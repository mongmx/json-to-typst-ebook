import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);

export const ebookSchemaPath = require.resolve(
  '@mongmx/ai-flywheel-content-schemas/schemas/ebook-layout.v1.schema.json'
);

export const slidesSchemaPath = require.resolve(
  '@mongmx/ai-flywheel-content-schemas/schemas/slides-layout.v1.schema.json'
);
