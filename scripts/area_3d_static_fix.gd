extends Area3D


func _physics_process(delta):
    # Considering "area" an Area3D, and layer 32 an unused layer
    self.set_collision_layer_value(32, not self.get_collision_layer_value(32))
