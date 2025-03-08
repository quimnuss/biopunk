extends Node3D
class_name Trajectory

func parabola(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0):
    var mesh_instance := MeshInstance3D.new()
    var immediate_mesh := ImmediateMesh.new()
    var material := ORMMaterial3D.new()

    mesh_instance.mesh = immediate_mesh
    mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

    var direction := (pos2 - pos1).normalized()
    
    var step_point := pos1
        
    const sampling_distance := 0.1
    const max_height := 4.0
    
    var numsteps := pos1.distance_to(pos2)/sampling_distance + 1
    
    immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
    immediate_mesh.surface_add_vertex(pos1)
    for step in range(numsteps):
        var height : float = -4*max_height/pos1.distance_squared_to(pos2) * step * sampling_distance*(step * sampling_distance - pos1.distance_to(pos2))
        step_point = pos1 + step * sampling_distance * direction + height * Vector3.UP
        immediate_mesh.surface_add_vertex(step_point)
        
    immediate_mesh.surface_add_vertex(pos2)
    immediate_mesh.surface_end()

    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    material.albedo_color = color

    return await final_cleanup(mesh_instance, persist_ms)

func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0):
    var mesh_instance := MeshInstance3D.new()
    var immediate_mesh := ImmediateMesh.new()
    var material := ORMMaterial3D.new()

    mesh_instance.mesh = immediate_mesh
    mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

    immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
    immediate_mesh.surface_add_vertex(pos1)
    immediate_mesh.surface_add_vertex(pos2)
    immediate_mesh.surface_end()

    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    material.albedo_color = color

    return await final_cleanup(mesh_instance, persist_ms)

func point(pos: Vector3, radius = 0.05, color = Color.WHITE_SMOKE, persist_ms = 0):
    var mesh_instance := MeshInstance3D.new()
    var sphere_mesh := SphereMesh.new()
    var material := ORMMaterial3D.new()

    mesh_instance.mesh = sphere_mesh
    mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    mesh_instance.position = pos

    sphere_mesh.radius = radius
    sphere_mesh.height = radius*2
    sphere_mesh.material = material

    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    material.albedo_color = color

    return await final_cleanup(mesh_instance, persist_ms)

func square(pos: Vector3, size: Vector2, color = Color.WHITE_SMOKE, persist_ms = 0):
    var mesh_instance := MeshInstance3D.new()
    var box_mesh := BoxMesh.new()
    var material := ORMMaterial3D.new()

    mesh_instance.mesh = box_mesh
    mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    mesh_instance.position = pos

    box_mesh.size = Vector3(size.x, size.y, 1)
    box_mesh.material = material

    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    material.albedo_color = color

    return await final_cleanup(mesh_instance, persist_ms)

## 1 -> Lasts ONLY for current physics frame
## >1 -> Lasts X time duration.
## <1 -> Stays indefinitely
func final_cleanup(mesh_instance: MeshInstance3D, persist_ms: float):
    get_tree().get_root().add_child(mesh_instance)
    if persist_ms == 1:
        await get_tree().physics_frame
        mesh_instance.queue_free()
    elif persist_ms > 0:
        await get_tree().create_timer(persist_ms).timeout
        mesh_instance.queue_free()
    else:
        return mesh_instance
