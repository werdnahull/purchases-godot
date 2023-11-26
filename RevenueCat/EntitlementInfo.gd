class_name EntitlementInfo
extends Reference

var Identifier: String
var IsActive: bool
var WillRenew: bool
var PeriodType: String
var LatestPurchaseDate: String
var OriginalPurchaseDate: String
var ExpirationDate: String			# ?
var Store: String
var ProductIdentifier: String
var IsSandbox: bool
var UnsubscribeDetectedAt: String	# ?
var BillingIssueDetectedAt: String	# ?

func _init(response):
	Identifier = response["identifier"]
	IsActive = response["isActive"]
	WillRenew = response["willRenew"]
	PeriodType = response["periodType"]
	LatestPurchaseDate = Time.get_datetime_string_from_unix_time(int(response["latestPurchaseDateMillis"]))
	OriginalPurchaseDate = Time.get_datetime_string_from_unix_time(int(response["originalPurchaseDateMillis"]))

	var expirationDateJson = response["expirationDateMillis"]
	if expirationDateJson != null && int(expirationDateJson) != 0:
		ExpirationDate = Time.get_datetime_string_from_unix_time(int(expirationDateJson))

	Store = response["store"]
	ProductIdentifier = response["productIdentifier"]
	IsSandbox = response["isSandbox"]

	var unsubscribeDetectedJson = response["unsubscribeDetectedAtMillis"]
	if unsubscribeDetectedJson != null && int(unsubscribeDetectedJson) != 0:
		UnsubscribeDetectedAt = Time.get_datetime_string_from_unix_time(unsubscribeDetectedJson)

	var billingIssueJson = response["billingIssueDetectedAtMillis"]
	if billingIssueJson != null && int(billingIssueJson) != 0:
		BillingIssueDetectedAt = Time.get_datetime_string_from_unix_time(billingIssueJson)
