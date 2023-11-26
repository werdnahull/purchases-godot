# <summary>
# This class contains all the offerings configured in RevenueCat dashboard.
# Offerings let you control which products are shown to users without requiring an app update.
# </summary>

class_name Offerings
extends Reference

var All: Dictionary
var Current #: Offering

func _init(response):
	All = {}
	for keyValuePair in response["all"]:
		All[keyValuePair] = Offering.new(response["all"][keyValuePair])

	var currentJsonNode = response["current"]
	if (currentJsonNode != null && currentJsonNode != ""):
		Current = Offering.new(currentJsonNode)
