# Alcance del proyecto: InmoConecta

## Problema que resuelve

La comercialización de propiedades suele estar fragmentada entre publicaciones informales, datos incompletos y acuerdos de comisión que no quedan claramente registrados. InmoConecta centraliza la oferta inmobiliaria y permite documentar la participación de las dos puntas de una venta para calcular una distribución transparente de la comisión.

## Usuario objetivo

La aplicación está dirigida principalmente a agentes inmobiliarios independientes y pequeñas agencias que comercializan propiedades residenciales en Colombia. También podrán usarla propietarios que desean publicar directamente un inmueble y personas interesadas en comprar, quienes consultarán la oferta y solicitarán contacto con el responsable de cada publicación.

## Funcionalidades mínimas (MVP)

- Registrar e iniciar sesión con correo electrónico y seleccionar un rol: agente inmobiliario, propietario o comprador.
- Crear, editar, publicar y desactivar propiedades con precio, tipo de inmueble, ubicación, descripción, características e imágenes.
- Consultar el catálogo de propiedades y filtrarlo por ciudad, tipo de inmueble, rango de precio y estado de disponibilidad.
- Ver el detalle de una propiedad, guardarla como favorita y enviar una solicitud de contacto o visita al agente o propietario responsable.
- Registrar una oportunidad de venta asociando la propiedad, la punta captadora y la punta colocadora; definir la comisión total y calcular el valor correspondiente a cada punta según el porcentaje acordado.
- Actualizar el estado de la propiedad y de la oportunidad (`publicada`, `reservada` o `vendida`) y conservar en la nube el resumen de la operación y de la distribución calculada.

## Qué queda fuera de alcance

- Procesar pagos, custodiar dinero o transferir automáticamente comisiones; el MVP solo calcula y registra su distribución.
- Elaborar contratos, autenticar documentos o realizar trámites notariales, registrales, tributarios o de crédito hipotecario.
- Incluir arriendos, inmuebles comerciales o proyectos de construcción; la primera versión se concentra en la compraventa de vivienda usada.
- Incorporar avalúos automáticos, recorridos virtuales, firma electrónica, chat en tiempo real o recomendaciones mediante inteligencia artificial.
- Desarrollar versiones web o de escritorio, un panel administrativo avanzado o integraciones con bancos, notarías, catastros, portales externos y sistemas CRM.

## Stack

- **Aplicación móvil:** Flutter y Dart.
- **Control de versiones:** Git y repositorio público en GitHub.
- **Autenticación:** Firebase Authentication con correo electrónico y contraseña.
- **Datos:** Cloud Firestore para usuarios, propiedades, favoritos, solicitudes de contacto y oportunidades de venta.
- **Archivos:** Firebase Storage para las imágenes de las propiedades.
- **Arquitectura:** Clean Architecture por capas, Riverpod para el manejo de estado y `go_router` para la navegación.
- **Seguridad:** reglas de acceso de Firebase basadas en autenticación, rol y propiedad de los registros.

