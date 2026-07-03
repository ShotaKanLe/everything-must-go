extends BaseItem
class_name ShoppingItem

@export_enum("Apple", "Avocado", "Banana", "Melon", "Watermelon", "Broccoli", "Cabbage", "Carrot", "Potato", "Spinach", "Chicken Breast", "Lobster", "Pork", "Salmon", "Wagyu", "Blender", "Electric Kettle", "Microwave", "Rice Cooker", "Toaster", "Milk", "Mineral Water", "Orange Juice", "Soda Can", "Shampoo", "Soap", "Tissue Roll Pack", "Tooth Paste", "Chocolate Bar", "Gummy Bear", "Popcorn", "Potato Chips", "Jeans", "Shoes", "Socks", "T-shirt", "Cashier Table", "Wooden Table", "Fridge", "Wooden Shelf", "Showcase", "Mall Pillar", "Escalator", "Trash Can") var objectNameId: String

@export var objectCategory: String = ""
@export var isFragile: bool = false
@export var isIllegalToSteal: bool = true
@export var availableFromDay: int = 1
@export var isPaid: bool = false
