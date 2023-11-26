# <summary>
# Advanced settings. Use only after contacting RevenueCat support and making sure you understand them.
# </summary>
class_name DangerousSettings
extends Reference


var AutoSyncPurchases: bool

func _init(autoSyncPurchases):
	AutoSyncPurchases = autoSyncPurchases

func serialize():
	var n = {}
	n["AutoSyncPurchases"] = AutoSyncPurchases;
	return n;
