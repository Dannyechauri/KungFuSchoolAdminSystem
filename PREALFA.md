# Plan de prealfa web

## Objetivo

Probar con el maestro y un grupo pequeño de instructores si la agenda sirve para organizar el trabajo real de la escuela. Esta fase busca feedback sobre calendario, clases, cursos, salas y horarios recurrentes; no pretende probar la gestión del alumnado ni sustituir la app móvil.

Grupo sugerido: el maestro y 2–4 instructores durante una o dos semanas. Empezar con datos ficticios que representen una semana habitual. No cargar información personal real del alumnado.

## Roles acordados

| Rol | Uso en la prealfa | Permisos |
| --- | --- | --- |
| `ADMIN` | Una única cuenta de administración | Única cuenta que puede dar de alta y modificar alumnos, cursos, salas, grados, formas, estilos y demás datos (sección Datos). Cambia las contraseñas de los alumnos desde Datos → Alumnos → Editar. Fija el límite de participantes de cada actividad u horario (o sin límite) y decide si los alumnos ven cuántos asisten. |
| `INSTRUCTOR` | Alumno con `es_instructor` activado | Mismo inicio de sesión que su cuenta de alumno. Programa, edita y cancela sesiones y horarios recurrentes. Se apunta a actividades como alumno o como instructor (este último no ocupa plaza) y ve siempre el número y la lista de participantes. Ve su ficha en «Mi ficha» y marca las formas de su grado que está aprendiendo y su avance. No crea ni edita cursos, salas ni otros datos, ni accede a Datos. |
| `USER` | Cuenta de cada alumno | Consulta el calendario, se apunta o se quita de actividades (un día concreto o toda la serie), ve su ficha (datos, formas que sabe y formas obligatorias y opcionales de su grado) en «Mi ficha», donde marca las que está aprendiendo y su % de avance, y gestiona su propia asistencia. |

Solo hay dos tipos de cuenta: la del administrador y la de cada alumno. Ser instructor es un indicador del alumno (`alumnos.es_instructor`); al activarlo, la base crea o reactiva su registro en `instructores`, y al desactivarlo lo deja inactivo (nunca lo borra, porque la agenda lo referencia). El rol se recalcula en cada petición, así que el cambio se aplica sin volver a iniciar sesión. Al crear un alumno sin contraseña, su contraseña inicial es su nombre en minúsculas, sin acentos ni espacios; las contraseñas nuevas que fije el administrador deben tener al menos 8 caracteres. La base de datos impone una sola cuenta ADMIN y la web no ofrece registro público.

## Plan y estado

### 1. Modelo de acceso y permisos — implementado

- [x] Mantener los tres roles existentes y adoptar el uso acordado.
- [x] V16: cuentas solo para el administrador y los alumnos; `es_instructor` en el alumno da permisos de instructor; contraseña inicial derivada del nombre.
- [x] V17: participantes en actividades, con límite de plazas, inscripción a un día o a la serie y visibilidad del número de asistentes decidida por el administrador.
- [x] V18: al desactivar un alumno se le quita de las actividades futuras y de sus series; las asistencias de fechas pasadas no se pueden borrar.
- [x] V19: los alumnos marcan las formas de su grado (obligatorias y opcionales) que están aprendiendo y su porcentaje de avance; al registrar la forma como sabida, el avance se retira.
- [x] Dar a `INSTRUCTOR` la gestión de sesiones y recurrencias; cursos, salas y demás altas quedan para `ADMIN`.
- [x] Reservar `/api/database` y la pantalla Datos a `ADMIN`; los instructores reciben solo los datos mínimos de agenda que necesitan.
- [x] Admitir `USER` en la web con el calendario en solo lectura.
- [x] Impedir crear una segunda cuenta ADMIN desde la API y evitar borrar la única cuenta.
- [x] Añadir una restricción de base de datos que limita ADMIN a una cuenta.
- [x] Retirar el endpoint HTTP de migración; usar el arranque del backend o `npm run db:migrate`.
- [x] Añadir `npm run admin:create` para el alta inicial segura: comprueba que no exista otra cuenta, aplica migraciones pendientes y solicita la contraseña sin mostrarla.

### 2. Pruebas automatizadas — implementado en web y backend

- [x] Backend: cobertura de login/sesiones, API genérica de Datos, separación de roles, cuenta ADMIN única y edición del calendario y salas.
- [x] Web: pruebas de navegación por rol, gestión de agenda del instructor sin cursos ni salas, y calendario de solo lectura para `USER`.
- [x] Android consume la API del backend (perfil, formas, calendario, participación y agenda) con las mismas reglas por rol que la web.
- [x] Pruebas unitarias Android (.\gradlew.bat :app:testDebugUnitTest) de mapeo de respuestas y validaciones.
- [ ] Hacer una prueba manual de los flujos web en el PC Windows de la escuela siguiendo [PRUEBA-WINDOWS.md](PRUEBA-WINDOWS.md).

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
