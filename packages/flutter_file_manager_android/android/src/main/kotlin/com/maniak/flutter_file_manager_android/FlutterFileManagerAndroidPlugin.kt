package com.maniak.flutter_file_manager_android

import AndroidMessageApi
import FlutterError
import android.content.Context

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlutterFileManagerAndroidPlugin */
class FlutterFileManagerAndroidPlugin : FlutterPlugin, AndroidMessageApi, ActivityAware {
    private lateinit var context: Context

    private var activityBinding: ActivityPluginBinding? = null
    private var fileDialog: FileDialog? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        AndroidMessageApi.setUp(flutterPluginBinding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
      AndroidMessageApi.setUp(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        doOnDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivity() {
        doOnDetachedFromActivity()
    }

    private fun doOnDetachedFromActivity() {
        fileDialog?.let {
            activityBinding?.removeActivityResultListener(it)
            fileDialog = null
        }
        activityBinding = null
    }

    private fun createFileDialog(): Boolean {
        activityBinding?.let {
            val fileDialog = FileDialog(activity = it.activity)
            it.addActivityResultListener(fileDialog)
            this.fileDialog = fileDialog
            return true
        }
        this.fileDialog = null
        return false
    }

  override fun writeFile(
    fileName: String,
    mimeType: String?,
    bytes: ByteArray,
    callback: (Result<String>) -> Unit
  ) {
    if (fileDialog == null) {
      if (!createFileDialog()) {
        callback(Result.failure(FlutterError(code = "init_failed", message = "Not attached")))
        return
      }
    }

    fileDialog?.saveFile(
      callback,
      bytes,
      fileName,
      mimeType,
    )
  }
}
