extends Resource
class_name ShoppingItem

@export var objectName : String = "Meat Pack"
@export var objectCategory : String = "Animal Food"
@export var isShoppingItem : bool = true
@export var minimumPrice : float = 40.0
@export var maximumPrice : float = 60.0
@export var weight : float = 1.0
@export var strengthLevelToLift : int = 0
@export var isFragile : bool = false
@export var availableFromDay : int = 1
@export var isIllegalToSteal : bool = true

func get_random_price() -> float:
	return snapped(randf_range(minimumPrice, maximumPrice), 0.01)
