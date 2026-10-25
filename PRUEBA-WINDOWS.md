# Prueba local en Windows

Esta guía prepara el entorno de demostración para probar la web y su API en un PC Windows. No despliega la aplicación en Internet. Los pasos usan datos ficticios guardados localmente en ese ordenador.

## 1. Instalar los requisitos

Instala estas herramientas antes de clonar el proyecto. No hace falta instalar Java ni Android Studio para probar la web:

1. **Git for Windows:** https://git-scm.com/download/win
2. **Node.js 24.21.0 y npm 11.19.0:** https://nodejs.org/en/download
3. **PostgreSQL local:** https://www.postgresql.org/download/windows/

Durante la instalación de PostgreSQL, deja el puerto `5432` y guarda la contraseña que asignes al usuario `postgres`. El repositorio no fija una versión mayor de PostgreSQL. Asegúrate de que el servicio local quede iniciado. No se necesita WSL ni Git Bash; puedes seguir los pasos desde PowerShell.

Abre una nueva ventana de PowerShell y comprueba las versiones:

```powershell
git --version
node --version
npm --version
```

Las dos últimas deben mostrar `v24.21.0` y `11.19.0` respectivamente.

## 2. Clonar la rama de prueba con sus submódulos

Desde la carpeta donde quieras guardar el proyecto:

```powershell
git clone --recurse-submodules --branch feature/frontend-definitivo https://github.com/Dannyechauri/KungFuSchoolAdminSystem.git
cd KungFuSchoolAdminSystem
git branch --show-current
git submodule status
```

La rama debe ser `feature/frontend-definitivo`. El comando `--recurse-submodules` descarga también la web y el backend en los commits exactos que necesita esta rama.

Si GitHub pide iniciar sesión, la cuenta de prueba necesita acceso de lectura al repositorio padre y a los dos repositorios de submódulos.

Si ya habías clonado el proyecto sin submódulos, desde la raíz ejecuta:

```powershell
git checkout feature/frontend-definitivo
git pull --ff-only
git submodule update --init --recursive
```

## 3. Instalar las dependencias del front y del backend

Instala las dependencias por separado en cada submódulo; no copies `node_modules` desde otro ordenador:

```powershell
cd KungFuSchoolWebPage
npm.cmd ci
Copy-Item .env.example .env.dev.local
notepad .env.dev.local
```

En `.env.dev.local`, configura el usuario y la contraseña de PostgreSQL. En Windows normalmente será:

```text
DEV_DB_HOST=127.0.0.1
DEV_DB_PORT=5432
DEV_DB_USER=postgres
DEV_DB_PASSWORD=
```

Escribe en `DEV_DB_PASSWORD` la contraseña que elegiste para PostgreSQL y guarda el archivo. Este archivo contiene una credencial local, está excluido de Git y **no se debe compartir ni enviar a una IA**. Para este arranque no hace falta crear un `.env.local` en el backend: el lanzador del front pasa las credenciales localmente al proceso.

Instala ahora el backend:

```powershell
cd ..\KungFuBackendService\backend-service
npm.cmd ci
```

## 4. Arrancar la aplicación

Vuelve a la carpeta del front y arranca el entorno completo:

```powershell
cd ..\..\KungFuSchoolWebPage
npm.cmd run dev
```

El primer arranque crea la base local `kungfu_school_dev`, aplica las migraciones y carga los datos ficticios. La web estará en http://127.0.0.1:8000/ y el backend en http://127.0.0.1:8080. Deja abierta esa ventana de PowerShell mientras haces la prueba; para apagarlo, pulsa `Ctrl+C`.

Para probar la agenda como instructor (un alumno marcado como instructor):

```text
Correo: chen.wei@wushu.test
Contraseña: chenwei
```

Los alumnos e instructores entran con su correo y, como contraseña inicial, su nombre en minúsculas, sin acentos ni espacios (por ejemplo `alumno.02@wushu.test` / `marcsoler`). Un alumno sin permisos de instructor ve el calendario en solo lectura. El administrador (`admin@wushu.test` / `WushuDemo2026!`) puede cambiar cualquier contraseña desde Datos → Alumnos → Editar.

Estas credenciales solo existen en la base de demostración local. No las uses para ningún entorno online.

El ejemplo del taller de fin de semana aparece como dos sesiones separadas, sábado y domingo, del mismo curso.

## 5. Solución de problemas frecuentes

- **PowerShell bloquea `npm.ps1`:** usa `npm.cmd` como en los comandos de esta guía; no cambies la política de ejecución.
- **Error `EBADENGINE`:** comprueba `node --version` y `npm --version`; deben ser las versiones indicadas arriba.
- **Error de conexión a PostgreSQL:** comprueba que el servicio PostgreSQL esté iniciado, que escucha en `127.0.0.1:5432` y que `.env.dev.local` tenga las credenciales correctas.
- **El puerto 8000 o 8080 está ocupado:** cierra la instancia anterior de la aplicación y vuelve a ejecutar `npm.cmd run dev`.
- **Aparece un aviso de que la base tiene una versión anterior de datos de demostración:** detén primero la aplicación con `Ctrl+C`; luego ejecuta `npm.cmd run dev:reset` desde `KungFuSchoolWebPage`. Recrea la base ficticia y **borra todos los cambios guardados en esa base local**, así que úsalo solo si se puede descartar esa información.

## Prompt para pedir ayuda a otra IA

Puedes compartir con otra IA esta guía y el mensaje:

> Ayúdame a seguir `PRUEBA-WINDOWS.md` en Windows usando PowerShell. Primero comprueba conmigo los requisitos y avanza paso a paso. Usa `npm.cmd` si PowerShell bloquea `npm.ps1`. No cambies el código ni ejecutes `npm.cmd run dev:reset` sin explicarme que borra la base local. Si falla un paso, pídeme el mensaje de error exacto y ayúdame a resolverlo. No me pidas que comparta la contraseña de PostgreSQL ni el contenido de `.env.dev.local`.
