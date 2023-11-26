class_name StoreProduct
extends Reference

var Title: String
var Identifier: String
var Description: String
var Price: float
var PriceString: String
var CurrencyCode
var _IntroductoryPrice: IntroductoryPrice
var _ProductCategory: ProductCategory
var DefaultOption
var SubscriptionOptions = []
var PresentedOfferingIdentifier

# <summary>
# Collection of iOS promotional offers for a product. Null for Android.
# </summary>
# <returns></returns>
var Discounts = []

# <summary>
# Subscription period, specified in ISO 8601 format. For example,
# P1W equates to one week, P1M equates to one month,
# P3M equates to three months, P6M equates to six months,
# and P1Y equates to one year.
# Note: Not available for Amazon.
# </summary>
# <returns></returns>
var SubscriptionPeriod

func _init(response):
	Title = response["title"]
	Identifier = response["identifier"]
	Description = response["description"]
	Price = response["price"]
	PriceString = response["priceString"]
	CurrencyCode = response["currencyCode"]
	SubscriptionPeriod = response["subscriptionPeriod"]
	var introPriceJsonNode = response["introPrice"]
	if introPriceJsonNode != null and not introPriceJsonNode == "":
		_IntroductoryPrice = IntroductoryPrice.new(introPriceJsonNode)
	PresentedOfferingIdentifier = response["presentedOfferingIdentifier"]
	if not response["productCategory"] in ProductCategory.Category.keys():
		_ProductCategory = ProductCategory.UNKNOWN
	var defaultOptionJsonNode = response["defaultOption"]
	if defaultOptionJsonNode != null and not defaultOptionJsonNode == "":
		DefaultOption = SubscriptionOption.new(defaultOptionJsonNode)

	var subscriptionOptionsResponse = response["subscriptionOptions"]
	if subscriptionOptionsResponse == null:
		SubscriptionOptions = []
	else:
		var subscriptionOptionsTemporaryList = []
		for subscriptionOptionResponse in subscriptionOptionsResponse:
			subscriptionOptionsTemporaryList.append(SubscriptionOption.new(subscriptionOptionResponse))
		SubscriptionOptions = subscriptionOptionsTemporaryList

	var discountsResponse = response["discounts"]
	if discountsResponse == null:
		Discounts = []
	else:
		var temporaryList = []
		for discountResponse in discountsResponse:
			temporaryList.append(Discount.new(discountResponse))
		Discounts = temporaryList

