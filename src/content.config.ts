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

const plantillas = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/plantillas' }),
  schema: z.object({
    categoria: z.enum(['sector', 'personal', 'cliente']),
    sector: z.string().optional(),
    nombre: z.string(),
    descripcion: z.string(),
    estado: z.enum(['publico', 'proximamente', 'privado']),
    colorHex: z.string().optional(),
    origenArchivo: z.string().optional(),
  }),
});

export const collections = { sectores, plantillas };
