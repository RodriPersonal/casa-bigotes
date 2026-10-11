# Casa Bigotes

Escaparate editorial estático para recomendaciones de gatos de interior. No vende ni almacena productos propios.

## Sitio publicado

https://rodripersonal.github.io/casa-bigotes/

## Estructura

- `index.html`: portada y tarjetas de guías.
- `guias/`: artículos editoriales.
- `transparencia.html`: afiliación, privacidad y contacto.
- `sobre-nosotros.html`: forma de trabajo y contacto.
- `styles.css`: diseño responsive y accesibilidad.
- `verify.ps1`: comprobaciones locales sin dependencias.

## Afiliación

Casa Bigotes participa en Amazon Afiliados España con el ID `casabigotes-21`. Actualmente no hay enlaces de afiliado publicados. Toda guía que incorpore enlaces debe añadir un `.aff-note` con la frase oficial de Amazon inmediatamente antes del primer enlace. Cada enlace debe llevar `rel="sponsored nofollow noopener"` y `target="_blank"`.

## Cómo añadir una guía

1. Crear el HTML con `lang="es"`, título único, meta description, canonical, Open Graph, Twitter Card y JSON-LD.
2. Añadir la guía al sitemap.
3. Añadir una tarjeta en la portada.
4. Añadir enlaces relacionados sin autoenlace.
5. Añadir el aviso `.aff-note` si contiene afiliación.
6. Ejecutar `verify.ps1`.
7. Revisar el diff y solo después publicar.

## Privacidad y presupuesto

El sitio no usa analítica, cookies propias ni dependencias externas. El proyecto no compra inventario, muestras, dominios, anuncios ni aplicaciones de pago. Shopify permanece privado; GitHub Pages es el escaparate público.

La página `404.html` usa rutas absolutas `/casa-bigotes/` porque el sitio se sirve como GitHub Pages de proyecto.
