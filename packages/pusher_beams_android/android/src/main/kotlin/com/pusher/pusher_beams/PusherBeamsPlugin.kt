package com.pusher.pusher_beams

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.google.firebase.messaging.RemoteMessage
import com.pusher.pushnotifications.*
import com.pusher.pushnotifications.auth.AuthData
import com.pusher.pushnotifications.auth.AuthDataGetter
import com.pusher.pushnotifications.auth.BeamsTokenProvider
import io.flutter.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONTokener

/** PusherBeamsPlugin */
class PusherBeamsPlugin : FlutterPlugin, Messages.PusherBeamsApi, ActivityAware, NewIntentListener {
    private lateinit var context: Context
    private var alreadyInterestsListener: Boolean = false
    private var currentActivity: Activity? = null

    private var data: kotlin.collections.Map<String, kotlin.Any?>? = null
    private var initialIntentHandled = false
    private var notificationOpenedCallbackId: String? = null
    private val pendingNotificationOpenedData = mutableListOf<Map<String, Any?>>()

    private lateinit var callbackHandlerApi: Messages.CallbackHandlerApi

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Messages.PusherBeamsApi.setup(flutterPluginBinding.binaryMessenger, this)

        context = flutterPluginBinding.applicationContext
        callbackHandlerApi = Messages.CallbackHandlerApi(flutterPluginBinding.binaryMessenger)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Messages.PusherBeamsApi.setup(binding.binaryMessenger, null)
        callbackHandlerApi = Messages.CallbackHandlerApi(binding.binaryMessenger)
    }

    override fun onNewIntent(intent: Intent): Boolean {
        return handleNotificationOpenedIntent(intent)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.currentActivity = binding.activity;
        binding.addOnNewIntentListener(this)
        handleInitialIntent(binding.activity.intent)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.currentActivity = binding.activity
        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onDetachedFromActivity() {
        this.currentActivity = null;
    }

    private fun handleInitialIntent(intent: Intent) {
        if (initialIntentHandled) return
        initialIntentHandled = true

        if (!isPusherNotificationIntent(intent)) return

        data = notificationDataFromIntent(intent)
        Log.d(this.toString(), "Got initial notification data: $data")
        emitOrQueueNotificationOpened(data!!)
    }

    private fun handleNotificationOpenedIntent(intent: Intent): Boolean {
        if (!isPusherNotificationIntent(intent)) return false

        val notificationData = notificationDataFromIntent(intent)
        Log.d(this.toString(), "Notification opened with data: $notificationData")
        emitOrQueueNotificationOpened(notificationData)
        return true
    }

    private fun isPusherNotificationIntent(intent: Intent): Boolean {
        val extras = intent.extras ?: return false
        return extras.containsKey("pusher") || extras.containsKey("info")
    }

    private fun notificationDataFromIntent(intent: Intent): Map<String, Any?> {
        return bundleToMap(intent.extras?.getString("info")) ?: emptyMap()
    }

    private fun emitOrQueueNotificationOpened(notificationData: Map<String, Any?>) {
        val callbackId = notificationOpenedCallbackId
        if (callbackId == null) {
            pendingNotificationOpenedData.add(notificationData)
            return
        }

        emitNotificationOpened(callbackId, notificationData)
    }

    private fun emitNotificationOpened(callbackId: String, notificationData: Map<String, Any?>) {
        callbackHandlerApi.handleCallback(
            callbackId,
            "onNotificationOpened",
            listOf(notificationData)
        ) {
            Log.d(this.toString(), "Notification-open callback delivered: $notificationData")
        }
    }

    override fun start(instanceId: kotlin.String) {
        PushNotifications.start(this.context, instanceId)
        Log.d(this.toString(), "PusherBeams started with $instanceId instanceId")
    }

    override fun getInitialMessage(result: Messages.Result<kotlin.collections.Map<String, kotlin.Any?>>) {
        Log.d(this.toString(), "Returning initial data: $data")
        result.success(data)
    }

    override fun addDeviceInterest(interest: kotlin.String) {
        PushNotifications.addDeviceInterest(interest)
        Log.d(this.toString(), "Added device to interest: $interest")
    }

    override fun removeDeviceInterest(interest: String) {
        PushNotifications.removeDeviceInterest(interest)
        Log.d(this.toString(), "Removed device to interest: $interest")
    }

    override fun getDeviceInterests(): kotlin.collections.List<String> {
        return PushNotifications.getDeviceInterests().toList()
    }

    override fun setDeviceInterests(interests: kotlin.collections.List<String>) {
        PushNotifications.setDeviceInterests(interests.toSet())
        Log.d(this.toString(), "$interests added to device")
    }

    override fun clearDeviceInterests() {
        PushNotifications.clearDeviceInterests()
        Log.d(this.toString(), "Cleared device interests")
    }

    override fun onInterestChanges(callbackId: String) {
        if (!alreadyInterestsListener) {
            PushNotifications.setOnDeviceInterestsChangedListener(object :
                SubscriptionsChangedListener {
                override fun onSubscriptionsChanged(interests: Set<String>) {
                    callbackHandlerApi.handleCallback(
                        callbackId,
                        "onInterestChanges",
                        listOf(interests.toList()),
                        Messages.CallbackHandlerApi.Reply {
                            Log.d(this.toString(), "interests changed $interests")
                        })
                }
            })
        }
    }

    override fun setUserId(
        userId: String,
        provider: Messages.BeamsAuthProvider,
        callbackId: String
    ) {
        val tokenProvider = BeamsTokenProvider(
            provider.authUrl,
            object : AuthDataGetter {
                override fun getAuthData(): AuthData {
                    return AuthData(
                        headers = provider.headers,
                        queryParams = provider.queryParams
                    )
                }
            }
        )

        PushNotifications.setUserId(
            userId,
            tokenProvider,
            object : BeamsCallback<Void, PusherCallbackError> {
                override fun onFailure(error: PusherCallbackError) {
                    callbackHandlerApi.handleCallback(
                        callbackId,
                        "setUserId",
                        listOf(error.message),
                        Messages.CallbackHandlerApi.Reply {
                            Log.d(this.toString(), "Failed to set Authentication to device")
                        })
                }

                override fun onSuccess(vararg values: Void) {
                    callbackHandlerApi.handleCallback(
                        callbackId,
                        "setUserId",
                        listOf(null),
                        Messages.CallbackHandlerApi.Reply {
                            Log.d(this.toString(), "Device authenticated with $userId")
                        })
                }
            }
        )
    }

    override fun clearAllState() {
        PushNotifications.clearAllState()
    }

    override fun onMessageReceivedInTheForeground(callbackId: String) {
        currentActivity?.let { activity ->
            PushNotifications.setOnMessageReceivedListenerForVisibleActivity(
                activity,
                object : PushNotificationReceivedListener {
                    override fun onMessageReceived(remoteMessage: RemoteMessage) {
                        activity.runOnUiThread {
                            val pusherMessage = remoteMessage.toPusherMessage()
                            callbackHandlerApi.handleCallback(
                                callbackId,
                                "onMessageReceivedInTheForeground",
                                listOf(pusherMessage)
                            ) {
                                Log.d(this.toString(), "Message received: $pusherMessage")
                            }
                        }
                    }
                })
        }
    }

    override fun onNotificationOpened(callbackId: String) {
        notificationOpenedCallbackId = callbackId

        val pendingData = pendingNotificationOpenedData.toList()
        pendingNotificationOpenedData.clear()
        pendingData.forEach { emitNotificationOpened(callbackId, it) }
    }

    override fun stop() {
        PushNotifications.stop()
    }

    private fun bundleToMap(info: String?): Map<String, Any?>? {
        if (info == null) return null

        return try {
            jsonObjectToMap(JSONTokener(info).nextValue() as JSONObject)
        } catch (exception: Exception) {
            Log.e(this.toString(), "Unable to parse notification info payload", exception)
            emptyMap()
        }
    }

    private fun jsonObjectToMap(jsonObject: JSONObject): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        val keys = jsonObject.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            map[key] = jsonValueToKotlin(jsonObject.get(key))
        }
        return map
    }

    private fun jsonArrayToList(jsonArray: JSONArray): List<Any?> {
        return (0 until jsonArray.length()).map { index ->
            jsonValueToKotlin(jsonArray.get(index))
        }
    }

    private fun jsonValueToKotlin(value: Any?): Any? {
        return when (value) {
            JSONObject.NULL -> null
            is JSONObject -> jsonObjectToMap(value)
            is JSONArray -> jsonArrayToList(value)
            else -> value
        }
    }
}

fun RemoteMessage.toPusherMessage() = mapOf(
    "title" to notification?.title,
    "body" to notification?.body,
    "data" to data
)
