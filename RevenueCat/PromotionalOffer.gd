# <summary>
# Represents a <see cref="Discount"/> that has been validated and is ready to be used for a purchase.
# </summary>
class_name PromotionalOffer
extends Reference


# <summary>
# Identifier of the PromotionalOffer.
# </summary>
var Identifier: String

# <summary>
#  A string that identifies the key used to generate the signature.
# </summary>
var KeyIdentifier: String

# <summary>
# A universally unique ID (UUID) value that you define.
# </summary>
var Nonce: String

# <summary>
# A string representing the properties of a specific promotional offer, cryptographically signed.
# </summary>
var Signature: String

# <summary>
# The date and time of the signature's creation in milliseconds, formatted in Unix epoch time.
# </summary>
var Timestamp: int

func _init(response):
	Identifier = response["identifier"]
	KeyIdentifier = response["keyIdentifier"]
	Nonce = response["nonce"]
	Signature = response["signature"]
	Timestamp = response["timestamp"]
