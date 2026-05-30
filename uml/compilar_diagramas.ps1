# Script para compilar todos los diagramas UML
# Requiere: Java JDK 11+ y plantuml.jar en esta misma carpeta

$plantumlJar = "$PSScriptRoot\plantuml.jar"
$outputDir   = "$PSScriptRoot\output"

if (-not (Test-Path $plantumlJar)) {
    Write-Host "ERROR: No se encontró plantuml.jar en $PSScriptRoot" -ForegroundColor Red
    Write-Host "Descárgalo desde: https://plantuml.com/download" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
    Write-Host "Carpeta 'output' creada." -ForegroundColor Green
}

Write-Host "`nCompilando diagramas UML..." -ForegroundColor Cyan

# Generar PNG
java -jar $plantumlJar -o $outputDir "$PSScriptRoot\*.puml"

# Generar SVG también
java -jar $plantumlJar -tsvg -o "$outputDir\svg" "$PSScriptRoot\*.puml"

Write-Host "`nDiagramas generados en: $outputDir" -ForegroundColor Green
Write-Host "Imágenes PNG y SVG disponibles." -ForegroundColor Green
