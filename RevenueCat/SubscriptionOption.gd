class_name SubscriptionOption
extends Reference

# Identifier of the subscription option
# If this SubscriptionOption represents a base plan, this will be the basePlanId.
# If it represents an offer, it will be {basePlanId}:{offerId}
var Id : String

# Identifier of the StoreProduct associated with this SubscriptionOption
# This will be {subId}:{basePlanId}
var StoreProductId : String

# Identifer of the subscription associated with this SubscriptionOption
# This will be {subId}
var ProductId : String

# Pricing phases defining a user's payment plan for the product over time.
var PricingPhases : Array

# Tags defined on the base plan or offer. Empty for Amazon.
var Tags : Array

# True if this SubscriptionOption represents a subscription base plan (rather than an offer).
var IsBasePlan : bool

# The subscription period of fullPricePhase (after free and intro trials).
var BillingPeriod : Period

# True if the subscription is pre-paid.
var IsPrepaid : bool

# The full price PricingPhase of the subscription.
# Looks for the last price phase of the SubscriptionOption.
var FullPricePhase #: PricingPhase

# The free trial PricingPhase of the subscription.
# Looks for the first pricing phase of the SubscriptionOption where amountMicros is 0.
# There can be a freeTrialPhase and an introductoryPhase in the same SubscriptionOption.
var FreePhase #: PricingPhase

# The intro trial PricingPhase of the subscription.
# Looks for the first pricing phase of the SubscriptionOption where amountMicros is greater than 0.
# There can be a freeTrialPhase and an introductoryPhase in the same SubscriptionOption.
var IntroPhase #: PricingPhase

# Offering identifier the subscription option was presented from
var PresentedOfferingIdentifier #: String

func _init(response):
	Id = response["id"]
	StoreProductId = response["storeProductId"]
	ProductId = response["productId"]

	var tagsResponse = response["tags"]
	Tags = []
	for tag in tagsResponse:
		Tags.append(tag)

	IsBasePlan = response["isBasePlan"]
	BillingPeriod = Period.new(response["billingPeriod"])
	IsPrepaid = response["isPrepaid"]

	var pricingPhasesNode = response["pricingPhases"]
	PricingPhases = []
	if pricingPhasesNode and not pricingPhasesNode.is_null():
		for phase in pricingPhasesNode:
			PricingPhases.append(PricingPhase.new(phase))

	var fullPricePhaseNode = response["fullPricePhase"]
	if fullPricePhaseNode and not fullPricePhaseNode.is_null():
		FullPricePhase = PricingPhase.new(fullPricePhaseNode)

	var freePhaseNode = response["freePhase"]
	if freePhaseNode and not freePhaseNode.is_null():
		FreePhase = PricingPhase.new(freePhaseNode)

	var introPhaseNode = response["introPhase"]
	if introPhaseNode and not introPhaseNode.is_null():
		IntroPhase = PricingPhase.new(introPhaseNode)

	PresentedOfferingIdentifier = response["presentedOfferingIdentifier"]

#func to_string() -> String:
#    return "Id: " + Id + "\n" +\
#           "StoreProductId: " + StoreProductId + "\n" +\
#           "ProductId: " + ProductId + "\n" +\
#           "PricingPhases: " + str(PricingPhases) + "\n" +\
#           "Tags: " + str(Tags) + "\n" +\
#           "IsBasePlan: " + str(IsBasePlan) + "\n" +\
#           "BillingPeriod: " + BillingPeriod.to_string() + "\n" +\
#           "IsPrepaid: " + str(IsPrepaid) + "\n" +\
#           "FullPricePhase: " + FullPricePhase.to_string() + "\n" +\
#           "FreePhase: " + FreePhase.to_string() + "\n" +\
#           "IntroPhase: " + IntroPhase.to_string() + "\n" +\
#           "PresentedOfferingIdentifier: " + PresentedOfferingIdentifier

class PricingPhase:

	# Billing period for which the PricingPhase applies
	var BillingPeriod : Period

	# Recurrence mode of the PricingPhase
	var RecurrenceMode

	# Number of cycles for which the pricing phase applies.
	# Null for infiniteRecurring or finiteRecurring recurrence modes.
	var BillingCycleCount : int

	# Price of the PricingPhase
	var Price : Price

	# Indicates how the pricing phase is charged for finiteRecurring pricing phases
	var OfferPaymentMode

	func _init(response):
		BillingPeriod = Period.new(response["billingPeriod"])
		if not response["recurrenceMode"] in RecurrenceMode.keys():
			RecurrenceMode = RecurrenceMode.UNKNOWN
		BillingCycleCount = response["billingCycleCount"]
		Price = Price.new(response["price"])
		if not response["offerPaymentMode"] in OfferPaymentMode.keys():
			OfferPaymentMode = OfferPaymentMode.UNKNOWN

#	func to_string() -> String:
#	    return "BillingPeriod: " + BillingPeriod.to_string() + "\n" +
#	           "RecurrenceMode: " + str(RecurrenceMode) + "\n" +
#	           "BillingCycleCount: " + str(BillingCycleCount) + "\n" +
#	           "Price: " + Price.to_string() + "\n" +
#	           "OfferPaymentMode: " + str(OfferPaymentMode) + "\n"

enum RecurrenceMode {
	INFINITE_RECURRING = 1,
	FINITE_RECURRING = 2,
	NON_RECURRING = 3,
	UNKNOWN = 4
}

enum OfferPaymentMode {
	FREE_TRIAL = 0,
	SINGLE_PAYMENT = 1,
	DISCOUNTED_RECURRING_PAYMENT = 2,
	UNKNOWN = 3
}

class Period:

	# The number of period units: day, week, month, year, unknown
	var Unit

	# The increment of time that a subscription period is specified in
	var Value : int

	# Specified in ISO 8601 format. For example, P1W equates to one week,
	# P1M equates to one month, P3M equates to three months, P6M equates to six months,
	# and P1Y equates to one year
	var ISO8601 : String

	func _init(response):
		if not response["unit"] in PeriodUnit.keys():
			Unit = PeriodUnit.UNKNOWN
		Value = response["value"]
		ISO8601 = response["iso8601"]

#	func to_string() -> String:
#		return "Unit: " + str(Unit) + "\n" +
#			   "Value: " + str(Value) + "\n" +
#			   "ISO8601: " + ISO8601 + "\n"

enum PeriodUnit {
	DAY = 0,
	WEEK = 1,
	MONTH = 2,
	YEAR = 3,
	UNKNOWN = 4
}

class Price:

	# Formatted price of the item, including its currency sign. For example $3.00
	var Formatted : String

	# Price in micro-units, where 1,000,000 micro-units equal one unit of the currency.
	var AmountMicros : int

	# Returns ISO 4217 currency code for price and original price.
	# For example if price is specified in British pounds sterling, price_currency_code is "GBP".
	#If currency code cannot be determined, currency symbol is returned.
	var CurrencyCode: String

	func Price(response):
		Formatted = response["formatted"]
		AmountMicros = response["amountMicros"]
		CurrencyCode = response["currencyCode"]
