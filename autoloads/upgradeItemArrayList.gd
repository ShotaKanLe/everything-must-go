extends Node
class_name UpgradeItemArrayList

enum {
	HEALTH,
	STAMINA,
	STRENGTH,
	RANGE,
	SPEED,
	STAMINA_REGEN,
	DOUBLE_JUMP
}

@export var upgradeItemArrayList : Array = [
	{
		"objectName" : "Health Upgrade",
		"minimumPrice" : 4,
		"maximumPrice" : 10,
		"upgradeType" : HEALTH,
	},
	{
		"objectName" : "Stamina Upgrade",
		"minimumPrice" : 5,
		"maximumPrice" : 12,
		"upgradeType" : STAMINA,
	},
	{
		"objectName" : "Strength Upgrade",
		"minimumPrice" : 8,
		"maximumPrice" : 15,
		"upgradeType" : STRENGTH,
	},
	{
		"objectName" : "Range Upgrade",
		"minimumPrice" : 6,
		"maximumPrice" : 14,
		"upgradeType" : RANGE,
	},
	{
		"objectName" : "Speed Upgrade",
		"minimumPrice" : 10,
		"maximumPrice" : 20,
		"upgradeType" : SPEED,
	},
	{
		"objectName" : "Stamina Regen Upgrade",
		"minimumPrice" : 12,
		"maximumPrice" : 25,
		"upgradeType" : STAMINA_REGEN,
	},
	{
		"objectName" : "Double Jump Upgrade",
		"minimumPrice" : 80,
		"maximumPrice" : 150,
		"upgradeType" : DOUBLE_JUMP,
	}
]
