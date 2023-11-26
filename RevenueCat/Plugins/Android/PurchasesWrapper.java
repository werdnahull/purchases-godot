package com.revenuecat.purchasesgodot;

import android.app.Activity;
import android.util.ArraySet;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.PackageManagerCompat;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;
import com.revenuecat.purchases.CustomerInfo;
import com.revenuecat.purchases.DangerousSettings;
import com.revenuecat.purchases.Purchases;
import com.revenuecat.purchases.Store;
import com.revenuecat.purchases.common.PlatformInfo;
import com.revenuecat.purchases.hybridcommon.CommonKt;
import com.revenuecat.purchases.hybridcommon.ErrorContainer;
import com.revenuecat.purchases.hybridcommon.OnResult;
import com.revenuecat.purchases.hybridcommon.OnResultAny;
import com.revenuecat.purchases.hybridcommon.OnResultList;
import com.revenuecat.purchases.hybridcommon.SubscriberAttributesKt;
import com.revenuecat.purchases.hybridcommon.mappers.CustomerInfoMapperKt;
import com.revenuecat.purchases.hybridcommon.mappers.MappersHelpersKt;
import com.revenuecat.purchases.interfaces.UpdatedCustomerInfoListener;
import com.revenuecat.purchases.models.InAppMessageType;

import org.godotengine.godot.plugin.UsedByGodot;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class PurchasesWrapper extends GodotPlugin {

    private Activity godotActivity;
    private final String RECEIVE_PRODUCTS = "_receiveProducts";
    private final String GET_CUSTOMER_INFO = "_getCustomerInfo";
    private final String MAKE_PURCHASE = "_makePurchase";
    private final String RECEIVE_CUSTOMER_INFO = "_receiveCustomerInfo";
    private final String RESTORE_PURCHASES = "_restorePurchases";
    private final String LOG_IN = "_logIn";
    private final String LOG_OUT = "_logOut";
    private final String GET_OFFERINGS = "_getOfferings";
    private final String CHECK_ELIGIBILITY = "_checkTrialOrIntroductoryPriceEligibility";
    private final String CAN_MAKE_PAYMENTS = "_canMakePayments";
    private final String GET_PROMOTIONAL_OFFER = "_getPromotionalOffer";

    private final String HANDLE_LOG = "_handleLog";

    private final String PLATFORM_NAME = "godot";
    private final String PLUGIN_VERSION = "6.1.0-SNAPSHOT";

    private String godotNode;

    private UpdatedCustomerInfoListener listener = new UpdatedCustomerInfoListener() {
        @Override
        public void onReceived(@NonNull CustomerInfo customerInfo) {
            sendCustomerInfo(CustomerInfoMapperKt.map(customerInfo), RECEIVE_CUSTOMER_INFO);
        }
    };



    public PurchasesWrapper(Godot godot) {
        super(godot);
        godotActivity = godot.getActivity();
    }

    @UsedByGodot
    public void setup(String apiKey,
                             String appUserId,
                             String godotNode,
                             boolean observerMode,
                             String userDefaultsSuiteName,
                             boolean useAmazon,
                             boolean shouldShowInAppMessagesAutomatically,
                             String dangerousSettingsJSON) {
        this.godotNode = godotNode;
        PlatformInfo platformInfo = new PlatformInfo(PLATFORM_NAME, PLUGIN_VERSION);
        Store store = useAmazon ? Store.AMAZON : Store.PLAY_STORE;
        DangerousSettings dangerousSettings = getDangerousSettingsFromJSON(dangerousSettingsJSON);
        CommonKt.configure(godotActivity,
                apiKey, appUserId, observerMode, platformInfo, store, dangerousSettings, shouldShowInAppMessagesAutomatically);
        Purchases.getSharedInstance().setUpdatedCustomerInfoListener(listener);
    }

    @UsedByGodot
    public void getProducts(String jsonProducts, String type) {
        try {
            JSONObject request = new JSONObject(jsonProducts);
            JSONArray products = request.getJSONArray("productIdentifiers");
            List<String> productIds = new ArrayList<>();
            for (int i = 0; i < products.length(); i++) {
                String product = products.getString(i);
                productIds.add(product);
            }

            CommonKt.getProductInfo(productIds, type, new OnResultList() {
                @Override
                public void onReceived(List<Map<String, ?>> map) {
                    try {
                        JSONObject object = new JSONObject();
                        object.put("products", MappersHelpersKt.convertToJsonArray(map));
                        sendJSONObject(object, RECEIVE_PRODUCTS);
                    } catch (JSONException e) {
                        logJSONException(e);
                    }
                }

                @Override
                public void onError(ErrorContainer errorContainer) {
                    sendError(errorContainer, RECEIVE_PRODUCTS);
                }
            });
        } catch (JSONException e) {
            Log.e("Purchases", "Failure parsing product identifiers " + jsonProducts);
        }
    }

    @UsedByGodot
    public void purchaseProduct(final String productIdentifier,
                                       final String type,
                                       @Nullable final String oldSKU,
                                       final int prorationMode,
                                       final boolean isPersonalized,
                                       @Nullable final String presentedOfferingIdentifier) {
        CommonKt.purchaseProduct(
                godotActivity,
                productIdentifier,
                type,
                null,
                oldSKU,
                prorationMode == 0 ? null : prorationMode,
                isPersonalized,
                presentedOfferingIdentifier,
                new OnResult() {
                    @Override
                    public void onReceived(Map<String, ?> map) {
                        sendJSONObject(MappersHelpersKt.convertToJson(map), MAKE_PURCHASE);
                    }

                    @Override
                    public void onError(ErrorContainer errorContainer) {
                        sendErrorPurchase(errorContainer);
                    }
                });
    }

    @UsedByGodot
    public void purchaseProduct(String productIdentifier, String type) {
        purchaseProduct(productIdentifier, type, null,  0, false, null);
    }

    @UsedByGodot
    public void purchasePackage(String packageIdentifier,
                                       String offeringIdentifier,
                                       @Nullable final String oldSKU,
                                       final int prorationMode,
                                       final boolean isPersonalized
    ) {
        CommonKt.purchasePackage(
                godotActivity,
                packageIdentifier,
                offeringIdentifier,
                oldSKU,
                prorationMode == 0 ? null : prorationMode,
                isPersonalized,
                new OnResult() {
                    @Override
                    public void onReceived(Map<String, ?> map) {
                        sendJSONObject(MappersHelpersKt.convertToJson(map), MAKE_PURCHASE);
                    }

                    @Override
                    public void onError(ErrorContainer errorContainer) {
                        sendErrorPurchase(errorContainer);
                    }
                });
    }

    @UsedByGodot
    public void purchasePackage(String packageIdentifier,
                                       String offeringIdentifier) {
        purchasePackage(packageIdentifier, offeringIdentifier, null,  0, false);
    }

    @UsedByGodot
    public void purchaseSubscriptionOption(final String productIdentifier,
                                                  final String optionIdentifier,
                                                  @Nullable final String oldSKU,
                                                  final int prorationMode,
                                                  final boolean isPersonalized,
                                                  @Nullable final String offerIdentifier
    ) {
        CommonKt.purchaseSubscriptionOption(
                godotActivity,
                productIdentifier,
                optionIdentifier,
                oldSKU,
                (prorationMode == 0) ? null : prorationMode,
                isPersonalized,
                offerIdentifier,
                new OnResult() {
                    @Override
                    public void onReceived(Map<String, ?> map) {
                        sendJSONObject(MappersHelpersKt.convertToJson(map), MAKE_PURCHASE);
                    }

                    @Override
                    public void onError(ErrorContainer errorContainer) {
                        sendErrorPurchase(errorContainer);
                    }
                });
    }

    @UsedByGodot
    public void restorePurchases() {
        CommonKt.restorePurchases(getCustomerInfoListener(RESTORE_PURCHASES));
    }

    @UsedByGodot
    public void logIn(String appUserId) {
        CommonKt.logIn(appUserId, getLogInListener(LOG_IN));
    }

    @UsedByGodot
    public void logOut() {
        CommonKt.logOut(getCustomerInfoListener(LOG_OUT));
    }

    @UsedByGodot
    public void setAllowSharingStoreAccount(boolean allowSharingStoreAccount) {
        CommonKt.setAllowSharingAppStoreAccount(allowSharingStoreAccount);
    }

    @UsedByGodot
    public void getOfferings() {
        CommonKt.getOfferings(new OnResult() {
            @Override
            public void onReceived(Map<String, ?> map) {
                try {
                    JSONObject object = new JSONObject();
                    object.put("offerings", MappersHelpersKt.convertToJson(map));
                    sendJSONObject(object, GET_OFFERINGS);
                } catch (JSONException e) {
                    logJSONException(e);
                }
            }

            @Override
            public void onError(ErrorContainer errorContainer) {
                sendError(errorContainer, GET_OFFERINGS);
            }
        });
    }

    @UsedByGodot
    public void syncObserverModeAmazonPurchase(
            String productID,
            String receiptID,
            String amazonUserID,
            String isoCurrencyCode,
            double price
    ) {
        Purchases.getSharedInstance().syncObserverModeAmazonPurchase(productID, receiptID,
                amazonUserID, isoCurrencyCode, price);
    }

    @UsedByGodot
    public void setLogLevel(String level) {
        CommonKt.setLogLevel(level);
    }

    @UsedByGodot
    public void setLogHandler() {
        CommonKt.setLogHandlerWithOnResult(new OnResult() {
            @Override
            public void onReceived(@NonNull Map<String, ?> map) {
                sendJSONObject(MappersHelpersKt.convertToJson(map), HANDLE_LOG);
            }

            @Override
            public void onError(@NonNull ErrorContainer errorContainer) {
                // Intentionally left blank since it will never be called
            }
        });
    }

    @UsedByGodot
    public void setDebugLogsEnabled(boolean enabled) {
        CommonKt.setDebugLogsEnabled(enabled);
    }

    @UsedByGodot
    public void setProxyURL(String proxyURL) {
        CommonKt.setProxyURLString(proxyURL);
    }

    @UsedByGodot
    public String getAppUserID() {
        return CommonKt.getAppUserID();
    }

    @UsedByGodot
    public void getCustomerInfo() {
        CommonKt.getCustomerInfo(getCustomerInfoListener(GET_CUSTOMER_INFO));
    }

    @UsedByGodot
    public void setFinishTransactions(boolean enabled) {
        CommonKt.setFinishTransactions(enabled);
    }

    @UsedByGodot
    public void syncPurchases() {
        CommonKt.syncPurchases();
    }

    @UsedByGodot
    public boolean isAnonymous() {
        return CommonKt.isAnonymous();
    }

    @UsedByGodot
    public void checkTrialOrIntroductoryPriceEligibility(String jsonProducts) {
        try {
            JSONObject request = new JSONObject(jsonProducts);
            JSONArray products = request.getJSONArray("productIdentifiers");
            List<String> productIds = new ArrayList<>();
            for (int i = 0; i < products.length(); i++) {
                String product = products.getString(i);
                productIds.add(product);
            }

            Map<String, Map<String, Object>> map = CommonKt.checkTrialOrIntroductoryPriceEligibility(productIds);
            sendJSONObject(MappersHelpersKt.convertToJson(map), CHECK_ELIGIBILITY);
        } catch (JSONException e) {
            Log.e("Purchases", "Failure parsing product identifiers " + jsonProducts);
        }
    }

    @UsedByGodot
    public void invalidateCustomerInfoCache() {
        CommonKt.invalidateCustomerInfoCache();
    }

    @UsedByGodot
    public void setAttributes(String jsonAttributes) {
        try {
            JSONObject jsonObject = new JSONObject(jsonAttributes);
            SubscriberAttributesKt.setAttributes(MappersHelpersKt.convertToMap(jsonObject));
        } catch (JSONException e) {
            Log.e("Purchases", "Failure parsing attributes " + jsonAttributes);
        }
    }

    @UsedByGodot
    public void setEmail(String email) {
        SubscriberAttributesKt.setEmail(email);
    }

    @UsedByGodot
    public void setPhoneNumber(String phoneNumber) {
        SubscriberAttributesKt.setPhoneNumber(phoneNumber);
    }

    @UsedByGodot
    public void setDisplayName(String displayName) {
        SubscriberAttributesKt.setDisplayName(displayName);
    }

    @UsedByGodot
    public void setPushToken(String token) {
        SubscriberAttributesKt.setPushToken(token);
    }

    @UsedByGodot
    public void setAdjustID(String adjustID) {
        SubscriberAttributesKt.setAdjustID(adjustID);
    }

    @UsedByGodot
    public void setAppsflyerID(String appsflyerID) {
        SubscriberAttributesKt.setAppsflyerID(appsflyerID);
    }

    @UsedByGodot
    public void setFBAnonymousID(String fbAnonymousID) {
        SubscriberAttributesKt.setFBAnonymousID(fbAnonymousID);
    }

    @UsedByGodot
    public void setMparticleID(String mparticleID) {
        SubscriberAttributesKt.setMparticleID(mparticleID);
    }

    @UsedByGodot
    public void setOnesignalID(String onesignalID) {
        SubscriberAttributesKt.setOnesignalID(onesignalID);
    }

    @UsedByGodot
    public void setAirshipChannelID(String airshipChannelID) {
        SubscriberAttributesKt.setAirshipChannelID(airshipChannelID);
    }

    @UsedByGodot
    public void setCleverTapID(String cleverTapID) {
        SubscriberAttributesKt.setCleverTapID(cleverTapID);
    }

    @UsedByGodot
    public void setMixpanelDistinctID(String mixpanelDistinctID) {
        SubscriberAttributesKt.setMixpanelDistinctID(mixpanelDistinctID);
    }

    @UsedByGodot
    public void setFirebaseAppInstanceID(String firebaseAppInstanceID) {
        SubscriberAttributesKt.setFirebaseAppInstanceID(firebaseAppInstanceID);
    }

    @UsedByGodot
    public void setMediaSource(String mediaSource) {
        SubscriberAttributesKt.setMediaSource(mediaSource);
    }

    @UsedByGodot
    public void setCampaign(String campaign) {
        SubscriberAttributesKt.setCampaign(campaign);
    }

    @UsedByGodot
    public void setAdGroup(String adGroup) {
        SubscriberAttributesKt.setAdGroup(adGroup);
    }

    @UsedByGodot
    public void setAd(String ad) {
        SubscriberAttributesKt.setAd(ad);
    }

    @UsedByGodot
    public void setKeyword(String keyword) {
        SubscriberAttributesKt.setKeyword(keyword);
    }

    @UsedByGodot
    public void setCreative(String creative) {
        SubscriberAttributesKt.setCreative(creative);
    }

    @UsedByGodot
    public void collectDeviceIdentifiers() {
        SubscriberAttributesKt.collectDeviceIdentifiers();
    }

    @UsedByGodot
    public void canMakePayments(String featuresJson) {
        try {
            JSONObject request = new JSONObject(featuresJson);
            JSONArray features = request.getJSONArray("features");
            List<Integer> featuresToSend = new ArrayList<>();
            for (int i = 0; i < features.length(); i++) {
                int feature = features.getInt(i);
                featuresToSend.add(feature);
            }

            CommonKt.canMakePayments(godotActivity, featuresToSend, new OnResultAny<Boolean>() {
                @Override
                public void onReceived(Boolean canMakePayments) {
                    JSONObject object = new JSONObject();
                    try {
                        object.put("canMakePayments", canMakePayments);
                    } catch (JSONException e) {
                        logJSONException(e);
                    }
                    sendJSONObject(object, CAN_MAKE_PAYMENTS);
                }

                @Override
                public void onError(ErrorContainer errorContainer) {
                    sendError(errorContainer, CAN_MAKE_PAYMENTS);
                }
            });
        } catch (JSONException e) {
            logJSONException(e);
        }
    }

    @UsedByGodot
    public void getPromotionalOffer(String productIdentifier, String discountIdentifier) {
        ErrorContainer errorContainer = CommonKt.getPromotionalOffer();
        sendError(errorContainer, GET_PROMOTIONAL_OFFER);
    }

    @UsedByGodot
    public void showInAppMessages(String messagesJson) {
        try {
            JSONObject request = new JSONObject(messagesJson);
            JSONArray messageTypes = request.getJSONArray("messageTypes");
            if (messageTypes == null) {
                CommonKt.showInAppMessagesIfNeeded(godotActivity);
            } else {
                ArrayList<InAppMessageType> messageTypesList = new ArrayList<>();
                InAppMessageType[] inAppMessageTypes = InAppMessageType.values();
                for (int i = 0; i < messageTypes.length(); i++) {
                    int messageTypeInt = messageTypes.getInt(i);
                    InAppMessageType messageType = null;
                    if (messageTypeInt < inAppMessageTypes.length) {
                        messageType = inAppMessageTypes[messageTypeInt];
                    }
                    if (messageType != null) {
                        messageTypesList.add(messageType);
                    } else {
                        Log.e("PurchasesPlugin", "Unsupported in-app message type: " + messageTypeInt);
                    }
                }
                CommonKt.showInAppMessagesIfNeeded(godotActivity, messageTypesList);
            }
        } catch (JSONException e) {
            logJSONException(e);
        }
    }

    private void logJSONException(JSONException e) {
        Log.e("Purchases", "JSON Error: " + e.getLocalizedMessage());
    }

    void sendJSONObject(JSONObject object, String method) {
        //UnityPlayer.UnitySendMessage(godotNode, method, object.toString());
        emitSignal("GodotSendMessage", godotNode, method, object.toString());
    }

    private void sendError(ErrorContainer error, String method) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("error", MappersHelpersKt.convertToJson(error.getInfo()));
        } catch (JSONException e) {
            logJSONException(e);
        }
        sendJSONObject(jsonObject, method);
    }

    private void sendCustomerInfo(Map<String, ?> map, String method) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("customerInfo", MappersHelpersKt.convertToJson(map));
        } catch (JSONException e) {
            logJSONException(e);
        }
        sendJSONObject(jsonObject, method);
    }

    private void sendErrorPurchase(ErrorContainer errorContainer) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("error", MappersHelpersKt.convertToJson(errorContainer.getInfo()));
            jsonObject.put("userCancelled", errorContainer.getInfo().get("userCancelled"));
        } catch (JSONException e) {
            logJSONException(e);
        }
        sendJSONObject(jsonObject, MAKE_PURCHASE);
    }

    @NonNull
    private OnResult getLogInListener(final String method) {
        return new OnResult() {
            @Override
            public void onReceived(Map<String, ?> map) {
                JSONObject jsonObject = new JSONObject();
                try {
                    Map<String, ?> customerInfoMap = (Map<String, ?>)map.get("customerInfo");
                    jsonObject.put("customerInfo", MappersHelpersKt.convertToJson(customerInfoMap));
                    jsonObject.put("created", (Boolean)map.get("created"));
                } catch (ClassCastException castException) {
                    Log.e("Purchases", "invalid casting Error: " + castException.getLocalizedMessage());
                } catch (JSONException e) {
                    logJSONException(e);
                }
                sendJSONObject(jsonObject, method);
            }

            @Override
            public void onError(ErrorContainer errorContainer) {
                sendError(errorContainer, method);
            }
        };
    }

    @NonNull
    private OnResult getCustomerInfoListener(final String method) {
        return new OnResult() {
            @Override
            public void onReceived(Map<String, ?> map) {
                sendCustomerInfo(map, method);
            }

            @Override
            public void onError(ErrorContainer errorContainer) {
                sendError(errorContainer, method);
            }
        };
    }

    @Nullable
    private DangerousSettings getDangerousSettingsFromJSON(String dangerousSettingsJSON) {
        JSONObject jsonObject;
        DangerousSettings dangerousSettings = null;
        try {
            jsonObject = new JSONObject(dangerousSettingsJSON);
            boolean autoSyncPurchases = jsonObject.getBoolean("AutoSyncPurchases");
            dangerousSettings = new DangerousSettings(autoSyncPurchases);
        } catch (JSONException e) {
            Log.e("Purchases", "Error parsing dangerousSettings JSON: " + dangerousSettingsJSON);
            logJSONException(e);
        }
        return dangerousSettings;
    }


    @NonNull
    @Override
    public String getPluginName() {
        return "PurchasesWrapper";
    }

    @NonNull
    @Override
    public Set<SignalInfo> getPluginSignals() {
        Set<SignalInfo> signals = new ArraySet<>();
        signals.add(new SignalInfo("GodotSendMessage", String.class, String.class, String.class));
        return signals;
    }
}
