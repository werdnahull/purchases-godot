class_name CustomerInfo
extends Reference


var Entitlements: EntitlementInfos
var ActiveSubscriptions: Array
var AllPurchasedProductIdentifiers: Array
var LatestExpirationDate: String			# ?
var FirstSeen: String
var OriginalAppUserId: String
var RequestDate: String
var OriginalPurchaseDate: String			# ?
var AllExpirationDates: Dictionary
var AllPurchaseDates: Dictionary			# ?
var OriginalApplicationVersion
var ManagementURL
var NonSubscriptionTransactions: Array


func _init(response):
	Entitlements =  EntitlementInfos.new(response["entitlements"])
	ActiveSubscriptions = []
	for subscription in response["activeSubscriptions"]:
		ActiveSubscriptions.append(subscription)

	AllPurchasedProductIdentifiers = []
	for productIdentifier in response["allPurchasedProductIdentifiers"]:
		AllPurchasedProductIdentifiers.append(productIdentifier)

	FirstSeen = Time.get_datetime_string_from_unix_time(int(response["firstSeenMillis"]))
	OriginalAppUserId = response["originalAppUserId"]
	RequestDate = Time.get_datetime_string_from_unix_time(int(response["requestDateMillis"]))
	if response["originalPurchaseDateMillis"]:
		OriginalPurchaseDate = Time.get_datetime_string_from_unix_time(int(response["originalPurchaseDateMillis"]))
	else: OriginalPurchaseDate = ""
	if response["latestExpirationDateMillis"]:
		LatestExpirationDate = Time.get_datetime_string_from_unix_time(int(response["latestExpirationDateMillis"]))
	else: LatestExpirationDate = ""
	if response["managementURL"]: ManagementURL = response["managementURL"]
	else: ManagementURL = ""
	AllExpirationDates = {}
	for keyValue in response["allExpirationDatesMillis"]:
		var productID = keyValue
		var expirationDateJSON = response["allExpirationDatesMillis"][keyValue]
		if (expirationDateJSON != null && int(expirationDateJSON) != 0):
			AllExpirationDates[productID] = Time.get_datetime_string_from_unix_time(int(expirationDateJSON))
		else:
			AllExpirationDates[productID] = ""

	AllPurchaseDates = {}
	for keyValue in response["allPurchaseDatesMillis"]:
		AllPurchaseDates[keyValue] = Time.get_datetime_string_from_unix_time(int(response["allPurchaseDatesMillis"][keyValue]))

	if response["originalApplicationVersion"]: OriginalApplicationVersion = response["originalApplicationVersion"]
	else: OriginalApplicationVersion = ""

	NonSubscriptionTransactions = []
	for transactionResponse in response["nonSubscriptionTransactions"]:
		NonSubscriptionTransactions.append(StoreTransaction.new(transactionResponse))
