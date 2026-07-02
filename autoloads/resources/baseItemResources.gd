extends Resource
class_name BaseItem

@export var objectName: String = ""
@export var minimumPrice: float = 0.0
@export var maximumPrice: float = 0.0
@export var weight: float = 1.0
@export var strengthLevelToLift: int = 0

func get_random_price() -> float:
	return snapped(randf_range(minimumPrice, maximumPrice), 0.01)
