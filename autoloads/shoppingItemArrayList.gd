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
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Avocado",
						"minimumPrice" : 2,
						"maximumPrice" : 5,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Banana",
						"minimumPrice" : 1,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Melon",
						"minimumPrice" : 4,
						"maximumPrice" : 8,
						"weight" : 3,
						"strenghtLevelToLift" : 1,
						"isFragile" : false,
						"availableFromDay" : 2,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Watermelon",
						"minimumPrice" : 5,
						"maximumPrice" : 12,
						"weight" : 8,
						"strenghtLevelToLift" : 2,
						"isFragile" : false,
						"availableFromDay" : 2,
						"isIllegalToSteal" : true
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
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Cabbage",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Carrot",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Potato",
						"minimumPrice" : 2,
						"maximumPrice" : 5,
						"weight" : 3,
						"strenghtLevelToLift" : 1,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Spinach",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
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
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Lobster",
						"minimumPrice" : 20,
						"maximumPrice" : 45,
						"weight" : 2,
						"strenghtLevelToLift" : 1,
						"isFragile" : true,
						"availableFromDay" : 3,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Pork",
						"minimumPrice" : 6,
						"maximumPrice" : 12,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Salmon",
						"minimumPrice" : 12,
						"maximumPrice" : 25,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 2,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Wagyu",
						"minimumPrice" : 50,
						"maximumPrice" : 150,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 4,
						"isIllegalToSteal" : true
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
						"weight" : 4,
						"strenghtLevelToLift" : 1,
						"isFragile" : true,
						"availableFromDay" : 2,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Electric Kettle",
						"minimumPrice" : 15,
						"maximumPrice" : 40,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Microwave",
						"minimumPrice" : 60,
						"maximumPrice" : 150,
						"weight" : 15,
						"strenghtLevelToLift" : 3,
						"isFragile" : true,
						"availableFromDay" : 3,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Rice Cooker",
						"minimumPrice" : 30,
						"maximumPrice" : 80,
						"weight" : 5,
						"strenghtLevelToLift" : 1,
						"isFragile" : true,
						"availableFromDay" : 2,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Toaster",
						"minimumPrice" : 15,
						"maximumPrice" : 35,
						"weight" : 3,
						"strenghtLevelToLift" : 1,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					}
				],
			},
			{
				"category" : "beverages",
				"listItem" : [
					{
						"objectName" : "Milk",
						"minimumPrice" : 1,
						"maximumPrice" : 5,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Mineral Water",
						"minimumPrice" : 2,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Orange Juice",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Soda Can",
						"minimumPrice" : 3,
						"maximumPrice" : 8,
						"weight" : 2,
						"strenghtLevelToLift" : 1,
						"isFragile" : false,
						"availableFromDay" : 2,
						"isIllegalToSteal" : true
					},
				],
			},
			{
				"category" : "personal care",
				"listItem" : [
					{
						"objectName" : "Shampoo",
						"minimumPrice" : 2,
						"maximumPrice" : 6,
						"weight" : 3,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Soap",
						"minimumPrice" : 1,
						"maximumPrice" : 8,
						"weight" : 2,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Tissue Roll Pack",
						"minimumPrice" : 3,
						"maximumPrice" : 6,
						"weight" : 6,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Tooth Paste",
						"minimumPrice" : 1,
						"maximumPrice" : 4,
						"weight" : 1,
						"strenghtLevelToLift" : 1,
						"isFragile" : true,
						"availableFromDay" : 2,
						"isIllegalToSteal" : true
					},
				],
			},
			{
				"category" : "snacks",
				"listItem" : [
					{
						"objectName" : "Chocolate Bar",
						"minimumPrice" : 3,
						"maximumPrice" : 8,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Gummy Bear",
						"minimumPrice" : 1,
						"maximumPrice" : 5,
						"weight" : 5,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Popcorn",
						"minimumPrice" : 2,
						"maximumPrice" : 4,
						"weight" : 4,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Potato Chips",
						"minimumPrice" : 1,
						"maximumPrice" : 8,
						"weight" : 1,
						"strenghtLevelToLift" : 1,
						"isFragile" : true,
						"availableFromDay" : 2,
						"isIllegalToSteal" : true
					},
				],
			},
			{
				"category" : "clothes",
				"listItem" : [
					{
						"objectName" : "Jeans",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 8,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Shoes",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 6,
						"strenghtLevelToLift" : 0,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "Socks",
						"minimumPrice" : 2,
						"maximumPrice" : 8,
						"weight" : 1,
						"strenghtLevelToLift" : 0,
						"isFragile" : false,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
					},
					{
						"objectName" : "T-shirt",
						"minimumPrice" : 1,
						"maximumPrice" : 3,
						"weight" : 8,
						"strenghtLevelToLift" : 1,
						"isFragile" : true,
						"availableFromDay" : 1,
						"isIllegalToSteal" : true
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
			"weight": 200,
			"strenghtLevelToLift": 7,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Wooden Table",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 100,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Fridge",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 100,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Wooden Shelf",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 100,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},{
			"objectName": "Showcase",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 100,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},{
			"objectName": "Mall Pillar",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 100,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},{
			"objectName": "Escalator",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 100,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},{
			"objectName": "Trash Can",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 100,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		}
	]
},
		]
	}
]
