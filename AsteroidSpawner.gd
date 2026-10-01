extends "res://AsteroidSpawner.gd"

var is_ready:bool = false
signal has_finished_readying

func _ready():
	is_ready = true
	emit_signal("has_finished_readying")

func getVeinAt(pos):
	var localCoord = CurrentGame.localCoords(pos)
	var psq = Physics2DShapeQueryParameters.new()
	var pss = CircleShape2D.new()
	pss.radius = 0.1
	psq.set_shape(pss)
	psq.transform = Transform2D(0.0, localCoord)
	psq.collision_layer = 1
	for col in get_world_2d().direct_space_state.intersect_shape(psq):
		var c = col.collider
		if "frakking" in c and c.frakking:
			var ctr:int = c.max_samples
			var content:Dictionary = c.sampleField.duplicate()
			var ores:Array = c.sampleKeys.duplicate()
			while ctr > 1:
				var select = ores[randi() % ores.size()]
				content[select] -= 1
				if content[select] < 1:
					content.erase(select)
					ores.erase(select)
				ctr -= 1
			return ores[0]
	return .getVeinAt(pos)

func getChaosAt(pos):
	var localCoord = CurrentGame.localCoords(pos)
	var psq = Physics2DShapeQueryParameters.new()
	var pss = CircleShape2D.new()
	pss.radius = 0.1
	psq.set_shape(pss)
	psq.transform = Transform2D(0.0, localCoord)
	psq.collision_layer = 1
	var world = get_world_2d()
	if world:
		for col in world.direct_space_state.intersect_shape(psq):
			var c = col.collider
			if "frakking" in c and c.frakking:
				return c.chaos
	return .getChaosAt(pos)
