# Plan de prealfa web

## Objetivo

Probar con el maestro y un grupo pequeño de instructores si la agenda sirve para organizar el trabajo real de la escuela. Esta fase busca feedback sobre calendario, clases, cursos, salas y horarios recurrentes; no pretende probar la gestión del alumnado ni sustituir la app móvil.

Grupo sugerido: el maestro y 2–4 instructores durante una o dos semanas. Empezar con datos ficticios que representen una semana habitual. No cargar información personal real del alumnado.

## Roles acordados

| Rol | Uso en la prealfa | Permisos |
| --- | --- | --- |
| `ADMIN` | Una única cuenta de intervención, custodiada por el equipo de desarrollo | Acceso total de gestión, incluida la sección provisional Datos. No se crean cuentas ADMIN para maestros, instructores ni alumnos. |
| `INSTRUCTOR` | Cuenta individual para el maestro y cada instructor participante | Consultar y gestionar sesiones, cursos, horarios recurrentes y salas. Sin acceso al editor genérico de Datos ni a datos personales de alumnos. |
| `USER` | No se usa en la web | Se conserva en la API para futuros flujos de la app de alumnos. El inicio de sesión web lo rechaza. |

No hay un rol supremo, niveles distintos de instructor ni capacidades adicionales que activar. La base de datos impone una sola cuenta ADMIN. La web no ofrece registro público; las cuentas de instructores se preparan antes de invitar al grupo.

## Plan y estado

### 1. Modelo de acceso y permisos — implementado

- [x] Mantener los tres roles existentes y adoptar el uso acordado.
- [x] Dar a `INSTRUCTOR` gestión completa del calendario, incluidos cursos, recurrencias y salas.
- [x] Reservar `/api/database` y la pantalla Datos a `ADMIN`; los instructores reciben solo los datos mínimos de agenda que necesitan.
- [x] Rechazar `USER` en el login web y cerrar su sesión web; conservar el rol en el backend para la futura app.
- [x] Impedir crear una segunda cuenta ADMIN desde la API y evitar borrar la única cuenta.
- [x] Añadir una restricción de base de datos que limita ADMIN a una cuenta.
- [x] Retirar el endpoint HTTP de migración; usar el arranque del backend o `npm run db:migrate`.
- [x] Añadir `npm run admin:create` para el alta inicial segura: comprueba que no exista otra cuenta, aplica migraciones pendientes y solicita la contraseña sin mostrarla.

### 2. Pruebas automatizadas — implementado en web y backend

- [x] Backend: cobertura de login/sesiones, API genérica de Datos, separación de roles, cuenta ADMIN única y edición del calendario y salas.
- [x] Web: pruebas de navegación por rol, acceso del instructor a gestión de salas y rechazo de `USER`.
- [x] El Android actual sigue siendo un prototipo sin llamadas a este backend; no se han cambiado sus flujos.
- [ ] Ejecutar pruebas Android cuando haya un JDK instalado y la app empiece a consumir la API.
- [ ] Hacer una prueba manual de los flujos web en el PC Windows de la escuela.

### 3. Preparar entorno privado de prealfa — pendiente de proveedor y secretos

- [ ] Elegir alojamiento para front, backend y PostgreSQL, y definir dominio de prueba.
- [ ] Crear un entorno separado de desarrollo, accesible solo al grupo invitado. No publicar Vite ni el lanzador `npm run dev`.
- [ ] Configurar `NODE_ENV=production`, `SESSION_KEY` aleatoria de 32 bytes, `COOKIE_SECURE=true`, `CORS_ORIGINS` con el dominio web exacto y credenciales de base de datos privadas.
- [ ] Ejecutar migraciones durante el despliegue con credenciales temporales de migración; el backend en producción no migra al arrancar.
- [ ] Usar una cuenta PostgreSQL de mínimo privilegio para el proceso web y permitir acceso de red solo desde el backend.
- [ ] Poner el backend detrás de un proxy confiable que termina HTTPS; no exponer directamente el listener con `trustProxy` habilitado.
- [x] Limitar los inicios de sesión a 10 intentos por IP y correo cada 15 minutos, evitando que un error de una cuenta bloquee a todo el grupo.
- [ ] Revisar la base antes de migrar: V15 falla deliberadamente si ya existen varias cuentas ADMIN; no borrar cuentas automáticamente.
- [ ] Crear la única cuenta ADMIN con `npm run admin:create`; custodiarla en el gestor de secretos del equipo y no compartirla con los testers.
- [ ] Dar de alta una cuenta individual por instructor desde Datos. Usar contraseñas iniciales largas y comunicarlas en privado.
- [ ] Mantener registro de quién recibe acceso y revocarlo al terminar la prueba.
- [ ] Configurar copia de seguridad automática y comprobar una restauración antes de invitar a nadie.
- [ ] Ejecutar migraciones y un smoke test con un ADMIN y un INSTRUCTOR antes de abrir el acceso.

### 4. Preparar datos de prueba

- [ ] Preparar nombres ficticios para cursos, instructores y salas; representar horarios habituales y cursos especiales reales en forma, pero no copiar datos de alumnos.
- [ ] Incluir una semana con sesiones simultáneas en salas distintas, horarios recurrentes, un curso especial y al menos un conflicto de sala.
- [ ] Comprobar que la cuenta `INSTRUCTOR` no ve la sección Datos ni información de alumnos.
- [ ] No usar `admin@wushu.test`, `WushuDemo2026!` ni datos cargados por el lanzador local en un entorno online.

### 5. Sesión de feedback

Dar las tareas sin indicar cada clic. Observar dónde se atasca cada participante y registrar tarea, resultado, duda, frecuencia y gravedad.

1. Consultar una semana y encontrar una clase concreta.
2. Filtrar por sala y revisar qué espacios quedan disponibles.
3. Crear una sesión puntual y cambiarle hora, duración, instructor o sala.
4. Crear un horario recurrente y modificar una ocurrencia concreta.
5. Crear o programar un curso especial de varios días como sesiones independientes por jornada.
6. Provocar un conflicto en la misma sala y comprobar que el aviso se entiende; repetir en otra sala.
7. Cancelar una sesión o regla y comprobar qué queda visible en el calendario.

Al finalizar, preguntar: qué tarea fue más difícil; qué información faltó; qué hacen hoy fuera de la herramienta; qué función nueva tendría utilidad frecuente; y qué confianza les da la agenda para coordinar una semana. Recoger una valoración de facilidad de 1 a 5 y comentarios libres.

Clasificar el resultado como: **bloqueo/error**, **fricción de uso**, **mejora** o **idea futura**. Priorizar primero errores y fricciones observadas por más de una persona.

### 6. Criterio de salida

La prealfa se considera satisfactoria cuando:

- el maestro y los instructores pueden planificar una semana sin ayuda constante;
- no se pierden sesiones ni se crean conflictos silenciosos de sala;
- un instructor no puede acceder a Datos ni a información personal de alumnos, ni siquiera llamando directamente a la API;
- las cuentas y permisos se pueden retirar al terminar la prueba;
- no hay errores críticos o altos pendientes en los flujos que se probaron;
- el feedback queda convertido en una lista priorizada para decidir la siguiente iteración.

## Comandos de comprobación

Desde `KungFuSchoolWebPage`:

```text
npm test
npm run lint
npm run build
```

Desde `KungFuBackendService/backend-service`:

```text
npm run typecheck
npm run lint
npm test
npm run build
```

`npm test` del backend requiere PostgreSQL local y crea/elimina bases temporales con nombre y marca de prueba. El lanzador web y sus datos demo son exclusivamente locales.

## Última verificación realizada

- Backend: typecheck, lint, **16 pruebas**, build y `npm audit`; todo pasa y la auditoría da 0 vulnerabilidades.
- Web: **8 pruebas**, lint, build y auditoría completa; todo pasa y la auditoría da 0 vulnerabilidades.
- Android: no se ha cambiado; `./gradlew test` no pudo arrancar porque este entorno no tiene un runtime Java instalado. Además, el prototipo Android aún no llama a esta API.
- Windows y prueba manual con el maestro/instructores: pendientes.

## Pendiente para poder invitar al grupo

El repositorio no contiene todavía una decisión ni configuración de alojamiento, dominio, gestor de secretos o copias externas. El código queda preparado para configurar esos elementos, pero la prealfa online no debe darse por desplegada hasta completar la fase 3 y pasar sus smoke tests. La instalación y prueba manual en Windows también sigue pendiente.
