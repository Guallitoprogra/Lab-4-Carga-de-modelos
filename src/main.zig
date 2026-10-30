const ray = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    const ancho = 1000;
    const alto = 750;
    ray.InitWindow(ancho, alto, "Lab 4 - Monkey en Zig");
    defer ray.CloseWindow();
    ray.SetTargetFPS(60);

    // El OBJ se exporto desde Blender con todas sus caras trianguladas.
    const ruta = "modelos/monkey.obj";
    if (!ray.FileExists(ruta)) return error.NoSeEncontroElModelo;
    const modelo = ray.LoadModel(ruta);
    defer ray.UnloadModel(modelo);
    if (modelo.meshCount == 0) return error.NoSePudoCargarElModelo;

    // Suzanne mira hacia el eje Z positivo despues de exportarla.
    var camara = ray.Camera3D{
        .position = .{ .x = 0, .y = 0.3, .z = 5 },
        .target = .{ .x = 0, .y = 0, .z = 0 },
        .up = .{ .x = 0, .y = 1, .z = 0 },
        .fovy = 45,
        .projection = ray.CAMERA_PERSPECTIVE,
    };
    const posicion = ray.Vector3{ .x = 0, .y = 0, .z = 0 };
    const blanco = ray.Color{ .r = 255, .g = 255, .b = 255, .a = 255 };
    const negro = ray.Color{ .r = 0, .g = 0, .b = 0, .a = 255 };
    var angulo: f32 = 0;

    while (!ray.WindowShouldClose()) {
        // El tiempo entre cuadros mantiene la misma velocidad de giro.
        const paso = 60 * ray.GetFrameTime();
        if (ray.IsKeyDown(ray.KEY_LEFT)) angulo -= paso;
        if (ray.IsKeyDown(ray.KEY_RIGHT)) angulo += paso;
        camara.position.z -= ray.GetMouseWheelMove() * 0.3;
        camara.position.z = @max(3, @min(10, camara.position.z));
        if (ray.IsKeyPressed(ray.KEY_R)) {
            angulo = 0;
            camara.position.z = 5;
        }

        ray.BeginDrawing();
        ray.ClearBackground(negro);
        ray.BeginMode3D(camara);
        // Wireframe: dibuja unicamente las aristas de cada triangulo.
        ray.DrawModelWiresEx(modelo, posicion, .{ .x = 0, .y = 1, .z = 0 }, angulo, .{ .x = 1, .y = 1, .z = 1 }, blanco);
        ray.EndMode3D();
        ray.DrawText("LAB 4 - CARGA DE MODELOS", 25, 25, 24, blanco);
        ray.DrawText("Monkey de Blender | Zig + Raylib", 25, 58, 18, blanco);
        ray.DrawText("Flechas: girar | Rueda: zoom | R: reiniciar | ESC: salir", 25, alto - 35, 18, blanco);
        ray.EndDrawing();
    }
}
