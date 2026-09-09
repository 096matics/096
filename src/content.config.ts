import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const sectores = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/sectores' }),
  schema: z.object({
    titulo: z.string(),
    negocioEjemplo: z.string(),
    colorHex: z.string(),
    resumen: z.string(),
    valoracion: z.string(),
    testimonioTexto: z.string(),
    testimonioAutor: z.string(),
    testimonioNegocio: z.string(),
  }),
});

export const collections = { sectores };
