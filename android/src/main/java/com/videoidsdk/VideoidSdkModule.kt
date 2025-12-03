package com.videoidsdk

import android.app.Activity
import android.app.AlertDialog
import android.app.ProgressDialog
import android.content.Intent
import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import eu.electronicid.sdk.ExtraModulesProvider.Companion.loadEidKoinModules
import eu.electronicid.sdk.base.certid.CertIDActivity
import eu.electronicid.sdk.base.model.Environment
import eu.electronicid.sdk.base.ui.base.VideoIdServiceActivity
import eu.electronicid.sdk.discriminator.CheckRequirements
import eu.electronicid.sdk.ui.smileid.SmileIDActivity
import eu.electronicid.sdk.ui.videoid.VideoIDActivity
import eu.electronicid.sdk.ui.videoscan.VideoScanActivity
import java.net.URL

@ReactModule(name = VideoidSdkModule.NAME)
class VideoidSdkModule(
    reactContext: ReactApplicationContext
) : NativeVideoidSdkSpec(reactContext), ActivityEventListener {

    companion object {
        const val NAME = "VideoidSdk"
        private const val REQUEST_CODE_VIDEOID = 9001
    }

    private enum class FlowType {
        VIDEO_ID,
        VIDEO_SCAN,
        SMILE_ID,
        CERT_ID
    }

    private var sdkInitialized = false

    // Config for current run (taken from JS config)
    private var endpoint: URL? = null
    private var authToken: String? = null
    private var language: String = "en"
    private var documentId: Int = 62
    private var currentFlowType: FlowType? = null

    private var pendingPromise: Promise? = null

    init {
        reactApplicationContext.addActivityEventListener(this)
    }

    override fun getName(): String = NAME

    // ---------- Shared helpers ----------

    private fun ensureSdkInitialized(promise: Promise): Boolean {
        if (sdkInitialized) return true
        return try {
            loadEidKoinModules(reactApplicationContext)
            sdkInitialized = true
            true
        } catch (e: Exception) {
            promise.reject("VIDEOID_INIT_ERROR", e)
            false
        }
    }

    private fun readCommonConfig(config: ReadableMap, promise: Promise): Boolean {
        val endpointStr = config.getString("endpoint") ?: ""
        val authStr = config.getString("authorization") ?: ""
        val lang = if (config.hasKey("language") && !config.isNull("language")) {
            config.getString("language") ?: "en"
        } else {
            "en"
        }

        if (endpointStr.isBlank()) {
            promise.reject("VIDEOID_CONFIG_ERROR", "endpoint must not be empty")
            return false
        }
        if (authStr.isBlank()) {
            promise.reject("VIDEOID_CONFIG_ERROR", "authorization must not be empty")
            return false
        }

        try {
            endpoint = URL(endpointStr)
        } catch (e: Exception) {
            promise.reject("VIDEOID_CONFIG_ERROR", "Invalid endpoint URL: $endpointStr")
            return false
        }

        authToken = authStr
        language = lang
        return true
    }

    private fun readDocumentIdIfPresent(config: ReadableMap) {
        documentId = if (config.hasKey("documentID") && !config.isNull("documentID")) {
            config.getInt("documentID")
        } else {
            62
        }
    }

    private fun ensureNoPending(promise: Promise): Boolean {
        if (pendingPromise != null) {
            promise.reject("IN_PROGRESS", "A VideoID session is already running")
            return false
        }
        return true
    }

    // ---------- Public methods exposed to JS ----------

    /**
     * startVideoID({
     *   endpoint: string,
     *   authorization: string,
     *   language?: string,
     *   documentID: number,
     * })
     */
    override fun startVideoID(config: ReadableMap, promise: Promise) {
        val activity = reactApplicationContext.currentActivity
        if (activity == null) {
            promise.reject("NO_ACTIVITY", "Current activity is null")
            return
        }

        if (!readCommonConfig(config, promise)) return
        readDocumentIdIfPresent(config)
        if (!ensureNoPending(promise)) return
        if (!ensureSdkInitialized(promise)) return

        val endpointLocal = endpoint!!
        val authLocal = authToken!!
        currentFlowType = FlowType.VIDEO_ID

        @Suppress("DEPRECATION")
        val progress = ProgressDialog.show(activity, "Checking Requirements", "")

        CheckRequirements.getInstance(activity).checkVideoID(
            endpointLocal,
            { step -> progress.setMessage("$step/10") }
        ) { result ->
            progress.dismiss()

            if (result.passed) {
                try {
                    pendingPromise = promise

                    val intent = Intent(activity, VideoIDActivity::class.java).apply {
                        putExtra(
                            VideoIDActivity.ENVIRONMENT,
                            Environment(endpointLocal, authLocal)
                        )
                        putExtra(VideoScanActivity.LANGUAGE, language)
                        putExtra(VideoIDActivity.ID_DOCUMENT, documentId)
                    }

                    activity.startActivityForResult(intent, REQUEST_CODE_VIDEOID)
                } catch (e: Exception) {
                    pendingPromise = null
                    promise.reject("VIDEOID_START_ERROR", e)
                }
            } else {
                activity.runOnUiThread {
                    AlertDialog.Builder(activity)
                        .setCancelable(false)
                        .setMessage("Requirements for VideoID not passed, please, try another onboarding solution")
                        .setPositiveButton(android.R.string.ok, null)
                        .show()
                }

                val resultMap = Arguments.createMap().apply {
                    putString("status", "error")
                    putString("code", "REQUIREMENTS_NOT_PASSED")
                    putString("message", "VideoID requirements not passed")
                    putString("flowType", "videoId")
                }
                promise.resolve(resultMap)
            }
        }
    }

    /**
     * startVideoScan({
     *   endpoint: string,
     *   authorization: string,
     *   language?: string,
     *   documentID: number,
     * })
     */
    override fun startVideoScan(config: ReadableMap, promise: Promise) {
        val activity = reactApplicationContext.currentActivity
        if (activity == null) {
            promise.reject("NO_ACTIVITY", "Current activity is null")
            return
        }

        if (!readCommonConfig(config, promise)) return
        readDocumentIdIfPresent(config)
        if (!ensureNoPending(promise)) return
        if (!ensureSdkInitialized(promise)) return

        val endpointLocal = endpoint!!
        val authLocal = authToken!!
        currentFlowType = FlowType.VIDEO_SCAN

        @Suppress("DEPRECATION")
        val progress = ProgressDialog.show(activity, "Checking Requirements", "")

        CheckRequirements.getInstance(activity).checkVideoScan(
            endpointLocal,
            { step -> progress.setMessage("$step/10") }
        ) { result ->
            progress.dismiss()

            if (result.passed) {
                try {
                    pendingPromise = promise

                    val intent = Intent(activity, VideoScanActivity::class.java).apply {
                        putExtra(
                            VideoScanActivity.ENVIRONMENT,
                            Environment(endpointLocal, authLocal)
                        )
                        putExtra(VideoScanActivity.LANGUAGE, language)
                        putExtra(VideoScanActivity.ID_DOCUMENT, documentId)
                    }

                    activity.startActivityForResult(intent, REQUEST_CODE_VIDEOID)
                } catch (e: Exception) {
                    pendingPromise = null
                    promise.reject("VIDEOSCAN_START_ERROR", e)
                }
            } else {
                activity.runOnUiThread {
                    AlertDialog.Builder(activity)
                        .setCancelable(false)
                        .setMessage("Requirements for VideoScan not passed, please, try another onboarding solution")
                        .setPositiveButton(android.R.string.ok, null)
                        .show()
                }

                val resultMap = Arguments.createMap().apply {
                    putString("status", "error")
                    putString("code", "REQUIREMENTS_NOT_PASSED")
                    putString("message", "VideoScan requirements not passed")
                    putString("flowType", "videoScan")
                }
                promise.resolve(resultMap)
            }
        }
    }

    /**
     * startSmileID({
     *   endpoint: string,
     *   authorization: string,
     *   language?: string,
     * })
     */
    override fun startSmileID(config: ReadableMap, promise: Promise) {
        val activity = reactApplicationContext.currentActivity
        if (activity == null) {
            promise.reject("NO_ACTIVITY", "Current activity is null")
            return
        }

        if (!readCommonConfig(config, promise)) return
        if (!ensureNoPending(promise)) return
        if (!ensureSdkInitialized(promise)) return

        val endpointLocal = endpoint!!
        val authLocal = authToken!!
        currentFlowType = FlowType.SMILE_ID

        @Suppress("DEPRECATION")
        val progress = ProgressDialog.show(activity, "Checking Requirements", "")

        CheckRequirements.getInstance(activity).checkSmileID(
            endpointLocal,
            { step -> progress.setMessage("$step/10") }
        ) { result ->
            progress.dismiss()

            if (result.passed) {
                try {
                    pendingPromise = promise

                    val intent = Intent(activity, SmileIDActivity::class.java).apply {
                        putExtra(
                            SmileIDActivity.ENVIRONMENT,
                            Environment(endpointLocal, authLocal)
                        )
                        putExtra(VideoScanActivity.LANGUAGE, language)
                    }

                    activity.startActivityForResult(intent, REQUEST_CODE_VIDEOID)
                } catch (e: Exception) {
                    pendingPromise = null
                    promise.reject("SMILEID_START_ERROR", e)
                }
            } else {
                activity.runOnUiThread {
                    AlertDialog.Builder(activity)
                        .setCancelable(false)
                        .setMessage("Requirements for SmileID not passed, please, try another onboarding solution")
                        .setPositiveButton(android.R.string.ok, null)
                        .show()
                }

                val resultMap = Arguments.createMap().apply {
                    putString("status", "error")
                    putString("code", "REQUIREMENTS_NOT_PASSED")
                    putString("message", "SmileID requirements not passed")
                    putString("flowType", "smileId")
                }
                promise.resolve(resultMap)
            }
        }
    }

    /**
     * startCertID({
     *   endpoint: string,
     *   authorization: string,
     *   language?: string,
     * })
     */
    override fun startCertID(config: ReadableMap, promise: Promise) {
        val activity = reactApplicationContext.currentActivity
        if (activity == null) {
            promise.reject("NO_ACTIVITY", "Current activity is null")
            return
        }

        // Read config (endpoint, authorization, language)
        if (!readCommonConfig(config, promise)) return
        // Ensure no other flow is running
        if (!ensureNoPending(promise)) return
        // Ensure SDK is initialized
        if (!ensureSdkInitialized(promise)) return

        val endpointLocal = endpoint!!
        val authLocal = authToken!!
        currentFlowType = FlowType.CERT_ID

        // No CheckRequirements for CertID – same as sample app
        try {
            pendingPromise = promise

            val intent = Intent(activity, CertIDActivity::class.java).apply {
                putExtra(
                    CertIDActivity.ENVIRONMENT,
                    Environment(endpointLocal, authLocal)
                )
                putExtra(CertIDActivity.LANGUAGE, language)
            }

            activity.startActivityForResult(intent, REQUEST_CODE_VIDEOID)
        } catch (e: Exception) {
            pendingPromise = null
            promise.reject("CERTID_START_ERROR", e)
        }
    }

    // ---------- ActivityEventListener ----------

    override fun onActivityResult(
        activity: Activity,
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        if (requestCode != REQUEST_CODE_VIDEOID) return

        val promise = pendingPromise ?: return
        pendingPromise = null

        val flowTypeString = when (currentFlowType) {
            FlowType.VIDEO_ID -> "videoId"
            FlowType.VIDEO_SCAN -> "videoScan"
            FlowType.SMILE_ID -> "smileId"
            FlowType.CERT_ID -> "certId"
            else -> null
        }
        currentFlowType = null

        try {
            if (resultCode == Activity.RESULT_OK) {
                val videoId = data?.getStringExtra(VideoIdServiceActivity.RESULT_OK)
                val resultMap = Arguments.createMap().apply {
                    putString("status", "success")
                    putString("videoId", videoId)
                    if (flowTypeString != null) {
                        putString("flowType", flowTypeString)
                    }
                }
                promise.resolve(resultMap)
            } else if (resultCode == Activity.RESULT_CANCELED) {
                val errorId = data?.getStringExtra(VideoIdServiceActivity.RESULT_ERROR_CODE)
                val errorMsg = data?.getStringExtra(VideoIdServiceActivity.RESULT_ERROR_MESSAGE)
                val resultMap = Arguments.createMap().apply {
                    putString("status", "error")
                    putString("code", errorId)
                    putString("message", errorMsg)
                    if (flowTypeString != null) {
                        putString("flowType", flowTypeString)
                    }
                }
                promise.resolve(resultMap)
            } else {
                val resultMap = Arguments.createMap().apply {
                    putString("status", "error")
                    putString("code", "UNKNOWN_RESULT")
                    putString("message", "Unknown resultCode: $resultCode")
                    if (flowTypeString != null) {
                        putString("flowType", flowTypeString)
                    }
                }
                promise.resolve(resultMap)
            }
        } catch (e: Exception) {
            promise.reject("VIDEOID_RESULT_ERROR", e)
        }
    }

    override fun onNewIntent(intent: Intent) {
        // no-op
    }
}
