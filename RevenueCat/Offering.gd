# <summary>
# An offering is a collection of <see cref="Package"/>, and they let you control which products
# are shown to users without requiring an app update.
# </summary>
class_name Offering
extends Reference

var Identifier: String
var ServerDescription: String
var AvailablePackages: Array
var Metadata
var Lifetime #: Package
var Annual #: Package
var SixMonth #: Package
var ThreeMonth #: Package
var TwoMonth #: Package
var Monthly #: Package
var Weekly #: Package

func _init(response):
	Identifier = response["identifier"]
	ServerDescription = response["serverDescription"]
	AvailablePackages = []

	for packageResponse in response["availablePackages"]:
		AvailablePackages.append(Package.new(packageResponse))

	if (response["lifetime"] != null && response["lifetime"] != ""):
		Lifetime = Package.new(response["lifetime"])

	if (response["annual"] != null && response["annual"] != ""):
		Annual = Package.new(response["annual"])

	if (response["sixMonth"] != null && response["sixMonth"] != ""):
		SixMonth = Package.new(response["sixMonth"])

	if (response["threeMonth"] != null && response["threeMonth"] != ""):
		ThreeMonth = Package.new(response["threeMonth"])

	if (response["twoMonth"] != null && response["twoMonth"] != ""):
		TwoMonth = Package.new(response["twoMonth"])

	if (response["monthly"] != null && response["monthly"] != ""):
		Monthly = Package.new(response["monthly"])
	if (response["weekly"] != null && response["weekly"] != ""):
		Weekly = Package.new(response["weekly"])
	Metadata = {}
	if (response["metadata"] != null && response["metadata"] != ""):
		for metadataEntry in response["metadata"]:
			Metadata[metadataEntry] = response["metadata"][metadataEntry]
