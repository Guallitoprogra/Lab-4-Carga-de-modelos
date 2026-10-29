const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimizacion = b.standardOptimizeOption(.{});
    const destino = b.resolveTargetQuery(.{ .cpu_arch = .x86_64, .os_tag = .windows, .abi = .gnu });
    const programa = b.addExecutable(.{
        .name = "laboratorio",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = destino,
            .optimize = optimizacion,
            .link_libc = true,
        }),
    });

    // Usamos la biblioteca de Raylib para Windows desde Zig.
    programa.root_module.addIncludePath(b.path("dependencias/raylib-5.5_win64_mingw-w64/include"));
    programa.root_module.addObjectFile(b.path("dependencias/raylib-5.5_win64_mingw-w64/lib/libraylib.a"));
    programa.root_module.linkSystemLibrary("opengl32", .{});
    programa.root_module.linkSystemLibrary("gdi32", .{});
    programa.root_module.linkSystemLibrary("winmm", .{});
    b.installArtifact(programa);

    const ejecutar = b.addRunArtifact(programa);
    ejecutar.setCwd(b.path("."));
    const paso = b.step("run", "Muestra el modelo Monkey");
    paso.dependOn(&ejecutar.step);
}
