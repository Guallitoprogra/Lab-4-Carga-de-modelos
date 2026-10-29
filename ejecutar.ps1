$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    # Raylib queda en dependencias y no se sube al repositorio.
    $raylib = 'dependencias/raylib-5.5_win64_mingw-w64'
    if (!(Test-Path "$raylib/include/raylib.h")) {
        New-Item -ItemType Directory -Force 'dependencias' | Out-Null
        Invoke-WebRequest 'https://github.com/raysan5/raylib/releases/download/5.5/raylib-5.5_win64_mingw-w64.zip' -OutFile 'dependencias/raylib.zip'
        Expand-Archive 'dependencias/raylib.zip' 'dependencias' -Force
    }

    # Se necesita Zig instalado para compilar el programa en C.
    zig cc src/main.c -o laboratorio.exe -I "$raylib/include" "$raylib/lib/libraylib.a" -target x86_64-windows-gnu -lopengl32 -lgdi32 -lwinmm -std=c99 -Wall -Wextra
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo compilar el laboratorio.' }
    & './laboratorio.exe'
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo ejecutar el laboratorio.' }
}
finally {
    Pop-Location
}
