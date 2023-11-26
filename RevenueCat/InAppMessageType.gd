class_name InAppMessageType
extends Reference

enum MessageType{
	# In-app messages to indicate there has been a billing issue charging the user.
	BillingIssue = 0,

	# iOS-only. This message will show if you increase the price of a subscription and
	# the user needs to opt-in to the increase.
	PriceIncreaseConsent = 1,

	# iOS-only. StoreKit generic messages.
	Generic = 2,
}
