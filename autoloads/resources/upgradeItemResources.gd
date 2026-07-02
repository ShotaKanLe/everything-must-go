extends BaseItem
class_name UpgradeItem

enum UpgradeType {
	HEALTH,
	STAMINA,
	STRENGTH,
	RANGE,
	SPEED,
	STAMINA_REGEN,
	SLOT_TOOLS,
	DOUBLE_JUMP
}

@export var upgrade_type: UpgradeType = UpgradeType.HEALTH
@export var upgrade_amount: int = 1

func apply_upgrade() -> void:
	match upgrade_type:
		UpgradeType.HEALTH:
			LevelData.health_level += upgrade_amount
		UpgradeType.STAMINA:
			LevelData.stamina_level += upgrade_amount
		UpgradeType.STRENGTH:
			LevelData.strength_level += upgrade_amount
		UpgradeType.RANGE:
			LevelData.range_level += upgrade_amount
		UpgradeType.SPEED:
			LevelData.speed_level += upgrade_amount
		UpgradeType.STAMINA_REGEN:
			LevelData.stamina_regen_level += upgrade_amount
		UpgradeType.SLOT_TOOLS:
			LevelData.slot_tools_level += upgrade_amount
		UpgradeType.DOUBLE_JUMP:
			LevelData.double_jump_upgrade = true
