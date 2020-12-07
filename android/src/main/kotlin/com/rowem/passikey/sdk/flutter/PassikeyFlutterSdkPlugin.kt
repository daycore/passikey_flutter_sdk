package com.rowem.passikey.sdk.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.rowem.passikey.sdk.PassikeySDK
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class PassikeyFlutterSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    private lateinit var channel: MethodChannel

    private lateinit var applicationContext: Context
    private var activity: Activity? = null
    private var activityPluginBinding: ActivityPluginBinding? = null

    // Passikey SDK Instance
    private var passikeySDK: PassikeySDK? = null

    private fun init(call: MethodCall, result: Result) {
        try {
            PassikeySDK.init(applicationContext)
            passikeySDK = PassikeySDK.getInstance()
            result.success(true)
        } catch (e: Exception) {
            result.error("passikey_sdk", e.message, null)
        }
    }

    private fun login(call: MethodCall, result: Result) {
        if (this.passikeySDK == null) {
            result.error("passikey_sdk", "플러그인이 초기화 되지 않았습니다", null)
            return
        }

        if (this.activity == null) {
            result.error("passikey_sdk", "액티비티가 초기화 되지 않았습니다", null)
            return
        }

        if (!call.hasArgument("stateToken")) result.error("passikey_sdk", "stateToken을 설정해주세요", null)
        val stateToken = call.argument<String>("stateToken")


        val sdk = PassikeySDK.getInstance()
        sdk.login(this.activity, stateToken) { passikeyLogin, errorInfo ->
            if (passikeyLogin != null) {
                if (!stateToken.equals(passikeyLogin.statToken, ignoreCase = true)) {
                    result.error("passikey_sdk", "로그인 요청시 전달한 상태토큰 불일치", null)
                } else {
                    result.success(mapOf("statToken" to passikeyLogin.statToken, "ptnToken" to passikeyLogin.ptnToken))
                }
            } else {
                result.error("passikey_sdk", "로그인에 실패했습니다", mapOf("errorCode" to errorInfo.code, "errorName" to errorInfo.name))
            }
        }
    }

    private fun getClientId(call: MethodCall, result: Result) {
        if (this.passikeySDK == null) {
            result.error("passikey_sdk", "플러그인이 초기화 되지 않았습니다", null)
            return
        }

        result.success(passikeySDK?.clientId)
    }

    private fun getSecretKey(call: MethodCall, result: Result) {
        if (this.passikeySDK == null) {
            result.error("passikey_sdk", "플러그인이 초기화 되지 않았습니다", null)
            return
        }

        result.success(passikeySDK?.secretKey)
    }

    private fun isInstalledPassikey(call: MethodCall, result: Result) {
        result.success(PassikeySDK.isInstalledPassikey(applicationContext))
    }

    private fun startStore(call: MethodCall, result: Result) {
        result.success(PassikeySDK.startStore(applicationContext))
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "passikey_flutter_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "Passikey#init" -> init(call, result)
            "Passikey#login" -> login(call, result)
            "Passikey#getClientId" -> getClientId(call, result)
            "Passikey#getSecretKey" -> getSecretKey(call, result)
            "Passikey#isInstalledPassikey" -> isInstalledPassikey(call, result)
            "Passikey#startStore" -> startStore(call, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        this.activity = null
        this.activityPluginBinding?.removeActivityResultListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        this.activityPluginBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (this.passikeySDK?.handleResult(requestCode, resultCode, data) == true) {
            return true
        }

        return false
    }
}
