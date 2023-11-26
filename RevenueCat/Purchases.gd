#class_name Purchases
extends Node


## "Activate if you plan to call Purchases.Configure or Purchases.Setup programmatically."
export (bool) var useRuntimeSetup

##  "RevenueCat API Key specifically for Apple platforms.\nGet from https://app.revenuecat.com/ \n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
export (String) var revenueCatAPIKeyApple

##  "RevenueCat API Key specifically for Google Play.\nGet from https://app.revenuecat.com/ \n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
export (String) var revenueCatAPIKeyGoogle

##  [Header("Alternative Stores"
##  "RevenueCat API Key specifically for Amazon Appstore.\nGet from https://app.revenuecat.com/ \n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
export (String) var revenueCatAPIKeyAmazon

##  "Enables Amazon Store support. Android only, on iOS it has no effect.\n" +
##           "If enabled, it will use the API key in RevenueCatAPIKeyAmazon.\n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
export (bool) var useAmazon

##  [Header("Dangerous Settings"
##  "Disable or enable automatically detecting current subscriptions.\n" +
##           "If this is disabled, RevenueCat won't check current purchases, and it will not sync any purchase automatically " +
##           "when the app starts.\nCall syncPurchases whenever a new purchase is detected so the receipt is sent to " +
##           "RevenueCat's backend.\n" +
##           "In iOS, consumables disappear from the receipt after the transaction is finished, so make sure purchases " +
##           "are synced before finishing any consumable transaction, otherwise RevenueCat won't register the purchase.\n" +
##           "Auto syncing of purchases is enabled by default.\n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
export (bool) var autoSyncPurchases = true

##  "App user id. Pass in your own ID if your app has accounts.\n" +
##           "If blank, RevenueCat will generate a user ID for you.\n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
##  ReSharper disable once InconsistentNaming
export (String) var appUserID

##  "List of product identifiers."
export (Array) var productIdentifiers

##  "A subclass of Purchases.UpdatedCustomerInfoListener component.\n" +
##           "Use your custom subclass to define how to handle updated customer information."
export (NodePath) var listener

##  "An optional boolean. Set this to true if you have your own IAP implementation " +
##           "and want to use only RevenueCat's backend.\nDefault is false.\n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
export (bool) var observerMode

##  "An optional String. iOS only.\n" +
##           "Set this to use a specific NSUserDefaults suite for RevenueCat. " +
##           "This might be handy if you are deleting all NSUserDefaults in your app " +
##           "and leaving RevenueCat in a bad state.\n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
export (String) var userDefaultsSuiteName

##  [Header("Advanced"
##  "Set this property to your proxy URL before configuring Purchases *only* if you've received " +
##           "a proxy key value from your RevenueCat contact.\n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
export (String) var proxyURL

##  [Header("⚠️ Deprecated"
##  "⚠️ RevenueCat currently uses StoreKit 1 for purchases, as its stability in production " +
##           "scenarios has proven to be more performant than StoreKit 2.\n" +
##           "We're collecting more data on the best approach, but StoreKit 1 vs StoreKit 2 is \n" +
##           "an implementation detail that you shouldn't need to care about.\n" +
##           "We recommend not using this parameter, letting RevenueCat decide for " +
##           "you which StoreKit implementation to use.\n" +
##           "NOTE: This value will be ignored if \"Use Runtime Setup\" is true. For Runtime Setup, you can configure " +
##           "it through PurchasesConfiguration instead"
##[Obsolete("RevenueCat currently uses StoreKit 1 for purchases, as its stability in production " +
##  "scenarios has proven to be more performant than StoreKit 2.\n" +
##  "We're collecting more data on the best approach, but StoreKit 1 vs StoreKit 2 is \n" +
##  "an implementation detail that you shouldn't need to care about.\n" +
##  "We recommend not using this parameter, letting RevenueCat decide for " +
##  "you which StoreKit implementation to use.", false
export (bool) var usesStoreKit2IfAvailable

##  "Whether we should show store in-app messages automatically. Both Google Play and the App Store provide in-app " +
##           "messages for some situations like billing issues. By default, those messages will be shown automatically.\n" +
##           "This allows to disable that behavior, so you can display those messages at your convenience. For more information, " +
##           "check: https://rev.cat/storekit-message and https://rev.cat/googleplayinappmessaging"
export (bool) var shouldShowInAppMessagesAutomatically = true

var _wrapper


func _ready():
	var _platform: String = OS.get_name()
	if _platform == "Android":
		_wrapper = PurchasesWrapperAndroid.new()
		_wrapper.name = "PurchasesWrapperAndroid"
		add_child(_wrapper)
	elif _platform == "iOS":
		_wrapper = PurchasesWrapperiOS.new()
		_wrapper.name = "PurchasesWrapperiOS"
		add_child(_wrapper)
	else:
		_wrapper = PurchasesWrapperNoop.new()
		_wrapper.name = "PurchasesWrapperNoop"
		add_child(_wrapper)

	if proxyURL != "":
		_wrapper.SetProxyURL(proxyURL)

	if (useRuntimeSetup): return

	var x = "" if appUserID.empty() else appUserID
	_configure(x)
	GetProducts(productIdentifiers, "")

func _configure(newUserId: String):
	var apiKey = ""

	if (OS.get_name() == "iOS" or OS.get_name() == "OSX"):
		apiKey = revenueCatAPIKeyApple
	elif (OS.get_name() == "Android"):
		apiKey = useAmazon if revenueCatAPIKeyAmazon else revenueCatAPIKeyGoogle

	var dangerousSettings = DangerousSettings.new(autoSyncPurchases)
#	var builder = PurchasesConfiguration.Builder.Init(apiKey)\
#		.SetAppUserId(newUserId)\
#		.SetObserverMode(observerMode)\
#		.SetUserDefaultsSuiteName(userDefaultsSuiteName)\
#		.SetUseAmazon(useAmazon)\
#		.SetDangerousSettings(dangerousSettings)\
#		.SetUsesStoreKit2IfAvailable(usesStoreKit2IfAvailable)\
#		.SetShouldShowInAppMessagesAutomatically(shouldShowInAppMessagesAutomatically)
	var config = PurchasesConfiguration.new(apiKey, newUserId, observerMode, userDefaultsSuiteName, useAmazon, dangerousSettings, usesStoreKit2IfAvailable, shouldShowInAppMessagesAutomatically)

	Configure(config)

func Configure(purchasesConfiguration: PurchasesConfiguration):
	var dangerousSettings = JSON.print(purchasesConfiguration.dangerousSettings.serialize())
	_wrapper.Setup(str(listener), purchasesConfiguration.ApiKey, purchasesConfiguration.AppUserId,\
			purchasesConfiguration.ObserverMode, purchasesConfiguration.UsesStoreKit2IfAvailable, purchasesConfiguration.UserDefaultsSuiteName,\
			purchasesConfiguration.UseAmazon, dangerousSettings, purchasesConfiguration.ShouldShowInAppMessagesAutomatically)

signal products_recieved(products, error)

## <summary>
## Fetches the <c>StoreProducts</c> for your IAPs for given productIdentifiers.
## This method is called automatically with products pre-configured through Godot Editor.
## You can optionally call this if you want to fetch more products.
## </summary>
## <seealso cref="StoreProduct"/>
## <param name="products">
## A set of product identifiers for in-app purchases setup via AppStoreConnect.\n
## This should be either hard coded in your application, from a file, or from a custom endpoint if \n
## you want to be able to deploy new IAPs without an app update.
## </param>
## <param name="type"> Android only. The type of product to purchase. </param>
## <remarks>
## completion may be called without <see cref="StoreProduct"/>s that you are expecting.\n
## This is usually caused by iTunesConnect configuration errors.\n
## Ensure your IAPs have the “Ready to Submit” status in iTunesConnect.\n
## Also ensure that you have an active developer program subscription and you have signed the\n
## latest paid application agreements.\n
## If you’re having trouble, <see href="https://rev.cat/how-to-configure-products"/>
## </remarks>
func GetProducts(products: Array, type: String = "subs"):
	_wrapper.GetProducts(products, type)

signal purchase_made(productIdentifier, customerInfo, userCancelled, error)
func PurchaseProduct( productIdentifier: String, type: String = "subs", oldSku: String = "",\
		prorationMode: ProrationMode = ProrationMode.UnknownSubscriptionUpgradeDowngradePolicy,\
		googleIsPersonalizedPrice: bool = false):
	_wrapper.PurchaseProduct(productIdentifier, type, oldSku, prorationMode, googleIsPersonalizedPrice)

func PurchaseDiscountedProduct(productIdentifier: String, discount: PromotionalOffer):
	_wrapper.PurchaseProduct(productIdentifier, discount)

func PurchasePackage(package: Package, oldSku: String = "",\
		prorationMode: ProrationMode = ProrationMode.UnknownSubscriptionUpgradeDowngradePolicy,\
		googleIsPersonalizedPrice: bool = false):
	_wrapper.PurchasePackage(package, oldSku, prorationMode, googleIsPersonalizedPrice)

func PurchaseDiscountedPackage(package: Package,  discount: PromotionalOffer):
		_wrapper.PurchasePackage(package, discount)

func PurchaseSubscriptionOption(subscriptionOption: SubscriptionOption,\
		googleProductChangeInfo: GoogleProductChangeInfo = null, googleIsPersonalizedPrice: bool = false):
	_wrapper.PurchaseSubscriptionOption(subscriptionOption, googleProductChangeInfo, googleIsPersonalizedPrice)

signal CustomerInfoRecieved(customerInfo, error)
func RestorePurchases():
	#RestorePurchasesCallback = callback
	_wrapper.RestorePurchases()

signal logged_in(customerInfo, created, error)
func LogIn(appUserId: String):
	_wrapper.LogIn(appUserId)

func LogOut():
	_wrapper.LogOut()

func SetFinishTransactions(finishTransactions: bool):
	_wrapper.SetFinishTransactions(finishTransactions)

func GetAppUserId() -> String:
	return _wrapper.GetAppUserId()

func IsAnonymous() -> bool:
	return _wrapper.IsAnonymous()

signal log_level_set(logLevel, message)
func SetLogLevel(level: LogLevel):
	_wrapper.SetLogLevel(level)

func SetLogHandler():			#LogHandlerFunc logHandler)
	#LogHandler = logHandler
	_wrapper.SetLogHandler()

#signal customer_info_recieved(customerInfo, error) #CustomerInfoFunc callback)
func GetCustomerInfo():
	_wrapper.GetCustomerInfo()

signal offerings_recieved(offerings, error) #GetOfferingsFunc callback)
func GetOfferings():
	_wrapper.GetOfferings()

func SyncPurchases():
	_wrapper.SyncPurchases()

func SyncObserverModeAmazonPurchase(productID: String, receiptID: String, amazonUserID: String,\
		isoCurrencyCode: String, price: float):
	_wrapper.SyncObserverModeAmazonPurchase(productID, receiptID, amazonUserID, isoCurrencyCode, price)

func SetAutomaticAppleSearchAdsAttributionCollection(searchAdsAttributionEnabled: bool):
	_wrapper.SetAutomaticAppleSearchAdsAttributionCollection(searchAdsAttributionEnabled)

func EnableAdServicesAttributionTokenCollection():
	_wrapper.EnableAdServicesAttributionTokenCollection()

signal CheckTrialOrIntroductoryPriceEligibilityFunc(products)
func CheckTrialOrIntroductoryPriceEligibility(products: Array):
	_wrapper.CheckTrialOrIntroductoryPriceEligibility(products)

func InvalidateCustomerInfoCache():
	_wrapper.InvalidateCustomerInfoCache()

func PresentCodeRedemptionSheet():
	_wrapper.PresentCodeRedemptionSheet()

func SetSimulatesAskToBuyInSandbox(askToBuyEnabled: bool):
	_wrapper.SetSimulatesAskToBuyInSandbox(askToBuyEnabled)

func SetAttributes(attributes: Dictionary):
	var jsonObject = {}
	for keyValuePair in attributes:
		if (attributes[keyValuePair] == ""):
			jsonObject[keyValuePair] = ""
		else:
			jsonObject[keyValuePair] = attributes[keyValuePair]
	_wrapper.SetAttributes(str(jsonObject))

func SetEmail(email: String):
	_wrapper.SetEmail(email)

func SetPhoneNumber(phoneNumber: String):
	_wrapper.SetPhoneNumber(phoneNumber)

func SetDisplayName(displayName: String):
	_wrapper.SetDisplayName(displayName)

func SetPushToken(token: String):
	_wrapper.SetPushToken(token)

func SetAdjustID(adjustID: String):
	_wrapper.SetAdjustID(adjustID)

func SetAppsflyerID(appsflyerID: String):
	_wrapper.SetAppsflyerID(appsflyerID)

func SetFBAnonymousID(fbAnonymousID: String):
	_wrapper.SetFBAnonymousID(fbAnonymousID)

func SetMparticleID(mparticleID: String):
	_wrapper.SetMparticleID(mparticleID)

func SetOnesignalID(onesignalID: String):
	_wrapper.SetOnesignalID(onesignalID)

func SetAirshipChannelID(airshipChannelID: String):
	_wrapper.SetAirshipChannelID(airshipChannelID)

func SetCleverTapID(cleverTapID: String):
	_wrapper.SetCleverTapID(cleverTapID)

func SetMixpanelDistinctID(mixpanelDistinctID: String):
	_wrapper.SetMixpanelDistinctID(mixpanelDistinctID)

func SetFirebaseAppInstanceID(firebaseAppInstanceID: String):
	_wrapper.SetFirebaseAppInstanceID(firebaseAppInstanceID)

func SetMediaSource(mediaSource: String):
	_wrapper.SetMediaSource(mediaSource)

func SetCampaign(campaign: String):
	_wrapper.SetCampaign(campaign)

func SetAdGroup(adGroup: String):
	_wrapper.SetAdGroup(adGroup)

func SetAd(ad: String):
	_wrapper.SetAd(ad)

func SetKeyword(keyword: String):
	_wrapper.SetKeyword(keyword)

func SetCreative(creative: String):
	_wrapper.SetCreative(creative)

func CollectDeviceIdentifiers():
	_wrapper.CollectDeviceIdentifiers()

signal CanMakePaymentsFunc(canMakePayments, error)
func CanMakePayments(features: BillingFeature):		#, CanMakePaymentsFunc callback):
	#CanMakePaymentsCallback = callback
	var x = BillingFeature.new() if features == null else features
	_wrapper.CanMakePayments(x)

signal GetPromotionalOfferFunc(promotionalOffer, error)
func GetPromotionalOffer(storeProduct: StoreProduct, discount: Discount): 			#GetPromotionalOfferFunc callback)
	#GetPromotionalOfferCallback = callback
	_wrapper.GetPromotionalOffer(storeProduct.Identifier, discount.Identifier)

func ShowInAppMessages(messageTypes: InAppMessageType = null):
	_wrapper.ShowInAppMessages(messageTypes)

func _receiveProducts(productsJson: String) -> void:
	print_debug("_receiveProducts " + productsJson)

	var response = JSON.parse(productsJson).result

	if response_has_error(response):
		emit_signal("products_recieved", null, Error.new(response["error"]))
	else:
		var products = []
		for productResponse in response["products"]:
			var product = StoreProduct.new(productResponse)
			products.append(product)
		emit_signal("products_recieved", products, null)

func _getCustomerInfo(customerInfoJson: String):
	print_debug("_getCustomerInfo " + customerInfoJson)
	_ReceiveCustomerInfoMethod(customerInfoJson)
	#GetCustomerInfoCallback = null

func _makePurchase(makePurchaseResponseJson: String):
	print_debug("_makePurchase " + makePurchaseResponseJson)

	var response = JSON.parse(makePurchaseResponseJson).result

	if response_has_error(response):
		emit_signal("purchase_made", null, null, response["userCancelled"], Error.new(response["error"]))
	else:
		var info = CustomerInfo.new(response["customerInfo"])
		var productIdentifier = response["productIdentifier"]
		emit_signal("purchase_made", productIdentifier, info, false, null)

func _receiveCustomerInfo(customerInfoJson: String):
	print_debug("_receiveCustomerInfo " + customerInfoJson)

	#if (listener == ""): return

	var response = JSON.parse(customerInfoJson).result
	if (response["customerInfo"] == null): return
	var info = CustomerInfo.new(response["customerInfo"])
	emit_signal("CustomerInfoRecieved", info)

func _handleLog(logDetailsJson: String):
	#if (listener == ""): return

	var response = JSON.parse(logDetailsJson).result
	var logLevelInResponse = response["logLevel"]
	if (logLevelInResponse == null): return
	var messageInResponse = response["message"]
	if (messageInResponse == null): return
	var _logLevel = LogLevel.new()
	var logLevel = _logLevel.ParseLogLevelByName(logLevelInResponse)

	emit_signal("log_level_set", logLevel, messageInResponse)

func _restorePurchases(customerInfoJson: String):
	print_debug("_restorePurchases " + customerInfoJson)
	_ReceiveCustomerInfoMethod(customerInfoJson)

	emit_signal("purchases_restored", customerInfoJson)

func _logIn(logInResultJson: String):
	print_debug("_logIn " + logInResultJson)
	_ReceiveLogInResultMethod(logInResultJson)

func _logOut(customerInfoJson: String):
	print_debug("_logOut " + customerInfoJson)
	_ReceiveCustomerInfoMethod(customerInfoJson)

func _getOfferings(offeringsJson: String):
	print_debug("_getOfferings " + offeringsJson)

	var response = JSON.parse(offeringsJson).result
	if response_has_error(response):
		emit_signal("offerings_recieved", null, Error.new(response["error"]))
	else:
		var offeringsResponse = response["offerings"]
		emit_signal("offerings_recieved", Offerings.new(offeringsResponse), null)

func _checkTrialOrIntroductoryPriceEligibility(json: String):
	print_debug("_checkTrialOrIntroductoryPriceEligibility " + json)

	var response = JSON.parse(json).result
	var dictionary = {}
	for keyValuePair in response:
		dictionary[keyValuePair] = IntroEligibility.new(response[keyValuePair])

	emit_signal("CheckTrialOrIntroductoryPriceEligibilityCallback", dictionary)

func _canMakePayments(canMakePaymentsJson: String):
	print_debug("_canMakePayments" + canMakePaymentsJson)

	var response = JSON.parse(canMakePaymentsJson).result

	if response_has_error(response):
		emit_signal("CanMakePaymentsFunc", false, Error.new(response["error"]))
	else:
		var canMakePayments = response["canMakePayments"]
		emit_signal("CanMakePaymentsFunc", canMakePayments, null)

func _getPromotionalOffer(getPromotionalOfferJson: String):
	print_debug("_getPromotionalOffer" + getPromotionalOfferJson)

	var response = JSON.parse(getPromotionalOfferJson).result

	if response_has_error(response):
		emit_signal("GetPromotionalOfferFunc", null, Error.new(response["error"]))
	else:
		var promotionalOffer = PromotionalOffer.new(response)
		emit_signal("GetPromotionalOfferFunc", promotionalOffer, null)

func _ReceiveCustomerInfoMethod(customerInfoJson):
	var response = JSON.parse(customerInfoJson).result

	if response_has_error(response):
		emit_signal("customer_info_recieved", null, Error.new(response["error"]))
	else:
		var info = CustomerInfo.new(response["customerInfo"])
		emit_signal("customer_info_recieved", info, null)

func _ReceiveLogInResultMethod(arguments: String):
	var response = JSON.parse(arguments).result

	if response_has_error(response):
		emit_signal("logged_in", null, false, Error.new(response["error"]))
	else:
		var info = CustomerInfo.new(response["customerInfo"])
		var created = response["created"]
		emit_signal("logged_in", info, created, null)

func response_has_error(response: Dictionary) -> bool:
	return response != null && response.has("error") && response["error"] != null
