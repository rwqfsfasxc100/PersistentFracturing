var __shadowed_object_ref_5829165779__ = null
func _init(oref):
	__shadowed_object_ref_5829165779__ = oref

var referenced_rock:Node = null

func spawnAsteroidByClass(oc, spot, chaos, spawnPointRandomness = 0.0, initialLinearVelocity = Vector2(0, 0), initialAngularVelocity = 0.0, tries = 1, spawned = true):
	var samples:Dictionary = referenced_rock.sampleField.duplicate()
	var current_sample_count:float = float(referenced_rock.max_samples)
	var currChaos:float = referenced_rock.chaos
	referenced_rock.frakking = true
	var doRef:bool = typeof(__shadowed_object_ref_5829165779__.objectClass[oc]) == TYPE_DICTIONARY
	var out = __shadowed_object_ref_5829165779__.spawnAsteroidByClass(oc, spot, chaos, spawnPointRandomness, initialLinearVelocity, initialAngularVelocity, tries, spawned)
	if not doRef and out and samples:
		out.is_overriding = true
		var sample_count:int = referenced_rock.sample_counter
		var max_samples:int = out.max_samples
		var sampleKeys:Array = samples.keys()
		while sample_count > max_samples:
			var mineral = sampleKeys[randi() % sampleKeys.size()]
			samples[mineral] -= 1
			if samples[mineral] < 1:
				samples.erase(mineral)
				sampleKeys.erase(mineral)
			sample_count -= 1
		out.sampleField = samples
		out.sample_counter = max_samples
		out.chaos = currChaos
		out.sampleKeys = sampleKeys
	return out

func getVeinAt(pos):
	return __shadowed_object_ref_5829165779__.getVeinAt(pos)

func getChaosAt(pos):
	return __shadowed_object_ref_5829165779__.getChaosAt(pos)
