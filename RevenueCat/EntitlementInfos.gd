class_name EntitlementInfos
extends Reference

# <summary>
# This class contains all the entitlements associated to the user.
# </summary>
var All: Dictionary
var Active: Dictionary

func _init(response):
	All = {}
	for keyValuePair in response["all"]:
		All[keyValuePair] = EntitlementInfo.new(response["all"][keyValuePair])

	Active = {}
	for keyValuePair in response["active"]:
		Active[keyValuePair] = EntitlementInfo.new(response["active"][keyValuePair])
