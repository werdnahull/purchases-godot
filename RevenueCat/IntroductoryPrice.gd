class_name IntroductoryPrice
extends Reference

var Price: float
var PriceString: String
var Period: String
var Unit: String
var NumberOfUnits: int
var Cycles: int

func _init(response):
	Price = response["price"]
	PriceString = response["priceString"]
	Period = response["period"]
	Unit = response["periodUnit"]
	NumberOfUnits = response["periodNumberOfUnits"]
	Cycles = response["cycles"]
