# 096matics — sitio web

Sitio construido con Astro + Tailwind, alojado en Cloudflare Pages.

## Estructura

- `src/pages/index.astro` — página de inicio
- `src/pages/portafolio/` — listado y páginas de ejemplo por sector
- `src/content/sectores/` — un archivo `.md` por sector (esto es lo que hace que añadir una plantilla nueva sea rápido: copia uno existente, cambia los datos)
- `src/components/` — Header, Footer, botón de WhatsApp, bloque de testimonio, tarjeta de sector

## Añadir un sector nuevo

1. Copia cualquier archivo de `src/content/sectores/` (por ejemplo `hosteleria.md`).
2. Cambia el nombre del archivo por el slug del nuevo sector (ej. `clinica-dental.md`).
3. Rellena los campos del frontmatter (título, negocio de ejemplo, resumen, valoración, testimonio) y el texto de abajo.
4. Astro genera automáticamente la página en `/portafolio/clinica-dental` — no hay que tocar código.

## Desarrollo local

```bash
npm install
npm run dev
```

Abre http://localhost:4321

## Desplegar en Cloudflare Pages

1. Sube este proyecto a un repositorio de GitHub.
2. En el panel de Cloudflare Pages, conecta el repositorio.
3. Comando de build: `npm run build`
4. Carpeta de salida: `dist`

Cloudflare detecta Astro automáticamente y rellena estos valores por ti.
