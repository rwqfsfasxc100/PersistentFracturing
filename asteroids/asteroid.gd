extends "res://asteroids/asteroid.gd"

func _ready():
	if rp_roidpersist:
		OS.kill(OS.get_process_id())
	rp_roidpersist = true
	pointersRP = ModLoader._savedObjects[0]
	pointersRP.ConfigDriver.__establish_connection("rp_persisttoep_UV",self)
	rp_persisttoep_UV()
	if field:
		if not field.is_ready:
			yield(field,"has_finished_readying")
		field = load("res://PersistentFracturing/asteroids/AsteroidShadow.gd").new(field)
		field.referenced_rock = self
		if max_samples == 0:
			max_samples = int(clamp(baseMass,16.0,1024.0))
			create_sample_data()

var composition = {}
var rp_roidpersist : bool = false
var persist_to_enceladus:bool = true
func getComposition():
	if persist_to_enceladus and composition:
		return composition
	var comp:Dictionary = .getComposition()
	if sample_counter > 0:
		var frac:float = (pow(chaos, 2) * comp["H2O"]) / sample_counter
		for i in sampleKeys:
			var value = sampleField[i] * frac
			comp["H2O"] -= value
			comp[i] = value
	return comp

func getScan():
	if randf() < pow(chaos, 2) * 0.5:
		sampleKeys.shuffle()
		var rand:int = randi() % sample_counter
		for i in sampleKeys:
			rand -= sampleField[i]
			if rand < 0:
				return i
	return .getScan()

var frakking:bool = false
var is_overriding:bool = false

var max_samples:int = 0
var sample_counter:int = 0

var chaos:float = 0.0

var sampleField:Dictionary = {}
var sampleKeys:Array = Array()
func create_sample_data():
	if not is_overriding:
		var gPos:Vector2 = CurrentGame.globalCoords(position)
		chaos = field.getChaosAt(gPos)
		var idx:int = 0
		while idx < 16 and sample_counter < max_samples:
			var sample = field.getVeinAt(gPos)
			if not sample in sampleKeys:
				sampleField[sample] = 1
				sampleKeys.append(sample)
			else:
				sampleField[sample] += 1
			sample_counter += 1
			idx += 1
		if sample_counter < max_samples:
			yield(get_tree(),"idle_frame")
			create_sample_data()

var pointersRP:HevLibPointers

func rp_persisttoep_UV():
	if pointersRP:
		persist_to_enceladus = pointersRP.ConfigDriver.__get_value("PersistentFracturing","ROCKPERSIST_CONFIG_SECT_ROCKS","persist_to_enceladus")
