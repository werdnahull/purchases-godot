# <summary>
# Class used to configure the SDK programmatically.
# Create a configuration builder, set its properties, then call `Build` to obtain the configuration.
# Lastly, call Purchases.Configure and with the obtained PurchasesConfiguration object.
# </summary>
#
# <example>
# For example:
# <code>
# Purchases.PurchasesConfiguration.Builder builder = Purchases.PurchasesConfiguration.Builder.Init("api_key")
# Purchases.PurchasesConfiguration purchasesConfiguration =
#     builder
#         .SetAppUserId(appUserId)
#         .Build()
# purchases.Configure(purchasesConfiguration)
# </code>
# </example>

class_name PurchasesConfiguration
extends Reference

var ApiKey: String
var AppUserId: String
var ObserverMode: bool
var UserDefaultsSuiteName: String
var UseAmazon: bool
var dangerousSettings: DangerousSettings
var UsesStoreKit2IfAvailable: bool
var ShouldShowInAppMessagesAutomatically: bool

func _init(apiKey: String, appUserId: String, observerMode: bool, userDefaultsSuiteName: String,\
			useAmazon: bool, dangerousSettings: DangerousSettings, usesStoreKit2IfAvailable: bool,\
			shouldShowInAppMessagesAutomatically: bool):
	ApiKey = apiKey
	AppUserId = appUserId
	ObserverMode = observerMode
	UserDefaultsSuiteName = userDefaultsSuiteName
	UseAmazon = useAmazon
	self.dangerousSettings = dangerousSettings
	UsesStoreKit2IfAvailable = usesStoreKit2IfAvailable
	ShouldShowInAppMessagesAutomatically = shouldShowInAppMessagesAutomatically

# <summary>
# Use self object to create a PurchasesConfiguration object that can be used to configure
# the SDK programmatically.
# Create a configuration builder, set its properties, then call `Build` to obtain the configuration.
# Lastly, call Purchases.Configure and with the obtained PurchasesConfiguration object.
# </summary>
#
# <example>
# For example:
# <code>
# Purchases.PurchasesConfiguration.Builder builder = Purchases.PurchasesConfiguration.Builder.Init("api_key")
# Purchases.PurchasesConfiguration purchasesConfiguration =
#     builder
#         .SetAppUserId(appUserId)
#         .Build()
# purchases.Configure(purchasesConfiguration)
# </code>
# </example>

class Builder:
	var _apiKey: String
	var _appUserId: String
	var _observerMode: bool
	var _userDefaultsSuiteName: String
	var _useAmazon: bool
	var _dangerousSettings: DangerousSettings
	var _usesStoreKit2IfAvailable: bool
	var _shouldShowInAppMessagesAutomatically: bool

	func _init(apiKey: String):
		_apiKey = apiKey

	static func Init(apiKey: String):
		return Builder.new(apiKey)

	func Build():
		var x = _dangerousSettings if _dangerousSettings else DangerousSettings.new(false)
		return .new(_apiKey, _appUserId, _observerMode, _userDefaultsSuiteName,
			_useAmazon, x, _usesStoreKit2IfAvailable, _shouldShowInAppMessagesAutomatically)

	func SetAppUserId(appUserId: String):
		_appUserId = appUserId
		return self

	func SetObserverMode(observerMode: bool):
		_observerMode = observerMode
		return self

	func SetUserDefaultsSuiteName(userDefaultsSuiteName: String):
		_userDefaultsSuiteName = userDefaultsSuiteName
		return self

	func SetUseAmazon(useAmazon: bool):
		_useAmazon = useAmazon
		return self

	func SetDangerousSettings(dangerousSettings: DangerousSettings):
		_dangerousSettings = dangerousSettings
		return self

#	[Obsolete("RevenueCat currently uses StoreKit 1 for purchases, as its stability in production " +
#				"scenarios has proven to be more performant than StoreKit 2.\n" +
#				"We're collecting more data on the best approach, but StoreKit 1 vs StoreKit 2 is \n" +
#				"an implementation detail that you shouldn't need to care about.\n" +
#				"We recommend not using self parameter, letting RevenueCat decide for " +
#				"you which StoreKit implementation to use.", false)]
	func SetUsesStoreKit2IfAvailable(usesStoreKit2IfAvailable: bool):
		_usesStoreKit2IfAvailable = usesStoreKit2IfAvailable
		return self

	func SetShouldShowInAppMessagesAutomatically(shouldShowInAppMessagesAutomatically: bool):
		_shouldShowInAppMessagesAutomatically = shouldShowInAppMessagesAutomatically
		return self
