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
			"objectName": "Mall Pillar",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 500,
			"strenghtLevelToLift": 10,
			"isFragile": false,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Escalator Step",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 150,
			"strenghtLevelToLift": 8,
			"isFragile": false,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Automatic Glass Door",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 200,
			"strenghtLevelToLift": 7,
			"isFragile": true,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Emergency Exit Sign",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 5,
			"strenghtLevelToLift": 0,
			"isFragile": false,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Central AC Vent",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 30,
			"strenghtLevelToLift": 3,
			"isFragile": false,
			"availableFromDay": 3,
			"isIllegalToSteal": true
		}
	]
},
{
	"category": "human_staff",
	"listItem": [
		{
			"objectName": "Cashier Man",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 70,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 5,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Cleaning Service",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 65,
			"strenghtLevelToLift": 5,
			"isFragile": true,
			"availableFromDay": 5,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Security Guard",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 80,
			"strenghtLevelToLift": 6,
			"isFragile": true,
			"availableFromDay": 5,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Mall Mascot",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 20,
			"strenghtLevelToLift": 2,
			"isFragile": true,
			"availableFromDay": 4,
			"isIllegalToSteal": false
		}
	]
},
{
	"category": "transportation",
	"listItem": [
		{
			"objectName": "Display Car",
			"minimumPrice": 15000,
			"maximumPrice": 80000,
			"weight": 1500,
			"strenghtLevelToLift": 10,
			"isFragile": false,
			"availableFromDay": 6,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Forklift Truck",
			"minimumPrice": 20000,
			"maximumPrice": 50000,
			"weight": 4000,
			"strenghtLevelToLift": 10,
			"isFragile": false,
			"availableFromDay": 7,
			"isIllegalToSteal": true
		},
		{
			"objectName": "Public Bus",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 12000,
			"strenghtLevelToLift": 10,
			"isFragile": false,
			"availableFromDay": 9,
			"isIllegalToSteal": true
		}
	]
},
{
	"category": "real_estate",
	"listItem": [
		{
			"objectName": "Cashier Counter Office",
			"minimumPrice": 500,
			"maximumPrice": 3000,
			"weight": 300,
			"strenghtLevelToLift": 8,
			"isFragile": false,
			"availableFromDay": 4,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Public Toilet Cubicle",
			"minimumPrice": 300,
			"maximumPrice": 1500,
			"weight": 150,
			"strenghtLevelToLift": 7,
			"isFragile": false,
			"availableFromDay": 4,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Security Guard Post",
			"minimumPrice": 200,
			"maximumPrice": 800,
			"weight": 200,
			"strenghtLevelToLift": 8,
			"isFragile": false,
			"availableFromDay": 5,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Rooftop Helipad",
			"minimumPrice": 0,
			"maximumPrice": 0,
			"weight": 5000,
			"strenghtLevelToLift": 10,
			"isFragile": false,
			"availableFromDay": 9,
			"isIllegalToSteal": false
		}
	]
},
{
	"category": "decoration",
	"listItem": [
		{
			"objectName": "Giant Fountain",
			"minimumPrice": 2000,
			"maximumPrice": 15000,
			"weight": 800,
			"strenghtLevelToLift": 10,
			"isFragile": true,
			"availableFromDay": 4,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Indoor Palm Tree",
			"minimumPrice": 100,
			"maximumPrice": 800,
			"weight": 50,
			"strenghtLevelToLift": 4,
			"isFragile": false,
			"availableFromDay": 3,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Food Court Dining Table",
			"minimumPrice": 80,
			"maximumPrice": 400,
			"weight": 40,
			"strenghtLevelToLift": 3,
			"isFragile": false,
			"availableFromDay": 3,
			"isIllegalToSteal": false
		},
		{
			"objectName": "Statue",
			"minimumPrice": 500,
			"maximumPrice": 8000,
			"weight": 300,
			"strenghtLevelToLift": 9,
			"isFragile": true,
			"availableFromDay": 4,
			"isIllegalToSteal": false
		}
	]
}
		]
	}
]
