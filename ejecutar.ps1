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

    # Compila y ejecuta el codigo Zig (requiere Zig 0.16).
    zig build run
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo ejecutar el laboratorio.' }
}
finally {
    Pop-Location
}
