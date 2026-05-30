# Instrucciones para compilar los diagramas UML

Todos los diagramas están escritos en **PlantUML**, que genera imágenes PNG/SVG desde archivos `.puml`.

---

## Opción 1 — Compilar con el JAR de PlantUML (recomendado)

### Requisitos
- **Java JDK 11+** instalado → https://adoptium.net/
- **Graphviz** → https://graphviz.org/download/ (requerido para diagramas de clases y componentes)
- Descargar **plantuml.jar** → https://plantuml.com/download

### Compilar todos los diagramas

Coloca `plantuml.jar` en la carpeta `uml/` y ejecuta:

```powershell
# Desde la carpeta uml/
java -jar plantuml.jar *.puml
```

Esto genera archivos `.png` junto a cada `.puml`.

### Compilar uno individual

```powershell
java -jar plantuml.jar 01_arquitectura_componentes.puml
java -jar plantuml.jar 02_diagrama_clases.puml
java -jar plantuml.jar 03_casos_de_uso.puml
java -jar plantuml.jar 04_diagrama_despliegue.puml
java -jar plantuml.jar 05_esquema_sql.puml
```

### Generar en SVG (mayor calidad)

```powershell
java -jar plantuml.jar -tsvg *.puml
```

---

## Opción 2 — Extensión de VS Code

Instala la extensión **PlantUML** de `jebbs` en VS Code:

1. Abre Extensions (`Ctrl+Shift+X`)
2. Busca `PlantUML` (autor: jebbs)
3. Instálala
4. Abre cualquier archivo `.puml`
5. Presiona `Alt+D` para previsualizar en tiempo real
6. Presiona `Ctrl+Shift+P` → `PlantUML: Export Current File Diagrams` para exportar

---

## Opción 3 — Online (sin instalación)

Copia y pega el contenido de cualquier `.puml` en:
- https://www.plantuml.com/plantuml/uml/
- https://editor.plantuml.com/

---

## Archivos incluidos

| Archivo | Tipo | Descripción |
|---|---|---|
| `01_arquitectura_componentes.puml` | Componentes | Arquitectura general del sistema |
| `02_diagrama_clases.puml` | Clases | Modelo orientado a objetos |
| `03_casos_de_uso.puml` | Casos de uso | Funcionalidades por actor |
| `04_diagrama_despliegue.puml` | Despliegue | Infraestructura de servidores |
| `05_esquema_sql.puml` | Entidad-Relación | Esquema de la base de datos SQL |
