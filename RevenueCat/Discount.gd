class_name Discount
extends Reference

# <summary>
# iOS only. Type that wraps StoreKit.Product.SubscriptionOffer and SKProductDiscount and provides access to their
# properties. Information about a subscription offer that you configured in App Store Connect.
# </summary>

# <summary>
# Identifier of the discount.
# </summary>
var Identifier: String

# <summary>
# Price in the local currency.
# </summary>
var Price: float

# <summary>
# Formatted price, including its currency sign, such as €3.99.
# </summary>
var PriceString: String

# <summary>
# Number of subscription billing periods for which the user will be given the discount, such as 3.
# </summary>
var Cycles: int

# <summary>
# Billing period of the discount, specified in ISO 8601 format.
# </summary>
var Period: String

# <summary>
# Unit for the billing period of the discount, can be DAY, WEEK, MONTH or YEAR.
# </summary>
var PeriodUnit: String

# <summary>
# Number of units for the billing period of the discount.
# </summary>
var PeriodNumberOfUnits: int

func _init(response):
	Identifier = response["identifier"]
	Price = response["price"]
	PriceString = response["priceString"]
	Cycles = response["cycles"]
	Period = response["period"]
	PeriodUnit = response["periodUnit"]
	PeriodNumberOfUnits = response["periodNumberOfUnits"]
