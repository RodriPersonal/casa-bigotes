# Casa Bigotes

Escaparate editorial estático para recomendaciones de gatos de interior. No vende ni almacena productos propios.

## Sitio publicado

https://rodripersonal.github.io/casa-bigotes/

## Estructura

- `index.html`: portada y tarjetas de guías.
- `guias/`: hub (`index.html`) y 10 guías de 1.000–1.300 palabras (FAQ, tabla, lista de comprobación).
- `og-image.png`: imagen social 1200×630.
- `transparencia.html`: afiliación, privacidad y contacto.
- `sobre-nosotros.html`: forma de trabajo y contacto.
- `styles.css`: diseño responsive y accesibilidad.
- `verify.ps1`: comprobaciones locales sin dependencias.

## Afiliación

Casa Bigotes participa en Amazon Afiliados España con el ID `casabigotes-21`. Actualmente no hay enlaces de afiliado publicados. Toda guía que incorpore enlaces debe añadir un `.aff-note` con la frase oficial de Amazon inmediatamente antes del primer enlace. Cada enlace debe llevar `rel="sponsored nofollow noopener"` y `target="_blank"`.

## Cómo añadir una guía

1. Crear el HTML con `lang="es"`, título ≤60 caracteres, meta description de 120–158, canonical, Open Graph, Twitter Card, JSON-LD (Article, BreadcrumbList, FAQPage) y migas de pan visibles. Mínimo 1.000 palabras en `.article-body`.
2. Añadir la guía al sitemap con su `lastmod` real.
3. Añadirla al hub `guias/index.html` y, si es reciente, a las tarjetas de la portada.
4. Añadir enlaces relacionados sin autoenlace y al menos 2 enlaces internos dentro del texto.
5. Añadir el aviso `.aff-note` si contiene afiliación.
6. Ejecutar `verify.ps1`.
7. Revisar el diff y solo después publicar.

## Privacidad y presupuesto

El sitio no usa analítica, cookies propias ni dependencias externas. El proyecto no compra inventario, muestras, dominios, anuncios ni aplicaciones de pago. Shopify permanece privado; GitHub Pages es el escaparate público.

La página `404.html` usa rutas absolutas `/casa-bigotes/` porque el sitio se sirve como GitHub Pages de proyecto.

## Contacto y bots

El email se monta con un pequeño script inline (`.mail`) para que no aparezca en texto plano en el HTML; con JavaScript desactivado se muestra con «[arroba]» y «[punto]».

## Search Console

En `index.html` hay un marcador `<!-- GSC-META-AQUI -->` en el `<head>`: ahí se pega la etiqueta de verificación de Google Search Console cuando se obtenga.

## Verificación

`powershell -ExecutionPolicy Bypass -File verify.ps1` comprueba enlaces internos, sitemap, canonical, longitud de título y descripción, un solo `h1`, `og:image`, JSON-LD válido, mínimo de 1.000 palabras por guía, 3 enlaces entrantes por página, ausencia de mojibake y `rel` de enlaces a Amazon.
