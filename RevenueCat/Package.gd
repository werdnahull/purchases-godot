# <summary>
# Packages help abstract platform-specific products by grouping equivalent products across iOS, Android, and web.
# A package is made up of three parts: identifier, packageType, and underlying StoreProduct.
# </summary>
class_name Package
extends Reference


var Identifier: String
var PackageType: String
var StoreProduct: StoreProduct
var OfferingIdentifier: String

func _init(response):
	Identifier = response["identifier"]
	PackageType = response["packageType"]
	StoreProduct = StoreProduct.new(response["product"])
	OfferingIdentifier = response["offeringIdentifier"]
