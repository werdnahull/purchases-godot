class_name PurchasesWrapperAndroid
extends Node

var _purchasesSingleton

func _init():
	if Engine.has_singleton("PurchasesWrapper"):
		print_debug("Singleton PurchasesWrapper Found!")
		_purchasesSingleton = Engine.get_singleton("PurchasesWrapper")
		_purchasesSingleton.connect("GodotSendMessage", self, "_on_godot_send_message")
	else:
		print_debug("Singleton PurchasesWrapper not loaded")
		return

func _on_godot_send_message(purchasesNode: String, method: String, jsonObject: String):
	get_parent().call(method, jsonObject)
	pass

class ProductsRequest:
	var productIdentifiers: Array

func GetProducts(productIdentifiers: Array, type: String = "subs"):
	var request = ProductsRequest.new()
	request.productIdentifiers = productIdentifiers  ## This needs to be a dictionary, with "productIdentifiers" as the key
	var d = inst2dict(request)
	_purchasesSingleton.call("getProducts", JSON.print(d), type)

func PurchaseProduct(productIdentifier: String, type: String = "subs", oldSku: String = "",\
	prorationMode: ProrationMode = ProrationMode.UnknownSubscriptionUpgradeDowngradePolicy,\
	googleIsPersonalizedPrice: bool = false, presentedOfferingIdentifier: String = "",\
	discount: PromotionalOffer = null):
	if (oldSku == null):
		_purchasesSingleton.call("purchaseProduct", productIdentifier, type)
	else:
		_purchasesSingleton.call("purchaseProduct", productIdentifier, type, oldSku, prorationMode.to_int(), googleIsPersonalizedPrice, presentedOfferingIdentifier)

func PurchasePackage(packageToPurchase: Package, oldSku: String = "",\
	prorationMode: ProrationMode = ProrationMode.UnknownSubscriptionUpgradeDowngradePolicy,\
	googleIsPersonalizedPrice: bool = false, discount: PromotionalOffer = null):
	if (oldSku == null):
		_purchasesSingleton.call("purchasePackage", packageToPurchase.Identifier, packageToPurchase.OfferingIdentifier)
	else:
		_purchasesSingleton.call("purchasePackage", packageToPurchase.Identifier, packageToPurchase.OfferingIdentifier, oldSku,\
		prorationMode.to_int(), googleIsPersonalizedPrice)


func PurchaseSubscriptionOption(subscriptionOption: SubscriptionOption, googleProductChangeInfo: GoogleProductChangeInfo = null, googleIsPersonalizedPrice: bool = false):
	if (googleProductChangeInfo == null):
		_purchasesSingleton.call("purchaseSubscriptionOption", subscriptionOption.ProductId, subscriptionOption.Id,
		null, 0, googleIsPersonalizedPrice, subscriptionOption.PresentedOfferingIdentifier)
	else:
		_purchasesSingleton.call("purchaseSubscriptionOption", subscriptionOption.ProductId, subscriptionOption.Id,\
		googleProductChangeInfo.OldProductIdentifier, googleProductChangeInfo.ProrationMode.to_int(), googleIsPersonalizedPrice,
		subscriptionOption.PresentedOfferingIdentifier)

func Setup(gameObject: String, apiKey: String, appUserId: String, observerMode: bool,\
			usesStoreKit2IfAvailable: bool, userDefaultsSuiteName: String, useAmazon: bool,\
			dangerousSettingsJson: String, shouldShowInAppMessagesAutomatically: bool):
	_purchasesSingleton.call("setup", apiKey, appUserId, gameObject, observerMode, userDefaultsSuiteName, useAmazon, shouldShowInAppMessagesAutomatically,
		dangerousSettingsJson)

func RestorePurchases():
	_purchasesSingleton.call("restorePurchases")

func LogIn(appUserId: String):
	_purchasesSingleton.call("logIn", appUserId)

func LogOut():
	_purchasesSingleton.call("logOut")

func SetFinishTransactions(finishTransactions: bool):
	_purchasesSingleton.call("setFinishTransactions", finishTransactions)

func SetAllowSharingStoreAccount(allow: String):
	_purchasesSingleton.call("setAllowSharingStoreAccount", allow)

func SetDebugLogsEnabled(enabled: bool):
	_purchasesSingleton.call("setDebugLogsEnabled", enabled)

func SetLogLevel(level: LogLevel):
	_purchasesSingleton.call("setLogLevel", level.Name())

func SetLogHandler():
	_purchasesSingleton.call("setLogHandler")

func SetProxyURL(proxyURL: String):
	_purchasesSingleton.call("setProxyURL", proxyURL)

func GetAppUserId()->String:
	return _purchasesSingleton.call("getAppUserID").to_string()

func GetCustomerInfo():
	_purchasesSingleton.call("getCustomerInfo")

func GetOfferings():
	_purchasesSingleton.call("getOfferings")

func SyncPurchases():
	_purchasesSingleton.call("syncPurchases")

func SyncObserverModeAmazonPurchase(productID: String, receiptID: String, amazonUserID: String,\
	isoCurrencyCode: String, price: float):
	_purchasesSingleton.call("syncObserverModeAmazonPurchase", productID, receiptID, amazonUserID, isoCurrencyCode, price)

func SetAutomaticAppleSearchAdsAttributionCollection(enabled: bool):
	# NOOP
	pass

func EnableAdServicesAttributionTokenCollection():
	# NOOP
	pass

func IsAnonymous()->bool:
	return _purchasesSingleton.call("isAnonymous")

func CheckTrialOrIntroductoryPriceEligibility(productIdentifiers: Array):
	var request = ProductsRequest.new()
	request.productIdentifiers = productIdentifiers
	_purchasesSingleton.call("checkTrialOrIntroductoryPriceEligibility", JSON.print(request))

func InvalidateCustomerInfoCache():
	_purchasesSingleton.call("invalidateCustomerInfoCache")

func PresentCodeRedemptionSheet():
	# NOOP
	pass

func SetSimulatesAskToBuyInSandbox(enabled: bool):
	# NOOP
	pass

func SetAttributes(attributesJson: String):
	_purchasesSingleton.call("setAttributes", attributesJson)

func SetEmail(email: String):
	_purchasesSingleton.call("setEmail", email)

func SetPhoneNumber(phoneNumber: String):
	_purchasesSingleton.call("setPhoneNumber", phoneNumber)

func SetDisplayName(displayName: String):
	_purchasesSingleton.call("setDisplayName", displayName)

func SetPushToken(token: String):
	_purchasesSingleton.call("setPushToken", token)

func SetAdjustID(adjustID: String):
	_purchasesSingleton.call("setAdjustID", adjustID)

func SetAppsflyerID(appsflyerID: String):
	_purchasesSingleton.call("setAppsflyerID", appsflyerID)

func SetFBAnonymousID(fbAnonymousID: String):
	_purchasesSingleton.call("setFBAnonymousID", fbAnonymousID)

func SetMparticleID(mparticleID: String):
	_purchasesSingleton.call("setMparticleID", mparticleID)

func SetOnesignalID(onesignalID: String):
	_purchasesSingleton.call("setOnesignalID", onesignalID)

func SetAirshipChannelID(airshipChannelID: String):
	_purchasesSingleton.call("setAirshipChannelID", airshipChannelID)

func SetCleverTapID(cleverTapID: String):
	_purchasesSingleton.call("setCleverTapID", cleverTapID)

func SetMixpanelDistinctID(mixpanelDistinctID: String):
	_purchasesSingleton.call("setMixpanelDistinctID", mixpanelDistinctID)

func SetFirebaseAppInstanceID(firebaseAppInstanceID: String):
	_purchasesSingleton.call("setFirebaseAppInstanceID", firebaseAppInstanceID)

func SetMediaSource(mediaSource: String):
	_purchasesSingleton.call("setMediaSource", mediaSource)

func SetCampaign(campaign: String):
	_purchasesSingleton.call("setCampaign", campaign)

func SetAdGroup(adGroup: String):
	_purchasesSingleton.call("setAdGroup", adGroup)

func SetAd(ad: String):
	_purchasesSingleton.call("setAd", ad)

func SetKeyword(keyword: String):
	_purchasesSingleton.call("setKeyword", keyword)

func SetCreative(creative: String):
	_purchasesSingleton.call("setCreative", creative)

func CollectDeviceIdentifiers():
	_purchasesSingleton.call("collectDeviceIdentifiers")

class CanMakePaymentsRequest:
	var features: Array

func CanMakePayments(features: Array):
	var featuresAsInts = []
	for i in features.size():
		var feature = features[i]
		featuresAsInts[i] = feature.to_int()

	var request = CanMakePaymentsRequest.new()
	request.features = featuresAsInts
	_purchasesSingleton.call("canMakePayments", JSON.print(request))

func GetPromotionalOffer(productIdentifier: String, discountIdentifier: String):
	_purchasesSingleton.call("getPromotionalOffer", productIdentifier, discountIdentifier)

class ShowInAppMessagesRequest:
	var messageTypes: Array

func ShowInAppMessages(messageTypes: Array):
	var messageTypesAsInts = []
	for i in messageTypes.size():
		var messageType = messageTypes[i]
		messageTypesAsInts[i] = messageType.to_int()

	var request = ShowInAppMessagesRequest.new()
	messageTypes = messageTypesAsInts
	_purchasesSingleton.call("showInAppMessages", JSON.print(request))
