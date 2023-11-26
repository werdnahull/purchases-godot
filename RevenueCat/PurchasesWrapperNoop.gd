class_name PurchasesWrapperNoop

extends Node

func GetProducts(productIdentifiers: Array, type: String = "subs"):
	pass

func PurchaseProduct(productIdentifier: String, type: String = "subs", oldSku: String = "",\
					prorationMode: ProrationMode = ProrationMode.UnknownSubscriptionUpgradeDowngradePolicy,\
					googleIsPersonalizedPrice: bool = false, presentedOfferingIdentifier: String = "",\
					discount: PromotionalOffer = null):
	pass

func PurchasePackage(packageToPurchase: Package, oldSku: String = "",\
	prorationMode: ProrationMode = ProrationMode.UnknownSubscriptionUpgradeDowngradePolicy,\
	googleIsPersonalizedPrice: bool = false, discount: PromotionalOffer = null):
	pass


func PurchaseSubscriptionOption(subscriptionOption: SubscriptionOption,\
	googleProductChangeInfo: GoogleProductChangeInfo = null, googleIsPersonalizedPrice: bool = false):
	pass

func Setup(gameObject: String, apiKey: String, appUserId: String, observerMode: bool, usesStoreKit2IfAvailable: bool,\
	userDefaultsSuiteName: String, useAmazon: bool, dangerousSettingsJson: String, shouldShowInAppMessagesAutomatically: bool):
	pass

func RestorePurchases():
	pass

func LogIn(appUserId: String):
	pass

func LogOut():
	pass

func SetFinishTransactions(finishTransactions: bool):
	pass

func SetAllowSharingStoreAccount(allow: String):
	pass

func SetDebugLogsEnabled(enabled: bool):
	pass

func SetLogLevel(level: LogLevel):
	pass

func SetLogHandler():
	pass

func SetProxyURL(proxyURL: String):
	pass

func GetAppUserId()->String:
	return ""

func GetCustomerInfo():
	pass

func GetOfferings():
	pass

func SyncPurchases():
	pass

func SyncObserverModeAmazonPurchase(productID: String, receiptID: String, amazonUserID: String,\
	isoCurrencyCode: String, price: float):
	pass

func SetAutomaticAppleSearchAdsAttributionCollection(enabled: bool):
	# NOOP
	pass

func EnableAdServicesAttributionTokenCollection():
	# NOOP
	pass


func CheckTrialOrIntroductoryPriceEligibility(productIdentifiers: Array):
	pass

func InvalidateCustomerInfoCache():
	pass

func PresentCodeRedemptionSheet():
	# NOOP
	pass

func SetSimulatesAskToBuyInSandbox(enabled: bool):
	# NOOP
	pass

func SetAttributes(attributesJson: String):
	pass

func SetEmail(email: String):
	pass

func SetPhoneNumber(phoneNumber: String):
	pass

func SetDisplayName(displayName: String):
	pass

func SetPushToken(token: String):
	pass

func SetAdjustID(adjustID: String):
	pass

func SetAppsflyerID(appsflyerID: String):
	pass

func SetFBAnonymousID(fbAnonymousID: String):
	pass

func SetMparticleID(mparticleID: String):
	pass

func SetOnesignalID(onesignalID: String):
	pass

func SetAirshipChannelID(airshipChannelID: String):
	pass

func SetCleverTapID(cleverTapID: String):
	pass

func SetMixpanelDistinctID(mixpanelDistinctID: String):
	pass

func SetFirebaseAppInstanceID(firebaseAppInstanceID: String):
	pass

func SetMediaSource(mediaSource: String):
	pass

func SetCampaign(campaign: String):
	pass

func SetAdGroup(adGroup: String):
	pass

func SetAd(ad: String):
	pass

func SetKeyword(keyword: String):
	pass

func SetCreative(creative: String):
	pass

func CollectDeviceIdentifiers():
	pass


func CanMakePayments(features: Array):
	pass

func GetPromotionalOffer(productIdentifier: String, discountIdentifier: String):
	pass

func ShowInAppMessages(messageTypes: Array):
	pass
