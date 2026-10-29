#include "raylib.h"

int main(void)
{
    const int ancho = 1000;
    const int alto = 750;
    SetConfigFlags(FLAG_WINDOW_HIGHDPI);
    InitWindow(ancho, alto, "Lab 4 - Carga de modelos");
    SetTargetFPS(60);

    // La camara mira al centro del cohete desde un costado.
    Camera3D camara = {0};
    camara.position = (Vector3){6.0f, 3.0f, 8.0f};
    camara.target = (Vector3){0.0f, 0.0f, 0.0f};
    camara.up = (Vector3){0.0f, 1.0f, 0.0f};
    camara.fovy = 45.0f;
    camara.projection = CAMERA_PERSPECTIVE;

    // Raylib lee los vertices y las caras del archivo OBJ.
    const char *ruta = "modelos/cohete.obj";
    if (!FileExists(ruta))
    {
        TraceLog(LOG_ERROR, "No se encontro %s. Ejecuta desde la carpeta del laboratorio.", ruta);
        CloseWindow();
        return 1;
    }

    Model modelo = LoadModel(ruta);
    if (modelo.meshCount == 0)
    {
        TraceLog(LOG_ERROR, "No se pudo cargar el modelo");
        UnloadModel(modelo);
        CloseWindow();
        return 1;
    }

    Vector3 posicion = {0.0f, 0.0f, 0.0f};
    while (!WindowShouldClose())
    {
        BeginDrawing();
        ClearBackground(BLACK);

        BeginMode3D(camara);
        // Solo dibujamos las aristas, sin rellenar los triangulos.
        DrawModelWires(modelo, posicion, 1.0f, WHITE);
        EndMode3D();

        DrawText("LAB 4 - CARGA DE MODELOS", 25, 25, 24, WHITE);
        DrawText("Cohete OBJ | Wireframe", 25, 58, 18, LIGHTGRAY);
        DrawText("ESC: salir", 25, alto - 35, 18, GRAY);
        EndDrawing();
    }

    // Liberamos la memoria del modelo antes de cerrar la ventana.
    UnloadModel(modelo);
    CloseWindow();
    return 0;
}
