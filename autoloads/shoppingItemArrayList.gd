extends Node
class_name ShoppingItemArrayList

@export var shoppingItemArrayList : Array = [
	{
		"isAbsurd" : false,
		"list" : [
			{
				"category" : "fruits",
				"listItem" : [
					{
						"objectName" : "Apple",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Avocado",
						"minimumPrice" : 2,
						"maximumPrice" : 5,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Banana",
						"minimumPrice" : 1,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Melon",
						"minimumPrice" : 4,
						"maximumPrice" : 8,
						"weight" : 3,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Watermelon",
						"minimumPrice" : 5,
						"maximumPrice" : 12,
						"weight" : 6,
						"strenghtLevelToLift" : 1,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					}
				],
			},
			{
				"category" : "vegetables",
				"listItem" : [
					{
						"objectName" : "Broccoli",
						"minimumPrice" : 2,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Cabbage",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Carrot",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Potato",
						"minimumPrice" : 2,
						"maximumPrice" : 5,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Spinach",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					}
				],
			},
			{
				"category" : "animal food",
				"listItem" : [
					{
						"objectName" : "Chicken Breast",
						"minimumPrice" : 5,
						"maximumPrice" : 9,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Lobster",
						"minimumPrice" : 20,
						"maximumPrice" : 45,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Pork",
						"minimumPrice" : 6,
						"maximumPrice" : 12,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Salmon",
						"minimumPrice" : 12,
						"maximumPrice" : 25,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Wagyu",
						"minimumPrice" : 50,
						"maximumPrice" : 150,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					}
				],
			},
			{
				"category" : "electronics",
				"listItem" : [
					{
						"objectName" : "Blender",
						"minimumPrice" : 25,
						"maximumPrice" : 60,
						"weight" : 3,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Electric Kettle",
						"minimumPrice" : 15,
						"maximumPrice" : 40,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Microwave",
						"minimumPrice" : 60,
						"maximumPrice" : 150,
						"weight" : 12,
						"strenghtLevelToLift" : 2,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Rice Cooker",
						"minimumPrice" : 30,
						"maximumPrice" : 80,
						"weight" : 4,
						"strenghtLevelToLift" : 1,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Toaster",
						"minimumPrice" : 15,
						"maximumPrice" : 35,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					}
				],
			},
			{
				"category" : "beverages",
				"listItem" : [
					{
						"objectName" : "Milk",
						"minimumPrice" : 2,
						"maximumPrice" : 5,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Mineral Water",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Orange Juice",
						"minimumPrice" : 2,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Soda Can",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
				],
			},
			{
				"category" : "personal care",
				"listItem" : [
					{
						"objectName" : "Shampoo",
						"minimumPrice" : 3,
						"maximumPrice" : 7,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Soap",
						"minimumPrice" : 1,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Tissue Roll Pack",
						"minimumPrice" : 3,
						"maximumPrice" : 6,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Tooth Paste",
						"minimumPrice" : 1,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
				],
			},
			{
				"category" : "snacks",
				"listItem" : [
					{
						"objectName" : "Chocolate Bar",
						"minimumPrice" : 2,
						"maximumPrice" : 5,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Gummy Bear",
						"minimumPrice" : 1,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Popcorn",
						"minimumPrice" : 2,
						"maximumPrice" : 5,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Potato Chips",
						"minimumPrice" : 2,
						"maximumPrice" : 6,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
				],
			},
			{
				"category" : "clothes",
				"listItem" : [
					{
						"objectName" : "Jeans",
						"minimumPrice" : 15,
						"maximumPrice" : 40,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Shoes",
						"minimumPrice" : 20,
						"maximumPrice" : 80,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "Socks",
						"minimumPrice" : 3,
						"maximumPrice" : 10,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
					{
						"objectName" : "T-shirt",
						"minimumPrice" : 10,
						"maximumPrice" : 30,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 0,
						"isIllegalToSteal" : false
					},
				],
			},
		]
	},
	{
		"isAbsurd" : true,
		"list" : [
			{
				"category": "infrastructure",
				"listItem": [
					{
						"objectName": "Cashier Table",
						"minimumPrice": 0,
						"maximumPrice": 0,
						"weight": 80,
						"strenghtLevelToLift": 5,
						"isFragile": false,
						"availableFromDay": 0,
						"isIllegalToSteal": true
					},
					{
						"objectName": "Wooden Table",
						"minimumPrice": 0,
						"maximumPrice": 0,
						"weight": 40,
						"strenghtLevelToLift": 3,
						"isFragile": false,
						"availableFromDay": 0,
						"isIllegalToSteal": true
					},
					{
						"objectName": "Fridge",
						"minimumPrice": 0,
						"maximumPrice": 0,
						"weight": 120,
						"strenghtLevelToLift": 6,
						"isFragile": false,
						"availableFromDay": 0,
						"isIllegalToSteal": true
					},
					{
						"objectName": "Wooden Shelf",
						"minimumPrice": 0,
						"maximumPrice": 0,
						"weight": 60,
						"strenghtLevelToLift": 4,
						"isFragile": false,
						"availableFromDay": 0,
						"isIllegalToSteal": true
					},
					{
						"objectName": "Showcase",
						"minimumPrice": 0,
						"maximumPrice": 0,
						"weight": 150,
						"strenghtLevelToLift": 7,
						"isFragile": false,
						"availableFromDay": 0,
						"isIllegalToSteal": true
					},
					{
						"objectName": "Mall Pillar",
						"minimumPrice": 0,
						"maximumPrice": 0,
						"weight": 800,
						"strenghtLevelToLift": 11,
						"isFragile": false,
						"availableFromDay": 0,
						"isIllegalToSteal": true
					},
					{
						"objectName": "Escalator",
						"minimumPrice": 0,
						"maximumPrice": 0,
						"weight": 1500,
						"strenghtLevelToLift": 12,
						"isFragile": false,
						"availableFromDay": 0,
						"isIllegalToSteal": true
					},
					{
						"objectName": "Trash Can",
						"minimumPrice": 0,
						"maximumPrice": 0,
						"weight": 15,
						"strenghtLevelToLift": 2,
						"isFragile": false,
						"availableFromDay": 0,
						"isIllegalToSteal": true
					}
				]
			},
		]
	}
]
