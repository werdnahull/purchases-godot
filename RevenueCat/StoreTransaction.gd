# <summary>
# Abstract class that provides access to properties of a transaction. StoreTransactions can represent
# transactions from StoreKit 1, StoreKit 2 or transactions made from other places,
# like Stripe, Google Play or Amazon Store.
# </summary>
class_name StoreTransaction
extends Reference


# <summary>
# Id associated with the transaction in RevenueCat.
# </summary>
var TransactionIdentifier: String

# <summary>
# Product Id associated with the transaction.
# </summary>
var ProductIdentifier: String

# <summary>
# Purchase date of the transaction in UTC, be sure to compare them with DateTime.UtcNow
# </summary>
var PurchaseDate: String

func _init(response):
	TransactionIdentifier = response["transactionIdentifier"]
	ProductIdentifier = response["productIdentifier"]
	PurchaseDate = Time.get_datetime_string_from_unix_time(int(response["purchaseDateMillis"]))
